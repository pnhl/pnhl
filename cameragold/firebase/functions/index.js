const {onDocumentCreated} = require("firebase-functions/v2/firestore");
const {onCall, HttpsError} = require("firebase-functions/v2/https");
const admin = require("firebase-admin");

admin.initializeApp();

// Trigger when a new photo is created
exports.onPhotoCreated = onDocumentCreated(
    "photos/{photoId}",
    async (event) => {
      const photoData = event.data.data();
      const photoId = event.params.photoId;

      try {
        // Get group information
        const groupDoc = await admin.firestore()
            .collection("groups")
            .doc(photoData.groupId)
            .get();

        if (!groupDoc.exists) {
          console.error("Group not found:", photoData.groupId);
          return;
        }

        const groupData = groupDoc.data();
        const memberIds = groupData.memberIds || [];

        // Filter out the author from notification recipients
        const recipientIds = memberIds.filter((id) => id !== photoData.authorId);

        if (recipientIds.length === 0) {
          console.log("No recipients for notification");
          return;
        }

        // Get FCM tokens for all group members
        const userDocs = await admin.firestore()
            .collection("users")
            .where(admin.firestore.FieldPath.documentId(), "in", recipientIds)
            .get();

        const fcmTokens = [];
        userDocs.forEach((doc) => {
          const userData = doc.data();
          if (userData.fcmToken) {
            fcmTokens.push(userData.fcmToken);
          }
        });

        if (fcmTokens.length === 0) {
          console.log("No FCM tokens found for recipients");
          return;
        }

        // Create notification payload
        const payload = {
          notification: {
            title: `New photo in ${groupData.name}`,
            body: `${photoData.authorName} shared a new photo`,
            icon: "ic_notification",
            sound: "default",
          },
          data: {
            type: "new_photo",
            photoId: photoId,
            groupId: photoData.groupId,
            authorId: photoData.authorId,
            click_action: "FLUTTER_NOTIFICATION_CLICK",
          },
        };

        // Send notifications
        const response = await admin.messaging().sendToDevice(fcmTokens, payload);
        console.log("Notifications sent:", response.results.length);

        // Update widget data for group members
        await updateWidgetForGroup(photoData.groupId, {
          groupId: photoData.groupId,
          groupName: groupData.name,
          photoId: photoId,
          photoUrl: photoData.photoUrl,
          thumbnailUrl: photoData.thumbnailUrl,
          senderName: photoData.authorName,
          senderAvatar: photoData.authorAvatar,
          timestamp: photoData.timestamp.toMillis(),
          caption: photoData.caption || "",
          reactionCount: 0,
          hasNewContent: true,
        });
      } catch (error) {
        console.error("Error sending photo notifications:", error);
      }
    });

// Trigger when a reaction is added/updated
exports.onReactionUpdated = onDocumentCreated(
    "photos/{photoId}/reactions/{reactionId}",
    async (event) => {
      const reactionData = event.data.data();
      const photoId = event.params.photoId;

      try {
        // Get photo data
        const photoDoc = await admin.firestore()
            .collection("photos")
            .doc(photoId)
            .get();

        if (!photoDoc.exists) {
          console.error("Photo not found:", photoId);
          return;
        }

        const photoData = photoDoc.data();

        // Don't notify the photo author about their own reactions
        if (reactionData.userId === photoData.authorId) {
          return;
        }

        // Get author's FCM token
        const authorDoc = await admin.firestore()
            .collection("users")
            .doc(photoData.authorId)
            .get();

        if (!authorDoc.exists || !authorDoc.data().fcmToken) {
          console.log("Author FCM token not found");
          return;
        }

        const authorFcmToken = authorDoc.data().fcmToken;

        // Create notification payload
        const payload = {
          notification: {
            title: "New reaction",
            body: `${reactionData.userName} reacted to your photo`,
            icon: "ic_notification",
            sound: "default",
          },
          data: {
            type: "reaction",
            photoId: photoId,
            groupId: photoData.groupId,
            reactorId: reactionData.userId,
            reaction: reactionData.reaction,
            click_action: "FLUTTER_NOTIFICATION_CLICK",
          },
        };

        // Send notification
        await admin.messaging().sendToDevice([authorFcmToken], payload);
        console.log("Reaction notification sent to author");
      } catch (error) {
        console.error("Error sending reaction notification:", error);
      }
    });

// Cloud function to create a group invite
exports.createGroupInvite = onCall(async (request) => {
  const {groupId} = request.data;
  const uid = request.auth?.uid;

  if (!uid) {
    throw new HttpsError("unauthenticated", "User must be authenticated");
  }

  if (!groupId) {
    throw new HttpsError("invalid-argument", "Group ID is required");
  }

  try {
    // Check if user is admin of the group
    const groupDoc = await admin.firestore()
        .collection("groups")
        .doc(groupId)
        .get();

    if (!groupDoc.exists) {
      throw new HttpsError("not-found", "Group not found");
    }

    const groupData = groupDoc.data();
    const userMember = groupData.members.find((member) => member.userId === uid);

    if (!userMember || userMember.role !== "admin") {
      throw new HttpsError("permission-denied", "Only group admins can create invites");
    }

    // Generate invite code
    const inviteCode = generateInviteCode();
    const expiresAt = new Date();
    expiresAt.setDate(expiresAt.getDate() + 7); // Expires in 7 days

    // Create invite document
    const inviteData = {
      id: inviteCode,
      groupId: groupId,
      inviteCode: inviteCode,
      createdBy: uid,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
      expiresAt: expiresAt,
      usedCount: 0,
      isActive: true,
    };

    await admin.firestore()
        .collection("group_invites")
        .doc(inviteCode)
        .set(inviteData);

    return {
      success: true,
      inviteCode: inviteCode,
      inviteUrl: `https://cameragold.app/invite/${inviteCode}`,
    };
  } catch (error) {
    console.error("Error creating group invite:", error);
    throw new HttpsError("internal", "Failed to create group invite");
  }
});

// Cloud function to join group via invite
exports.joinGroupViaInvite = onCall(async (request) => {
  const {inviteCode} = request.data;
  const uid = request.auth?.uid;

  if (!uid) {
    throw new HttpsError("unauthenticated", "User must be authenticated");
  }

  if (!inviteCode) {
    throw new HttpsError("invalid-argument", "Invite code is required");
  }

  try {
    // Get invite document
    const inviteDoc = await admin.firestore()
        .collection("group_invites")
        .doc(inviteCode)
        .get();

    if (!inviteDoc.exists) {
      throw new HttpsError("not-found", "Invalid invite code");
    }

    const inviteData = inviteDoc.data();

    // Check if invite is still active and not expired
    if (!inviteData.isActive || inviteData.expiresAt.toDate() < new Date()) {
      throw new HttpsError("invalid-argument", "Invite code has expired");
    }

    // Get group document
    const groupDoc = await admin.firestore()
        .collection("groups")
        .doc(inviteData.groupId)
        .get();

    if (!groupDoc.exists) {
      throw new HttpsError("not-found", "Group not found");
    }

    const groupData = groupDoc.data();

    // Check if user is already a member
    if (groupData.memberIds.includes(uid)) {
      throw new HttpsError("already-exists", "User is already a member of this group");
    }

    // Check if group has reached max members
    if (groupData.memberIds.length >= groupData.maxMembers) {
      throw new HttpsError("resource-exhausted", "Group has reached maximum member limit");
    }

    // Get user data
    const userDoc = await admin.firestore()
        .collection("users")
        .doc(uid)
        .get();

    if (!userDoc.exists) {
      throw new HttpsError("not-found", "User not found");
    }

    const userData = userDoc.data();

    // Add user to group
    const newMember = {
      userId: uid,
      name: userData.displayName || userData.name,
      email: userData.email,
      role: "member",
      joinedAt: admin.firestore.FieldValue.serverTimestamp(),
      avatarUrl: userData.avatarUrl || "",
      isActive: true,
    };

    await admin.firestore()
        .collection("groups")
        .doc(inviteData.groupId)
        .update({
          memberIds: admin.firestore.FieldValue.arrayUnion(uid),
          members: admin.firestore.FieldValue.arrayUnion(newMember),
        });

    // Update invite usage count
    await admin.firestore()
        .collection("group_invites")
        .doc(inviteCode)
        .update({
          usedCount: admin.firestore.FieldValue.increment(1),
        });

    return {
      success: true,
      groupId: inviteData.groupId,
      groupName: groupData.name,
    };
  } catch (error) {
    console.error("Error joining group via invite:", error);
    throw error;
  }
});

// Helper function to update widget data for group members
async function updateWidgetForGroup(groupId, widgetData) {
  try {
    // Get group members
    const groupDoc = await admin.firestore()
        .collection("groups")
        .doc(groupId)
        .get();

    if (!groupDoc.exists) return;

    const groupData = groupDoc.data();
    const memberIds = groupData.memberIds || [];

    // Update widget data for each member
    const batch = admin.firestore().batch();

    memberIds.forEach((memberId) => {
      const userWidgetRef = admin.firestore()
          .collection("user_widgets")
          .doc(memberId);

      batch.set(userWidgetRef, {
        ...widgetData,
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      }, {merge: true});
    });

    await batch.commit();
    console.log("Widget data updated for group members");
  } catch (error) {
    console.error("Error updating widget data:", error);
  }
}

// Helper function to generate invite code
function generateInviteCode() {
  const chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
  let result = "";
  for (let i = 0; i < 8; i++) {
    result += chars.charAt(Math.floor(Math.random() * chars.length));
  }
  return result;
}

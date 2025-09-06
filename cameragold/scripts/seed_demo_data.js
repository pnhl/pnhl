const admin = require('firebase-admin');
const serviceAccount = require('./service-account-key.json'); // Download from Firebase Console

// Initialize Firebase Admin
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  projectId: 'camera-gold-app'
});

const db = admin.firestore();

async function seedDemoData() {
  try {
    console.log('Starting to seed demo data...');

    // Create demo users
    const users = [
      {
        id: 'user1',
        displayName: 'Nguyễn Văn An',
        email: 'an@example.com',
        avatarUrl: 'https://picsum.photos/seed/user1/200/200',
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
        lastSeenAt: admin.firestore.FieldValue.serverTimestamp(),
        fcmToken: 'demo_token_1'
      },
      {
        id: 'user2',
        displayName: 'Trần Thị Bình',
        email: 'binh@example.com',
        avatarUrl: 'https://picsum.photos/seed/user2/200/200',
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
        lastSeenAt: admin.firestore.FieldValue.serverTimestamp(),
        fcmToken: 'demo_token_2'
      },
      {
        id: 'user3',
        displayName: 'Lê Văn Cường',
        email: 'cuong@example.com',
        avatarUrl: 'https://picsum.photos/seed/user3/200/200',
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
        lastSeenAt: admin.firestore.FieldValue.serverTimestamp(),
        fcmToken: 'demo_token_3'
      },
      {
        id: 'user4',
        displayName: 'Phạm Thị Dung',
        email: 'dung@example.com',
        avatarUrl: 'https://picsum.photos/seed/user4/200/200',
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
        lastSeenAt: admin.firestore.FieldValue.serverTimestamp(),
        fcmToken: 'demo_token_4'
      },
      {
        id: 'user5',
        displayName: 'Hoàng Văn Em',
        email: 'em@example.com',
        avatarUrl: 'https://picsum.photos/seed/user5/200/200',
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
        lastSeenAt: admin.firestore.FieldValue.serverTimestamp(),
        fcmToken: 'demo_token_5'
      }
    ];

    // Create users
    for (const user of users) {
      await db.collection('users').doc(user.id).set(user);
      console.log(`Created user: ${user.displayName}`);
    }

    // Create demo groups
    const groups = [
      {
        id: 'group1',
        name: 'Gia đình',
        description: 'Nhóm gia đình yêu thương',
        creatorId: 'user1',
        memberIds: ['user1', 'user2', 'user3'],
        members: [
          {
            userId: 'user1',
            name: 'Nguyễn Văn An',
            email: 'an@example.com',
            role: 'admin',
            joinedAt: admin.firestore.FieldValue.serverTimestamp(),
            avatarUrl: 'https://picsum.photos/seed/user1/200/200',
            isActive: true
          },
          {
            userId: 'user2',
            name: 'Trần Thị Bình',
            email: 'binh@example.com',
            role: 'member',
            joinedAt: admin.firestore.FieldValue.serverTimestamp(),
            avatarUrl: 'https://picsum.photos/seed/user2/200/200',
            isActive: true
          },
          {
            userId: 'user3',
            name: 'Lê Văn Cường',
            email: 'cuong@example.com',
            role: 'member',
            joinedAt: admin.firestore.FieldValue.serverTimestamp(),
            avatarUrl: 'https://picsum.photos/seed/user3/200/200',
            isActive: true
          }
        ],
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
        inviteCode: 'FAMILY01',
        avatarUrl: 'https://picsum.photos/seed/group1/300/300',
        isPrivate: false,
        maxMembers: 20
      },
      {
        id: 'group2',
        name: 'Bạn thân',
        description: 'Hội bạn thân từ thời học sinh',
        creatorId: 'user2',
        memberIds: ['user2', 'user4', 'user5'],
        members: [
          {
            userId: 'user2',
            name: 'Trần Thị Bình',
            email: 'binh@example.com',
            role: 'admin',
            joinedAt: admin.firestore.FieldValue.serverTimestamp(),
            avatarUrl: 'https://picsum.photos/seed/user2/200/200',
            isActive: true
          },
          {
            userId: 'user4',
            name: 'Phạm Thị Dung',
            email: 'dung@example.com',
            role: 'member',
            joinedAt: admin.firestore.FieldValue.serverTimestamp(),
            avatarUrl: 'https://picsum.photos/seed/user4/200/200',
            isActive: true
          },
          {
            userId: 'user5',
            name: 'Hoàng Văn Em',
            email: 'em@example.com',
            role: 'member',
            joinedAt: admin.firestore.FieldValue.serverTimestamp(),
            avatarUrl: 'https://picsum.photos/seed/user5/200/200',
            isActive: true
          }
        ],
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
        inviteCode: 'FRIENDS01',
        avatarUrl: 'https://picsum.photos/seed/group2/300/300',
        isPrivate: false,
        maxMembers: 20
      },
      {
        id: 'group3',
        name: 'Đồng nghiệp',
        description: 'Team làm việc cùng nhau',
        creatorId: 'user3',
        memberIds: ['user1', 'user3', 'user4'],
        members: [
          {
            userId: 'user1',
            name: 'Nguyễn Văn An',
            email: 'an@example.com',
            role: 'member',
            joinedAt: admin.firestore.FieldValue.serverTimestamp(),
            avatarUrl: 'https://picsum.photos/seed/user1/200/200',
            isActive: true
          },
          {
            userId: 'user3',
            name: 'Lê Văn Cường',
            email: 'cuong@example.com',
            role: 'admin',
            joinedAt: admin.firestore.FieldValue.serverTimestamp(),
            avatarUrl: 'https://picsum.photos/seed/user3/200/200',
            isActive: true
          },
          {
            userId: 'user4',
            name: 'Phạm Thị Dung',
            email: 'dung@example.com',
            role: 'member',
            joinedAt: admin.firestore.FieldValue.serverTimestamp(),
            avatarUrl: 'https://picsum.photos/seed/user4/200/200',
            isActive: true
          }
        ],
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
        inviteCode: 'WORK01',
        avatarUrl: 'https://picsum.photos/seed/group3/300/300',
        isPrivate: false,
        maxMembers: 20
      }
    ];

    // Create groups
    for (const group of groups) {
      await db.collection('groups').doc(group.id).set(group);
      console.log(`Created group: ${group.name}`);
    }

    // Create demo photos
    const photos = [
      {
        id: 'photo1',
        groupId: 'group1',
        authorId: 'user1',
        authorName: 'Nguyễn Văn An',
        authorAvatar: 'https://picsum.photos/seed/user1/200/200',
        photoUrl: 'https://picsum.photos/seed/photo1/800/800',
        thumbnailUrl: 'https://picsum.photos/seed/photo1/300/300',
        caption: 'Bữa tối gia đình cuối tuần 🍽️',
        timestamp: admin.firestore.FieldValue.serverTimestamp(),
        reactions: {
          '❤️': 2,
          '😂': 1,
          '👍': 1
        },
        comments: [],
        isDeleted: false
      },
      {
        id: 'photo2',
        groupId: 'group2',
        authorId: 'user2',
        authorName: 'Trần Thị Bình',
        authorAvatar: 'https://picsum.photos/seed/user2/200/200',
        photoUrl: 'https://picsum.photos/seed/photo2/800/800',
        thumbnailUrl: 'https://picsum.photos/seed/photo2/300/300',
        caption: 'Cafe sáng với hội bạn thân ☕',
        timestamp: admin.firestore.FieldValue.serverTimestamp(),
        reactions: {
          '❤️': 3,
          '👍': 2
        },
        comments: [],
        isDeleted: false
      },
      {
        id: 'photo3',
        groupId: 'group3',
        authorId: 'user3',
        authorName: 'Lê Văn Cường',
        authorAvatar: 'https://picsum.photos/seed/user3/200/200',
        photoUrl: 'https://picsum.photos/seed/photo3/800/800',
        thumbnailUrl: 'https://picsum.photos/seed/photo3/300/300',
        caption: 'Họp team building hôm nay 🎯',
        timestamp: admin.firestore.FieldValue.serverTimestamp(),
        reactions: {
          '👍': 3,
          '😮': 1
        },
        comments: [],
        isDeleted: false
      },
      {
        id: 'photo4',
        groupId: 'group1',
        authorId: 'user2',
        authorName: 'Trần Thị Bình',
        authorAvatar: 'https://picsum.photos/seed/user2/200/200',
        photoUrl: 'https://picsum.photos/seed/photo4/800/800',
        thumbnailUrl: 'https://picsum.photos/seed/photo4/300/300',
        caption: 'Bánh mì tự làm cho cả nhà 🥖',
        timestamp: admin.firestore.FieldValue.serverTimestamp(),
        reactions: {
          '❤️': 3,
          '😂': 2
        },
        comments: [],
        isDeleted: false
      },
      {
        id: 'photo5',
        groupId: 'group2',
        authorId: 'user4',
        authorName: 'Phạm Thị Dung',
        authorAvatar: 'https://picsum.photos/seed/user4/200/200',
        photoUrl: 'https://picsum.photos/seed/photo5/800/800',
        thumbnailUrl: 'https://picsum.photos/seed/photo5/300/300',
        caption: 'Chuyến đi cuối tuần cùng bạn bè 🏖️',
        timestamp: admin.firestore.FieldValue.serverTimestamp(),
        reactions: {
          '❤️': 5,
          '👍': 3,
          '😮': 1
        },
        comments: [],
        isDeleted: false
      }
    ];

    // Create photos
    for (const photo of photos) {
      await db.collection('photos').doc(photo.id).set(photo);
      console.log(`Created photo: ${photo.caption}`);
    }

    // Create some reactions
    const reactions = [
      {
        photoId: 'photo1',
        reactionId: 'reaction1',
        userId: 'user2',
        userName: 'Trần Thị Bình',
        reaction: '❤️',
        timestamp: admin.firestore.FieldValue.serverTimestamp()
      },
      {
        photoId: 'photo1',
        reactionId: 'reaction2',
        userId: 'user3',
        userName: 'Lê Văn Cường',
        reaction: '👍',
        timestamp: admin.firestore.FieldValue.serverTimestamp()
      },
      {
        photoId: 'photo2',
        reactionId: 'reaction3',
        userId: 'user4',
        userName: 'Phạm Thị Dung',
        reaction: '❤️',
        timestamp: admin.firestore.FieldValue.serverTimestamp()
      }
    ];

    // Create reactions
    for (const reaction of reactions) {
      await db.collection('photos')
        .doc(reaction.photoId)
        .collection('reactions')
        .doc(reaction.reactionId)
        .set({
          userId: reaction.userId,
          userName: reaction.userName,
          reaction: reaction.reaction,
          timestamp: reaction.timestamp
        });
      console.log(`Created reaction: ${reaction.reaction} on ${reaction.photoId}`);
    }

    // Create group invites
    const invites = [
      {
        id: 'FAMILY01',
        groupId: 'group1',
        inviteCode: 'FAMILY01',
        createdBy: 'user1',
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
        expiresAt: new Date(Date.now() + 7 * 24 * 60 * 60 * 1000), // 7 days from now
        usedCount: 0,
        isActive: true
      },
      {
        id: 'FRIENDS01',
        groupId: 'group2',
        inviteCode: 'FRIENDS01',
        createdBy: 'user2',
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
        expiresAt: new Date(Date.now() + 7 * 24 * 60 * 60 * 1000),
        usedCount: 0,
        isActive: true
      },
      {
        id: 'WORK01',
        groupId: 'group3',
        inviteCode: 'WORK01',
        createdBy: 'user3',
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
        expiresAt: new Date(Date.now() + 7 * 24 * 60 * 60 * 1000),
        usedCount: 0,
        isActive: true
      }
    ];

    // Create invites
    for (const invite of invites) {
      await db.collection('group_invites').doc(invite.id).set(invite);
      console.log(`Created invite: ${invite.inviteCode}`);
    }

    console.log('✅ Demo data seeded successfully!');
    console.log('\nDemo accounts:');
    console.log('- an@example.com (Admin of Gia đình)');
    console.log('- binh@example.com (Admin of Bạn thân)');
    console.log('- cuong@example.com (Admin of Đồng nghiệp)');
    console.log('- dung@example.com');
    console.log('- em@example.com');
    console.log('\nDemo groups:');
    console.log('- Gia đình (Invite: FAMILY01)');
    console.log('- Bạn thân (Invite: FRIENDS01)');
    console.log('- Đồng nghiệp (Invite: WORK01)');
    console.log('\nDemo photos: 5 photos created across groups');

  } catch (error) {
    console.error('Error seeding demo data:', error);
  } finally {
    process.exit(0);
  }
}

// Run the seeding
seedDemoData();

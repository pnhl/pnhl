import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:permission_handler/permission_handler.dart';

import '../config/app_config.dart';

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService.instance;
});

class NotificationService {
  static final NotificationService instance = NotificationService._internal();
  NotificationService._internal();

  FirebaseMessaging? _messaging;
  String? _fcmToken;

  Future<void> initialize() async {
    try {
      _messaging = FirebaseMessaging.instance;

      // Request permission
      await requestPermission();

      // Get FCM token
      _fcmToken = await _messaging?.getToken();
      debugPrint('FCM Token: $_fcmToken');

      // Listen for token refresh
      _messaging?.onTokenRefresh.listen((token) {
        _fcmToken = token;
        debugPrint('FCM Token refreshed: $token');
        // TODO: Update token in Firestore
      });

      // Handle foreground messages
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

      // Handle background messages
      FirebaseMessaging.onBackgroundMessage(_handleBackgroundMessage);

      // Handle notification taps
      FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);

      // Check for initial message (when app is opened from notification)
      final initialMessage = await _messaging?.getInitialMessage();
      if (initialMessage != null) {
        _handleNotificationTap(initialMessage);
      }

    } catch (e) {
      debugPrint('Failed to initialize NotificationService: $e');
    }
  }

  Future<void> requestPermission() async {
    if (_messaging == null) return;

    // Request notification permission
    final settings = await _messaging!.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      announcement: false,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
    );

    debugPrint('Notification permission: ${settings.authorizationStatus}');

    // For Android 13+, request POST_NOTIFICATIONS permission
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }
  }

  String? get fcmToken => _fcmToken;

  // Subscribe to group notifications
  Future<void> subscribeToGroup(String groupId) async {
    try {
      await _messaging?.subscribeToTopic('group_$groupId');
      debugPrint('Subscribed to group: $groupId');
    } catch (e) {
      debugPrint('Failed to subscribe to group: $e');
    }
  }

  // Unsubscribe from group notifications
  Future<void> unsubscribeFromGroup(String groupId) async {
    try {
      await _messaging?.unsubscribeFromTopic('group_$groupId');
      debugPrint('Unsubscribed from group: $groupId');
    } catch (e) {
      debugPrint('Failed to unsubscribe from group: $e');
    }
  }

  // Handle foreground messages
  void _handleForegroundMessage(RemoteMessage message) {
    debugPrint('Foreground message: ${message.data}');
    
    // Show local notification or update UI
    // You could use flutter_local_notifications here
    
    // Update widget if it's a photo notification
    if (message.data['type'] == 'new_photo') {
      // Trigger widget update
    }
  }

  // Handle notification tap
  void _handleNotificationTap(RemoteMessage message) {
    debugPrint('Notification tapped: ${message.data}');
    
    final data = message.data;
    final type = data['type'];
    
    switch (type) {
      case 'new_photo':
        final photoId = data['photoId'];
        final groupId = data['groupId'];
        if (photoId != null && groupId != null) {
          // Navigate to photo viewer
          // GoRouter.of(context).go('/photo/$photoId?groupId=$groupId');
        }
        break;
      case 'group_invite':
        final inviteCode = data['inviteCode'];
        if (inviteCode != null) {
          // Navigate to join group
          // GoRouter.of(context).go('/groups/join?code=$inviteCode');
        }
        break;
      case 'reaction':
        final photoId = data['photoId'];
        if (photoId != null) {
          // Navigate to photo viewer
          // GoRouter.of(context).go('/photo/$photoId');
        }
        break;
    }
  }
}

// Background message handler (must be top-level function)
@pragma('vm:entry-point')
Future<void> _handleBackgroundMessage(RemoteMessage message) async {
  debugPrint('Background message: ${message.data}');
  
  // Update widget if needed
  if (message.data['type'] == 'new_photo') {
    // Trigger widget update
  }
}

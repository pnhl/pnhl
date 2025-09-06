class AppConfig {
  static const String appName = 'Camera Gold';
  static const String packageName = 'com.cameragold.app';
  
  // Widget Config
  static const String widgetGroupId = 'group.com.cameragold.app.widgets';
  static const String widgetName = 'CameraGoldWidget';
  
  // Firebase Config
  static const String firebaseProjectId = 'camera-gold-app';
  
  // Image Config
  static const int maxImageDimension = 1440;
  static const int jpegQuality = 75;
  static const int thumbnailSize = 300;
  
  // Group Config
  static const int maxGroupMembers = 20;
  static const int maxCommentLength = 60;
  
  // Widget Refresh Config
  static const Duration widgetRefreshInterval = Duration(minutes: 15);
  static const Duration widgetDebounceDelay = Duration(seconds: 3);
  
  // Notification Config
  static const String notificationChannelId = 'camera_gold_main';
  static const String notificationChannelName = 'Camera Gold';
  static const String notificationChannelDescription = 'Notifications for new photos and reactions';
}

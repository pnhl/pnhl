import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_widget/home_widget.dart';
import 'package:workmanager/workmanager.dart';

import '../config/app_config.dart';
import '../models/widget_state.dart';
import '../../features/photos/domain/entities/photo.dart';
import '../../features/groups/domain/entities/group.dart';

final widgetServiceProvider = Provider<WidgetService>((ref) {
  return WidgetService.instance;
});

class WidgetService {
  static final WidgetService instance = WidgetService._internal();
  WidgetService._internal();

  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Initialize home_widget
      await HomeWidget.setAppGroupId(AppConfig.widgetGroupId);
      await HomeWidget.registerBackgroundCallback(_backgroundCallback);
      
      // Schedule periodic widget refresh for Android
      if (Platform.isAndroid) {
        await Workmanager().registerPeriodicTask(
          'widget_refresh',
          'widget_refresh',
          frequency: AppConfig.widgetRefreshInterval,
          constraints: Constraints(
            networkType: NetworkType.connected,
            requiresBatteryNotLow: true,
          ),
        );
      }
      
      _isInitialized = true;
    } catch (e) {
      debugPrint('Failed to initialize WidgetService: $e');
    }
  }

  // Background callback for widget updates
  @pragma('vm:entry-point')
  static Future<void> _backgroundCallback(Uri uri) async {
    try {
      await WidgetService.instance.refreshWidgets();
    } catch (e) {
      debugPrint('Widget background callback error: $e');
    }
  }

  // Update widget with latest photo from user's pinned group
  Future<void> updateWidget(WidgetState widgetState) async {
    try {
      // Save widget data to shared preferences/app group
      await HomeWidget.saveWidgetData<String>(
        'widget_data',
        jsonEncode(widgetState.toJson()),
      );

      // Update widget UI
      await HomeWidget.updateWidget(
        name: AppConfig.widgetName,
        androidName: 'CameraGoldWidgetProvider',
        iOSName: 'CameraGoldWidget',
        qualifiedAndroidName: 'com.cameragold.app.CameraGoldWidgetProvider',
      );

      debugPrint('Widget updated successfully');
    } catch (e) {
      debugPrint('Failed to update widget: $e');
    }
  }

  // Refresh widgets with latest data
  Future<void> refreshWidgets() async {
    try {
      // This would typically fetch the latest photo from the user's pinned group
      // For now, we'll just trigger a widget update
      await HomeWidget.updateWidget(
        name: AppConfig.widgetName,
        androidName: 'CameraGoldWidgetProvider',
        iOSName: 'CameraGoldWidget',
        qualifiedAndroidName: 'com.cameragold.app.CameraGoldWidgetProvider',
      );
    } catch (e) {
      debugPrint('Failed to refresh widgets: $e');
    }
  }

  // Push latest photo to widget for a specific user
  Future<void> pushLatestForUser(String uid) async {
    try {
      // This would be called after a new photo is uploaded
      // Fetch user's pinned group and latest photo
      // Update widget accordingly
      
      // For now, just refresh the widget
      await refreshWidgets();
    } catch (e) {
      debugPrint('Failed to push latest for user: $e');
    }
  }

  // Handle widget tap (deep link)
  Future<void> handleWidgetTap(String? data) async {
    if (data == null) return;
    
    try {
      final Map<String, dynamic> tapData = jsonDecode(data);
      final action = tapData['action'] as String?;
      
      switch (action) {
        case 'open_photo':
          final photoId = tapData['photoId'] as String?;
          final groupId = tapData['groupId'] as String?;
          if (photoId != null) {
            // Handle deep link to photo
            // This would typically be handled by the router
          }
          break;
        case 'open_group':
          final groupId = tapData['groupId'] as String?;
          if (groupId != null) {
            // Handle deep link to group
          }
          break;
        case 'refresh':
          await refreshWidgets();
          break;
      }
    } catch (e) {
      debugPrint('Failed to handle widget tap: $e');
    }
  }

  // Get current widget state
  Future<WidgetState?> getCurrentWidgetState() async {
    try {
      final data = await HomeWidget.getWidgetData<String>('widget_data');
      if (data != null) {
        return WidgetState.fromJson(jsonDecode(data));
      }
    } catch (e) {
      debugPrint('Failed to get current widget state: $e');
    }
    return null;
  }

  // Clear widget data
  Future<void> clearWidget() async {
    try {
      await HomeWidget.saveWidgetData<String>('widget_data', '');
      await HomeWidget.updateWidget(
        name: AppConfig.widgetName,
        androidName: 'CameraGoldWidgetProvider',
        iOSName: 'CameraGoldWidget',
        qualifiedAndroidName: 'com.cameragold.app.CameraGoldWidgetProvider',
      );
    } catch (e) {
      debugPrint('Failed to clear widget: $e');
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:workmanager/workmanager.dart';

import 'src/app.dart';
import 'src/core/config/firebase_options.dart';
import 'src/core/services/widget_service.dart';
import 'src/core/services/notification_service.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      
      switch (task) {
        case 'widget_refresh':
          await WidgetService.instance.refreshWidgets();
          break;
        case 'sync_photos':
          // Sync latest photos for widgets
          break;
      }
      return Future.value(true);
    } catch (e) {
      return Future.value(false);
    }
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Setup Crashlytics
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  
  // Initialize WorkManager for background tasks
  await Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: false,
  );
  
  // Initialize services
  await NotificationService.instance.initialize();
  await WidgetService.instance.initialize();
  
  runApp(
    const ProviderScope(
      child: CameraGoldApp(),
    ),
  );
}

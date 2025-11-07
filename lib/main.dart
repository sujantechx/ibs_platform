export 'app.dart';

import 'dart:developer' as developer;
import 'dart:ui';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Import your new app.dart file
import 'package:ibs_platform/app.dart';
import 'firebase_options.dart'; // From your Firebase setup

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    developer.log('Firebase initialized successfully');

    // Pass all uncaught errors to Crashlytics
    FlutterError.onError = (errorDetails) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    };
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };

    try {
      // Activate App Check with default providers. Avoid explicit deprecated androidProvider param.
      await FirebaseAppCheck.instance.activate();
      developer.log('Firebase App Check activated');
    } catch (e) {
      developer.log('Error activating App Check: $e', error: e);
    }

    // Run the app from app.dart
    runApp(const MyApp());
  } catch (e) {
    developer.log('Error initializing app: $e', error: e);
  }
}
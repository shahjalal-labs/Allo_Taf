import 'package:allo_taf/core/service/notification/initialization.dart';
import 'package:allo_taf/core/service/notification/services.dart';
import 'package:allo_taf/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'core/service/auth_service.dart';
import 'my_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AuthService.init(); // eta katle app language saved hobe na
  await AuthService.inits();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
  _initAsyncServices();
}

Future<void> _initAsyncServices() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await initializeFCM();
  await PushNotificationService().initialize();
}

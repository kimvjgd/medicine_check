import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:medicine_check/components/dory_theme.dart';
import 'package:medicine_check/pages/home_page.dart';
import 'package:medicine_check/sesrvices/dory_notification_service.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  final notification = DoryNotificationService();
  notification.initializeTimeZone();
  notification.initializeNotification();
  runApp(const MyApp());
}



class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: DoryThemes.lightTheme,
      home: const HomePage(),
    );
  }
}

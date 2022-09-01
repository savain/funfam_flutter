import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fun_fam/router/routes.dart';
import 'package:fun_fam/state/app_state.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constants.dart';
import 'firebase/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final state = AppState(await SharedPreferences.getInstance());
  state.checkLoggedIn();

  runApp(FunFamApp(appState: state));
}

class FunFamApp extends StatefulWidget {
  final AppState appState;
  const FunFamApp({Key? key, required this.appState}) : super(key: key);

  @override
  _FunFamApp createState() => _FunFamApp();
}

class _FunFamApp extends State<FunFamApp> {
  late GoRouter router;

  // Notification Channel을 디바이스에 생성
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    FirebaseMessaging.onMessageOpenedApp.listen((remoteMessage) {
      _firebaseMessagingBackgroundHandler(remoteMessage);
    });
    super.initState();

    initForegroundNotification();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppState>(
          lazy: false,
          create: (BuildContext createContext) => widget.appState,
        ),
        Provider<FunFamRouter>(
          lazy: false,
          create: (BuildContext createContext) => FunFamRouter(widget.appState),
        ),
      ],
      child: Builder(
        builder: (BuildContext context) {
          router = Provider.of<FunFamRouter>(context, listen: false).router;

          return MaterialApp.router(
              routeInformationParser: router.routeInformationParser,
              routerDelegate: router.routerDelegate,
              debugShowCheckedModeBanner: false,
              title: 'FunFam',
              theme: ThemeData(
                  pageTransitionsTheme: const PageTransitionsTheme(builders: {
                    TargetPlatform.android: CupertinoPageTransitionsBuilder(),
                    TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
                  }),
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  primaryColor: const Color(0xffffffff),
                  fontFamily: 'SpoqaHanSansNeo',
                  appBarTheme: const AppBarTheme(color: Colors.white),
                  scaffoldBackgroundColor: Colors.white,
                  textTheme: const TextTheme(
                    headline1:
                        TextStyle(fontSize: 24.0, fontWeight: FontWeight.w500),
                    headline2: TextStyle(
                        fontSize: 18.0, fontWeight: FontWeight.normal),
                    headline3: TextStyle(
                        fontSize: 14.0, fontWeight: FontWeight.normal),
                    caption: TextStyle(
                        fontSize: 12.0, fontWeight: FontWeight.normal),
                  )));
        },
      ),
    );
  }

  Future<void> initForegroundNotification() async {
    // Create android notification channel
    const androidChannelId = 'funfam_notification_channel';
    const androidChannelName = 'FunFam 알림';
    const androidChannelDescription = 'funfam notification channel';

    if (Platform.isAndroid) {
      const AndroidNotificationChannel androidNotificationChannel =
          AndroidNotificationChannel(androidChannelId, androidChannelName,
              description: androidChannelDescription,
              importance: Importance.max);

      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      await androidImplementation
          ?.createNotificationChannel(androidNotificationChannel);

      await androidImplementation?.requestPermission();
    }

    if (Platform.isIOS) {
      await FirebaseMessaging.instance.requestPermission(
        alert: true,
        announcement: true,
        badge: true,
        carPlay: true,
        criticalAlert: true,
        provisional: true,
        sound: true,
      );

      // iOS foreground에서 heads up display 표시를 위해 alert, sound true로 설정
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true, // Required to display a heads up notification
        badge: true,
        sound: true,
      );
    }

    // FlutterLocalNotificationsPlugin 초기화.
    await flutterLocalNotificationsPlugin.initialize(
        const InitializationSettings(
            android: AndroidInitializationSettings('@mipmap/ic_launcher'),
            iOS: IOSInitializationSettings()),
        onSelectNotification: (String? payload) async {
      if (payload != null) {
        handleNotificationMessage(jsonDecode(payload));
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;

      String uid = FirebaseAuth.instance.currentUser!.uid;
      final String senderUid = message.data["uid"];

      if (notification != null && senderUid != uid) {
        const AndroidNotificationDetails androidPlatformChannelSpecifics =
            AndroidNotificationDetails(androidChannelId, androidChannelName,
                channelDescription: androidChannelDescription,
                importance: Importance.max,
                priority: Priority.high);

        const NotificationDetails platformChannelSpecifics =
            NotificationDetails(android: androidPlatformChannelSpecifics);

        flutterLocalNotificationsPlugin.show(
          0,
          notification.title,
          notification.body,
          platformChannelSpecifics,
          payload: jsonEncode(message.data),
        );
      }
    });
  }

  Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    // If you're going to use other Firebase services in the background, such as Firestore,
    // make sure you call `initializeApp` before using other Firebase services.
    await Firebase.initializeApp();
    await Future.delayed(Duration.zero);

    handleNotificationMessage(message.data);
  }

  void handleNotificationMessage(Map<String, dynamic> payload) {
    String? messageType = payload["messageType"];
    if (messageType != null) {
      switch (messageType) {
        case 'new_schedule':
        case 'add_schedule_comment':
          String? date = payload["date"];
          if (date != null) {
            router.pushNamed(routeScheduleDetail, params: {'date': date});
          }
          break;
        case 'add_schedule_comment2':
          break;
        default:
          log("not defined message type");
      }
    }
  }
}

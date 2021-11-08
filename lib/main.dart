import 'dart:async';
import 'dart:math';

import 'package:firebase_core/firebase_core.dart';
import 'package:thepaper_starter/app/auth_widget_builder.dart';
import 'package:thepaper_starter/app/auth_widget.dart';
import 'package:thepaper_starter/routing/router.dart' as route;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thepaper_starter/services/analytics_service.dart';
import 'package:thepaper_starter/services/firestore_database.dart';
import 'package:thepaper_starter/services/firebase_auth_service.dart';

// TODO - Update android package names to thepaper

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Crashlytics.instance.enableInDevMode = true;
  // FlutterError.onError = Crashlytics.instance.recordFlutterError;

  runZoned(() {
    runApp(MyApp(
        authServiceBuilder: (_) => FirebaseAuthService(),
        databaseBuilder: (_, uid) => FirestoreDatabase(uid: uid),
        analyticsService: (_) => AnalyticsService(),
      ));
  });
  
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, this.authServiceBuilder, this.databaseBuilder, this.analyticsService})
      : super(key: key);
  // Expose builders for 3rd party services at the root of the widget tree
  // This is useful when mocking services while testing
  final FirebaseAuthService Function(BuildContext context)? authServiceBuilder;
  final FirestoreDatabase Function(BuildContext context, String uid)?
      databaseBuilder;
  
  final AnalyticsService Function(BuildContext context)? analyticsService;

  @override
  Widget build(BuildContext context) {
    // MultiProvider for top-level services that don't depend on any runtime values (e.g. uid)
    return MultiProvider(
      providers: [
        Provider<FirebaseAuthService>(
          create: authServiceBuilder!,
        ),
        Provider<AnalyticsService>(
          create: analyticsService!,
        )
      ],
      child: AuthWidgetBuilder(
        databaseBuilder: databaseBuilder,
        builder: (BuildContext context, AsyncSnapshot<AppUser> userSnapshot) {
          return MaterialApp(
            // theme: ThemeData(primarySwatch: Colors.indigo),
            theme: ThemeData(
              // brightness: Brightness.dark,
              primaryColor: Colors.white, //Color(0xFFF3F5F7),
              // primarySwatch: white,
              // primaryColor: Colors.white,//Color(0xFF3EBACE),
              // accentColor: Color(0xFFD8ECF1),
              scaffoldBackgroundColor: Colors.white, //Color(0xFFF3F5F7),
              // fontFamily: 'Goldman',
            ),
            debugShowCheckedModeBanner: false,
            home: AuthWidget(userSnapshot: userSnapshot),
            onGenerateRoute: route.Router.onGenerateRoute,
            builder: (context, child) {
              return MediaQuery(
                child: child!,
                  data: MediaQuery.of(context).copyWith(textScaleFactor: max(0.8, min(1.2, (10*MediaQuery.textScaleFactorOf(context)).round()/10))));
            },
          );
        },
      ),
    );
  }
}

const MaterialColor white = const MaterialColor(
  0xFFFFFFFF,
  const <int, Color>{
    50: const Color(0xFFFFFFFF),
    100: const Color(0xFFFFFFFF),
    200: const Color(0xFFFFFFFF),
    300: const Color(0xFFFFFFFF),
    400: const Color(0xFFFFFFFF),
    500: const Color(0xFFFFFFFF),
    600: const Color(0xFFFFFFFF),
    700: const Color(0xFFFFFFFF),
    800: const Color(0xFFFFFFFF),
    900: const Color(0xFFFFFFFF),
  },
);

import 'package:thepaper_starter/app/auth_widget_builder.dart';
import 'package:thepaper_starter/app/auth_widget.dart';
import 'package:thepaper_starter/routing/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thepaper_starter/services/firestore_database.dart';
import 'package:thepaper_starter/services/firebase_auth_service.dart';
// TODO - Update android package names to thepaper

void main() => runApp(MyApp(
      authServiceBuilder: (_) => FirebaseAuthService(),
      databaseBuilder: (_, uid) => FirestoreDatabase(uid: uid),
    ));

class MyApp extends StatelessWidget {
  const MyApp({Key key, this.authServiceBuilder, this.databaseBuilder})
      : super(key: key);
  // Expose builders for 3rd party services at the root of the widget tree
  // This is useful when mocking services while testing
  final FirebaseAuthService Function(BuildContext context) authServiceBuilder;
  final FirestoreDatabase Function(BuildContext context, String uid)
      databaseBuilder;

  @override
  Widget build(BuildContext context) {
    // MultiProvider for top-level services that don't depend on any runtime values (e.g. uid)
    return MultiProvider(
      providers: [
        Provider<FirebaseAuthService>(
          create: authServiceBuilder,
        ),
      ],
      child: AuthWidgetBuilder(
        databaseBuilder: databaseBuilder,
        builder: (BuildContext context, AsyncSnapshot<User> userSnapshot) {
          return MaterialApp(
            theme: ThemeData(primarySwatch: Colors.indigo),
            debugShowCheckedModeBanner: false,
            home: AuthWidget(userSnapshot: userSnapshot),
            onGenerateRoute: Router.onGenerateRoute,
          );
        },
      ),
    );
  }
}

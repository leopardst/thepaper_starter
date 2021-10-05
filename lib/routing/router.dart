import 'package:flutter/material.dart';
import 'package:thepaper_starter/app/auth_widget.dart';
import 'package:thepaper_starter/app/home/account/edit_profile_page.dart';
import 'package:thepaper_starter/app/home/condolences/compose_page.dart';
import 'package:thepaper_starter/app/home/condolences/condolences_page.dart';
import 'package:thepaper_starter/app/home/models/funeral.dart';
import 'package:thepaper_starter/app/home/models/user_profile.dart';
import 'package:thepaper_starter/app/sign_in/email_password/email_password_sign_in_page.dart';
import 'package:thepaper_starter/services/firebase_auth_service.dart';


class Routes {
  static const authWidget = '/';
  static const emailPasswordSignInPageBuilder =
      '/email-password-sign-in-page-builder';
  static const editProfilePage = '/edit-profile-page';
  static const condolencePage = '/condolences-page';
  static const composePage = '/compose-page';

}

class Router {
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case Routes.authWidget:
        return MaterialPageRoute<dynamic>(
          builder: (_) => AuthWidget(userSnapshot: args as AsyncSnapshot<AppUser>?),
          settings: settings,
        );
      case Routes.emailPasswordSignInPageBuilder:
        return MaterialPageRoute<dynamic>(
          builder: (_) => EmailPasswordSignInPageBuilder(onSignedIn: args as void Function()?),
          settings: settings,
          fullscreenDialog: true,
        );
      case Routes.editProfilePage:
        return MaterialPageRoute<dynamic>(
          builder: (_) => EditProfilePage(userProfile: args as UserProfile?),
          settings: settings,
          fullscreenDialog: true,
        );
      case Routes.composePage:
        return MaterialPageRoute<dynamic>(
          builder: (_) => ComposePage(funeral: args as Funeral?),
          settings: settings,
          fullscreenDialog: true,
        );
      case Routes.condolencePage:
        return MaterialPageRoute<dynamic>(
          builder: (_) => CondolencesPage(funeral: args as Funeral?),
          settings: settings,
          fullscreenDialog: true,
        );
      default:
        // TODO: Throw
        return null;
    }
  }
}
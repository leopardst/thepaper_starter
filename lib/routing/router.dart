import 'package:flutter/material.dart';
import 'package:thepaper_starter/app/auth_widget.dart';
import 'package:thepaper_starter/app/home/account/edit_profile_page.dart';
import 'package:thepaper_starter/app/home/condolences/compose_page.dart';
import 'package:thepaper_starter/app/home/condolences/condolences_page.dart';
import 'package:thepaper_starter/app/home/job_entries/entry_page.dart';
import 'package:thepaper_starter/app/home/jobs/edit_job_page.dart';
import 'package:thepaper_starter/app/home/models/entry.dart';
import 'package:thepaper_starter/app/home/models/job.dart';
import 'package:thepaper_starter/app/sign_in/email_password/email_password_sign_in_page.dart';


class Routes {
  static const authWidget = '/';
  static const emailPasswordSignInPageBuilder =
      '/email-password-sign-in-page-builder';
  static const editJobPage = '/edit-job-page';
  static const entryPage = '/entry-page';
  static const editProfilePage = '/edit-profile-page';
  static const condolencePage = '/condolences-page';
  static const composePage = '/compose-page';

}

class Router {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case Routes.authWidget:
        return MaterialPageRoute<dynamic>(
          builder: (_) => AuthWidget(userSnapshot: args),
          settings: settings,
        );
      case Routes.emailPasswordSignInPageBuilder:
        return MaterialPageRoute<dynamic>(
          builder: (_) => EmailPasswordSignInPageBuilder(onSignedIn: args),
          settings: settings,
          fullscreenDialog: true,
        );
      case Routes.editJobPage:
        return MaterialPageRoute<dynamic>(
          builder: (_) => EditJobPage(job: args),
          settings: settings,
          fullscreenDialog: true,
        );
      case Routes.entryPage:
        final Map<String, dynamic> mapArgs = args;
        final Job job = mapArgs['job'];
        final Entry entry = mapArgs['entry'];
        return MaterialPageRoute<dynamic>(
          builder: (_) => EntryPage(job: job, entry: entry),
          settings: settings,
          fullscreenDialog: true,
        );
      case Routes.editProfilePage:
        return MaterialPageRoute<dynamic>(
          builder: (_) => EditProfilePage(userProfile: args),
          settings: settings,
          fullscreenDialog: true,
        );
      case Routes.composePage:
        return MaterialPageRoute<dynamic>(
          builder: (_) => ComposePage(funeral: args),
          settings: settings,
          fullscreenDialog: true,
        );
      case Routes.condolencePage:
        return MaterialPageRoute<dynamic>(
          builder: (_) => CondolencesPage(funeral: args),
          settings: settings,
          fullscreenDialog: true,
        );
      default:
        // TODO: Throw
        return null;
    }
  }
}
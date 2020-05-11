// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:auto_route/router_utils.dart';
import 'package:thepaper_starter/app/auth_widget.dart';
import 'package:thepaper_starter/services/firebase_auth_service.dart';
import 'package:thepaper_starter/app/sign_in/email_password/email_password_sign_in_page.dart';
import 'package:thepaper_starter/app/home/jobs/edit_job_page.dart';
import 'package:thepaper_starter/app/home/models/job.dart';
import 'package:thepaper_starter/app/home/condolences/compose_page.dart';
import 'package:thepaper_starter/app/home/models/funeral.dart';
import 'package:thepaper_starter/app/home/condolences/condolences_page.dart';
import 'package:thepaper_starter/app/home/job_entries/entry_page.dart';
import 'package:thepaper_starter/app/home/models/entry.dart';

class Router {
  static const authWidget = '/';
  static const emailPasswordSignInPageBuilder =
      '/email-password-sign-in-page-builder';
  static const editJobPage = '/edit-job-page';
  static const composePage = '/compose-page';
  static const condolencesPage = '/condolences-page';
  static const entryPage = '/entry-page';
  static GlobalKey<NavigatorState> get navigatorKey =>
      getNavigatorKey<Router>();
  static NavigatorState get navigator => navigatorKey.currentState;

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case Router.authWidget:
        if (hasInvalidArgs<AuthWidgetArguments>(args, isRequired: true)) {
          return misTypedArgsRoute<AuthWidgetArguments>(args);
        }
        final typedArgs = args as AuthWidgetArguments;
        return MaterialPageRoute(
          builder: (_) => AuthWidget(
              key: typedArgs.key, userSnapshot: typedArgs.userSnapshot),
          settings: settings,
        );
      case Router.emailPasswordSignInPageBuilder:
        if (hasInvalidArgs<EmailPasswordSignInPageBuilderArguments>(args)) {
          return misTypedArgsRoute<EmailPasswordSignInPageBuilderArguments>(
              args);
        }
        final typedArgs = args as EmailPasswordSignInPageBuilderArguments ??
            EmailPasswordSignInPageBuilderArguments();
        return MaterialPageRoute(
          builder: (_) => EmailPasswordSignInPageBuilder(
              key: typedArgs.key, onSignedIn: typedArgs.onSignedIn),
          settings: settings,
          fullscreenDialog: true,
        );
      case Router.editJobPage:
        if (hasInvalidArgs<EditJobPageArguments>(args)) {
          return misTypedArgsRoute<EditJobPageArguments>(args);
        }
        final typedArgs =
            args as EditJobPageArguments ?? EditJobPageArguments();
        return MaterialPageRoute(
          builder: (_) => EditJobPage(key: typedArgs.key, job: typedArgs.job),
          settings: settings,
          fullscreenDialog: true,
        );
      case Router.composePage:
        if (hasInvalidArgs<ComposePageArguments>(args, isRequired: true)) {
          return misTypedArgsRoute<ComposePageArguments>(args);
        }
        final typedArgs = args as ComposePageArguments;
        return MaterialPageRoute(
          builder: (_) =>
              ComposePage(key: typedArgs.key, funeral: typedArgs.funeral),
          settings: settings,
          fullscreenDialog: true,
        );
      case Router.condolencesPage:
        if (hasInvalidArgs<CondolencesPageArguments>(args, isRequired: true)) {
          return misTypedArgsRoute<CondolencesPageArguments>(args);
        }
        final typedArgs = args as CondolencesPageArguments;
        return MaterialPageRoute(
          builder: (_) =>
              CondolencesPage(key: typedArgs.key, funeral: typedArgs.funeral),
          settings: settings,
          fullscreenDialog: true,
        );
      case Router.entryPage:
        if (hasInvalidArgs<EntryPageArguments>(args, isRequired: true)) {
          return misTypedArgsRoute<EntryPageArguments>(args);
        }
        final typedArgs = args as EntryPageArguments;
        return MaterialPageRoute(
          builder: (_) => EntryPage(job: typedArgs.job, entry: typedArgs.entry),
          settings: settings,
          fullscreenDialog: true,
        );
      default:
        return unknownRoutePage(settings.name);
    }
  }
}

//**************************************************************************
// Arguments holder classes
//***************************************************************************

//AuthWidget arguments holder class
class AuthWidgetArguments {
  final Key key;
  final AsyncSnapshot<User> userSnapshot;
  AuthWidgetArguments({this.key, @required this.userSnapshot});
}

//EmailPasswordSignInPageBuilder arguments holder class
class EmailPasswordSignInPageBuilderArguments {
  final Key key;
  final void Function() onSignedIn;
  EmailPasswordSignInPageBuilderArguments({this.key, this.onSignedIn});
}

//EditJobPage arguments holder class
class EditJobPageArguments {
  final Key key;
  final Job job;
  EditJobPageArguments({this.key, this.job});
}

//ComposePage arguments holder class
class ComposePageArguments {
  final Key key;
  final Funeral funeral;
  ComposePageArguments({this.key, @required this.funeral});
}

//CondolencesPage arguments holder class
class CondolencesPageArguments {
  final Key key;
  final Funeral funeral;
  CondolencesPageArguments({this.key, @required this.funeral});
}

//EntryPage arguments holder class
class EntryPageArguments {
  final Job job;
  final Entry entry;
  EntryPageArguments({@required this.job, this.entry});
}

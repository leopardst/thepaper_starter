// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:auto_route/router_utils.dart';
import 'package:thepaper_starter/app/home/funerals/funeral_details_page.dart';
import 'package:thepaper_starter/app/home/models/funeral.dart';
import 'package:thepaper_starter/app/home/user_profiles/user_profile_page.dart';
import 'package:thepaper_starter/app/home/models/user_profile.dart';
import 'package:thepaper_starter/app/home/groups/group_page.dart';
import 'package:thepaper_starter/app/home/models/group.dart';

class CupertinoTabViewRouter {
  static const funeralDetailsPage = '/funeral-details-page';
  static const userProfilePage = '/user-profile-page';
  static const groupPage = '/group-page';
  static GlobalKey<NavigatorState> get navigatorKey =>
      getNavigatorKey<CupertinoTabViewRouter>();
  static NavigatorState get navigator => navigatorKey.currentState;

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case CupertinoTabViewRouter.funeralDetailsPage:
        if (hasInvalidArgs<Funeral>(args, isRequired: true)) {
          return misTypedArgsRoute<Funeral>(args);
        }
        final typedArgs = args as Funeral;
        return CupertinoPageRoute(
          builder: (_) => FuneralDetailsPage(funeral: typedArgs),
          settings: settings,
          fullscreenDialog: false,
        );
      case CupertinoTabViewRouter.userProfilePage:
        if (hasInvalidArgs<UserProfile>(args)) {
          return misTypedArgsRoute<UserProfile>(args);
        }
        final typedArgs = args as UserProfile;
        return MaterialPageRoute(
          builder: (_) => UserProfilePage(userProfile: typedArgs),
          settings: settings,
        );
      case CupertinoTabViewRouter.groupPage:
        if (hasInvalidArgs<Group>(args, isRequired: true)) {
          return misTypedArgsRoute<Group>(args);
        }
        final typedArgs = args as Group;
        return MaterialPageRoute(
          builder: (_) => GroupPage(group: typedArgs),
          settings: settings,
        );
      default:
        return unknownRoutePage(settings.name);
    }
  }
}

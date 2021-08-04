import 'package:thepaper_starter/app/home/funerals/funeral_details_page.dart';
import 'package:thepaper_starter/app/home/groups/group_page.dart';
import 'package:thepaper_starter/app/home/models/funeral.dart';
import 'package:thepaper_starter/app/home/user_profiles/user_profile_page.dart';
import 'package:flutter/cupertino.dart';



// class $CupertinoTabViewRouter {
// //   @CupertinoRoute(fullscreenDialog: false)
// //   FuneralDetailsPage funeralDetailsPage;
// //   UserProfilePage userProfilePage;
// //   GroupPage groupPage;
// }

class CupertinoTabViewRoutes {
  static const funeralDetailsPage = '/funeral-details-page';
  static const userProfilePage = '/user-profile-page';
  static const groupPage = '/group-page';

  //   @CupertinoRoute(fullscreenDialog: false)
  //   FuneralDetailsPage funeralDetailsPage;
  //   UserProfilePage userProfilePage;
  //   GroupPage groupPage;
}

class CupertinoTabViewRouter {
  static Route generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case CupertinoTabViewRoutes.funeralDetailsPage:
        final Map<String, dynamic> mapArgs = settings.arguments;
        final Funeral funeral = mapArgs['funeral'];
        final String parent = mapArgs['parent'];
        return CupertinoPageRoute(
          builder: (_) => FuneralDetailsPage(funeral: funeral, parent: parent),
          settings: settings,
          fullscreenDialog: true,
        );
      case CupertinoTabViewRoutes.groupPage:
        final group = settings.arguments;
        return CupertinoPageRoute(
          builder: (_) => GroupPage(group: group),
          settings: settings,
          fullscreenDialog: true,
        );
      case CupertinoTabViewRoutes.userProfilePage:
        final userProfile = settings.arguments;
        return CupertinoPageRoute(
          builder: (_) => UserProfilePage(userProfile: userProfile),
          settings: settings,
          fullscreenDialog: true,
        );
    }
    return null;
  }
}
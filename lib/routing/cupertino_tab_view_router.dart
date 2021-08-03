import 'package:auto_route/annotations.dart';
import 'package:thepaper_starter/app/home/funerals/funeral_details_page.dart';
import 'package:thepaper_starter/app/home/groups/group_page.dart';
import 'package:thepaper_starter/app/home/user_profiles/user_profile_page.dart';

@CupertinoAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    AutoRoute(page: FuneralDetailsPage),
    AutoRoute(page: UserProfilePage),
    AutoRoute(page: GroupPage)
  ],
)

class $CupertinoTabViewRouter {
//   @CupertinoRoute(fullscreenDialog: false)
//   FuneralDetailsPage funeralDetailsPage;
//   UserProfilePage userProfilePage;
//   GroupPage groupPage;
}

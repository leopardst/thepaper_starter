import 'package:auto_route/auto_route_annotations.dart';
import 'package:thepaper_starter/app/home/funerals/funeral_details_page.dart';
import 'package:thepaper_starter/app/home/groups/group_page.dart';
import 'package:thepaper_starter/app/home/user_profiles/user_profile_page.dart';

@autoRouter
class $CupertinoTabViewRouter {
  @CupertinoRoute(fullscreenDialog: false)
  FuneralDetailsPage funeralDetailsPage;
  UserProfilePage userProfilePage;
  GroupPage groupPage;
}

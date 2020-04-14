import 'package:auto_route/auto_route_annotations.dart';
import 'package:thepaper_starter/app/home/funerals/funeral_details_page.dart';

@autoRouter
class $CupertinoTabViewRouter {
  @CupertinoRoute(fullscreenDialog: false)
  FuneralDetailsPage funeralDetailsPage;
}

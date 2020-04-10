import 'package:auto_route/auto_route_annotations.dart';
import 'package:thepaper_starter/app/home/job_entries/job_entries_page.dart';

@autoRouter
class $CupertinoTabViewRouter {
  @CupertinoRoute(fullscreenDialog: false)
  JobEntriesPage jobEntriesPage;
}

import 'package:auto_route/auto_route_annotations.dart';
import 'package:thepaper_starter/app/auth_widget.dart';
import 'package:thepaper_starter/app/home/account/edit_profile_page.dart';
import 'package:thepaper_starter/app/home/calendar/calendar_page.dart';
import 'package:thepaper_starter/app/home/job_entries/entry_page.dart';
import 'package:thepaper_starter/app/home/jobs/edit_job_page.dart';
import 'package:thepaper_starter/app/sign_in/email_password/email_password_sign_in_page.dart';
import 'package:thepaper_starter/app/home/condolences/compose_page.dart';
import 'package:thepaper_starter/app/home/condolences/condolences_page.dart';


// flutter packages pub run build_runner build

@autoRouter
class $AppRouter {
  @initial
  AuthWidget authWidget;

  @MaterialRoute(fullscreenDialog: true)
  EmailPasswordSignInPageBuilder emailPasswordSignInPageBuilder;

  @MaterialRoute(fullscreenDialog: true)
  EditJobPage editJobPage;

  @MaterialRoute(fullscreenDialog: true)
  ComposePage composePage;

  @MaterialRoute(fullscreenDialog: true)
  EditProfilePage editProfilePage;

  @MaterialRoute(fullscreenDialog: true)
  CondolencesPage condolencesPage;

  @MaterialRoute(fullscreenDialog: true)
  EntryPage entryPage;
}

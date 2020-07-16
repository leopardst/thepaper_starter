import 'package:amplitude_flutter/amplitude.dart';
import 'package:amplitude_flutter/identify.dart';

class AnalyticsService {

  // Create the instance
  final Amplitude analytics = Amplitude.getInstance(instanceName: "the paper");



  // Identify
  // final Identify identify1 = Identify()
  //   ..set('identify_test',
  //       'identify sent at ${DateTime.now().millisecondsSinceEpoch}')
  //   ..add('identify_count', 1);
  // analytics.identify(identify1);

  // Set group
  // analytics.setGroup('orgId', 15);

  // // Group identify
  // final Identify identify2 = Identify()
  //   ..set('identify_count', 1);
  // analytics.groupIdentify('orgId', '15', identify2);
  

  Future<void> logViewedFuneralPage(String funeralName, String funeralId) async {
    analytics.logEvent('Viewed funeral page', eventProperties: {
      'funeral_name': funeralName,
      'funeral_id': funeralId,
    });
  }

  Future<void> logSearched(String query, int count) async {
    analytics.logEvent('Searched for listing', eventProperties: {
      'query': query,
      'results_count': count,
    });
  }

  Future<void> logCreateCondolence(String message, String funeralId) async {
    analytics.logEvent('Created new condolence', eventProperties: {
      'message': message ?? null,
      'name_only': (message == null) ? 'true' : 'false',
      // 'funeral_name': funeralName,
      'funeral_id': funeralId,
    });
  }

  Future<void> logRemoveCondolence(String id, String funeralId) async {
    analytics.logEvent('Removed condolence', eventProperties: {
      'condolenceId': id,
      'funeral_id': funeralId,
    });
  }

  Future<void> logSignOut() async {
    analytics.logEvent('User signed out');
  }

  Future<void> identifyUser(String uid, String name) async {

    analytics.init('5a182768ac170e9709225cc38f44e3d0');

    // Enable COPPA privacy guard. This is useful when you choose not to report sensitive user information.
    analytics.enableCoppaControl();

    // Turn on automatic session events
    analytics.trackingSessionEvents(true);
    
    analytics.setUserId(uid);
    
    final Identify identify1 = Identify()
      ..set('name', name);
    analytics.identify(identify1);

    analytics.logEvent('App launched');

  }

  Future<void> logViewCalendar() async {
    analytics.logEvent('Viewed calendar');
  }


}
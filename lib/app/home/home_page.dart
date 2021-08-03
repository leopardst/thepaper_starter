import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:thepaper_starter/app/home/account/account_page.dart';
import 'package:thepaper_starter/app/home/cupertino_home_scaffold.dart';
import 'package:thepaper_starter/app/home/jobs/jobs_page.dart';
import 'package:thepaper_starter/app/home/funerals/funerals_page.dart';
import 'package:thepaper_starter/app/home/tab_item.dart';
import 'package:package_info/package_info.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:thepaper_starter/app/home/search/search_page.dart';
import 'package:thepaper_starter/push_notifications.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TabItem _currentTab = TabItem.funerals;

  final Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys = {
    TabItem.funerals: GlobalKey<NavigatorState>(),
    TabItem.search: GlobalKey<NavigatorState>(),
    TabItem.account: GlobalKey<NavigatorState>(),
  };

  Map<TabItem, WidgetBuilder> get widgetBuilders {
    return {
      TabItem.funerals: (_) => FuneralsPage(),
      TabItem.search: (_) => SearchPage(),
      TabItem.account: (_) => AccountPage(),
    };
  }
 
  final PushNotificationsManager pfm = new PushNotificationsManager();
  
  @override
  void initState() {
    // pfm.init();

    try {
      versionCheck(context);
    } catch (e) {
      print(e);
    }
    super.initState();
  }

  void _select(TabItem tabItem) {
    if (tabItem == _currentTab) {
      // pop to first route
      navigatorKeys[tabItem].currentState.popUntil((route) => route.isFirst);
    } else {
      setState(() => _currentTab = tabItem);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => !await navigatorKeys[_currentTab].currentState.maybePop(),
      child: CupertinoHomeScaffold(
        currentTab: _currentTab,
        onSelectTab: _select,
        widgetBuilders: widgetBuilders,
        navigatorKeys: navigatorKeys,
      ),
    );
  }

 versionCheck(context) async {
  //Get Current installed version of app
  final PackageInfo info = await PackageInfo.fromPlatform();
  double currentVersion = double.parse(info.version.trim().replaceAll(".", ""));

  //Get Latest version info from firebase config
  final RemoteConfig remoteConfig = await RemoteConfig.instance;

  try {
    // Using default duration to force fetching from remote server.
    // await remoteConfig.fetch(expiration: const Duration(seconds: 0));
    // await remoteConfig.activateFetched();

    final data = json.decode(remoteConfig.getString('new_version'));
    double newVersion = double.parse(data['version'].trim().replaceAll(".", ""));
    final newVersionText = data['text'];
    final url = data['url'];
    bool required = data['required'];
    
    print("text: $newVersionText");
    if (newVersion > currentVersion) {
      _showVersionDialog(context, newVersionText, url, required);
    }
  // } on FetchThrottledException catch (exception) {
  //   // Fetch throttled.
  //   print(exception);
  } catch (exception) {
    print('Unable to fetch remote config. Cached or default values will be '
        'used');
  }
  }

  _showVersionDialog(context, String text, String url, bool required) async {
    await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        String title = "New Update Available";
        String message = text ?? 
            "There is a newer version of the app available please update it now.";
        String btnLabel = "Update Now";
        String btnLabelCancel = "Later";
        return Platform.isIOS
            ? new CupertinoAlertDialog(
                title: Text(title),
                content: Text(message),
                actions: <Widget>[
                  FlatButton(
                    child: Text(btnLabel),
                    onPressed: () => _launchURL(url),
                  ),
                  FlatButton(
                    child: Text(btnLabelCancel),
                    onPressed: required ? null : () => Navigator.pop(context),
                  ),
                ],
              )
            : new AlertDialog(
                title: Text(title),
                content: Text(message),
                actions: <Widget>[
                  FlatButton(
                    child: Text(btnLabel),
                    onPressed: () => _launchURL(url),
                  ),
                  FlatButton(
                    child: Text(btnLabelCancel),
                    onPressed: required ? null : () => Navigator.pop(context),
                  ),
                ],
              );
      },
    );
  } 

  _launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
}

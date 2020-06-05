import 'package:flutter/material.dart';
import 'package:thepaper_starter/constants/keys.dart';
import 'package:thepaper_starter/constants/strings.dart';

enum TabItem {funerals, search, account}

class TabItemData {
  const TabItemData(
      {@required this.key, @required this.title, @required this.icon});

  final String key;
  final String title;
  final IconData icon;

  static const Map<TabItem, TabItemData> allTabs = {
    // TabItem.jobs: TabItemData(
    //   key: Keys.jobsTab,
    //   title: Strings.jobs,
    //   icon: Icons.work,
    // ),
    TabItem.funerals: TabItemData(
      key: Keys.funeralsTab,
      title: Strings.listing,
      icon: Icons.list,
    ),
    TabItem.search: TabItemData(
      key: Keys.searchTab,
      title: Strings.search,
      icon: Icons.search,
    ),
    // TabItem.entries: TabItemData(
    //   key: Keys.entriesTab,
    //   title: Strings.entries,
    //   icon: Icons.view_headline,
    // ),
    TabItem.account: TabItemData(
      key: Keys.accountTab,
      title: Strings.account,
      icon: Icons.person,
    ),
  };
}

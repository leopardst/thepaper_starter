// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:auto_route/auto_route.dart' as _i1;
import 'package:flutter/material.dart' as _i2;

import '../app/home/funerals/funeral_details_page.dart' as _i3;
import '../app/home/groups/group_page.dart' as _i5;
import '../app/home/models/funeral.dart' as _i6;
import '../app/home/models/group.dart' as _i8;
import '../app/home/models/user_profile.dart' as _i7;
import '../app/home/user_profiles/user_profile_page.dart' as _i4;

class CupertinoTabViewRouter extends _i1.RootStackRouter {
  CupertinoTabViewRouter([_i2.GlobalKey<_i2.NavigatorState> navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i1.PageFactory> pagesMap = {
    FuneralDetailsRoute.name: (routeData) => _i1.CupertinoPageX<dynamic>(
        routeData: routeData,
        builder: (data) {
          final args = data.argsAs<FuneralDetailsRouteArgs>(
              orElse: () => const FuneralDetailsRouteArgs());
          return _i3.FuneralDetailsPage(
              funeral: args.funeral, parent: args.parent);
        }),
    UserProfileRoute.name: (routeData) => _i1.CupertinoPageX<dynamic>(
        routeData: routeData,
        builder: (data) {
          final args = data.argsAs<UserProfileRouteArgs>(
              orElse: () => const UserProfileRouteArgs());
          return _i4.UserProfilePage(userProfile: args.userProfile);
        }),
    GroupRoute.name: (routeData) => _i1.CupertinoPageX<dynamic>(
        routeData: routeData,
        builder: (data) {
          final args =
              data.argsAs<GroupRouteArgs>(orElse: () => const GroupRouteArgs());
          return _i5.GroupPage(group: args.group);
        })
  };

  @override
  List<_i1.RouteConfig> get routes => [
        _i1.RouteConfig(FuneralDetailsRoute.name,
            path: '/funeral-details-page'),
        _i1.RouteConfig(UserProfileRoute.name, path: '/user-profile-page'),
        _i1.RouteConfig(GroupRoute.name, path: '/group-page')
      ];
}

class FuneralDetailsRoute extends _i1.PageRouteInfo<FuneralDetailsRouteArgs> {
  FuneralDetailsRoute({_i6.Funeral funeral, String parent})
      : super(name,
            path: '/funeral-details-page',
            args: FuneralDetailsRouteArgs(funeral: funeral, parent: parent));

  static const String name = 'FuneralDetailsRoute';
}

class FuneralDetailsRouteArgs {
  const FuneralDetailsRouteArgs({this.funeral, this.parent});

  final _i6.Funeral funeral;

  final String parent;
}

class UserProfileRoute extends _i1.PageRouteInfo<UserProfileRouteArgs> {
  UserProfileRoute({_i7.UserProfile userProfile})
      : super(name,
            path: '/user-profile-page',
            args: UserProfileRouteArgs(userProfile: userProfile));

  static const String name = 'UserProfileRoute';
}

class UserProfileRouteArgs {
  const UserProfileRouteArgs({this.userProfile});

  final _i7.UserProfile userProfile;
}

class GroupRoute extends _i1.PageRouteInfo<GroupRouteArgs> {
  GroupRoute({_i8.Group group})
      : super(name, path: '/group-page', args: GroupRouteArgs(group: group));

  static const String name = 'GroupRoute';
}

class GroupRouteArgs {
  const GroupRouteArgs({this.group});

  final _i8.Group group;
}

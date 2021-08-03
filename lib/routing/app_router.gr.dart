// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:auto_route/auto_route.dart' as _i1;
import 'package:flutter/material.dart' as _i2;

import '../app/auth_widget.dart' as _i3;
import '../app/home/account/edit_profile_page.dart' as _i6;
import '../app/home/condolences/compose_page.dart' as _i5;
import '../app/home/condolences/condolences_page.dart' as _i7;
import '../app/home/models/funeral.dart' as _i9;
import '../app/home/models/user_profile.dart' as _i10;
import '../app/sign_in/email_password/email_password_sign_in_page.dart' as _i4;
import '../services/firebase_auth_service.dart' as _i8;

class AppRouter extends _i1.RootStackRouter {
  AppRouter([_i2.GlobalKey<_i2.NavigatorState> navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i1.PageFactory> pagesMap = {
    AuthWidget.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (data) {
          final args =
              data.argsAs<AuthWidgetArgs>(orElse: () => const AuthWidgetArgs());
          return _i3.AuthWidget(key: args.key, userSnapshot: args.userSnapshot);
        }),
    EmailPasswordSignInRouteBuilder.name: (routeData) =>
        _i1.MaterialPageX<dynamic>(
            routeData: routeData,
            builder: (data) {
              final args = data.argsAs<EmailPasswordSignInRouteBuilderArgs>(
                  orElse: () => const EmailPasswordSignInRouteBuilderArgs());
              return _i4.EmailPasswordSignInPageBuilder(
                  key: args.key, onSignedIn: args.onSignedIn);
            }),
    ComposeRoute.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (data) {
          final args = data.argsAs<ComposeRouteArgs>(
              orElse: () => const ComposeRouteArgs());
          return _i5.ComposePage(key: args.key, funeral: args.funeral);
        }),
    EditProfileRoute.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (data) {
          final args = data.argsAs<EditProfileRouteArgs>(
              orElse: () => const EditProfileRouteArgs());
          return _i6.EditProfilePage(
              key: args.key, userProfile: args.userProfile);
        }),
    CondolencesRoute.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (data) {
          final args = data.argsAs<CondolencesRouteArgs>(
              orElse: () => const CondolencesRouteArgs());
          return _i7.CondolencesPage(key: args.key, funeral: args.funeral);
        })
  };

  @override
  List<_i1.RouteConfig> get routes => [
        _i1.RouteConfig(AuthWidget.name, path: '/'),
        _i1.RouteConfig(EmailPasswordSignInRouteBuilder.name,
            path: '/email-password-sign-in-page-builder'),
        _i1.RouteConfig(ComposeRoute.name, path: '/compose-page'),
        _i1.RouteConfig(EditProfileRoute.name, path: '/edit-profile-page'),
        _i1.RouteConfig(CondolencesRoute.name, path: '/condolences-page')
      ];
}

class AuthWidget extends _i1.PageRouteInfo<AuthWidgetArgs> {
  AuthWidget({_i2.Key key, _i2.AsyncSnapshot<_i8.AppUser> userSnapshot})
      : super(name,
            path: '/',
            args: AuthWidgetArgs(key: key, userSnapshot: userSnapshot));

  static const String name = 'AuthWidget';
}

class AuthWidgetArgs {
  const AuthWidgetArgs({this.key, this.userSnapshot});

  final _i2.Key key;

  final _i2.AsyncSnapshot<_i8.AppUser> userSnapshot;
}

class EmailPasswordSignInRouteBuilder
    extends _i1.PageRouteInfo<EmailPasswordSignInRouteBuilderArgs> {
  EmailPasswordSignInRouteBuilder({_i2.Key key, void Function() onSignedIn})
      : super(name,
            path: '/email-password-sign-in-page-builder',
            args: EmailPasswordSignInRouteBuilderArgs(
                key: key, onSignedIn: onSignedIn));

  static const String name = 'EmailPasswordSignInRouteBuilder';
}

class EmailPasswordSignInRouteBuilderArgs {
  const EmailPasswordSignInRouteBuilderArgs({this.key, this.onSignedIn});

  final _i2.Key key;

  final void Function() onSignedIn;
}

class ComposeRoute extends _i1.PageRouteInfo<ComposeRouteArgs> {
  ComposeRoute({_i2.Key key, _i9.Funeral funeral})
      : super(name,
            path: '/compose-page',
            args: ComposeRouteArgs(key: key, funeral: funeral));

  static const String name = 'ComposeRoute';
}

class ComposeRouteArgs {
  const ComposeRouteArgs({this.key, this.funeral});

  final _i2.Key key;

  final _i9.Funeral funeral;
}

class EditProfileRoute extends _i1.PageRouteInfo<EditProfileRouteArgs> {
  EditProfileRoute({_i2.Key key, _i10.UserProfile userProfile})
      : super(name,
            path: '/edit-profile-page',
            args: EditProfileRouteArgs(key: key, userProfile: userProfile));

  static const String name = 'EditProfileRoute';
}

class EditProfileRouteArgs {
  const EditProfileRouteArgs({this.key, this.userProfile});

  final _i2.Key key;

  final _i10.UserProfile userProfile;
}

class CondolencesRoute extends _i1.PageRouteInfo<CondolencesRouteArgs> {
  CondolencesRoute({_i2.Key key, _i9.Funeral funeral})
      : super(name,
            path: '/condolences-page',
            args: CondolencesRouteArgs(key: key, funeral: funeral));

  static const String name = 'CondolencesRoute';
}

class CondolencesRouteArgs {
  const CondolencesRouteArgs({this.key, this.funeral});

  final _i2.Key key;

  final _i9.Funeral funeral;
}

import 'package:thepaper_starter/app/sign_in/email_password/email_password_sign_in_page.dart';
import 'package:thepaper_starter/app/sign_in/sign_in_view_model.dart';
// import 'package:thepaper_starter/app/sign_in/sign_in_button.dart';
import 'package:thepaper_starter/app/sign_in/social_sign_in_button.dart';

import 'package:thepaper_starter/common_widgets/platform_exception_alert_dialog.dart';
import 'package:thepaper_starter/constants/keys.dart';
import 'package:thepaper_starter/constants/strings.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:thepaper_starter/services/firebase_auth_service.dart';

class SignInPageBuilder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final FirebaseAuthService auth =
        Provider.of<FirebaseAuthService>(context, listen: false);
    return ChangeNotifierProvider<SignInViewModel>(
      create: (_) => SignInViewModel(auth: auth),
      child: Consumer<SignInViewModel>(
        builder: (_, SignInViewModel viewModel, __) => SignInPage._(
          viewModel: viewModel,
          title: 'Architecture Demo',
        ),
      ),
    );
  }
}

class SignInPage extends StatelessWidget {
  const SignInPage._({Key key, this.viewModel, this.title}) : super(key: key);
  final SignInViewModel viewModel;
  final String title;

  static const Key googleButtonKey = Key('google');
  static const Key facebookButtonKey = Key('facebook');
  static const Key emailPasswordButtonKey = Key(Keys.emailPassword);
  static const Key anonymousButtonKey = Key(Keys.anonymous);

  Future<void> _showSignInError(
      BuildContext context, PlatformException exception) async {
    await PlatformExceptionAlertDialog(
      title: Strings.signInFailed,
      exception: exception,
    ).show(context);
  }

  Future<void> _signInAnonymously(BuildContext context) async {
    try {
      await viewModel.signInAnonymously();
    } on PlatformException catch (e) {
      _showSignInError(context, e);
    }
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      await viewModel.signInWithGoogle();
    } on PlatformException catch (e) {
      if (e.code != 'ERROR_ABORTED_BY_USER') {
        _showSignInError(context, e);
      }
    }
  } 

  Future<void> _signInWithFacebook(BuildContext context) async {
    try {
      await viewModel.signInWithFacebook();
    } on PlatformException catch (e) {
      if (e.code != 'ERROR_ABORTED_BY_USER') {
        _showSignInError(context, e);
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title: Text(title),
      ),
      backgroundColor: Colors.grey[200],
      body: _buildSignIn(context),
    );
  }

  Widget _buildHeader() {
    if (viewModel.isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return Text(
      Strings.signIn,
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.w600),
    );
  }

  Widget _buildSignIn(BuildContext context) {
    // Make content scrollable so that it fits on small screens
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(height: 32.0),
          SizedBox(
            height: 50.0,
            child: _buildHeader(),
          ),
          SizedBox(height: 32.0),
          SocialSignInButton(
              key: googleButtonKey,
              assetName: 'assets/go-logo.png',
              text: Strings.signInWithGoogle,
              onPressed: viewModel.isLoading ? null : () => _signInWithGoogle(context),
              color: Colors.white,
          ),
          SizedBox(height: 32.0),
          SocialSignInButton(
              key: facebookButtonKey,
              assetName: 'assets/fb-logo.png',
              text: Strings.signInWithFacebook,
              textColor: Colors.white,
              onPressed: viewModel.isLoading ? null : () => _signInWithFacebook(context),
              color: Color(0xFF334D92),
            ),
          SizedBox(height: 32.0),
          SignInButton(
            key: emailPasswordButtonKey,
            text: Strings.signInWithEmailPassword,
            onPressed: viewModel.isLoading
                ? null
                : () => EmailPasswordSignInPageBuilder.show(context),
            textColor: Colors.black,
            color: Theme.of(context).primaryColor,
          ),
          SizedBox(height: 8),
          Text(
            Strings.or,
            style: TextStyle(fontSize: 14.0, color: Colors.black87),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          SignInButton(
            key: anonymousButtonKey,
            text: Strings.goAnonymous,
            color: Theme.of(context).primaryColor,
            textColor: Colors.black,
            onPressed:
                viewModel.isLoading ? null : () => _signInAnonymously(context),
          ),
        ],
      ),
    );
  }
}

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:thepaper_starter/services/firebase_auth_service.dart';

class SignInViewModel with ChangeNotifier {
  SignInViewModel({required this.auth});
  final FirebaseAuthService auth;
  bool isLoading = false;

  Future<AppUser> _signIn(Future<AppUser> Function() signInMethod) async {
    try {
      isLoading = true;
      notifyListeners();
      return await signInMethod();
    } catch (e) {
      isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

 Future<AppUser> signInAnonymously() async {
    return _signIn(auth.signInAnonymously);
  }

  Future<void> signInWithGoogle() async {
    await _signIn(auth.signInWithGoogle);
  }

  Future<void> signInWithFacebook() async {
    await _signIn(auth.signInWithFacebook);
  }
  
}

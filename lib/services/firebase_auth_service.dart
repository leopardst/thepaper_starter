import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
// import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

@immutable
class AppUser {
  const AppUser({
    @required this.uid,
    this.email,
    this.photoURL,
    this.displayName,
  }) : assert(uid != null, 'User can only be created with a non-null uid');

  final String uid;
  final String email;
  final String photoURL;
  final String displayName;

  factory AppUser.fromFirebaseUser(User user) {
    if (user == null) {
      return null;
    }
    return AppUser(
      uid: user.uid,
      email: user.email,
      displayName: user.displayName,
      photoURL: user.photoURL,
    );
  }

  @override
  String toString() =>
      'uid: $uid, email: $email, photoUrl: $photoURL, displayName: $displayName';
}

class FirebaseAuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Stream<AppUser> authStateChanges() {
    return _firebaseAuth
        .authStateChanges()
        .map((user) => AppUser.fromFirebaseUser(user));
  }

  Future<AppUser> signInAnonymously() async {
    final userCredential = await _firebaseAuth.signInAnonymously();
    return AppUser.fromFirebaseUser(userCredential.user);
  }

  Future<AppUser> signInWithEmailAndPassword(
      String email, String password) async {
    final userCredential =
        await _firebaseAuth.signInWithCredential(EmailAuthProvider.credential(
      email: email,
      password: password,
    ));
    return AppUser.fromFirebaseUser(userCredential.user);
  }

  Future<AppUser> createUserWithEmailAndPassword(
      String email, String password) async {
    final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    return AppUser.fromFirebaseUser(userCredential.user);
  }

  Future<AppUser> signInWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount googleUser = await googleSignIn.signIn();

    if (googleUser != null) {
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      if (googleAuth.accessToken != null) {
        final userCredential = await FirebaseAuth.instance
            .signInWithCredential(GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
          accessToken: googleAuth.accessToken,
        ));
        return AppUser.fromFirebaseUser(userCredential.user);
      } else {
        throw FirebaseException(
          plugin: runtimeType.toString(),
          code: 'ERROR_MISSING_GOOGLE_ID_TOKEN',
          message: 'Missing Google ID Token',
        );
      }
    } else {
      throw FirebaseException(
        plugin: runtimeType.toString(),
        code: 'ERROR_ABORTED_BY_USER',
        message: 'Sign in aborted by user',
      );
    }
  }

  Future<AppUser> signInWithFacebook() async {
    final FacebookLogin facebookLogin = FacebookLogin();
    // https://github.com/roughike/flutter_facebook_login/issues/210
    facebookLogin.loginBehavior = FacebookLoginBehavior.webViewOnly;
    final FacebookLoginResult result =
        await facebookLogin.logIn(<String>['public_profile', 'email', 'user_hometown', 'user_age_range', 'user_location']);
    if (result.accessToken != null) {
      final userCredential = await FirebaseAuth.instance
      .signInWithCredential(
        FacebookAuthProvider.credential(result.accessToken.token),
      );
      return AppUser.fromFirebaseUser(userCredential.user);
    } else {
      throw FirebaseException(
        plugin: runtimeType.toString(),
        code: 'ERROR_ABORTED_BY_USER',
        message: 'Sign in aborted by user',
      );
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  AppUser get currentUser =>
      AppUser.fromFirebaseUser(_firebaseAuth.currentUser);

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }
}


// @immutable
// class AppUser {
//   const AppUser({
//     @required this.uid,
//     this.email,
//     this.photoUrl,
//     this.displayName,
//   }): assert(uid != null, 'User can only be created with a non-null uid');

//   final String uid;
//   final String email;
//   final String photoUrl;
//   final String displayName;
// }

// class FirebaseAuthService {
//   final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

//   User _userFromFirebase(FirebaseUser user) {
//     if (user == null) {
//       return null;
//     }
//     return User(
//       uid: user.uid,
//       email: user.email,
//       displayName: user.displayName,
//       photoUrl: user.photoUrl,
//     );
//   }

//   Stream<User> get onAuthStateChanged {
//     return _firebaseAuth.onAuthStateChanged.map(_userFromFirebase);
//   }

//   Future<User> signInAnonymously() async {
//     final AuthResult authResult = await _firebaseAuth.signInAnonymously();
//     return _userFromFirebase(authResult.user);
//   }

//   Future<User> signInWithEmailAndPassword(String email, String password) async {
//     final AuthResult authResult = await _firebaseAuth
//         .signInWithCredential(EmailAuthProvider.getCredential(
//       email: email,
//       password: password,
//     ));
//     return _userFromFirebase(authResult.user);
//   }
  
//   Future<User> signInWithGoogle() async {
//     final GoogleSignIn googleSignIn = GoogleSignIn();
//     final GoogleSignInAccount googleUser = await googleSignIn.signIn();

//     if (googleUser != null) {
//       final GoogleSignInAuthentication googleAuth =
//           await googleUser.authentication;
//       if (googleAuth.accessToken != null && googleAuth.idToken != null) {
//         final AuthResult authResult = await _firebaseAuth
//             .signInWithCredential(GoogleAuthProvider.getCredential(
//           idToken: googleAuth.idToken,
//           accessToken: googleAuth.accessToken,
//         ));
//         return _userFromFirebase(authResult.user);
//       } else {
//         throw PlatformException(
//             code: 'ERROR_MISSING_GOOGLE_AUTH_TOKEN',
//             message: 'Missing Google Auth Token');
//       }
//     } else {
//       throw PlatformException(
//           code: 'ERROR_ABORTED_BY_USER', message: 'Sign in aborted by user');
//     }
//   }

//   Future<User> signInWithFacebook() async {
//     final FacebookLogin facebookLogin = FacebookLogin();
//     // https://github.com/roughike/flutter_facebook_login/issues/210
//     facebookLogin.loginBehavior = FacebookLoginBehavior.webViewOnly;
//     final FacebookLoginResult result =
//         await facebookLogin.logIn(<String>['public_profile', 'email', 'user_hometown', 'user_age_range', 'user_location']);
//     if (result.accessToken != null) {
//       final AuthResult authResult = await _firebaseAuth.signInWithCredential(
//         FacebookAuthProvider.getCredential(
//             accessToken: result.accessToken.token),
//       );
//       return _userFromFirebase(authResult.user);
//     } else {
//       throw PlatformException(
//           code: 'ERROR_ABORTED_BY_USER', message: 'Sign in aborted by user');
//     }
//   }

//   Future<User> createUserWithEmailAndPassword(
//       String email, String password) async {
//     final AuthResult authResult = await _firebaseAuth
//         .createUserWithEmailAndPassword(email: email, password: password);
//     return _userFromFirebase(authResult.user);
//   }

//   Future<void> sendPasswordResetEmail(String email) async {
//     await _firebaseAuth.sendPasswordResetEmail(email: email);
//   }

//   Future<User> currentUser() async {
//     final FirebaseUser user = await _firebaseAuth.currentUser();
//     return _userFromFirebase(user);
//   }

//   Future<void> signOut() async {
//     final GoogleSignIn googleSignIn = GoogleSignIn();
//     await googleSignIn.signOut();
//     final FacebookLogin facebookLogin = FacebookLogin();
//     await facebookLogin.logOut();
//     return _firebaseAuth.signOut();
    
//   }
// }

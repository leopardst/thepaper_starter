import 'package:thepaper_starter/app/sign_in/validator.dart';
import 'package:thepaper_starter/constants/strings.dart';
import 'package:flutter/foundation.dart';
import 'package:thepaper_starter/services/firebase_auth_service.dart';

enum EmailPasswordSignInFormType { signIn, register, forgotPassword }

class EmailPasswordSignInModel with EmailAndPasswordValidators, ChangeNotifier {
  EmailPasswordSignInModel({
    required this.auth,
    this.name = '',
    this.email = '',
    this.password = '',
    this.confirmPassword = '',
    this.formType = EmailPasswordSignInFormType.signIn,
    this.isLoading = false,
    this.submitted = false,
  });
  final FirebaseAuthService auth;

  String name;
  String email;
  String password;
  String confirmPassword;
  EmailPasswordSignInFormType formType;
  bool isLoading;
  bool submitted;

  Future<bool> submit() async {
    try {
      updateWith(submitted: true);
      if (!canSubmit) {
        return false;
      }
      updateWith(isLoading: true);
      switch (formType) {
        case EmailPasswordSignInFormType.signIn:
          await auth.signInWithEmailAndPassword(email, password);
          break;
        case EmailPasswordSignInFormType.register:
          await auth.createUserWithEmailAndPassword(name, email, password);
          break;
        case EmailPasswordSignInFormType.forgotPassword:
          await auth.sendPasswordResetEmail(email);
          updateWith(isLoading: false);
          break;
      }
      return true;
    } catch (e) {
      updateWith(isLoading: false);
      rethrow;
    }
  }

  void updateName(String name) => updateWith(name: name);

  void updateEmail(String email) => updateWith(email: email);

  void updatePassword(String password) => updateWith(password: password);

  void updateConfirmPassword(String password) => updateWith(confirmPassword: password);

  void updateFormType(EmailPasswordSignInFormType? formType) {
    updateWith(
      name: '',
      email: '',
      password: '',
      confirmPassword: '',
      formType: formType,
      isLoading: false,
      submitted: false,
    );
  }

  void updateWith({
    String? name,
    String? email,
    String? password,
    String? confirmPassword,
    EmailPasswordSignInFormType? formType,
    bool? isLoading,
    bool? submitted,
  }) {
    this.name = name ?? this.name;
    this.email = email ?? this.email;
    this.password = password ?? this.password;
    this.confirmPassword = confirmPassword ?? this.confirmPassword;
    this.formType = formType ?? this.formType;
    this.isLoading = isLoading ?? this.isLoading;
    this.submitted = submitted ?? this.submitted;
    notifyListeners();
  }

  String get passwordLabelText {
    if (formType == EmailPasswordSignInFormType.register) {
      return Strings.password8CharactersLabel;
    }
    return Strings.passwordLabel;
  }

  String get confirmPasswordLabelText {
    return Strings.confirmPassword8CharactersLabel;
  }

  // Getters
  String? get primaryButtonText {
    return <EmailPasswordSignInFormType, String>{
      EmailPasswordSignInFormType.register: Strings.createAnAccount,
      EmailPasswordSignInFormType.signIn: Strings.signIn,
      EmailPasswordSignInFormType.forgotPassword: Strings.sendResetLink,
    }[formType];
  }

  String? get secondaryButtonText {
    return <EmailPasswordSignInFormType, String>{
      EmailPasswordSignInFormType.register: Strings.haveAnAccount,
      EmailPasswordSignInFormType.signIn: Strings.needAnAccount,
      EmailPasswordSignInFormType.forgotPassword: Strings.backToSignIn,
    }[formType];
  }

  EmailPasswordSignInFormType? get secondaryActionFormType {
    return <EmailPasswordSignInFormType, EmailPasswordSignInFormType>{
      EmailPasswordSignInFormType.register: EmailPasswordSignInFormType.signIn,
      EmailPasswordSignInFormType.signIn: EmailPasswordSignInFormType.register,
      EmailPasswordSignInFormType.forgotPassword:
          EmailPasswordSignInFormType.signIn,
    }[formType];
  }

  String? get errorAlertTitle {
    return <EmailPasswordSignInFormType, String>{
      EmailPasswordSignInFormType.register: Strings.registrationFailed,
      EmailPasswordSignInFormType.signIn: Strings.signInFailed,
      EmailPasswordSignInFormType.forgotPassword: Strings.passwordResetFailed,
    }[formType];
  }

  String? get title {
    return <EmailPasswordSignInFormType, String>{
      EmailPasswordSignInFormType.register: Strings.register,
      EmailPasswordSignInFormType.signIn: Strings.signIn,
      EmailPasswordSignInFormType.forgotPassword: Strings.forgotPassword,
    }[formType];
  }

  bool get canSubmitEmail {
    return emailSubmitValidator.isValid(email);
  }

  bool get canSubmitPassword {
    if (formType == EmailPasswordSignInFormType.register) {
      return passwordRegisterSubmitValidator.isValid(password);
    }
    return passwordSignInSubmitValidator.isValid(password);
  }

  bool get canSubmitName {
    return name.isNotEmpty;
  }

  bool get canSubmitConfirmPassword {
    return confirmPassword.isNotEmpty;
  }

  bool get canSubmit {
    final bool canSubmitFields =
        formType == EmailPasswordSignInFormType.forgotPassword
            ? canSubmitEmail
            : canSubmitEmail && canSubmitPassword && (formType == EmailPasswordSignInFormType.forgotPassword ? canSubmitName && canSubmitConfirmPassword: true);
    return canSubmitFields && !isLoading;
  }

  String? get nameErrorText {
    return submitted && name.isEmpty ? Strings.invalidNameEmpty : null;
  }

  String? get emailErrorText {
    final bool showErrorText = submitted && !canSubmitEmail;
    final String errorText = email.isEmpty
        ? Strings.invalidEmailEmpty
        : Strings.invalidEmailErrorText;
    return showErrorText ? errorText : null;
  }

  String? get passwordErrorText {
    final bool showErrorText = submitted && !canSubmitPassword;
    final String errorText = password.isEmpty
        ? Strings.invalidPasswordEmpty
        : Strings.invalidPasswordTooShort;
    return showErrorText ? errorText : null;
  }

  String? get confirmPasswordErrorText {
    final bool showErrorText = submitted && (!canSubmitPassword || password != confirmPassword);
    return showErrorText ? Strings.invalidConfirmPassword : null;
  }

  @override
  String toString() {
    return 'email: $email, password: $password, formType: $formType, isLoading: $isLoading, submitted: $submitted';
  }
}

import 'package:thepaper_starter/app/sign_in/email_password/email_password_sign_in_model.dart';
import 'package:thepaper_starter/common_widgets/form_submit_button.dart';
import 'package:thepaper_starter/common_widgets/platform_alert_dialog.dart';
import 'package:thepaper_starter/common_widgets/platform_exception_alert_dialog.dart';
import 'package:thepaper_starter/constants/strings.dart';
import 'package:thepaper_starter/routing/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:thepaper_starter/services/firebase_auth_service.dart';

class EmailPasswordSignInPageBuilder extends StatelessWidget {
  const EmailPasswordSignInPageBuilder({Key? key, this.onSignedIn})
      : super(key: key);
  final VoidCallback? onSignedIn;

  static Future<void> show(BuildContext context) async {
    final navigator = Navigator.of(context);
    await navigator.pushNamed(Routes.emailPasswordSignInPageBuilder,
        arguments: () => navigator.pop(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final FirebaseAuthService auth =
        Provider.of<FirebaseAuthService>(context, listen: false);
    return ChangeNotifierProvider<EmailPasswordSignInModel>(
      create: (_) => EmailPasswordSignInModel(auth: auth),
      child: Consumer<EmailPasswordSignInModel>(
        builder: (_, EmailPasswordSignInModel model, __) =>
            EmailPasswordSignInPage(model: model, onSignedIn: onSignedIn),
      ),
    );
  }
}

class EmailPasswordSignInPage extends StatefulWidget {
  const EmailPasswordSignInPage(
      {Key? key, required this.model, this.onSignedIn})
      : super(key: key);
  final EmailPasswordSignInModel model;
  final VoidCallback? onSignedIn;

  @override
  _EmailPasswordSignInPageState createState() =>
      _EmailPasswordSignInPageState();
}

class _EmailPasswordSignInPageState extends State<EmailPasswordSignInPage> {
  final FocusScopeNode _node = FocusScopeNode();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  EmailPasswordSignInModel get model => widget.model;

  @override
  void dispose() {
    _node.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _showSignInError(
      EmailPasswordSignInModel model, PlatformException exception) {
    PlatformExceptionAlertDialog(
      title: model.errorAlertTitle!,
      exception: exception,
    ).show(context);
  }

  Future<void> _submit() async {
    try {
      final bool success = await model.submit();
      if (success) {
        if (model.formType == EmailPasswordSignInFormType.forgotPassword) {
          await PlatformAlertDialog(
            title: Strings.resetLinkSentTitle,
            content: Strings.resetLinkSentMessage,
            defaultActionText: Strings.ok,
          ).show(context);
        } else {
          if (widget.onSignedIn != null) {
            widget.onSignedIn!();
          }
        }
      }
    } on PlatformException catch (e) {
      _showSignInError(model, e);
    }
  }

  void _emailEditingComplete() {
    if (model.canSubmitEmail) {
      _node.nextFocus();
    }
  }

  void _passwordEditingComplete() {
    if (!model.canSubmitEmail) {
      _node.previousFocus();
      return;
    }
    _submit();
  }

  void _updateFormType(EmailPasswordSignInFormType? formType) {
    model.updateFormType(formType);
    _emailController.clear();
    _passwordController.clear();
  }

  Widget _buildEmailField() {
    return TextField(
      key: Key('email'),
      controller: _emailController,
      decoration: InputDecoration(
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.blue,
            width: 1,
          ),
        ),
        labelText: Strings.emailLabel,
        hintText: Strings.emailHint,
        errorText: model.emailErrorText,
        enabled: !model.isLoading,
        labelStyle: TextStyle(
          color: Colors.black54,
        ),
        hintStyle: TextStyle(
          fontStyle: FontStyle.italic,
        ),
      ),
      autocorrect: false,
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.emailAddress,
      keyboardAppearance: Brightness.light,
      onChanged: model.updateEmail,
      onEditingComplete: _emailEditingComplete,
      inputFormatters: <TextInputFormatter>[
        model.emailInputFormatter,
      ],
    );
  }

  Widget _buildNameField() {
    return TextField(
      key: Key('name'),
      controller: _nameController,
      decoration: InputDecoration(
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.blue,
            width: 1,
          ),
        ),
        labelText: Strings.nameLabel,
        hintText: Strings.nameHint,
        errorText: model.nameErrorText,
        enabled: !model.isLoading,
        labelStyle: TextStyle(
          color: Colors.black54,
        ),
        hintStyle: TextStyle(
          fontStyle: FontStyle.italic,
        ),
      ),
      autocorrect: false,
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.name,
      keyboardAppearance: Brightness.light,
      onChanged: model.updateName,
      onEditingComplete: _emailEditingComplete,
    );
  }

  Widget _buildPasswordField() {
    return TextField(
      key: Key('password'),
      controller: _passwordController,
      decoration: InputDecoration(
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.blue,
            width: 1,
          ),
        ),
        labelText: Strings.passwordLabel,
        hintText: model.passwordLabelText,
        errorText: model.passwordErrorText,
        enabled: !model.isLoading,
        labelStyle: TextStyle(
          color: Colors.black54,
        ),
        hintStyle: TextStyle(
          fontStyle: FontStyle.italic,
        ),
      ),
      obscureText: true,
      autocorrect: false,
      textInputAction: TextInputAction.done,
      keyboardAppearance: Brightness.light,
      onChanged: model.updatePassword,
      onEditingComplete: _passwordEditingComplete,
    );
  }

  Widget _buildConfirmPasswordField() {
    return TextField(
      key: Key('confirm_password'),
      controller: _confirmPasswordController,
      decoration: InputDecoration(
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.blue,
            width: 1,
          ),
        ),
        labelText: model.confirmPasswordLabelText,
        hintText: model.confirmPasswordLabelText,
        errorText: model.confirmPasswordErrorText,
        enabled: !model.isLoading,
        labelStyle: TextStyle(
          color: Colors.black54,
        ),
        hintStyle: TextStyle(
          fontStyle: FontStyle.italic,
        ),
      ),
      obscureText: true,
      autocorrect: false,
      textInputAction: TextInputAction.done,
      keyboardAppearance: Brightness.light,
      onChanged: model.updateConfirmPassword,
      onEditingComplete: _passwordEditingComplete,
    );
  }

  Widget _buildContent() {
    return FocusScope(
      node: _node,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(height: 8.0),
          if (model.formType == EmailPasswordSignInFormType.register)
            _buildNameField(),
          _buildEmailField(),
          if (model.formType !=
              EmailPasswordSignInFormType.forgotPassword) ...<Widget>[
            SizedBox(height: 8.0),
            _buildPasswordField(),

            if (model.formType == EmailPasswordSignInFormType.register)
              _buildConfirmPasswordField(),
          ],
          SizedBox(height: 8.0),
          FormSubmitButton(
            key: Key('primary-button'),
            text: model.primaryButtonText!,
            loading: model.isLoading,
            onPressed: model.isLoading ? null : _submit,
          ),
          SizedBox(height: 8.0),
          TextButton(
            key: Key('secondary-button'),
            child: Text(
              model.secondaryButtonText!,
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            onPressed: model.isLoading
                ? null
                : () => _updateFormType(model.secondaryActionFormType),
          ),
          if (model.formType == EmailPasswordSignInFormType.signIn)
            TextButton(
              key: Key('tertiary-button'),
              child: Text(
                Strings.forgotPasswordQuestion,
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              onPressed: model.isLoading
                  ? null
                  : () => _updateFormType(
                      EmailPasswordSignInFormType.forgotPassword),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildContent()
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_survey/ui/login/login_screen.dart';
import 'package:flutter_survey/ui/widget/primary_text_form_field_decoration.dart';
import '../../theme/app_colors.dart';
import '../../utils/util.dart';

class LoginForm extends ConsumerStatefulWidget {
  const LoginForm({super.key});

  @override
  LoginFormState createState() => LoginFormState();
}

class LoginFormState extends ConsumerState<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: _buildLoginForm(),
    );
  }

  Widget _buildLoginForm() {
    const forgotButtonWidth = 80.0;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextFormField(
          key: LoginScreenKey.tfEmail,
          decoration: PrimaryTextFormFieldDecoration(
            context: context,
            hint: AppLocalizations.of(context)!.email,
          ),
          keyboardType: TextInputType.emailAddress,
          style: Theme.of(context).textTheme.bodyMedium,
          textInputAction: TextInputAction.next,
          controller: _emailController,
          validator: _emailValidator,
          autovalidateMode: AutovalidateMode.onUserInteraction,
        ),
        const SizedBox(height: 20),
        Stack(
          children: [
            TextFormField(
              key: LoginScreenKey.tfPassword,
              decoration: PrimaryTextFormFieldDecoration(
                context: context,
                hint: AppLocalizations.of(context)!.password,
              ).copyWith(
                  contentPadding: const EdgeInsets.only(
                      left: 12,
                      right: forgotButtonWidth,
                      top: 15, // O:
                      bottom: 15 // use dimen constants
                      )),
              obscureText: true,
              obscuringCharacter: "●",
              style: Theme.of(context).textTheme.bodyMedium,
              textInputAction: TextInputAction.done,
              controller: _passwordController,
              validator: _passwordValidator,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              onFieldSubmitted: (_) => {
                // TODO: log in
              },
            ),
            Align(
              alignment: Alignment.centerRight,
              child: SizedBox(
                height: 56,
                child: TextButton(
                  key: LoginScreenKey.btLogin,
                  child: Text(
                    AppLocalizations.of(context)!.forgotPassword,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.whiteAlpha50,
                        ),
                  ),
                  onPressed: () {
                    _logIn();
                  },
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              shadowColor: Colors.black12,
              padding: const EdgeInsets.symmetric(
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: Text(AppLocalizations.of(context)!.login),
            onPressed: () => {_logIn()},
          ),
        ),
      ],
    );
  }

  String? _emailValidator(String? value) {
    var isValidEmail =
        ref.read(loginViewModelProvider.notifier).isValidEmail(value);
    if (!isValidEmail) {
      return AppLocalizations.of(context)!.errorInvalidEmail;
    } else {
      return null;
    }
  }

  String? _passwordValidator(String? value) {
    var isValidPassword =
        ref.read(loginViewModelProvider.notifier).isValidPassword(value);
    if (!isValidPassword) {
      return AppLocalizations.of(context)!.errorInvalidPassword;
    } else {
      return null;
    }
  }

  void _logIn() {
    if (!_formKey.currentState!.validate()) return;
    Util.hideKeyboard(context);
    ref
        .read(loginViewModelProvider.notifier)
        .logIn(_emailController.text, _passwordController.text);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_survey/ui/login/login_screen.dart';
import 'package:flutter_survey/ui/widget/primary_text_form_field_decoration.dart';
import '../../theme/app_colors.dart';
import '../../utils/Util.dart';

const _minPasswordLength = 6;

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
          decoration: PrimaryTextFormFieldDecoration(
            context: context,
            hint: AppLocalizations.of(context)!.email,
          ),
          keyboardType: TextInputType.emailAddress,
          style: Theme
              .of(context)
              .textTheme
              .bodyMedium,
          textInputAction: TextInputAction.next,
          controller: _emailController,
          validator: _emailValidator,
          autovalidateMode: AutovalidateMode.onUserInteraction,
        ),
        const SizedBox(height: 20),
        Stack(
          children: [
            TextFormField(
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
              style: Theme
                  .of(context)
                  .textTheme
                  .bodyMedium,
              textInputAction: TextInputAction.done,
              controller: _passwordController,
              validator: _passwordValidator,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              onFieldSubmitted: (_) =>
              {
                // TODO: log in
              },
            ),
            Align(
              alignment: Alignment.centerRight,
              child: SizedBox(
                height: 56,
                child: TextButton(
                  child: Text(
                    AppLocalizations.of(context)!.forgotPassword,
                    style: Theme
                        .of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(
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
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.white),
              foregroundColor: MaterialStateProperty.all(Colors.black),
              overlayColor: MaterialStateProperty.all(Colors.black12),
              padding: MaterialStateProperty.all(
                const EdgeInsets.symmetric(
                  vertical: 12,
                ),
              ),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              textStyle: MaterialStateProperty.all(
                Theme
                    .of(context)
                    .textTheme
                    .labelLarge,
              ),
            ),
            child: Text(AppLocalizations.of(context)!.login),
            onPressed: () => {
            _logIn()
          },
          ),
        ),
      ],
    );
  }

  String? _emailValidator(String? value) {
    if (value == null || !EmailValidator.validate(value)) {
      return AppLocalizations.of(context)!.errorInvalidEmail;
    } else {
      return null;
    }
  }

  String? _passwordValidator(String? value) {
    if (value == null || value.length < _minPasswordLength) {
      return AppLocalizations.of(context)!.errorInvalidPassword;
    } else {
      return null;
    }
  }

  void _logIn() {
    if(!_formKey.currentState!.validate()) return;
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

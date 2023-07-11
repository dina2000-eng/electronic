import 'package:electronics_market/consts/app_color.dart';
import 'package:electronics_market/screens/auth/register.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';

import '../../consts/validators.dart';
import '../../loading_manager.dart';
import '../../providers/auth_provider.dart';
import '../../root_screen.dart';
import '../../services/global_method.dart';
import '../../widgets/app_name_text.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/texts/subtitle_text.dart';
import '../../widgets/texts/title_text.dart';
import 'forgot_password.dart';

class LoginPage extends StatefulWidget {
  static const routeName = '/LoginScreen';
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  late final FocusNode _emailFocusNode;
  late final FocusNode _passwordFocusNode;
  late final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    // Focus Nodes
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
    super.initState();
  }

  bool _isLoading = false;
  bool obscureText = true;
  @override
  void dispose() {
    if (mounted) {
      _emailController.dispose();
      _passwordController.dispose();
      // Focus Nodes
      _emailFocusNode.dispose();
      _passwordFocusNode.dispose();
    }
    super.dispose();
  }

  Future<void> _loginFct() async {
    final authProv = Provider.of<AuthProvider>(context, listen: false);
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      _formKey.currentState!.save();
      try {
        setState(() {
          _isLoading = true;
        });
        await authProv.loginUser(
            _emailController.text, _passwordController.text);
        // await authProv.loginUser("test@test.com", "testers");
        if (!mounted) return;
        Navigator.pushNamed(context, RootScreen.routeName);
      } catch (error) {
        await GlobalMethods.warningOrErrorDialog(
            subtitle: error.toString(),
            fct: () {},
            context: context,
            isError: true);
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoadingManager(
        isLoading: _isLoading,
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SafeArea(
            child: ListView(
              // shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              physics: const BouncingScrollPhysics(),
              children: [
                // Section 1 - Header
                const SizedBox(
                  height: 40,
                ),
                const Center(
                  child: AppNameTextWidget(),
                ),

                const SizedBox(
                  height: 30,
                ),
                const TitlesTextWidget(
                  label: 'Welcome Back',
                  fontSize: 22,
                ),
                const SubtitlesTextWidget(
                  label: 'Let\'s get you logged in so you can start exploring.',
                  fontSize: 14,
                ),
                const SizedBox(
                  height: 40,
                ),
                // Section 2 - Form
                // Email
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _emailController,
                        focusNode: _emailFocusNode,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: 'youremail@email.com',
                          prefixIcon: Container(
                            padding: const EdgeInsets.all(12),
                            child: const Icon(IconlyLight.message),
                          ),
                          filled: true,
                        ),
                        // validator: (v) {
                        //   if (v!.isEmpty || !v.contains('@')) {
                        //     return 'Please enter a valid email address';
                        //   } else {
                        //     return null;
                        //   }
                        // },
                        validator: (value) {
                          return MyValidators.emailValidator(value);
                        },
                        onFieldSubmitted: (_) {
                          // Move focus to the next field when the "next" button is pressed
                          FocusScope.of(context)
                              .requestFocus(_passwordFocusNode);
                        },
                      ),

                      const SizedBox(height: 16),
                      // Password
                      TextFormField(
                        controller: _passwordController,
                        focusNode: _passwordFocusNode,
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: obscureText,
                        decoration: InputDecoration(
                          hintText: '**********',
                          prefixIcon: const Icon(IconlyLight.password),
                          filled: true,
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                obscureText = !obscureText;
                              });
                            },
                            icon: Icon(
                              obscureText
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                          ),
                        ),
                        validator: (value) {
                          return MyValidators.passwordValidator(value);
                        },
                        onFieldSubmitted: (v) {
                          _loginFct();
                        },
                      ),
                    ],
                  ),
                ),

                // Forgot Passowrd
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushNamed(
                          context, ForgotPasswordScreen.routeName);
                    },
                    child: const SubtitlesTextWidget(
                      label: 'Forgot Password ?',
                      // color: Theme.of(context).primaryColor,
                      textDecoration: TextDecoration.underline,
                      // color: Colors.blue,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                // Sign In button
                // CustomElevatedButton(
                //   buttonText: "Sign in",
                //   fct: _loginFct,
                //   color: Theme.of(context).primaryColor,
                //   textColor: Colors.white,
                //   widthHeightpadding: const [15, 15],
                // ),
                CustomElevatedButton(
                  elevation: 1,
                  horizontalPadding: 10,
                  verticalPadding: 10,
                  buttonText: 'Sign in',
                  color:AppColor.ON_BOARDING_COLOR,
                  textColor: Colors.white,
                  fct: () {
                    _loginFct();
                  },
                ),

                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SubtitlesTextWidget(label: "Don't have an account?"),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, RegisterScreen.routeName);
                      },
                      style: TextButton.styleFrom(
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const SubtitlesTextWidget(
                        label: 'Sign up',
                        fontStyle: FontStyle.italic,
                        textDecoration: TextDecoration.underline,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget orWidget() {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 10),
    child: Row(
      children: [
        Expanded(
          child: Divider(
            thickness: 2,
          ),
        ),
        SizedBox(
          width: 5,
        ),
        SubtitlesTextWidget(
          label: 'OR CONNECT USING',
          fontSize: 18,
          // fontWeight: FontWeight.w500,
        ),
        SizedBox(
          width: 5,
        ),
        Expanded(
          child: Divider(
            thickness: 2,
          ),
        ),
      ],
    ),
  );
}

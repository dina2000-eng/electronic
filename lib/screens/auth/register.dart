import 'package:electronics_market/consts/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';
import '../../consts/validators.dart';
import '../../loading_manager.dart';
import '../../providers/auth_provider.dart';
import '../../root_screen.dart';
import '../../services/global_method.dart';
import '../../widgets/app_name_text.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/go_back_widget.dart';
import '../../widgets/texts/subtitle_text.dart';
import '../../widgets/texts/title_text.dart';

class RegisterScreen extends StatefulWidget {
  static const routeName = '/RegisterScreen';
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late final TextEditingController _nameController,
      _emailController,
      _passwordController,
      _repeatPassController,
      _phoneNumberController;
  bool obscureText = true;
  late final FocusNode _nameFocusNode,
      _emailFocusNode,
      _passwordFocusNode,
      _repeatPasswordFocusNode,
      _phoneNumberFocusNode;
  late final _formKey = GlobalKey<FormState>();

  String? userImageUrl;
  bool _isLoading = false;
  @override
  void initState() {
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _repeatPassController = TextEditingController();
    _phoneNumberController = TextEditingController();
    // Focus nodes
    _nameFocusNode = FocusNode();
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
    _repeatPasswordFocusNode = FocusNode();
    _phoneNumberFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    if (mounted) {
      _nameController.dispose();
      _emailController.dispose();
      _passwordController.dispose();
      _repeatPassController.dispose();
      _phoneNumberController.dispose();
      // Focus Nodes
      _nameFocusNode.dispose();
      _emailFocusNode.dispose();
      _passwordFocusNode.dispose();
      _repeatPasswordFocusNode.dispose();
      _phoneNumberFocusNode.dispose();
    }
    super.dispose();
  }

  Future<void> _registerFct() async {
    final authProv = Provider.of<AuthProvider>(context, listen: false);
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState!.save();
      try {
        setState(() {
          _isLoading = true;
        });
        await authProv.registerUser(
            _nameController.text,
            _emailController.text,
            _passwordController.text,
            _repeatPassController.text,
            _phoneNumberController.text);
        await authProv.loginUser(
            _emailController.text, _passwordController.text);
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
    return LoadingManager(
      isLoading: _isLoading,
      child: Scaffold(
        appBar: AppBar(
          leading: const GoBackWidget(),
          centerTitle: true,
          title: const TitlesTextWidget(label: "Sign up"),
        ),
        body: GestureDetector(
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
                const Center(
                  child: AppNameTextWidget(),
                ),
                const SizedBox(
                  height: 30,
                ),
                const TitlesTextWidget(
                  label: 'Welcome',
                  fontSize: 22,
                ),
                const SubtitlesTextWidget(
                  label:
                      'Sign up now to receive special offers and updates from our app',
                  fontSize: 14,
                ),
                const SizedBox(
                  height: 30,
                ),
                // Image picker

                // Section 2 - Form
                // Email
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // name
                      TextFormField(
                        controller: _nameController,
                        focusNode: _nameFocusNode,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                          hintText: 'John doe',
                          prefixIcon: Container(
                            padding: const EdgeInsets.all(12),
                            child: const Icon(IconlyLight.profile),
                          ),
                          filled: true,
                        ),
                        validator: (value) {
                          return MyValidators.nameValidator(value);
                        },
                        onFieldSubmitted: (_) {
                          // Move focus to the next field when the "next" button is pressed
                          FocusScope.of(context).requestFocus(_emailFocusNode);
                        },
                      ),

                      const SizedBox(height: 16),
                      // email
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
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: obscureText,
                        decoration: InputDecoration(
                          hintText: "Password",
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
                        onFieldSubmitted: (_) {
                          // Move focus to the next field when the "next" button is pressed
                          FocusScope.of(context)
                              .requestFocus(_repeatPasswordFocusNode);
                        },
                      ),
                      const SizedBox(height: 16),
                      // REPEAT PASS TEXT FIELD
                      TextFormField(
                        controller: _repeatPassController,
                        focusNode: _repeatPasswordFocusNode,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: obscureText,
                        decoration: InputDecoration(
                          hintText: "Repeat password",
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
                          return MyValidators.repeatPasswordValidator(
                            value: value,
                            password: _passwordController.text,
                          );
                        },
                        onFieldSubmitted: (_) async {
                          // Move focus to the next field when the "next" button is pressed
                          FocusScope.of(context)
                              .requestFocus(_phoneNumberFocusNode);
                        },
                      ),
                      const SizedBox(height: 16),
                      // phone number
                      TextFormField(
                        maxLength: 10,
                        controller: _phoneNumberController,
                        focusNode: _phoneNumberFocusNode,
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        textInputAction: TextInputAction.done,
                        decoration: const InputDecoration(
                          hintText: "Phone number",
                          prefixIcon: Icon(Icons.numbers),
                          filled: true,
                        ),
                        validator: (value) {
                          return MyValidators.validatePhoneNumber(
                            phone: value,
                          );
                        },
                        onFieldSubmitted: (_) async {
                          // Move focus to the next field when the "next" button is pressed
                          await _registerFct();
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(
                  height: 30,
                ),
                // Sign In button
                CustomElevatedButton(
                  elevation: 1, horizontalPadding: 10,
                  verticalPadding: 10,
                  buttonText: 'Sign up',
                  color:AppColor.ON_BOARDING_COLOR,
                  textColor: Colors.white,
                  fct: () async {
                    await _registerFct();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

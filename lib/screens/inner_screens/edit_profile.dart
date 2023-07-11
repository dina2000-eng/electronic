import 'package:electronics_market/models/get_user_info_model.dart';
import 'package:electronics_market/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import '../../consts/validators.dart';
import '../../loading_manager.dart';
import '../../providers/auth_provider.dart';
import '../../services/global_method.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/go_back_widget.dart';
import '../../widgets/texts/title_text.dart';

class EditProfileScreen extends StatefulWidget {
  static const routeName = '/EditProfileScreen';
  final UserGetInfoModel userGetInfoModel;
  const EditProfileScreen({super.key, required this.userGetInfoModel});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final TextEditingController _nameController,
      _emailController,
      _phoneNumberController;
  bool obscureText = true;
  late final FocusNode _nameFocusNode, _emailFocusNode, _phoneNumberFocusNode;
  late final _formKey = GlobalKey<FormState>();

  String? userImageUrl;
  bool _isLoading = false;
  @override
  void initState() {
    _nameController = TextEditingController(text: widget.userGetInfoModel.name);
    _emailController =
        TextEditingController(text: widget.userGetInfoModel.email);
    _phoneNumberController =
        TextEditingController(text: widget.userGetInfoModel.phone);
    // Focus nodes
    _nameFocusNode = FocusNode();
    _emailFocusNode = FocusNode();
    _phoneNumberFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    if (mounted) {
      _nameController.dispose();
      _emailController.dispose();
      _phoneNumberController.dispose();
      // Focus Nodes
      _nameFocusNode.dispose();
      _emailFocusNode.dispose();
      _phoneNumberFocusNode.dispose();
    }
    super.dispose();
  }

  Future<void> confirmEditFCT() async {
    final authProv = Provider.of<AuthProvider>(context, listen: false);
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState!.save();
      try {
        setState(() {
          _isLoading = true;
        });
        await APIServices.updateProfile(
          name: _nameController.text,
          email: _emailController.text,
          phone: _phoneNumberController.text,
          token: authProv.getToken!,
        );
        await APIServices.getUserGetInfoModel(authProv.getToken!);
        if (!mounted) return;
        Fluttertoast.showToast(msg: "Succefully updated");
        Navigator.pop(context);
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
          title: const TitlesTextWidget(label: "Edit profile data"),
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
                // Email
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 30),

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
                          await confirmEditFCT();
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
                  buttonText: 'Confirm edit',
                  // color: Colors.blue,
                  // textColor: Colors.white,
                  fct: () async {
                    await confirmEditFCT();
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

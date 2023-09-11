import 'package:employee_app/common_widgets/app_assets/app_images.dart';
import 'package:employee_app/common_widgets/button.dart';
import 'package:employee_app/common_widgets/radio_buttons/radio.dart';
import 'package:employee_app/common_widgets/textfields/email_textfield.dart';
import 'package:employee_app/common_widgets/textfields/name_textfield.dart';
import 'package:employee_app/common_widgets/textfields/password_textfield.dart';
import 'package:employee_app/pages/login_pages/login.dart';
import 'package:employee_app/services/registration_services.dart';
import 'package:employee_app/style/fonts.dart';
import 'package:employee_app/style/sized_box.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import '../home_pages/home.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _nameController = TextEditingController();

  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  int type = 0;

  bool buttonDisabled() {
    if (type > 0 &&
        _emailController.text != '' &&
        _nameController.text != '' &&
        _passwordController.text.length > 7 &&
        _confirmPasswordController.text.length > 7 &&
        _passwordController.text == _confirmPasswordController.text) {
      return false;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
            children: [
              HeightBox.primary,
              Text('REGISTER', style: AppFonts.primaryHeader),
              HeightBox.primary,
              AppImages.appLogo,
              HeightBox.primary,
              Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      NameTextField(
                        nameController: _nameController,
                        onChanged: (p0) {
                          setState(() {});
                        },
                      ),
                      HeightBox.primary,
                      EmailTextField(
                          emailController: _emailController,
                          onChanged: (p0) {
                            setState(() {});
                          }),
                      HeightBox.primary,
                      PasswordTextField(
                          password: _passwordController,
                          hint: 'Password',
                          onChanged: (p0) {
                            setState(() {});
                          }),
                      HeightBox.primary,
                      PasswordTextField(
                          password: _confirmPasswordController,
                          hint: 'Confirm Password',
                          onChanged: (p0) {
                            setState(() {});
                          }),
                      HeightBox.primary,
                      Row(
                        children: [
                          RadioButton(
                            value: 1,
                            type: type,
                            title: 'Admin',
                            onChanged: (value) {
                              setState(() {
                                type = value!;
                              });
                            },
                          ),
                          RadioButton(
                            value: 2,
                            type: type,
                            title: 'Employee',
                            onChanged: (value) {
                              setState(() {
                                type = value!;
                              });
                            },
                          ),
                        ],
                      ),
                      AppButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate() &&
                                type != 0) {
                              FirebaseAuth.instance
                                  .createUserWithEmailAndPassword(
                                      email: _emailController.text,
                                      password: _confirmPasswordController.text)
                                  .then((value) async {
                                bool isRegistered = await RegistrationServices
                                    .firestoreRegistration(
                                  uid: FirebaseAuth.instance.currentUser!.uid,
                                  name: _nameController.text,
                                  email: _emailController.text,
                                  password: _confirmPasswordController.text,
                                  type: type == 1 ? 'Admin' : 'Employee',
                                );
                                if (isRegistered) {
                                  final snackBar = SnackBar(
                                    content:
                                        Text('Account created successfully'),
                                    action: SnackBarAction(
                                      label: 'Hide',
                                      onPressed: () {},
                                    ),
                                  );
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                  Navigator.of(context).pushReplacement(
                                      PageTransition(
                                          child: HomePage(),
                                          type: PageTransitionType.fade,
                                          childCurrent: widget,
                                          duration: Duration(milliseconds: 600),
                                          alignment: Alignment.topLeft));
                                } else {
                                  final snackBar = SnackBar(
                                    content: Text('Unable to create account!'),
                                    action: SnackBarAction(
                                      label: 'Hide',
                                      onPressed: () {},
                                    ),
                                  );
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                }
                              }).onError((error, stackTrace) {
                                print(error.toString());
                                final snackBar = SnackBar(
                                  content: Text(error
                                      .toString()
                                      .replaceAll(RegExp('\\[.*?\\]'), '')),
                                  action: SnackBarAction(
                                    label: 'Hide',
                                    onPressed: () {},
                                  ),
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              });
                            }
                          },
                          text: 'Signup',
                          width: 100,
                          disabled: buttonDisabled()),
                      HeightBox.primary,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Already have an account? '),
                          GestureDetector(
                            child: Text(
                              'Login',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0143DB)),
                            ),
                            onTap: () {
                              Navigator.of(context).pushReplacement(
                                  PageTransition(
                                      child: LoginPage(),
                                      type: PageTransitionType.fade,
                                      childCurrent: widget,
                                      duration: Duration(milliseconds: 600),
                                      alignment: Alignment.topLeft));
                            },
                          )
                        ],
                      )
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

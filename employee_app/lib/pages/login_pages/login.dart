import 'package:employee_app/models/user/user_type.dart';
import 'package:employee_app/services/login_services.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import '../../common_widgets/app_assets/app_images.dart';
import '../../common_widgets/button.dart';
import '../../common_widgets/radio_buttons/radio.dart';
import '../../common_widgets/textfields/email_textfield.dart';
import '../../common_widgets/textfields/password_textfield.dart';
import '../../services/leave_request_services/admin_leave_request_services.dart';
import '../home_pages/home.dart';
import '../../style/fonts.dart';
import '../../style/sized_box.dart';
import '../registration_pages/registration.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();

  TextEditingController _passwordController = TextEditingController();
  int type = 0;

  bool buttonDisabled() {
    if (type > 0 &&
        _emailController.text != '' &&
        _passwordController.text.length > 7) {
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
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              HeightBox.primary,
              Text(
                'Login',
                style: AppFonts.primaryHeader,
              ),
              HeightBox.primary,
              AppImages.appLogo,
              HeightBox.primary,
              Form(
                  key: _formKey,
                  // autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    children: [
                      EmailTextField(
                        emailController: _emailController,
                        onChanged: (p0) {
                          setState(() {});
                        },
                      ),
                      HeightBox.primary,
                      PasswordTextField(
                        password: _passwordController,
                        hint: 'Password',
                        onChanged: (p0) {
                          setState(() {});
                        },
                      ),
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
                          )
                        ],
                      ),
                      HeightBox.primary,
                      AppButton(
                        text: 'Login',
                        width: 100,
                        onPressed: () async {
                          if (_formKey.currentState!.validate() && type != 0) {
                            bool isLoggedIn =
                                await LoginService.authenticateUser(
                              emailId: _emailController.text,
                              password: _passwordController.text,
                              userType: type == 1
                                  ? UserType.admin.result
                                  : UserType.employee.result,
                            );
                            await AdminLeaveRequestService
                                .fetchLeaveRequestList();
                            if (isLoggedIn) {
                              Navigator.of(context).pushReplacement(
                                  PageTransition(
                                      child: HomePage(),
                                      type: PageTransitionType.fade,
                                      childCurrent: widget,
                                      duration: Duration(milliseconds: 600),
                                      alignment: Alignment.topLeft));
                            } else {
                              final snackBar = SnackBar(
                                content: const Text('Invalid credentials'),
                                action: SnackBarAction(
                                  label: 'Hide',
                                  onPressed: () {},
                                ),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            }
                          }
                        },
                        disabled: buttonDisabled(),
                      ),
                      HeightBox.primary,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Don\'t have an account? '),
                          GestureDetector(
                            child: Text('SignUp', style: AppFonts.loginSignup),
                            onTap: () {
                              Navigator.of(context).pushReplacement(
                                  PageTransition(
                                      child: RegistrationPage(),
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

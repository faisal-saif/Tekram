import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:newproject/authentication/model/user.dart';
import 'package:newproject/authentication/repository/authentication_repository.dart';
import 'package:newproject/authentication/widget/auth_text_field.dart';
import 'package:newproject/home/main_page.dart';
import 'package:provider/provider.dart';

import '../widget/primary_botton.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();

  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  TextEditingController phoneController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(body: SafeArea(
      child: Consumer<AuthenticationRepository>(
        builder: (context, value, child) {
          return Form(
            key: formKey,
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      MainAppBar(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        size: size,
                        title: 'Sign Up',
                      ),
                      Image.asset(
                        'assets/image/MicrosoftTeams-image.png',
                        width: size.width * 0.6,
                      ),
                      AuthTextField(
                          validator: (name) {
                            if (name == null || name.isEmpty) {
                              return 'Enter your name';
                            } else {
                              return null;
                            }
                          },
                          controller: nameController,
                          forPassword: false,
                          labelText: 'Name',
                          textInputType: TextInputType.text),
                      AuthTextField(
                          validator: (email) {
                            if (email != null &&
                                !EmailValidator.validate(email)) {
                              return 'Enter a valid Email';
                            } else {
                              return null;
                            }
                          },
                          controller: emailController,
                          forPassword: false,
                          labelText: 'Email',
                          textInputType: TextInputType.emailAddress),
                      AuthTextField(
                        validator: (password) {
                          if (password == null || password.isEmpty) {
                            return 'Enter a valid password';
                          } else if (password.length < 6) {
                            return 'Must be at least 6 characters long';
                          } else {
                            return null;
                          }
                        },
                        forPassword: true,
                        suffixIcon: IconButton(
                            onPressed: () {
                              value.encryption();
                            },
                            icon: value.isSecure
                                ? const Icon(
                                    Icons.visibility_off_outlined,
                                    color: Colors.black26,
                                  )
                                : const Icon(
                                    Icons.visibility_outlined,
                                    color: Colors.black38,
                                  )),
                        textInputType: TextInputType.text,
                        controller: passwordController,
                        labelText: 'Password',
                      ),
                      AuthTextField(
                          validator: (phone) {
                            if (phone == null ||
                                phone.isEmpty ||
                                phone.length < 10) {
                              return 'Enter a valid phone number';
                            } else {
                              return null;
                            }
                          },
                          controller: phoneController,
                          forPassword: false,
                          labelText: 'Phone Number',
                          textInputType: TextInputType.phone),
                      PrimaryBottom(
                        name: 'Register',
                        onPressed: () {
                          final form = formKey.currentState!;
                          if (form.validate()) {
                            value.signUp(
                                Users(
                                    id: '',
                                    name: nameController.text,
                                    email: emailController.text,
                                    phone: phoneController.text),
                                passwordController.text, () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const MainPage()));
                            }, size);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    ));
  }
}

// ignore: must_be_immutable
class MainAppBar extends StatelessWidget {
  MainAppBar(
      {Key? key,
      required this.size,
      required this.title,
      this.onTap,
      this.icon})
      : super(key: key);

  final Size size;
  final String title;
  VoidCallback? onTap;
  Widget? icon;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(10),
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              offset: Offset(0, -1),
              blurRadius: 8,
              color: Colors.black,
            ),
          ],
        ),
        // height: size.height * 0.11,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                  fontFamily: 'ArbFONTS', color: Colors.black, fontSize: 27),
            ),
            InkWell(
              onTap: onTap,
              child: icon ??
                  IconButton(
                      onPressed: onTap,
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.black26,
                      )),
            ),
          ],
        ),
      ),
    );
  }
}

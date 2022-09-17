import 'package:flutter/material.dart';
import 'package:newproject/authentication/repository/authentication_repository.dart';
import 'package:newproject/authentication/screens/signup.dart';
import 'package:provider/provider.dart';

import '../../home/main_page.dart';
import '../widget/auth_text_field.dart';
import '../widget/primary_botton.dart';

// ignore: must_be_immutable
class Login extends StatelessWidget {
  Login({Key? key}) : super(key: key);
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Consumer<AuthenticationRepository>(
        builder: (context, value, child) {
          return SingleChildScrollView(
            child: Column(
              children: [
                MainAppBar(
                  icon: SizedBox(
                    height: size.height * 0.07,
                  ),
                  size: size,
                  title: 'Login',
                ),
                Image.asset(
                  'assets/image/MicrosoftTeams-image.png',
                  width: size.width * 0.6,
                ),
                AuthTextField(
                  forPassword: false,
                  controller: emailController,
                  textInputType: TextInputType.emailAddress,
                  labelText: 'Email',
                ),
                AuthTextField(
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
                  controller: passController,
                  labelText: 'Password',
                ),
                PrimaryBottom(
                  name: 'Login',
                  onPressed: () {
                    value.signIn(emailController.text, passController.text, () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MainPage()));
                    }, size);
                  },
                ),
                InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignUp()));
                    },
                    child: const Text(
                      'Don\'t have an account? Sign up',
                      style: TextStyle(color: Colors.black38),
                    )),
              ],
            ),
          );
        },
      ),
    );
  }
}

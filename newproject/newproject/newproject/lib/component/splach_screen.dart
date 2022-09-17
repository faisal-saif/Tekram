import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../authentication/repository/authentication_repository.dart';
import '../authentication/repository/user_repo.dart';
import '../authentication/screens/login.dart';
import '../home/main_page.dart';

class SplashScreens extends StatefulWidget {
  const SplashScreens({Key? key}) : super(key: key);

  @override
  State<SplashScreens> createState() => _SplashScreensState();
}

class _SplashScreensState extends State<SplashScreens> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Consumer<UserRepository>(
      builder: (context, controller, child) {
        return Consumer<UserRepository>(
          builder: (context, value, child) {
            return AnimatedSplashScreen(
                duration: 3000,
                function: controller.check,
                splashIconSize: size.height * 0.7,
                backgroundColor: const Color(0xff1CA568),
                splashTransition: SplashTransition.sizeTransition,
                splash: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/image/logo (1).gif',
                      width: size.width * 0.5,
                    ),
                  ],
                ),
                nextScreen: Provider.of<AuthenticationRepository>(context,
                            listen: false)
                        .isLogin()
                    ? const MainPage()
                    : Login());
          },
        );
      },
    );
  }
}

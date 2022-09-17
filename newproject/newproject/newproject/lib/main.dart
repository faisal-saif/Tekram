import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:newproject/authentication/repository/user_repo.dart';
import 'package:newproject/authentication/screens/login.dart';
import 'package:provider/provider.dart';

import 'authentication/repository/authentication_repository.dart';
import 'component/splach_screen.dart';
import 'home/main_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => AuthenticationRepository()),
    ChangeNotifierProvider(create: (_) => UserRepository()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      builder: EasyLoading.init(),
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: "//",
      routes: {
        "//": (context) => const SplashScreens(),
        "/": (context) => const MainPage(),
        "/login": (context) => Login()
      },
    );
  }
}

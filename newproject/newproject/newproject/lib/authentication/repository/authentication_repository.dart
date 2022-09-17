import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:newproject/authentication/repository/user_repo.dart';

import '../model/user.dart';
import 'auth_exeption.dart';

class AuthenticationRepository extends ChangeNotifier {
  // ignore: unused_field
  final _auth = FirebaseAuth.instance;
  UserRepository userRepository = UserRepository();
  late AuthResultStatus status;
  int selectedIndex = 0;
  bool isSignUp = false;
  bool isSecure = true;

  void encryption() {
    isSecure = !isSecure;
    notifyListeners();
  }

  void signUp(Users user, String password, Function onProsses, Size size) {
    EasyLoading.show(status: 'Loading...');
    _auth
        .createUserWithEmailAndPassword(
            email: user.email ?? '', password: password)
        .then((value) {
      onProsses();
      userRepository.createNewUser(value.user!.uid, user);
      EasyLoading.showSuccess('Sign Up successfully');
    }).catchError((e) {
      EasyLoading.dismiss();
      status = AuthExceptionHandler.handleException(e);

      EasyLoading.showError(
        AuthExceptionHandler.generateExceptionMessage(status),
        duration: const Duration(seconds: 2),
      );
    });
  }

  void signIn(String email, String password, Function onProsses, Size size) {
    EasyLoading.show(status: 'Loading...');
    _auth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) {
      onProsses();
      EasyLoading.showSuccess('login successfully');
    }).catchError((e) {
      e.toString();
      EasyLoading.showError("Email or Password is not correct",
          duration: const Duration(seconds: 2));
      notifyListeners();
    });
  }

  User? currentUser() {
    return FirebaseAuth.instance.currentUser;
  }

  String? currentUserId() {
    return FirebaseAuth.instance.currentUser?.uid ?? '';
  }

  void signOut() {
    _auth.signOut();
  }

  void forgetPassword(String email) {
    _auth.sendPasswordResetEmail(email: email);
  }

  bool isLogin() {
    return _auth.currentUser != null;
  }
}

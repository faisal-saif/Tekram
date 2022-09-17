import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:newproject/authentication/repository/user_repo.dart';
import 'package:newproject/authentication/screens/signup.dart';
import 'package:newproject/authentication/widget/primary_botton.dart';
import 'package:provider/provider.dart';

import '../../authentication/model/servise.dart';
import '../../authentication/repository/authentication_repository.dart';

// ignore: must_be_immutable
class AddNewService extends StatelessWidget {
  double lat;
  double log;
  AddNewService({Key? key, required this.lat, required this.log})
      : super(key: key);

  TextEditingController titleController = TextEditingController();
  TextEditingController desController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    String id = Provider.of<AuthenticationRepository>(context, listen: false)
            .currentUserId() ??
        '';
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Column(
          children: [
            MainAppBar(
              size: size,
              title: 'Help Request',
              onTap: () => Navigator.pop(context),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: size.height * 0.04),
                    child: const Text(
                      'Create your request Now',
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: size.height * 0.02,
                    ),
                    child: TextFormField(
                      controller: titleController,
                      decoration: InputDecoration(
                        hintText: 'Title',
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.black26),
                          borderRadius: BorderRadius.circular(7),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.black26),
                          borderRadius: BorderRadius.circular(7),
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  TextFormField(
                    controller: desController,
                    maxLines: 7,
                    decoration: InputDecoration(
                      hintText: 'Description',
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.black26),
                        borderRadius: BorderRadius.circular(7),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.black26),
                        borderRadius: BorderRadius.circular(7),
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: size.height * 0.04,
            ),
            PrimaryBottom(
              name: 'Save',
              onPressed: () {
                Provider.of<UserRepository>(context, listen: false).addService(
                    Service(
                      userUID: FirebaseAuth.instance.currentUser!.uid,
                      address: Address(lat: lat, log: log),
                      title: titleController.text,
                      description: desController.text,
                      users: Provider.of<UserRepository>(context, listen: false)
                          .user,
                      state: 0,
                    ),
                    id);
                Provider.of<UserRepository>(context, listen: false).check();
                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
    );
  }
}

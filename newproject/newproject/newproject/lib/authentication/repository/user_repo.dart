import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:newproject/authentication/model/servise.dart';

import '../model/user.dart';

class UserRepository extends ChangeNotifier {
  final _dataBaseRef = FirebaseDatabase.instance.ref();
  final _auth = FirebaseAuth.instance;
  double latitude = -1;
  double longitude = -1;
  bool _isMyService = false;
  bool _haveService = false;

  Users user = Users(
    name: '',
    email: '',
    id: '',
    phone: '',
  );
  UserHelper helperUser = UserHelper(
    name: '',
    email: '',
    id: '',
    phone: '',
  );
  List<Service> services = [];
  Service? myServices;

  void createNewUser(String id, Users user) {
    user.id = id;
    _dataBaseRef.child('User').child(id).set(user.toJson());
  }

  addService(Service service, String id) {
    _dataBaseRef.child('Services').child(id).set(service.toJson());
    _dataBaseRef.child('MyServices').child(id).set(service.toJson());
  }

  Future<void> getUser() async {
    _dataBaseRef
        .child('User')
        .child(_auth.currentUser!.uid)
        .get()
        .then((value) {
      var data = value.value as Map;
      user = Users.fromJson(data);
      // _me = Users.fromJson(data);
    });
    notifyListeners();
  }

  Future<void> getHelperUser() async {
    _dataBaseRef
        .child('User')
        .child(_auth.currentUser!.uid)
        .get()
        .then((value) {
      var data = value.value as Map;
      helperUser = UserHelper.fromJson(data);
      log(helperUser.name!);
    });
    notifyListeners();
  }

  Future<void> getAllService() async {
    List<Service> allService = [];
    _dataBaseRef.child('Services').onValue.listen((event) {
      var data = event.snapshot.value as Map;
      data.forEach((key, value) {
        allService.add(Service.fromJson(value));
        services = allService;
      });
    });
    notifyListeners();
//    services.clear();
    // _databaceRef.child('Services').get().then((value) {
    //   var data = value.value as Map;
    //   data.forEach((key, value) {
    //     services.add(Service.fromJson(value));
    //   });
    // });
  }

  Future<void> fetchMyService() async {
    await _dataBaseRef
        .child('MyServices')
        .child(_auth.currentUser!.uid)
        .get()
        .then((value) {
      if (value.exists) {
        var data = value.value as Map;
        myServices = Service.fromJson(data);
        if (myServices?.title != null || myServices?.description != null) {
          _haveService = true;
        } else {
          _haveService = false;
        }
      }
    });
    notifyListeners();
  }

  Future<void> deleteMyService() async {
    await _dataBaseRef
        .child('MyServices')
        .child(_auth.currentUser!.uid)
        .remove()
        .then((value) {
      _dataBaseRef.child('Services').child(_auth.currentUser!.uid).remove();
      _haveService = false;
    });
    notifyListeners();
  }

  Future<void> getUserLocation(double lat, double log) async {
    latitude = lat;
    longitude = log;
    notifyListeners();
  }

  changeState(bool state) {
    _isMyService = state;
  }

  Future<void> canHelp(Service service, String userUID) async {
    await _dataBaseRef
        .child('MyServices')
        .child(userUID)
        .update(service.toJson())
        .then((value) {
      _dataBaseRef.child('Services').child(userUID).update(service.toJson());
    });
    notifyListeners();
  }

  Future<void> check() async {
    if (_auth.currentUser != null) {
      getUser();
      await fetchMyService();
    }
  }

  bool get getIsMyService {
    return _isMyService;
  }

  bool get getHaveService {
    return _haveService;
  }
}

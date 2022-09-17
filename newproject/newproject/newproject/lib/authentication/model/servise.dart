import 'dart:convert';

import 'package:newproject/authentication/model/user.dart';

Service serviceFromJson(String str) => Service.fromJson(json.decode(str));

String serviceToJson(Service data) => json.encode(data.toJson());

class Service {
  Service({
    this.users,
    required this.address,
    this.title,
    this.description,
    this.state,
    this.help,
    required this.userUID,
  });
  Users? users;
  Address address;
  String? title;
  String? description;
  int? state;
  UserHelper? help;
  String userUID;
  factory Service.fromJson(Map json) => Service(
        users: Users.fromJson(json["Users"]),
        address: Address.fromJson(json["Address"]),
        description: json["description"],
        title: json["title"],
        state: json['state'],
        help: UserHelper.fromJson(json["help"]),
        userUID: json["userUID"],
      );

  Map<String, dynamic> toJson() => {
        "Users": users?.toJson(),
        "Address": address.toJson(),
        "description": description,
        "title": title,
        "state": state,
        'help': help?.toJson(),
        "userUID": userUID,
      };
}

class Address {
  Address({
    this.lat,
    this.log,
  });

  double? lat;
  double? log;

  factory Address.fromJson(Map json) => Address(
        lat: json["Lat"],
        log: json["log"],
      );

  Map<String, dynamic> toJson() => {
        "Lat": lat,
        "log": log,
      };
}

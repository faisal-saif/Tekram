class Users {
  Users({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.description,
    this.title,
  });

  String? id;
  String? name;
  String? email;
  String? title;
  String? phone;
  String? description;

  factory Users.fromJson(Map json) => Users(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
      );

  Map<String, Object?> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "phone": phone,
        "description": description,
        "title": title
      };
}

class UserHelper {
  UserHelper({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.description,
    this.title,
  });

  String? id;
  String? name;
  String? email;
  String? title;
  String? phone;
  String? description;

  factory UserHelper.fromJson(Map? json) {
    if (json != null) {
      return UserHelper(
        id: json["id"] ?? '',
        name: json["name"] ?? '',
        email: json["email"] ?? '',
        phone: json["phone"] ?? '',
      );
    } else {
      return UserHelper(
        id: '',
        name: '',
        email: '',
        phone: '',
      );
    }
  }

  Map<String, Object?> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "phone": phone,
        "description": description,
        "title": title
      };
}

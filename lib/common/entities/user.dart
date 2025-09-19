// user.dart
class LoginRequestEntity {
  int? type;
  String? name;
  String? description;
  String? email;
  String? phone;
  String? avatar;
  String? open_id;
  int? online;
  String? password; // Add password field

  LoginRequestEntity({
    this.type,
    this.name,
    this.description,
    this.email,
    this.phone,
    this.avatar,
    this.open_id,
    this.online,
    this.password, // Add password field
  });

  Map<String, dynamic> toJson() => {
    "type": type,
    "name": name,
    "description": description,
    "email": email,
    "phone": phone,
    "avatar": avatar,
    "open_id": open_id,
    "online": online,
    "password": password, // Add password field
  };
}

//api post response msg
class UserLoginResponseEntity {
  int? code;
  String? msg;
  UserItem? data;

  UserLoginResponseEntity({this.code, this.msg, this.data});

  factory UserLoginResponseEntity.fromJson(Map<String, dynamic> json) =>
      UserLoginResponseEntity(
        code: json["code"],
        msg: json["msg"],
        data: UserItem.fromJson(json["data"]),
      );
}

// login result
class UserItem {
  String? access_token;
  String? token;
  String? name;
  String? description;
  String? avatar;
  int? online;
  String? type;
  String? email; // Add email field

  UserItem({
    this.access_token,
    this.token,
    this.name,
    this.description,
    this.avatar,
    this.online,
    this.type,
    this.email, // Add email field
  });

  factory UserItem.fromJson(Map<String, dynamic> json) => UserItem(
    access_token: json["access_token"],
    token: json["token"],
    name: json["name"],
    description: json["description"],
    avatar: json["avatar"],
    online: json["online"],
    type: json["type"],
    email: json["email"], // Add email field
  );

  Map<String, dynamic> toJson() => {
    "access_token": access_token,
    "token": token,
    "name": name,
    "description": description,
    "avatar": avatar,
    "online": online,
    "type": type,
    "email": email, // Add email field
  };
}

// user.dart - Add these classes to your existing user.dart file
class RegisterRequestEntity {
  String? name;
  String? firstName;
  String? lastName;
  String? email;
  String? password;
  String? confirmPassword;

  RegisterRequestEntity({
    this.name,
    this.firstName,
    this.lastName,
    this.email,
    this.password,
    this.confirmPassword,
  });

  Map<String, dynamic> toJson() => {
    "name": name,
    "first_name": firstName,
    "last_name": lastName,
    "email": email,
    "password": password,
    "password_confirmation": confirmPassword,
  };
}

class RegisterResponseEntity {
  int? code;
  String? msg;
  UserItem? data;

  RegisterResponseEntity({this.code, this.msg, this.data});

  factory RegisterResponseEntity.fromJson(Map<String, dynamic> json) =>
      RegisterResponseEntity(
        code: json["code"],
        msg: json["msg"],
        data: json["data"] != null ? UserItem.fromJson(json["data"]) : null,
      );
}

class User {
  String? userId;
  String? userName;
  String? email;
  String? password;
  String? phone;
  String? regDate;

  User(
      {this.userId,
      this.email,
      this.userName,
      this.phone,
      this.password,
      this.regDate});

  User.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    userName = json['name'];
    email = json['email'];
    password = json['password'];
    phone = json['phone'];
    regDate = json['reg_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['name'] = userName;
    data['email'] = email;
    data['password'] = password;
    data['phone'] = phone;
    data['reg_date'] = regDate;
    return data;
  }
}
class UserLogin {
  String username;
  String password;

  UserLogin({required this.username, required this.password});

  Map<String, dynamic> toDatabaseJson() =>
      {"username": this.username, "password": this.password};
}

class UserSignUp extends UserLogin {
  String email;

  UserSignUp({required this.email, required username, required password})
      : super(username: username, password: password);

  Map<String, dynamic> toDatabaseJson() => {
        "username": this.username,
        "password": this.password,
        "email": this.email
      };
}

class Token {
  String token;

  Token({required this.token});

  factory Token.fromJson(Map<String, dynamic> json) {
    return Token(token: json['token']);
  }
}

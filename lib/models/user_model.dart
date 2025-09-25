class User {
  int? id;
  String email;
  String username;
  String password;

  User({
    this.id,
    required this.email,
    required this.username,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'password': password, // Note: In a real app, hash this password!
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      email: map['email'],
      username: map['username'],
      password: map['password'],
    );
  }
}

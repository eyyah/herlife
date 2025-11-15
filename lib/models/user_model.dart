class User {
  final int? id;
  final String firstName;
  final String lastName;
  final String? middleName;
  final String phoneNumber;
  final String email;
  final String password;

  User({
    this.id,
    required this.firstName,
    required this.lastName,
    this.middleName,
    required this.phoneNumber,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'middleName': middleName,
      'phoneNumber': phoneNumber,
      'email': email,
      'password': password,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      middleName: map['middleName'],
      phoneNumber: map['phoneNumber'],
      email: map['email'],
      password: map['password'],
    );
  }
}

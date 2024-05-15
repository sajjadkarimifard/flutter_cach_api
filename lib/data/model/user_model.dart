class User {
  int? id;
  String? firstName;
  String? lastName;
  String? maidenName;
  int? age;
  String? gender;
  String? email;
  String? phone;
  String? username;
  String? password;
  String? birthDate;
  String? image;

  User(
    this.id,
    this.firstName,
    this.lastName,
    this.maidenName,
    this.age,
    this.gender,
    this.email,
    this.phone,
    this.username,
    this.password,
    this.birthDate,
    this.image,
  );

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      json['id'],
      json['firstname'],
      json['lastname'],
      json['maidenname'],
      json['age'],
      json['gender'],
      json['email'],
      json['phone'],
      json['username'],
      json['password'],
      json['birthDate'],
      json['image'],
    );
  }

  // Map<String, dynamic> toJson() {}
}

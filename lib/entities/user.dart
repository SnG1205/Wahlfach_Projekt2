class User{
  final int? id;
  final String firstName;
  final String lastName;
  final String address;
  final int isEmployee;

  const User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.address,
    required this.isEmployee
  });

  const User.withoutId({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.address,
    required this.isEmployee
  });

  Map<String, dynamic> toMap(){
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'address': address,
      'is_employee': isEmployee
    };
  }
}
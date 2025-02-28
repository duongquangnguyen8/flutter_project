class UserModel {
  String _id;
  String _email;
  String _password;
  String _fullName;
  String _address;
  String _phoneNumber;
  DateTime? _birth;
  String _role;
  String _createdAt;
  String _updateAt;
  UserModel({
    required String id,
    required String email,
    required String password,
    required String fullName,
    required String address,
    required String phoneNumber,
    required DateTime birth,
    required String role,
    required String createdAt,
    required String updateAt,
  })  : _id = id,
        _email = email,
        _password = password,
        _fullName = fullName,
        _address = address,
        _phoneNumber = phoneNumber,
        _birth = birth,
        _role = role,
        _createdAt = createdAt,
        _updateAt = updateAt;

  UserModel.withEmailAndPass({
    required String email,
    required String password,
    required String role,
  })  : _id = '',
        _email = email,
        _password = password,
        _fullName = '',
        _address = '',
        _phoneNumber = '',
        _birth = DateTime(2005, 8, 5),
        _role = role,
        _createdAt = '',
        _updateAt = '';
  String get id => _id;

  set id(String value) => _id = value;

  get email => _email;

  set email(value) => _email = value;

  get password => _password;

  set password(value) => _password = value;

  get fullName => _fullName;

  set fullName(value) => _fullName = value;

  get address => _address;

  set address(value) => _address = value;

  get phoneNumber => _phoneNumber;

  set phoneNumber(value) => _phoneNumber = value;

  get birth => _birth;

  set birth(value) => _birth = value;

  get role => _role;

  set role(value) => _role = value;

  get createdAt => _createdAt;

  set createdAt(value) => _createdAt = value;

  get updateAt => _updateAt;

  set updateAt(value) => _updateAt = value;

  //convert json sang object
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        id: json['_id'],
        email: json['email'],
        password: json['password'],
        fullName: json['fullName'],
        address: json['address'],
        phoneNumber: json['phoneNumber'],
        role: json['role'],
        createdAt: json['createdAt'],
        birth: DateTime.parse(json['birth']),
        updateAt: json['updateAt']);
  }
  //convert object sang json
  Map<String, dynamic> toJson() {
    return {
      '_id': _id,
      'email': _email,
      'password': _password,
      'fullName': _fullName,
      'address': _address,
      'phoneNumber': _phoneNumber,
      'birth': '',
      'role': _role,
      'createdAt': _createdAt,
      'updateAt': _updateAt,
    };
  }
}

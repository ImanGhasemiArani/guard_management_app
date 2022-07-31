import 'package:get/get.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

import '../lang/strs.dart';

// ignore: library_private_types_in_public_api, non_constant_identifier_names
_User User({
  String? fName,
  String? fPCode,
  String? fNationalId,
  String? fEmail,
  String? fPassword,
  String? fPhone,
  String? fGrade,
  String fUserType = 'C',
}) {
  switch (UserType.valueOf(fUserType.toUpperCase())) {
    case UserType.A:
      return UserBoss(fName, fPCode, fNationalId, fEmail, fPassword, fPhone,
          fGrade, fUserType);
    case UserType.B:
      return UserResponsible(fName, fPCode, fNationalId, fEmail, fPassword,
          fPhone, fGrade, fUserType);
    case UserType.C:
      return UserEmployee(fName, fPCode, fNationalId, fEmail, fPassword, fPhone,
          fGrade, fUserType);
    default:
      return UserEmployee(fName, fPCode, fNationalId, fEmail, fPassword, fPhone,
          fGrade, fUserType);
  }
}

abstract class _User {
  String? _name;
  String? _pCode;
  String? _nationalId;
  String? _phone;
  String? _email;
  String? _password;
  String? _grade;
  String? _userType;

  String? get name => _name;
  String? get phone => _phone;
  String? get pCode => _pCode;
  String? get nationalId => _nationalId;
  String? get email => _email;
  String? get password => _password;
  String? get grade => _grade;
  String? get userType => _userType;

  _User(
    String? fName,
    String? fPCode,
    String? fNationalId,
    String? fEmail,
    String? fPassword,
    String? fPhone,
    String? fGrade,
    String? fUserType,
  ) {
    name = fName;
    pCode = fPCode;
    nationalId = fNationalId;
    phone = fPhone;
    email = fEmail;
    password = fPassword;
    grade = fGrade;
    userType = fUserType;
  }

  set name(String? name) {
    _name = name?.trim();
  }

  set phone(String? phone) {
    if (phone == null) return;
    phone.isValidIranianMobileNumber()
        ? _phone = phone
        : throw Exception(Strs.invalidPhoneNumberErrorMessage.tr);
  }

  set pCode(String? value) {
    _pCode = value;
  }

  set nationalId(String? id) {
    if (id == null) return;
    id.isValidIranianNationalCode()
        ? _nationalId = id
        : throw Exception(Strs.invalidNationalIdErrorMessage.tr);
  }

  set email(String? email) {
    if (email == null) return;
    email.isEmail
        ? _email = email
        : throw Exception(Strs.invalidEmailErrorMessage.tr);
  }

  set password(String? value) {
    _password = value;
  }

  set grade(String? grade) {
    if (grade == null) return;
    _grade = grade.toUpperCase().trim();
  }

  set userType(String? userType) {
    if (userType == null) return;
    userType = userType.toUpperCase();
    _userType = UserType.valueOf(userType).value.tr;
  }

  void getUser();
}

class UserBoss extends _User {
  UserBoss(super.fName, super.fPCode, super.fNationalId, super.fEmail,
      super.fPassword, super.fPhone, super.fGrade, super.fUserType);

  @override
  void getUser() {
    // TODO: implement getUser
  }
}

class UserResponsible extends _User {
  UserResponsible(super.fName, super.fPCode, super.fNationalId, super.fEmail,
      super.fPassword, super.fPhone, super.fGrade, super.fUserType);

  @override
  void getUser() {
    // TODO: implement getUser
  }
}

class UserEmployee extends _User {
  UserEmployee(super.fName, super.fPCode, super.fNationalId, super.fEmail,
      super.fPassword, super.fPhone, super.fGrade, super.fUserType);

  @override
  void getUser() {
    // TODO: implement getUser
  }
}

enum UserType {
  A(Strs.bossStr),
  B(Strs.responsibleStr),
  C(Strs.employeeStr);

  const UserType(this.value);
  final String value;

  static UserType valueOf(String value) {
    return UserType.values.firstWhere((type) => type.name == value);
  }
}

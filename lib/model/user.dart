import 'package:get/get.dart';
import 'package:guard_management_app/screens/admin_screen/admin_screen_holder.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

import '../lang/strs.dart';
import '../screens/employee_screen/employee_screen_holder.dart';
import '../screens/responsible_screen/responsible_screen_holder.dart';
import '../screens/screen_holder.dart';
import '../services/server_service.dart';

User user({
  String? fName,
  String? fPCode,
  String? fNationalId,
  String? fEmail,
  String? fPassword,
  String? fPhone,
  String? fGrade,
  String fUserType = 'C',
  ParseUser? parseUser,
}) {
  if (parseUser == null) {
    switch (UserType.valueOf(fUserType.toUpperCase())) {
      case UserType.A:
        return Admin(fName, fPCode, fNationalId, fEmail, fPassword, fPhone,
            fGrade, fUserType);
      case UserType.B:
        return Responsible(fName, fPCode, fNationalId, fEmail, fPassword,
            fPhone, fGrade, fUserType);
      case UserType.C:
        return Employee(fName, fPCode, fNationalId, fEmail, fPassword, fPhone,
            fGrade, fUserType);
      default:
        return Employee(fName, fPCode, fNationalId, fEmail, fPassword, fPhone,
            fGrade, fUserType);
    }
  } else {
    switch (UserType.valueOf(parseUser['userType'].toUpperCase())) {
      case UserType.A:
        return Admin.fromParseUser(parseUser);
      case UserType.B:
        return Responsible.fromParseUser(parseUser);
      case UserType.C:
        return Employee.fromParseUser(parseUser);
      default:
        return Employee.fromParseUser(parseUser);
    }
  }
}

abstract class User {
  String? _name;
  String? _pCode;
  String? _nationalId;
  String? _phone;
  String? _email;
  String? _password;
  String? _grade;
  String? _userType;
  UserType? _userTypeEnum;
  ScreenHolder screenHolder;

  String? get name => _name;
  String? get phone => _phone;
  String? get pCode => _pCode;
  String? get nationalId => _nationalId;
  String? get email => _email;
  String? get password => _password;
  String? get grade => _grade;
  String? get userType => _userType;
    UserType? get userTypeEnum => _userTypeEnum;

  User(
      String? fName,
      String? fPCode,
      String? fNationalId,
      String? fEmail,
      String? fPassword,
      String? fPhone,
      String? fGrade,
      String? fUserType,
      this.screenHolder) {
    name = fName;
    pCode = fPCode;
    nationalId = fNationalId;
    phone = fPhone;
    email = fEmail;
    password = fPassword;
    grade = fGrade;
    userType = fUserType;
  }

  User.fromParseUser(ParseUser parseUser, this.screenHolder) {
    name = parseUser['name'];
    pCode = parseUser['pCode'];
    nationalId = parseUser.username;
    phone = parseUser['phone'];
    email = parseUser.emailAddress;
    password = parseUser.password;
    grade = parseUser['grade'];
    userType = parseUser['userType'];
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
    _userTypeEnum = UserType.valueOf(userType);
    _userType = _userTypeEnum!.value.tr;
  }

  void updatePhone(String newPhone) {
    newPhone = newPhone.trim();
    phone = newPhone.trim();
    updatePhoneToServer(newPhone);
  }

  void updateEmail(String newEmail) {
    newEmail = newEmail.trim();
    email = newEmail.trim();
    updateEmailToServer(newEmail);
  }

  void updatePassword(String password) {
    updatePasswordToServer(password);
  }

  @override
  String toString() {
    return 'name: $name, pCode: $pCode, nationalId: $nationalId, phone: $phone, email: $email, password: $password, grade: $grade, userType: $userType';
  }
}

class Admin extends User {
  Admin(
    String? fName,
    String? fPCode,
    String? fNationalId,
    String? fEmail,
    String? fPassword,
    String? fPhone,
    String? fGrade,
    String? fUserType,
  ) : super(
          fName,
          fPCode,
          fNationalId,
          fEmail,
          fPassword,
          fPhone,
          fGrade,
          fUserType,
          AdminScreenHolder(),
        );

  Admin.fromParseUser(ParseUser parseUser)
      : super.fromParseUser(
          parseUser,
          AdminScreenHolder(),
        );
}

class Responsible extends User {
  Responsible(
    String? fName,
    String? fPCode,
    String? fNationalId,
    String? fEmail,
    String? fPassword,
    String? fPhone,
    String? fGrade,
    String? fUserType,
  ) : super(
          fName,
          fPCode,
          fNationalId,
          fEmail,
          fPassword,
          fPhone,
          fGrade,
          fUserType,
          ResponsibleScreenHolder(),
        );

  Responsible.fromParseUser(ParseUser parseUser)
      : super.fromParseUser(
          parseUser,
          ResponsibleScreenHolder(),
        );
}

class Employee extends User {
  Employee(
    String? fName,
    String? fPCode,
    String? fNationalId,
    String? fEmail,
    String? fPassword,
    String? fPhone,
    String? fGrade,
    String? fUserType,
  ) : super(
          fName,
          fPCode,
          fNationalId,
          fEmail,
          fPassword,
          fPhone,
          fGrade,
          fUserType,
          EmployeeScreenHolder(),
        );

  Employee.fromParseUser(ParseUser parseUser)
      : super.fromParseUser(
          parseUser,
          EmployeeScreenHolder(),
        );
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

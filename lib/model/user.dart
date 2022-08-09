import 'package:get/get.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

import '../lang/strs.dart';
import '../screens/admin_screen/admin_screen_holder.dart';
import '../screens/employee_screen/employee_screen_holder.dart';
import '../screens/responsible_screen/responsible_screen_holder.dart';
import '../screens/screen_holder.dart';
import '../services/server_service.dart';

User user({
  String? fName,
  String? fNationalId,
  String? fEmail,
  String? fPassword,
  String? fPhone,
  String? fPost,
  String? fOrganPos,
  String fUserType = 'C',
  ParseUser? parseUser,
}) {
  if (parseUser == null) {
    switch (UserType.valueOf(fUserType.toUpperCase())) {
      case UserType.A:
        return Admin(fName, fNationalId, fEmail, fPassword, fPhone, fPost,
            fOrganPos, fUserType);
      case UserType.B:
        return Responsible(fName, fNationalId, fEmail, fPassword, fPhone, fPost,
            fOrganPos, fUserType);
      case UserType.C:
        return Employee(fName, fNationalId, fEmail, fPassword, fPhone, fPost,
            fOrganPos, fUserType);
      default:
        return Employee(fName, fNationalId, fEmail, fPassword, fPhone, fPost,
            fOrganPos, fUserType);
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
  String? _nationalId;
  String? _phone;
  String? _email;
  String? _password;
  String? _post;
  String? _organPos;
  String? _userType;
  UserType? _userTypeEnum;
  ScreenHolder screenHolder;

  String? get name => _name;
  String? get phone => _phone;
  String? get nationalId => _nationalId;
  String? get email => _email;
  String? get password => _password;
  String? get post => _post;
  String? get organPos => _organPos;
  String? get userType => _userType;
  UserType? get userTypeEnum => _userTypeEnum;

  User(
      String? fName,
      String? fNationalId,
      String? fEmail,
      String? fPassword,
      String? fPhone,
      String? fPost,
      String? fOrganPos,
      String? fUserType,
      this.screenHolder) {
    name = fName;
    nationalId = fNationalId;
    phone = fPhone;
    email = fEmail;
    password = fPassword;
    post = fPost;
    organPos = fOrganPos;
    userType = fUserType;
  }

  User.fromParseUser(ParseUser parseUser, this.screenHolder) {
    name = parseUser['name'];
    nationalId = parseUser.username;
    phone = parseUser['phone'];
    email = parseUser.emailAddress;
    password = parseUser.password;
    post = parseUser['post'];
    organPos = parseUser['organPos'];
    userType = parseUser['userType'];
  }

  set name(String? name) {
    _name = name?.trim();
  }

  set phone(String? phone) {
    phone = phone?.trim();
    if (phone == null || phone.isEmpty) return;
    phone.isValidIranianMobileNumber()
        ? _phone = phone
        : throw Exception(Strs.invalidPhoneNumberErrorMessage.tr);
  }

  set nationalId(String? id) {
    id = id?.trim();
    if (id == null || id.isEmpty) return;
    id.isValidIranianNationalCode()
        ? _nationalId = id
        : throw Exception(Strs.invalidNationalIdErrorMessage.tr);
  }

  set email(String? email) {
    email = email?.trim();
    if (email == null || email.isEmpty) return;
    email.isEmail
        ? _email = email
        : throw Exception(Strs.invalidEmailErrorMessage.tr);
  }

  set password(String? value) {
    _password = value;
  }

  set post(String? post) {
    post = post?.trim();
    if (post == null || post.isEmpty) return;
    _post = post.toUpperCase().trim();
  }

  set organPos(String? organPos) {
    organPos = organPos?.trim();
    if (organPos == null || organPos.isEmpty) return;
    _organPos = organPos;
  }

  set userType(String? userType) {
    userType = userType?.trim();
    if (userType == null || userType.isEmpty) return;
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
    return 'name: $_name, nationalId: $_nationalId, phone: $_phone, email: $_email, password: $_password, post: $_post, organPos: $_organPos, userType: $_userType';
  }
}

class Admin extends User {
  Admin(
    String? fName,
    String? fNationalId,
    String? fEmail,
    String? fPassword,
    String? fPhone,
    String? fPost,
    String? fOrganPos,
    String? fUserType,
  ) : super(
          fName,
          fNationalId,
          fEmail,
          fPassword,
          fPhone,
          fPost,
          fOrganPos,
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
    String? fNationalId,
    String? fEmail,
    String? fPassword,
    String? fPhone,
    String? fPost,
    String? fOrganPos,
    String? fUserType,
  ) : super(
          fName,
          fNationalId,
          fEmail,
          fPassword,
          fPhone,
          fPost,
          fOrganPos,
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
    String? fNationalId,
    String? fEmail,
    String? fPassword,
    String? fPhone,
    String? fPost,
    String? fOrganPos,
    String? fUserType,
  ) : super(
          fName,
          fNationalId,
          fEmail,
          fPassword,
          fPhone,
          fPost,
          fOrganPos,
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

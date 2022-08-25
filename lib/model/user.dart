import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

import '../lang/strs.dart';
import '../screens/admin_user_screen/admin_screen_holder.dart';
import '../screens/headunit_user_screen/headunit_screen_holder.dart';
import '../screens/normal_user_screen/normal_screen_holder.dart';
import '../screens/screen_holder.dart';
import '../services/server_service.dart';

User user({
  String? fUsername,
  String? fName,
  String? fEmail,
  String? fPhone,
  String? fRank,
  String? fOrganPos,
  String fUserType = 'N',
  ParseUser? parseUser,
}) {
  if (parseUser == null) {
    switch (UserType.valueOf(fUserType.toUpperCase())) {
      case UserType.A:
        return AdminUser(
            fUsername, fName, fEmail, fPhone, fRank, fOrganPos, fUserType);
      case UserType.H:
        return HeadUnitUser(
            fUsername, fName, fEmail, fPhone, fRank, fOrganPos, fUserType);
      case UserType.N:
        return NormalUser(
            fUsername, fName, fEmail, fPhone, fRank, fOrganPos, fUserType);
      default:
        return NormalUser(
            fUsername, fName, fEmail, fPhone, fRank, fOrganPos, fUserType);
    }
  } else {
    switch (UserType.valueOf(parseUser['userType'].toUpperCase())) {
      case UserType.A:
        return AdminUser.fromParseUser(parseUser);
      case UserType.H:
        return HeadUnitUser.fromParseUser(parseUser);
      case UserType.N:
        return NormalUser.fromParseUser(parseUser);
      default:
        return NormalUser.fromParseUser(parseUser);
    }
  }
}

abstract class User {
  String? _username;
  String? _name;
  String? _email;
  String? _phone;
  String? _rank;
  String? _organPos;
  String? _userType;
  UserType? _userTypeEnum;
  ScreenHolder screenHolder;
  Uint8List? _profileImage;
  Map<String, dynamic>? teamData;

  String? get username => _username;
  String? get name => _name;
  String? get email => _email;
  String? get phone => _phone;
  String? get rank => _rank;
  String? get organPos => _organPos;
  String? get userType => _userType;
  UserType? get userTypeEnum => _userTypeEnum;
  Uint8List? get profileImage => _profileImage;

  User(
    String? fUsername,
    String? fName,
    String? fEmail,
    String? fPhone,
    String? fRank,
    String? fOrganPos,
    String? fUserType,
    this.screenHolder,
  ) {
    username = fUsername;
    name = fName;
    email = fEmail;
    phone = fPhone;
    rank = fRank;
    organPos = fOrganPos;
    userType = fUserType;
  }

  User.fromParseUser(ParseUser parseUser, this.screenHolder) {
    username = parseUser.username;
    name = parseUser['name'];
    email = parseUser.emailAddress;
    phone = parseUser['phone'];
    rank = parseUser['rank'];
    organPos = parseUser['organPos'];
    userType = parseUser['userType'];
    profileImage = parseUser['profileImg'];
  }

  set username(String? id) {
    id = id?.trim();
    if (id == null || id.isEmpty) return;
    id.isValidIranianNationalCode()
        ? _username = id
        : throw Exception(Strs.invalidNationalIdErrorMessage.tr);
  }

  set name(String? name) {
    _name = name?.trim();
  }

  set email(String? email) {
    email = email?.trim();
    if (email == null || email.isEmpty) return;
    email.isEmail
        ? _email = email
        : throw Exception(Strs.invalidEmailErrorMessage.tr);
  }

  set phone(String? phone) {
    phone = phone?.trim();
    if (phone == null || phone.isEmpty) return;
    phone.isValidIranianMobileNumber()
        ? _phone = phone
        : throw Exception(Strs.invalidPhoneNumberErrorMessage.tr);
  }

  set rank(String? rank) {
    rank = rank?.trim();
    if (rank == null || rank.isEmpty) return;
    _rank = rank.toUpperCase().trim();
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

  set profileImage(dynamic profileImgStr) {
    profileImgStr = profileImgStr as String?;
    if (profileImgStr == null || profileImgStr.isEmpty) return;
    _profileImage = Uint8List.fromList(profileImgStr.codeUnits);
  }

  void updateProfileImg(Uint8List? profileImg) {
    if (profileImg == null || profileImg.isEmpty) return;
    final str = String.fromCharCodes(profileImg);
    profileImage = str;
    ServerService.updateProfileImgToServer(str);
  }

  void updatePhone(String newPhone) {
    newPhone = newPhone.trim();
    phone = newPhone.trim();
    ServerService.updatePhoneToServer(newPhone);
  }

  void updateEmail(String newEmail) {
    newEmail = newEmail.trim();
    email = newEmail.trim();
    ServerService.updateEmailToServer(newEmail);
  }

  void updatePassword(String password) {
    ServerService.updatePasswordToServer(password);
  }

  @override
  String toString() {
    return 'username: $_username, name: $_name, email: $_email, phone: $_phone, rank: $_rank, organPos: $_organPos, userType: $_userType';
  }
}

class AdminUser extends User {
  AdminUser(
    String? fUsername,
    String? fName,
    String? fEmail,
    String? fPhone,
    String? fRank,
    String? fOrganPos,
    String? fUserType,
  ) : super(
          fUsername,
          fName,
          fEmail,
          fPhone,
          fRank,
          fOrganPos,
          fUserType,
          AdminScreenHolder(),
        );

  AdminUser.fromParseUser(ParseUser parseUser)
      : super.fromParseUser(
          parseUser,
          AdminScreenHolder(),
        );
}

class HeadUnitUser extends User {
  HeadUnitUser(
    String? fUsername,
    String? fName,
    String? fEmail,
    String? fPhone,
    String? fRank,
    String? fOrganPos,
    String? fUserType,
  ) : super(
          fUsername,
          fName,
          fEmail,
          fPhone,
          fRank,
          fOrganPos,
          fUserType,
          HeadUnitScreenHolder(),
        );

  HeadUnitUser.fromParseUser(ParseUser parseUser)
      : super.fromParseUser(
          parseUser,
          HeadUnitScreenHolder(),
        );
}

class NormalUser extends User {
  NormalUser(
    String? fUsername,
    String? fName,
    String? fEmail,
    String? fPhone,
    String? fRank,
    String? fOrganPos,
    String? fUserType,
  ) : super(
          fUsername,
          fName,
          fEmail,
          fPhone,
          fRank,
          fOrganPos,
          fUserType,
          const NormalScreenHolder(),
        );

  NormalUser.fromParseUser(ParseUser parseUser)
      : super.fromParseUser(
          parseUser,
          const NormalScreenHolder(),
        );
}

enum UserType {
  A(Strs.adminUserStr),
  H(Strs.headUnitUserStr),
  N(Strs.normalUserStr);

  const UserType(this.value);
  final String value;

  static UserType valueOf(String value) {
    return UserType.values.firstWhere((type) => type.name == value);
  }
}

enum ShiftType {
  N(Strs.nightShiftStr),
  D(Strs.dayShiftStr),
  M(Strs.morningShiftStr);

  const ShiftType(this.value);
  final String value;

  static ShiftType valueOf(String value) {
    return ShiftType.values.firstWhere((type) => type.name == value);
  }
}

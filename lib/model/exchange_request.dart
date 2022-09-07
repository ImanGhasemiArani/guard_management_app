import 'dart:convert';
import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:shamsi_date/shamsi_date.dart';

import '../lang/strs.dart';
import 'user.dart';

class ExchangeRequest {
  String? changerUsername;
  String? changerName;
  String? changerOrganPos;
  late final Rx<String?> _supplierUsername;
  String? supplierName;
  late final Rx<DateTime?> _changerShiftDate;
  late final Rx<String?> _changerShiftDescription;
  late final Rx<Uint8List?> _changerSignature;
  String? _changerConfirmDate;
  late final Rx<Uint8List?> _supplierSignature;
  String? _supplierConfirmDate;
  late final Rx<Uint8List?> _headUserSignature;
  String? _headUserConfirmDate;

  late final String? id;
  late final ExchangeRequestStatus? status;
  late final bool isSeen;

  ExchangeRequest(
    this.changerUsername,
    this.changerName,
    this.changerOrganPos,
  ) {
    _init();
    isSeen = false;
    id = null;
  }

  String? get supplierUsername => _supplierUsername.value;
  DateTime? get changerShiftDate => _changerShiftDate.value;
  String? get changerShiftDescription => _changerShiftDescription.value;

  Uint8List? get changerSignature => _changerSignature.value;
  String? get changerSignatureBase64 {
    return base64.encode(changerSignature!);
  }

  Uint8List? get supplierSignature => _supplierSignature.value;
  String? get supplierSignatureBase64 {
    return base64.encode(supplierSignature!);
  }

  Uint8List? get headUserSignature => _headUserSignature.value;
  String? get headUserSignatureBase64 {
    return base64.encode(headUserSignature!);
  }

  String? get reqStatus => status?.toStr;

  String? get changerShiftDateString {
    if (changerShiftDate == null) return null;
    var f = Jalali.fromDateTime(changerShiftDate!).formatter;
    return "${f.d}  ${f.mN}  ${f.y}";
  }

  String? get changerShiftDescriptionString {
    if (changerShiftDescription == null) return null;
    return ShiftType.valueOf(changerShiftDescription!).value.tr;
  }

  String get changerConfirmDate => _changerConfirmDate ?? "-";
  String get supplierConfirmDate => _supplierConfirmDate ?? "-";
  String get headUserConfirmDate => _headUserConfirmDate ?? "-";

  set supplierUsername(String? value) => _supplierUsername.value = value;
  set changerShiftDate(DateTime? value) => _changerShiftDate.value = value;
  set changerShiftDescription(String? value) =>
      _changerShiftDescription.value = value;

  set changerSignature(Uint8List? value) {
    if (value == null) {
      _changerSignature.value = null;
      _changerConfirmDate = null;
      return;
    }

    _changerSignature.value = value;
    var f = Jalali.now().formatter;
    _changerConfirmDate = "${f.y}-${f.m}-${f.d}";
  }

  set changerSignatureBase64(String? value) {
    if (value == null) {
      changerSignature = null;
      return;
    }
    changerSignature = base64.decode(value);
  }

  set supplierSignature(Uint8List? value) {
    if (value == null) {
      _supplierSignature.value = null;
      _supplierConfirmDate = null;
      return;
    }
    _supplierSignature.value = value;
    var f = Jalali.now().formatter;
    _supplierConfirmDate = "${f.y}-${f.m}-${f.d}";
  }

  set supplierSignatureBase64(String? value) {
    if (value == null) {
      supplierSignature = null;
      return;
    }
    supplierSignature = base64.decode(value);
  }

  set headUserSignature(Uint8List? value) {
    if (value == null) {
      _headUserSignature.value = null;
      _headUserConfirmDate = null;
      return;
    }
    _headUserSignature.value = value;
    var f = Jalali.now().formatter;
    _headUserConfirmDate = "${f.y}-${f.m}-${f.d}";
  }

  set headUserSignatureBase64(String? value) {
    if (value == null) {
      headUserSignature = null;
      return;
    }
    headUserSignature = base64.decode(value);
  }

  void _init() {
    _supplierUsername = Rx<String?>(null);
    _changerShiftDate = Rx<DateTime?>(null);
    _changerShiftDescription = Rx<String?>(null);
    _changerSignature = Rx<Uint8List?>(null);
    _supplierSignature = Rx<Uint8List?>(null);
    _headUserSignature = Rx<Uint8List?>(null);
  }

  ExchangeRequest.fromParse(Map<String, dynamic> map) {
    _init();
    changerName = map['changerName'];
    changerUsername = map['changerUsername'];
    changerOrganPos = map['changerOrganPos'];
    supplierName = map['supplierName'];
    supplierUsername = map['supplierUsername'];
    final date = (map['shiftDate'] as String).split("-");
    changerShiftDate = map['shiftDate'] == null
        ? null
        : Jalali(int.parse(date[0]), int.parse(date[1]), int.parse(date[2]))
            .toDateTime();
    changerShiftDescription = map['shiftDes'];
    changerSignatureBase64 = map['changerSign'];
    supplierSignatureBase64 = map['supplierSign'];
    headUserSignatureBase64 = map['headUserSign'];
    _changerConfirmDate = map['changerConfirmDate'];
    _supplierConfirmDate = map['supplierConfirmDate'];
    _headUserConfirmDate = map['headUserConfirmDate'];
    id = map['id'];
    status = ExchangeRequestStatus.valueOf(map['status']);
    isSeen = map['isSeen'] ?? false;
  }

  Map<String, dynamic> parseMap() {
    var f = Jalali.fromDateTime(changerShiftDate!).formatter;
    return {
      'changerName': changerName,
      'changerUsername': changerUsername,
      'changerOrganPos': changerOrganPos,
      'supplierName': supplierName,
      'supplierUsername': supplierUsername,
      'shiftDate': "${f.y}-${f.m}-${f.d}",
      'shiftDes': changerShiftDescription,
      'changerSign': changerSignature != null ? changerSignatureBase64 : null,
      'supplierSign':
          supplierSignature != null ? supplierSignatureBase64 : null,
      'headUserSign':
          headUserSignature != null ? headUserSignatureBase64 : null,
      'changerConfirmDate': _changerConfirmDate,
      'supplierConfirmDate': _supplierConfirmDate,
      'headUserConfirmDate': _headUserConfirmDate,
      'id': id,
    };
  }

  @override
  String toString() {
    return 'ExchangeRequest{changerNationalId: $changerUsername, changerName: $changerName, changerOrganPos: $changerOrganPos, supplierNationalId: $supplierUsername, supplierName: $supplierName, changerShiftDate: $changerShiftDate, changerShiftDescription: $changerShiftDescription, changerSignature: $changerSignature, supplierSignature: $supplierSignature, headUserSignature: $headUserSignature}';
  }
}

enum ExchangeRequestStatus {
  WC("${Strs.waitedConfirmStr} ${Strs.changerReqStr}"),
  WS("${Strs.waitedConfirmStr} ${Strs.supplierReqStr}"),
  WH("${Strs.waitedConfirmStr} ${Strs.headUnitUserStr}"),
  FC("${Strs.failedConfirmStr} ${Strs.changerReqStr}"),
  FS("${Strs.failedConfirmStr} ${Strs.supplierReqStr}"),
  FH("${Strs.failedConfirmStr} ${Strs.headUnitUserStr}"),
  C(Strs.confirmationsStr);

  const ExchangeRequestStatus(this.toStr);
  final String toStr;

  static ExchangeRequestStatus valueOf(String value) {
    return values.firstWhere((type) => type.name == value);
  }
}

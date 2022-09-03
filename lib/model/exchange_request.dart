import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:shamsi_date/shamsi_date.dart';

import 'user.dart';

class ExchangeRequest {
  String? changerNationalId;
  String? changerName;
  String? changerOrganPos;
  late final Rx<String?> _supplierNationalId;
  String? supplierName;
  late final Rx<DateTime?> _changerShiftDate;
  late final Rx<String?> _changerShiftDescription;
  late final Rx<Uint8List?> _changerSignature;
  late final Rx<Uint8List?> _supplierSignature;
  late final Rx<Uint8List?> _headUserSignature;
  bool isSeen = false;

  ExchangeRequest(
    this.changerNationalId,
    this.changerName,
    this.changerOrganPos,
  ) {
    _init();
  }

  String? get supplierNationalId => _supplierNationalId.value;
  DateTime? get changerShiftDate => _changerShiftDate.value;
  String? get changerShiftDescription => _changerShiftDescription.value;
  Uint8List? get changerSignature => _changerSignature.value;
  Uint8List? get supplierSignature => _supplierSignature.value;
  Uint8List? get headUserSignature => _headUserSignature.value;

  String? get changerShiftDateString {
    if (changerShiftDate == null) return null;
    var f = Jalali.fromDateTime(changerShiftDate!).formatter;
    return "${f.d}  ${f.mN}  ${f.y}";
  }

  String? get changerShiftDescriptionString {
    if (changerShiftDescription == null) return null;
    return ShiftType.valueOf(changerShiftDescription!).value.tr;
  }

  set supplierNationalId(String? value) => _supplierNationalId.value = value;
  set changerShiftDate(DateTime? value) => _changerShiftDate.value = value;
  set changerShiftDescription(String? value) =>
      _changerShiftDescription.value = value;
  set changerSignature(Uint8List? value) => _changerSignature.value = value;
  set supplierSignature(Uint8List? value) => _supplierSignature.value = value;
  set headUserSignature(Uint8List? value) => _headUserSignature.value = value;

  void _init() {
    _supplierNationalId = Rx<String?>(null);
    _changerShiftDate = Rx<DateTime?>(null);
    _changerShiftDescription = Rx<String?>(null);
    _changerSignature = Rx<Uint8List?>(null);
    _supplierSignature = Rx<Uint8List?>(null);
    _headUserSignature = Rx<Uint8List?>(null);
  }

  ExchangeRequest.fromParse(Map<String, dynamic> map) {
    _init();
    changerName = map['changerName'];
    changerNationalId = map['changerUsername'];
    changerOrganPos = map['changerOrganPos'];
    supplierName = map['supplierName'];
    supplierNationalId = map['supplierUsername'];
    final date = (map['shiftDate'] as String).split("-");
    changerShiftDate = map['shiftDate'] == null
        ? null
        : Jalali(int.parse(date[0]), int.parse(date[1]), int.parse(date[2]))
            .toDateTime();
    changerShiftDescription = map['shiftDes'];
    changerSignature =
        Uint8List.fromList((map['changerSign'] as String?)?.codeUnits ?? []);
    supplierSignature =
        Uint8List.fromList((map['supplierSign'] as String?)?.codeUnits ?? []);
    headUserSignature =
        Uint8List.fromList((map['headUserSign'] as String?)?.codeUnits ?? []);
    if (changerSignature != null && changerSignature!.isEmpty) {
      changerSignature = null;
    }
    if (supplierSignature != null && supplierSignature!.isEmpty) {
      supplierSignature = null;
    }
    if (headUserSignature != null && headUserSignature!.isEmpty) {
      headUserSignature = null;
    }
    isSeen = map['isSeen'] ?? false;
  }

  Map<String, dynamic> parseMap() {
    var f = Jalali.fromDateTime(changerShiftDate!).formatter;
    return {
      'changerName': changerName,
      'changerUsername': changerNationalId!,
      'changerOrganPos': changerOrganPos,
      'supplierName': supplierName,
      'supplierUsername': supplierNationalId!,
      'shiftDate': "${f.y}-${f.m}-${f.d}",
      'shiftDes': changerShiftDescription!,
      'changerSign': changerSignature != null
          ? String.fromCharCodes(changerSignature!)
          : null,
      'supplierSign': supplierSignature != null
          ? String.fromCharCodes(supplierSignature!)
          : null,
      'headUserSign': headUserSignature != null
          ? String.fromCharCodes(headUserSignature!)
          : null,
      'isSeen': isSeen,
    };
  }

  @override
  String toString() {
    return 'ExchangeRequest{changerNationalId: $changerNationalId, changerName: $changerName, changerOrganPos: $changerOrganPos, supplierNationalId: $supplierNationalId, supplierName: $supplierName, changerShiftDate: $changerShiftDate, changerShiftDescription: $changerShiftDescription, changerSignature: $changerSignature, supplierSignature: $supplierSignature, headUserSignature: $headUserSignature}';
  }
}

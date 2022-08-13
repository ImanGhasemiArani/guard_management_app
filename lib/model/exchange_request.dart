import 'dart:typed_data';

import 'package:get/get.dart';

class ExchangeRequest {
  String? changerNationalId;
  String? changerName;
  late final Rx<String?> _supplierNationalId;
  String? supplierName;
  late final Rx<String?> _changerShiftDate;
  late final Rx<String?> _changerShiftDescription;
  late final Rx<Uint8List?> _changerSignature;
  late final Rx<Uint8List?> _supplierSignature;
  late final Rx<Uint8List?> _headUserSignature;

  ExchangeRequest(
    this.changerNationalId,
    this.changerName,
  ) {
    _init();
  }

  String? get supplierNationalId => _supplierNationalId.value;
  String? get changerShiftDate => _changerShiftDate.value;
  String? get changerShiftDescription => _changerShiftDescription.value;
  Uint8List? get changerSignature => _changerSignature.value;
  Uint8List? get supplierSignature => _supplierSignature.value;
  Uint8List? get headUserSignature => _headUserSignature.value;

  set supplierNationalId(String? value) => _supplierNationalId.value = value;
  set changerShiftDate(String? value) => _changerShiftDate.value = value;
  set changerShiftDescription(String? value) =>
      _changerShiftDescription.value = value;
  set changerSignature(Uint8List? value) => _changerSignature.value = value;
  set supplierSignature(Uint8List? value) => _supplierSignature.value = value;
  set headUserSignature(Uint8List? value) => _headUserSignature.value = value;

  void _init() {
    _supplierNationalId = Rx<String?>(null);
    _changerShiftDate = Rx<String?>(null);
    _changerShiftDescription = Rx<String?>(null);
    _changerSignature = Rx<Uint8List?>(null);
    _supplierSignature = Rx<Uint8List?>(null);
    _headUserSignature = Rx<Uint8List?>(null);
  }
}

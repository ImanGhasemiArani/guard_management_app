import 'package:get/get.dart';

class ExchangeRequest {
  String? changerNationalId;
  late final Rx<String?> _supplierNationalId;
  late final Rx<String?> _changerShiftDate;
  late final Rx<String?> _changerShiftDescription;

  ExchangeRequest(
    this.changerNationalId,
  ) {
    _init();
  }

  String? get supplierNationalId => _supplierNationalId.value;
  String? get changerShiftDate => _changerShiftDate.value;
  String? get changerShiftDescription => _changerShiftDescription.value;

  set supplierNationalId(String? value) => _supplierNationalId.value = value;
  set changerShiftDate(String? value) => _changerShiftDate.value = value;
  set changerShiftDescription(String? value) =>
      _changerShiftDescription.value = value;

  void _init() {
    _supplierNationalId = Rx<String?>(null);
    _changerShiftDate = Rx<String?>(null);
    _changerShiftDescription = Rx<String?>(null);
  }
}

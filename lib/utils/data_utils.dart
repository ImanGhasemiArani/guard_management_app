import 'package:get/get.dart';
import 'package:shamsi_date/shamsi_date.dart';

import '../model/user.dart';
import '../services/server_service.dart';

class DataUtils {
  DataUtils._();

  /// Converter:
  ///
  ///       List<Map<String, dynamic>> => Map<DateTime, List<dynamic>>
  ///
  ///       database Plan objects => calendar events
  ///
  /// this method convert the map that we get from the server to
  ///  a map that we can use in events of calendar.
  static Map<DateTime, List<dynamic>> convertPlanToEvents(
    List<Map<String, dynamic>> planObj,
  ) {
    final Map<DateTime, List<dynamic>> events = {};
    planObj.forEach((row) {
      final shifts = row['shifts'] as Map<String, dynamic>;
      final username = row['username'] as String;
      final name = row['name'] as String;

      shifts.entries.map((e) {
        final key = e.key;
        final value = e.value as String;
        final jalaliStr = key.split('-').map((str) => int.parse(str)).toList();
        final dateTime =
            Jalali(jalaliStr[0], jalaliStr[1], jalaliStr[2]).toDateTime();
        final values = value.toUpperCase().split('').map((char) {
          return {
            'username': username,
            'name': name,
            'shift': ShiftType.valueOf(char).value.tr
          };
        }).toList();
        return MapEntry(dateTime, values);
      }).forEach((element) {
        if (events.containsKey(element.key)) {
          events[element.key]!.addAll(element.value);
        } else {
          events[element.key] = element.value;
        }
      });
    });
    return events;
  }

  /// Filter:
  ///
  ///      Map<String, String> => remove all data about currentUser
  static Map<String, String> filterCurrentUserFromUsersMap(
    Map<String, String> map,
  ) {
    var result = {...map};
    result.removeWhere(
        (key, value) => key == ServerService.currentUser.nationalId);
    return result;
  }
}

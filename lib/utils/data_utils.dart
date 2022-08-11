import 'package:shamsi_date/shamsi_date.dart';

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
    final events = <DateTime, List<dynamic>>{};
    for (var row in planObj) {
      var plans = row['plan'] as List<dynamic>;
      var username = row['username'] as String;
      var name = row['name'] as String;
      plans.map((e) {
        var me = (e as Map<String, dynamic>).entries.first;
        final jalaliStr =
            me.key.split('-').map((str) => int.parse(str)).toList();
        var dateTime =
            Jalali(jalaliStr[0], jalaliStr[1], jalaliStr[2]).toDateTime();
        return MapEntry(
            dateTime, {'username': username, 'name': name, 'shift': me.value});
      }).forEach((element) {
        if (events.containsKey(element.key)) {
          events[element.key]!.add(element.value);
        } else {
          events[element.key] = [element.value];
        }
      });
    }
    return events;
  }

  /// Filter:
  ///
  ///      Map<String, String> => remove all data about currentUser
  static Map<String, String> filterCurrentUserFromUsersMap(
    Map<String, String> map,
  ) {
    var result = {...map};
    result.removeWhere((key, value) => key == currentUser.nationalId);
    return result;
  }
}

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
      final profileImg = row['profileImg'];
      final post = row['post'];
      final teamName = row['teamName'];

      shifts.entries.map((e) {
        final key = e.key;
        final value = (e.value as Map<String, dynamic>)["des"];
        final isExchangeable =
            (e.value as Map<String, dynamic>)["isExchangeable"];
        final jalaliStr = key.split('-').map((str) => int.parse(str)).toList();
        final dateTime =
            Jalali(jalaliStr[0], jalaliStr[1], jalaliStr[2]).toDateTime();
        final values = value.toUpperCase().split('').map((char) {
          return {
            'username': username,
            'name': name,
            'post': post,
            'teamName': teamName,
            'shift': {
              "des": ShiftType.valueOf(char).value.tr,
              "isExchangeable": isExchangeable
            },
            'profileImg': profileImg
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
    result
        .removeWhere((key, value) => key == ServerService.currentUser.username);
    return result;
  }

  /// Sorter:
  ///
  ///       List<Map<String, dynamic>> => sort by isCurrentUser
  static List<Map<String, dynamic>> sortByCurrentUser(
    List<Map<String, dynamic>> list,
  ) {
    list = [...list];
    final currentUserUsername = ServerService.currentUser.username;
    list.sort((a, b) {
      final aUsername = a['username'] as String;
      final bUsername = b['username'] as String;
      if (aUsername == currentUserUsername) {
        return -1;
      } else if (bUsername == currentUserUsername) {
        return 1;
      } else {
        return 0;
      }
    });
    return list;
  }

  /// Sorter
  /// 
  ///       List<Map<String, dynamic>> => sort by teamName then sort by post
  static List<Map<String, dynamic>> sortByTeam(
    List<Map<String, dynamic>> list,
  ) {
    list = [...list];
    list.sort((a, b) {
      final aTeam = a['teamName'] as String;
      final bTeam = b['teamName'] as String;
      if (aTeam.compareTo(bTeam) == 0) {
        final aPost = a['post'] as String;
        final bPost = b['post'] as String;
        if (aPost == "S") {
          return -1;
        } else if (bPost == "S") {
          return 1;
        } else {
          return 0;
        }
      } else {
        return aTeam.compareTo(bTeam);
      }
    });
    return list;
  }
}

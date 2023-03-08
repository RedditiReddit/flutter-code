import 'dart:convert';

class Alarm {
  final String name;
  final String
      day; // day of alarm: ["Saturday" = 1, "Sunday" = 2, "Monday" = 3, "Tuesday" = 4, "Wednesday" = 5, "Thursday" = 6, "Friday" = 7]
  final String time;
  final String id;
  bool isToggle;

  Alarm({
    required this.name,
    required this.day,
    required this.time,
    required this.id,
    required this.isToggle,
  });

  factory Alarm.fromJson(Map<String, dynamic> jsonData) {
    return Alarm(
      name: jsonData['name'],
      day: jsonData['day'],
      time: jsonData['time'],
      id: jsonData['id'],
      isToggle: jsonData['isToggle'],
    );
  }

  static Map<String, dynamic> toMap(Alarm alarm) => {
        'name': alarm.name,
        'day': alarm.day,
        'time': alarm.time,
        'id': alarm.id,
        'isToggle': alarm.isToggle,
      };

  static String encode(List<Alarm> alarms) => json.encode(
        alarms
            .map<Map<String, dynamic>>((alarm) => Alarm.toMap(alarm))
            .toList(),
      );

  static List<Alarm> decode(String alarms) =>
      (json.decode(alarms) as List<dynamic>)
          .map<Alarm>((item) => Alarm.fromJson(item))
          .toList();
}

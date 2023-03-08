import 'package:clock_app/models/alarms_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:uuid/uuid.dart';

import 'package:clock_app/assets/icons/widgets/calendar_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddingNewAlarmScreen extends StatefulWidget {
  const AddingNewAlarmScreen({super.key});

  @override
  State<AddingNewAlarmScreen> createState() => _AddingNewAlarmScreenState();
}

void savingAlarms(Future<List<Alarm>> data) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  List<Alarm> dataToSaving = await data;

  // Encode and store data in SharedPreferences
  final String encodedData = Alarm.encode(dataToSaving);

  await prefs.setString('Alarms', encodedData);
}

Future<List<Alarm>> addingToAlarms(
    String name, String day, String time, String id, bool isToggle) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  // Fetch and decode data
  final String alarmString = prefs.getString('Alarms').toString();

  final List<Alarm> alarms = Alarm.decode(alarmString);

  alarms.add(Alarm(
    name: name,
    day: day,
    time: time,
    id: id,
    isToggle: isToggle,
  ));

  return alarms;
}

Route slideTransition() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        const AddingNewAlarmScreen(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const end = Offset(0.0, 1.0);
      const begin = Offset.zero;
      const curve = Curves.easeInOut;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
    barrierColor: const Color.fromARGB(100, 0, 0, 0),
    transitionDuration: const Duration(milliseconds: 400),
  );
}

class _AddingNewAlarmScreenState extends State<AddingNewAlarmScreen> {
  int _hourValue = 0;
  int _minValue = 0;

  bool isAlarmHaveSound = false;

  TextEditingController nameTextEditingController = TextEditingController();

  bool isSaturday = false;
  bool isSunday = false;
  bool isMonday = false;
  bool isTuesday = false;
  bool isWednesday = false;
  bool isThursday = false;
  bool isFriday = false;

  @override
  Widget build(BuildContext context) {
    double heightOfWholeScreen = MediaQuery.of(context).size.height;
    double widthOfWholeScreen = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 240, 240, 240),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              height: (1 / 3) * heightOfWholeScreen,
              width: widthOfWholeScreen,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 240, 240, 240),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Transform.scale(
                    scale: 1.5,
                    child: NumberPicker(
                      value: _hourValue,
                      minValue: 0,
                      maxValue: 23,
                      onChanged: (value) => setState(() => _hourValue = value),
                      textStyle: TextStyle(
                        fontSize: (MediaQuery.of(context).orientation ==
                                Orientation.portrait)
                            ? widthOfWholeScreen / 16
                            : heightOfWholeScreen / 16,
                        color: const Color.fromARGB(255, 176, 176, 176),
                      ),
                      itemHeight: (MediaQuery.of(context).orientation ==
                              Orientation.portrait)
                          ? widthOfWholeScreen / 9
                          : heightOfWholeScreen / 9,
                      selectedTextStyle: TextStyle(
                        fontSize: (MediaQuery.of(context).orientation ==
                                Orientation.portrait)
                            ? widthOfWholeScreen / 11
                            : heightOfWholeScreen / 11,
                        color: const Color.fromARGB(255, 0, 123, 255),
                        // fontWeight: FontWeight.bold,
                      ),
                      zeroPad: true,
                      infiniteLoop: true,
                    ),
                  ),
                  Text(
                    "   :   ",
                    style: TextStyle(
                      fontSize: (MediaQuery.of(context).orientation ==
                              Orientation.portrait)
                          ? widthOfWholeScreen / 9
                          : heightOfWholeScreen / 9,
                      color: const Color.fromARGB(255, 0, 123, 255),
                    ),
                  ),
                  Transform.scale(
                    scale: 1.5,
                    child: NumberPicker(
                      key: const Key("Minutes"),
                      value: _minValue,
                      minValue: 0,
                      maxValue: 59,
                      onChanged: (value) => setState(() => _minValue = value),
                      textStyle: TextStyle(
                        fontSize: (MediaQuery.of(context).orientation ==
                                Orientation.portrait)
                            ? widthOfWholeScreen / 16
                            : heightOfWholeScreen / 16,
                        color: const Color.fromARGB(255, 176, 176, 176),
                      ),
                      itemHeight: (MediaQuery.of(context).orientation ==
                              Orientation.portrait)
                          ? widthOfWholeScreen / 9
                          : heightOfWholeScreen / 9,
                      selectedTextStyle: TextStyle(
                        fontSize: (MediaQuery.of(context).orientation ==
                                Orientation.portrait)
                            ? widthOfWholeScreen / 11
                            : heightOfWholeScreen / 11,
                        color: const Color.fromARGB(255, 0, 123, 255),
                        // fontWeight: FontWeight.bold,
                      ),
                      zeroPad: true,
                      infiniteLoop: true,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              alignment: Alignment.center,
              height: (2 / 3) * heightOfWholeScreen,
              width: widthOfWholeScreen,
              padding: EdgeInsets.only(
                right:
                    (MediaQuery.of(context).orientation == Orientation.portrait)
                        ? widthOfWholeScreen / 19
                        : heightOfWholeScreen / 19,
                left:
                    (MediaQuery.of(context).orientation == Orientation.portrait)
                        ? widthOfWholeScreen / 19
                        : heightOfWholeScreen / 19,
                top:
                    (MediaQuery.of(context).orientation == Orientation.portrait)
                        ? widthOfWholeScreen / 18
                        : heightOfWholeScreen / 18,
              ),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 255, 255, 255),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(
                      (MediaQuery.of(context).orientation ==
                              Orientation.portrait)
                          ? widthOfWholeScreen / 10
                          : heightOfWholeScreen / 10),
                  topRight: Radius.circular(
                      (MediaQuery.of(context).orientation ==
                              Orientation.portrait)
                          ? widthOfWholeScreen / 10
                          : heightOfWholeScreen / 10),
                ),
                shape: BoxShape.rectangle,
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromARGB(3, 0, 0, 0),
                    offset: Offset(0, -8),
                    blurRadius: 20,
                  ),
                ],
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    // Selecting the day on the calendar
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "Tomorrow, Sunday, Feb 15",
                          style: TextStyle(
                            fontSize: (MediaQuery.of(context).orientation ==
                                    Orientation.portrait)
                                ? widthOfWholeScreen / 21
                                : heightOfWholeScreen / 21,
                            fontFamily: "Roboto-Regular",
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Calendar.calendar),
                          iconSize: (MediaQuery.of(context).orientation ==
                                  Orientation.portrait)
                              ? widthOfWholeScreen / 11
                              : heightOfWholeScreen / 11,
                          onPressed: () {},
                        )
                      ],
                    ),
                    // A space between selecting on calendar and day of week
                    SizedBox(
                      height: (MediaQuery.of(context).orientation ==
                              Orientation.portrait)
                          ? widthOfWholeScreen / 20
                          : heightOfWholeScreen / 20,
                    ),
                    // the day of the week to select to alarm
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // sunday
                        TextButton(
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(widthOfWholeScreen),
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              isSunday = !isSunday;
                            });
                          },
                          child: Text(
                            "Su",
                            style: TextStyle(
                              color: (isSunday)
                                  ? const Color.fromARGB(255, 255, 17, 0)
                                  : const Color.fromARGB(100, 255, 17, 0),
                              fontFamily: "Roboto-Black",
                              fontSize: (MediaQuery.of(context).orientation ==
                                      Orientation.portrait)
                                  ? widthOfWholeScreen / 14
                                  : heightOfWholeScreen / 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        // Monday
                        TextButton(
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(widthOfWholeScreen),
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              isMonday = !isMonday;
                            });
                          },
                          child: Text(
                            "Mo",
                            style: TextStyle(
                              color: (isMonday)
                                  ? const Color.fromARGB(255, 7, 0, 196)
                                  : const Color.fromARGB(100, 7, 0, 196),
                              fontFamily: "Roboto-Black",
                              fontSize: (MediaQuery.of(context).orientation ==
                                      Orientation.portrait)
                                  ? widthOfWholeScreen / 14
                                  : heightOfWholeScreen / 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        // Tuesday
                        TextButton(
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(widthOfWholeScreen),
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              isTuesday = !isTuesday;
                            });
                          },
                          child: Text(
                            "Tu",
                            style: TextStyle(
                              color: (isTuesday)
                                  ? const Color.fromARGB(255, 7, 0, 196)
                                  : const Color.fromARGB(100, 7, 0, 196),
                              fontFamily: "Roboto-Black",
                              fontSize: (MediaQuery.of(context).orientation ==
                                      Orientation.portrait)
                                  ? widthOfWholeScreen / 14
                                  : heightOfWholeScreen / 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        // Wednesday
                        TextButton(
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(widthOfWholeScreen),
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              isWednesday = !isWednesday;
                            });
                          },
                          child: Text(
                            "We",
                            style: TextStyle(
                              color: (isWednesday)
                                  ? const Color.fromARGB(255, 7, 0, 196)
                                  : const Color.fromARGB(100, 7, 0, 196),
                              fontFamily: "Roboto-Black",
                              fontSize: (MediaQuery.of(context).orientation ==
                                      Orientation.portrait)
                                  ? widthOfWholeScreen / 14
                                  : heightOfWholeScreen / 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        // Thursday
                        TextButton(
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(widthOfWholeScreen),
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              isThursday = !isThursday;
                            });
                          },
                          child: Text(
                            "Th",
                            style: TextStyle(
                              color: (isThursday)
                                  ? const Color.fromARGB(255, 7, 0, 196)
                                  : const Color.fromARGB(100, 7, 0, 196),
                              fontFamily: "Roboto-Black",
                              fontSize: (MediaQuery.of(context).orientation ==
                                      Orientation.portrait)
                                  ? widthOfWholeScreen / 14
                                  : heightOfWholeScreen / 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        // Friday
                        TextButton(
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(widthOfWholeScreen),
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              isFriday = !isFriday;
                            });
                          },
                          child: Text(
                            "Fr",
                            style: TextStyle(
                              color: (isFriday)
                                  ? const Color.fromARGB(255, 7, 0, 196)
                                  : const Color.fromARGB(100, 7, 0, 196),
                              fontFamily: "Roboto-Black",
                              fontSize: (MediaQuery.of(context).orientation ==
                                      Orientation.portrait)
                                  ? widthOfWholeScreen / 14
                                  : heightOfWholeScreen / 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        // Saturday
                        TextButton(
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(widthOfWholeScreen),
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              isSaturday = !isSaturday;
                            });
                          },
                          child: Text(
                            "Sa",
                            style: TextStyle(
                              color: (isSaturday)
                                  ? const Color.fromARGB(255, 7, 0, 196)
                                  : const Color.fromARGB(100, 7, 0, 196),
                              fontFamily: "Roboto-Black",
                              fontSize: (MediaQuery.of(context).orientation ==
                                      Orientation.portrait)
                                  ? widthOfWholeScreen / 14
                                  : heightOfWholeScreen / 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    // Space betweeen the day selection and Name Edit Field
                    SizedBox(
                      height: (MediaQuery.of(context).orientation ==
                              Orientation.portrait)
                          ? widthOfWholeScreen / 15
                          : heightOfWholeScreen / 15,
                    ),
                    // Enterin the name of the alarm
                    Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(
                          (MediaQuery.of(context).orientation ==
                                  Orientation.portrait)
                              ? widthOfWholeScreen / 20
                              : heightOfWholeScreen / 20,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            offset: Offset(0, 0),
                            color: Color.fromARGB(40, 0, 0, 0),
                            blurRadius: 50,
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: nameTextEditingController,
                        cursorHeight: (MediaQuery.of(context).orientation ==
                                Orientation.portrait)
                            ? widthOfWholeScreen / 18
                            : heightOfWholeScreen / 18,
                        style: TextStyle(
                          fontSize: (MediaQuery.of(context).orientation ==
                                  Orientation.portrait)
                              ? widthOfWholeScreen / 18
                              : heightOfWholeScreen / 18,
                        ),
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              (MediaQuery.of(context).orientation ==
                                      Orientation.portrait)
                                  ? widthOfWholeScreen / 20
                                  : heightOfWholeScreen / 20,
                            ),
                            borderSide: const BorderSide(
                              color: Colors.white,
                              width: 2,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              (MediaQuery.of(context).orientation ==
                                      Orientation.portrait)
                                  ? widthOfWholeScreen / 20
                                  : heightOfWholeScreen / 20,
                            ),
                            borderSide: const BorderSide(
                              color: Colors.white,
                              width: 2,
                            ),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              (MediaQuery.of(context).orientation ==
                                      Orientation.portrait)
                                  ? widthOfWholeScreen / 20
                                  : heightOfWholeScreen / 20,
                            ),
                            borderSide: const BorderSide(
                              color: Colors.white,
                              width: 2,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              (MediaQuery.of(context).orientation ==
                                      Orientation.portrait)
                                  ? widthOfWholeScreen / 20
                                  : heightOfWholeScreen / 20,
                            ),
                            borderSide: const BorderSide(
                              color: Colors.white,
                              width: 2,
                            ),
                          ),
                          hintText: "Alarm name ...",
                          hintStyle: TextStyle(
                            fontSize: (MediaQuery.of(context).orientation ==
                                    Orientation.portrait)
                                ? widthOfWholeScreen / 18
                                : heightOfWholeScreen / 18,
                          ),
                          contentPadding: EdgeInsets.only(
                            left: (MediaQuery.of(context).orientation ==
                                    Orientation.portrait)
                                ? widthOfWholeScreen / 15
                                : heightOfWholeScreen / 15,
                            top: (MediaQuery.of(context).orientation ==
                                    Orientation.portrait)
                                ? widthOfWholeScreen / 20
                                : heightOfWholeScreen / 20,
                            bottom: (MediaQuery.of(context).orientation ==
                                    Orientation.portrait)
                                ? widthOfWholeScreen / 20
                                : heightOfWholeScreen / 20,
                          ),
                          floatingLabelAlignment: FloatingLabelAlignment.center,
                        ),
                        textAlign: TextAlign.left,
                        textAlignVertical: TextAlignVertical.center,
                      ),
                    ),
                    // Space betweeen the alarm sound selection and Name Edit Field
                    SizedBox(
                      height: (MediaQuery.of(context).orientation ==
                              Orientation.portrait)
                          ? widthOfWholeScreen / 15
                          : heightOfWholeScreen / 15,
                    ),
                    // Sound Selection
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              onPressed: () {},
                              style: ButtonStyle(
                                overlayColor: MaterialStateProperty.all(
                                    Colors.transparent),
                              ),
                              child: Text(
                                "Alarm sound",
                                style: TextStyle(
                                  fontFamily: "Roboto-Black",
                                  fontSize:
                                      (MediaQuery.of(context).orientation ==
                                              Orientation.portrait)
                                          ? widthOfWholeScreen / 20
                                          : heightOfWholeScreen / 20,
                                  color: const Color.fromARGB(255, 30, 30, 30),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: (MediaQuery.of(context).orientation ==
                                      Orientation.portrait)
                                  ? widthOfWholeScreen / 500
                                  : heightOfWholeScreen / 500,
                            ),
                            TextButton(
                              onPressed: () {},
                              style: ButtonStyle(
                                overlayColor: MaterialStateProperty.all(
                                    Colors.transparent),
                              ),
                              child: Text(
                                "Beep Once",
                                style: TextStyle(
                                  fontFamily: "Roboto-Regular",
                                  fontSize:
                                      (MediaQuery.of(context).orientation ==
                                              Orientation.portrait)
                                          ? widthOfWholeScreen / 30
                                          : heightOfWholeScreen / 30,
                                  color: const Color.fromARGB(255, 0, 123, 255),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: (MediaQuery.of(context).orientation ==
                                  Orientation.portrait)
                              ? widthOfWholeScreen / 4
                              : heightOfWholeScreen / 4,
                        ),
                        Container(
                          height: (MediaQuery.of(context).orientation ==
                                  Orientation.portrait)
                              ? widthOfWholeScreen / 6
                              : heightOfWholeScreen / 6,
                          width: 1,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(40, 83, 83, 83),
                            borderRadius:
                                BorderRadius.circular(widthOfWholeScreen),
                          ),
                          // child: Text("Hi"),
                        ),
                        SizedBox(
                          width: (MediaQuery.of(context).orientation ==
                                  Orientation.portrait)
                              ? widthOfWholeScreen / 40
                              : heightOfWholeScreen / 40,
                        ),
                        Transform.scale(
                          scale: 1.6,
                          child: CupertinoSwitch(
                            value: isAlarmHaveSound,
                            onChanged: (value) {
                              setState(() {
                                isAlarmHaveSound = value;
                              });
                            },
                            activeColor: const Color.fromARGB(255, 0, 123, 255),
                          ),
                        ),
                      ],
                    ),
                    // Space between the Alarm sound and Vibration
                    SizedBox(
                      height: (MediaQuery.of(context).orientation ==
                              Orientation.portrait)
                          ? widthOfWholeScreen / 15
                          : heightOfWholeScreen / 15,
                    ),
                    // The divider between the Alarm sound and the bellow weidget one
                    Container(
                      width: (MediaQuery.of(context).orientation ==
                              Orientation.portrait)
                          ? widthOfWholeScreen / 1.2
                          : heightOfWholeScreen / 1.2,
                      height: 1,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(40, 83, 83, 83),
                        borderRadius: BorderRadius.circular(widthOfWholeScreen),
                      ),
                      // child: Text("Hi"),
                    ),
                    // Space between the Alarm sound and Vibration
                    SizedBox(
                      height: (MediaQuery.of(context).orientation ==
                              Orientation.portrait)
                          ? widthOfWholeScreen / 15
                          : heightOfWholeScreen / 15,
                    ),
                    // Vibration
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              onPressed: () {},
                              style: ButtonStyle(
                                overlayColor: MaterialStateProperty.all(
                                    Colors.transparent),
                              ),
                              child: Text(
                                "Vibration",
                                style: TextStyle(
                                  fontFamily: "Roboto-Black",
                                  fontSize:
                                      (MediaQuery.of(context).orientation ==
                                              Orientation.portrait)
                                          ? widthOfWholeScreen / 20
                                          : heightOfWholeScreen / 20,
                                  color: const Color.fromARGB(255, 30, 30, 30),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: (MediaQuery.of(context).orientation ==
                                      Orientation.portrait)
                                  ? widthOfWholeScreen / 500
                                  : heightOfWholeScreen / 500,
                            ),
                            TextButton(
                              onPressed: () {},
                              style: ButtonStyle(
                                overlayColor: MaterialStateProperty.all(
                                    Colors.transparent),
                              ),
                              child: Text(
                                "Basic Call",
                                style: TextStyle(
                                  fontFamily: "Roboto-Regular",
                                  fontSize:
                                      (MediaQuery.of(context).orientation ==
                                              Orientation.portrait)
                                          ? widthOfWholeScreen / 30
                                          : heightOfWholeScreen / 30,
                                  color: const Color.fromARGB(255, 0, 123, 255),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: (MediaQuery.of(context).orientation ==
                                  Orientation.portrait)
                              ? widthOfWholeScreen / 3
                              : heightOfWholeScreen / 3,
                        ),
                        Container(
                          height: (MediaQuery.of(context).orientation ==
                                  Orientation.portrait)
                              ? widthOfWholeScreen / 6
                              : heightOfWholeScreen / 6,
                          width: 1,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(60, 83, 83, 83),
                            borderRadius:
                                BorderRadius.circular(widthOfWholeScreen),
                          ),
                          // child: Text("Hi"),
                        ),
                        SizedBox(
                          width: (MediaQuery.of(context).orientation ==
                                  Orientation.portrait)
                              ? widthOfWholeScreen / 40
                              : heightOfWholeScreen / 40,
                        ),
                        Transform.scale(
                          scale: 1.6,
                          child: CupertinoSwitch(
                            value: isAlarmHaveSound,
                            onChanged: (value) {
                              setState(() {
                                isAlarmHaveSound = value;
                              });
                            },
                            activeColor: const Color.fromARGB(255, 0, 123, 255),
                          ),
                        ),
                      ],
                    ),
                    // Space between the Alarm sound and Vibration
                    SizedBox(
                      height: (MediaQuery.of(context).orientation ==
                              Orientation.portrait)
                          ? widthOfWholeScreen / 15
                          : heightOfWholeScreen / 15,
                    ),
                    // The divider between the Alarm sound and the bellow weidget one
                    Container(
                      width: (MediaQuery.of(context).orientation ==
                              Orientation.portrait)
                          ? widthOfWholeScreen / 1.2
                          : heightOfWholeScreen / 1.2,
                      height: 1,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(60, 83, 83, 83),
                        borderRadius: BorderRadius.circular(widthOfWholeScreen),
                      ),
                      // child: Text("Hi"),
                    ),
                    // Space between the Alarm sound and Vibration
                    SizedBox(
                      height: (MediaQuery.of(context).orientation ==
                              Orientation.portrait)
                          ? widthOfWholeScreen / 15
                          : heightOfWholeScreen / 15,
                    ),
                    // Snooze
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              onPressed: () {},
                              style: ButtonStyle(
                                overlayColor: MaterialStateProperty.all(
                                    Colors.transparent),
                              ),
                              child: Text(
                                "Snooze",
                                style: TextStyle(
                                  fontFamily: "Roboto-Black",
                                  fontSize:
                                      (MediaQuery.of(context).orientation ==
                                              Orientation.portrait)
                                          ? widthOfWholeScreen / 20
                                          : heightOfWholeScreen / 20,
                                  color: const Color.fromARGB(255, 30, 30, 30),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: (MediaQuery.of(context).orientation ==
                                      Orientation.portrait)
                                  ? widthOfWholeScreen / 500
                                  : heightOfWholeScreen / 500,
                            ),
                            TextButton(
                              onPressed: () {},
                              style: ButtonStyle(
                                overlayColor: MaterialStateProperty.all(
                                    Colors.transparent),
                              ),
                              child: Text(
                                "5 minutes, 3 times",
                                style: TextStyle(
                                  fontFamily: "Roboto-Regular",
                                  fontSize:
                                      (MediaQuery.of(context).orientation ==
                                              Orientation.portrait)
                                          ? widthOfWholeScreen / 30
                                          : heightOfWholeScreen / 30,
                                  color: const Color.fromARGB(255, 0, 123, 255),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: (MediaQuery.of(context).orientation ==
                                  Orientation.portrait)
                              ? widthOfWholeScreen / 3
                              : heightOfWholeScreen / 3,
                        ),
                        Container(
                          height: (MediaQuery.of(context).orientation ==
                                  Orientation.portrait)
                              ? widthOfWholeScreen / 6
                              : heightOfWholeScreen / 6,
                          width: 1,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(60, 83, 83, 83),
                            borderRadius:
                                BorderRadius.circular(widthOfWholeScreen),
                          ),
                          // child: Text("Hi"),
                        ),
                        SizedBox(
                          width: (MediaQuery.of(context).orientation ==
                                  Orientation.portrait)
                              ? widthOfWholeScreen / 40
                              : heightOfWholeScreen / 40,
                        ),
                        Transform.scale(
                          scale: 1.6,
                          child: CupertinoSwitch(
                            value: isAlarmHaveSound,
                            onChanged: (value) {
                              setState(() {
                                isAlarmHaveSound = value;
                              });
                            },
                            activeColor: const Color.fromARGB(255, 0, 123, 255),
                          ),
                        ),
                      ],
                    ),
                    // Space between the Alarm sound and Vibration
                    SizedBox(
                      height: (MediaQuery.of(context).orientation ==
                              Orientation.portrait)
                          ? widthOfWholeScreen / 15
                          : heightOfWholeScreen / 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(slideTransition());
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                const Color.fromARGB(255, 202, 201, 255)),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(widthOfWholeScreen),
                              ),
                            ),
                            padding: MaterialStateProperty.all(
                              EdgeInsets.only(
                                top: (MediaQuery.of(context).orientation ==
                                        Orientation.portrait)
                                    ? widthOfWholeScreen / 35
                                    : heightOfWholeScreen / 35,
                                bottom: (MediaQuery.of(context).orientation ==
                                        Orientation.portrait)
                                    ? widthOfWholeScreen / 35
                                    : heightOfWholeScreen / 35,
                                right: (MediaQuery.of(context).orientation ==
                                        Orientation.portrait)
                                    ? widthOfWholeScreen / 10
                                    : heightOfWholeScreen / 10,
                                left: (MediaQuery.of(context).orientation ==
                                        Orientation.portrait)
                                    ? widthOfWholeScreen / 10
                                    : heightOfWholeScreen / 10,
                              ),
                            ),
                          ),
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                              fontSize: (MediaQuery.of(context).orientation ==
                                      Orientation.portrait)
                                  ? widthOfWholeScreen / 20
                                  : heightOfWholeScreen / 20,
                              fontFamily: "Roboto-Black",
                              color: const Color.fromARGB(255, 0, 79, 170),
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            String days = "";

                            if (isSaturday) {
                              days = "${days}1";
                            }
                            if (isSunday) {
                              days = "${days}2";
                            }
                            if (isMonday) {
                              days = "${days}3";
                            }
                            if (isTuesday) {
                              days = "${days}4";
                            }
                            if (isWednesday) {
                              days = "${days}5";
                            }
                            if (isThursday) {
                              days = "${days}6";
                            }
                            if (isFriday) {
                              days = "${days}7";
                            }

                            var uuid = const Uuid();

                            savingAlarms(
                              addingToAlarms(
                                nameTextEditingController.text,
                                days,
                                "$_hourValue:$_minValue",
                                uuid.v1().toString(),
                                true,
                              ),
                            );
                            // Working on saving the alarm datas
                            Navigator.of(context).pop(slideTransition());
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                const Color.fromARGB(255, 4, 0, 255)),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(widthOfWholeScreen),
                              ),
                            ),
                            padding: MaterialStateProperty.all(
                              EdgeInsets.only(
                                top: (MediaQuery.of(context).orientation ==
                                        Orientation.portrait)
                                    ? widthOfWholeScreen / 35
                                    : heightOfWholeScreen / 35,
                                bottom: (MediaQuery.of(context).orientation ==
                                        Orientation.portrait)
                                    ? widthOfWholeScreen / 35
                                    : heightOfWholeScreen / 35,
                                right: (MediaQuery.of(context).orientation ==
                                        Orientation.portrait)
                                    ? widthOfWholeScreen / 8
                                    : heightOfWholeScreen / 8,
                                left: (MediaQuery.of(context).orientation ==
                                        Orientation.portrait)
                                    ? widthOfWholeScreen / 8
                                    : heightOfWholeScreen / 8,
                              ),
                            ),
                          ),
                          child: Text(
                            "Save",
                            style: TextStyle(
                              fontSize: (MediaQuery.of(context).orientation ==
                                      Orientation.portrait)
                                  ? widthOfWholeScreen / 20
                                  : heightOfWholeScreen / 20,
                              fontFamily: "Roboto-Black",
                              color: const Color.fromARGB(255, 255, 255, 255),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: (MediaQuery.of(context).orientation ==
                              Orientation.portrait)
                          ? widthOfWholeScreen / 15
                          : heightOfWholeScreen / 15,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:clock_app/assets/icons/widgets/add_icons.dart';
import 'package:clock_app/assets/icons/widgets/menu_icons.dart';
import 'package:clock_app/assets/icons/widgets/alarm_icons.dart' as alarm_icon;
import 'package:clock_app/assets/icons/widgets/timer_icons.dart';
import 'package:clock_app/assets/icons/widgets/world_clock_icons.dart';
import 'package:clock_app/assets/icons/widgets/stopwatch_icons.dart';
import 'package:clock_app/models/alarms_model.dart';

import 'adding_new_alarm_screen.dart';

enum BottomNavigaionBarIndex {
  alarm,
  worldClock,
  stopwatch,
  timer,
}

List<Alarm> alarmDataToShow = [];

@override
initState() async {
  List<Alarm> alarmDataToShow = await readingFromMemory();
  print("Data form sharedpreference: $alarmDataToShow");
}

Future<List<Alarm>> readingFromMemory() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  // Fetch and decode data
  final String alarmString = prefs.getString('Alarms').toString();

  final List<Alarm> alarms = Alarm.decode(alarmString);

  alarmDataToShow = alarms;

  return alarms;
}

Route slideTransition() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        const AddingNewAlarmScreen(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
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

void storingTheIsToggle({bool? isTrunedOn, String? id, int? index}) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  // Fetch and decode data
  final String alarmString = prefs.getString('Alarms').toString();

  final List<Alarm> alarms = Alarm.decode(alarmString);

  alarms[index as int].isToggle = isTrunedOn as bool;

  // Encode and store data in SharedPreferences
  final String encodedData = Alarm.encode(alarms);

  await prefs.setString('Alarms', encodedData);
}

class AlarmScreen extends StatefulWidget {
  const AlarmScreen({super.key});

  @override
  State<AlarmScreen> createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> {
  BottomNavigaionBarIndex currentTap = BottomNavigaionBarIndex.alarm;

  bool boolean = true;

  PageController controller = PageController(
    initialPage: 0,
  );

  int bottomNavigationBarNumber = 0;

  @override
  Widget build(BuildContext contextOfWholeScreen) {
    double heightOfWholeScreen = MediaQuery.of(context).size.height;
    double widthOfWholeScreen = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 240, 240, 240),
      body: Padding(
        padding: EdgeInsets.only(
          top: widthOfWholeScreen / 20,
        ),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Stack(
              alignment: Alignment.topCenter,
              children: [
                // main contents
                PageView(
                  controller: controller,
                  scrollDirection: Axis.horizontal,
                  onPageChanged: (value) {
                    setState(() {
                      if (value == 0) {
                        currentTap = BottomNavigaionBarIndex.alarm;
                      } else if (value == 1) {
                        currentTap = BottomNavigaionBarIndex.worldClock;
                      } else if (value == 2) {
                        currentTap = BottomNavigaionBarIndex.stopwatch;
                      } else if (value == 3) {
                        currentTap = BottomNavigaionBarIndex.timer;
                      }
                    });
                  },
                  children: [
                    // Alarms
                    FutureBuilder(
                      future: readingFromMemory(),
                      builder: (context, snapshot) {
                        initState();

                        if (snapshot.connectionState == ConnectionState.done) {
                          print("AlarmDataToShow : $alarmDataToShow");

                          return Container(
                            width: widthOfWholeScreen,
                            // height: widthOfWholeScreen / 2,
                            margin: EdgeInsets.only(
                              top: widthOfWholeScreen / 3.5,
                              bottom: widthOfWholeScreen / 5,
                            ),
                            child: (alarmDataToShow.isNotEmpty)
                                ? ListView.builder(
                                    itemCount: alarmDataToShow.length,
                                    itemBuilder: (context, indexOfContainers) {
                                      return Container(
                                        alignment: Alignment.center,
                                        margin: const EdgeInsets.only(
                                          bottom: 50,
                                          left: 45,
                                          right: 45,
                                        ),
                                        height: widthOfWholeScreen / 2.2,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(
                                                widthOfWholeScreen / 15),
                                          ),
                                          boxShadow: const [
                                            BoxShadow(
                                              color:
                                                  Color.fromARGB(25, 0, 0, 0),
                                              blurRadius: 20,
                                              offset: Offset(0, 11),
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    top: 10,
                                                    left: 30,
                                                  ),
                                                  child: Text(
                                                    alarmDataToShow[
                                                            indexOfContainers]
                                                        .name
                                                        .toString(),
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                      color:
                                                          const Color.fromARGB(
                                                              255, 7, 0, 196),
                                                      fontFamily:
                                                          'FredokaOne-Regular',
                                                      fontWeight:
                                                          FontWeight.w100,
                                                      fontSize:
                                                          widthOfWholeScreen /
                                                              16,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    top: 20,
                                                    right: 30,
                                                  ),
                                                  child: Text(
                                                    (() {
                                                      String days = "";
                                                      if (alarmDataToShow[
                                                              indexOfContainers]
                                                          .day
                                                          .toString()
                                                          .contains('1')) {
                                                        days = '$days${"Sa "}';
                                                      }
                                                      if (alarmDataToShow[
                                                              indexOfContainers]
                                                          .day
                                                          .toString()
                                                          .contains("2")) {
                                                        days = '$days${"Su "}';
                                                      }
                                                      if (alarmDataToShow[
                                                              indexOfContainers]
                                                          .day
                                                          .toString()
                                                          .contains("3")) {
                                                        days = '$days${"Mo "}';
                                                      }
                                                      if (alarmDataToShow[
                                                              indexOfContainers]
                                                          .day
                                                          .toString()
                                                          .contains("4")) {
                                                        days = '$days${"Tu "}';
                                                      }
                                                      if (alarmDataToShow[
                                                              indexOfContainers]
                                                          .day
                                                          .toString()
                                                          .contains("5")) {
                                                        days = '$days${"We "}';
                                                      }
                                                      if (alarmDataToShow[
                                                              indexOfContainers]
                                                          .day
                                                          .toString()
                                                          .contains("6")) {
                                                        days = '$days${"Th "}';
                                                      }
                                                      if (alarmDataToShow[
                                                              indexOfContainers]
                                                          .day
                                                          .toString()
                                                          .contains("7")) {
                                                        days = '$days${"Fr "}';
                                                      }

                                                      return days;
                                                    }()),
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                      color:
                                                          const Color.fromARGB(
                                                              255, 0, 163, 255),
                                                      fontFamily:
                                                          'FredokaOne-Regular',
                                                      fontWeight:
                                                          FontWeight.w100,
                                                      fontSize:
                                                          widthOfWholeScreen /
                                                              20,
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    top: 20,
                                                    right: 30,
                                                  ),
                                                  child: Transform.scale(
                                                    scale: 2,
                                                    child: Switch.adaptive(
                                                      value: alarmDataToShow[
                                                              indexOfContainers]
                                                          .isToggle,
                                                      onChanged: (value) {
                                                        storingTheIsToggle(
                                                          index:
                                                              indexOfContainers,
                                                          id: alarmDataToShow[
                                                                  indexOfContainers]
                                                              .id,
                                                          isTrunedOn: !value,
                                                        );
                                                      },
                                                      activeColor:
                                                          const Color.fromARGB(
                                                              255, 0, 163, 255),
                                                      activeTrackColor:
                                                          const Color.fromARGB(
                                                              255,
                                                              94,
                                                              196,
                                                              255),
                                                      inactiveThumbColor:
                                                          const Color.fromARGB(
                                                              255,
                                                              209,
                                                              209,
                                                              209),
                                                      inactiveTrackColor:
                                                          const Color.fromARGB(
                                                              255,
                                                              186,
                                                              186,
                                                              186),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    bottom: 9,
                                                    left: 30,
                                                  ),
                                                  child: Text(
                                                    "${alarmDataToShow[indexOfContainers].time}",
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                      color:
                                                          const Color.fromARGB(
                                                              255, 7, 0, 196),
                                                      fontFamily: 'Roboto-Bold',
                                                      fontWeight:
                                                          FontWeight.w100,
                                                      fontSize:
                                                          widthOfWholeScreen /
                                                              10,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  )
                                : Center(
                                    child: Text(
                                      "No alarms is created.",
                                      style: TextStyle(
                                        fontSize: widthOfWholeScreen / 30,
                                      ),
                                    ),
                                  ),
                          );
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: Color.fromARGB(255, 0, 106, 255),
                              strokeWidth: 3,
                            ),
                          );
                        }
                      },
                    ),
                    // World Clock
                    const Center(
                      child: Text(
                        "This Page is for World Clock",
                      ),
                    ),
                    // Stop watch
                    const Center(
                      child: Text(
                        "This Page is for Stopwatch",
                      ),
                    ),
                    // Timer
                    const Center(
                      child: Text(
                        "This Page is for Timer.",
                      ),
                    ),
                  ],
                ),
                // the stack of floating action buttons and text show of alaram
                Padding(
                  padding: EdgeInsets.only(
                    top: widthOfWholeScreen / 13,
                  ),
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          top: widthOfWholeScreen / 60,
                        ),
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: '1 hour remaining to the\n',
                            style: TextStyle(
                              fontSize: widthOfWholeScreen / 24,
                              color: const Color.fromARGB(255, 7, 0, 196),
                              fontFamily: 'FredokaOne-Regular',
                              height: 1.7,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: 'Work time',
                                style: TextStyle(
                                  fontSize: widthOfWholeScreen / 24,
                                  color: const Color.fromARGB(255, 0, 163, 255),
                                  fontFamily: 'FredokaOne-Regular',
                                  height: 1.7,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Upper floating action buttons
                      Container(
                        margin: EdgeInsets.only(
                          bottom: (heightOfWholeScreen - 24) / 1.1,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: widthOfWholeScreen / 7,
                              height: widthOfWholeScreen / 7,
                              child: FloatingActionButton(
                                heroTag: "LeftMenu",
                                onPressed: () {},
                                backgroundColor:
                                    const Color.fromARGB(255, 0, 122, 255),
                                child: Icon(
                                  Menu.menu,
                                  size: widthOfWholeScreen / 13.5,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: widthOfWholeScreen / 1.55,
                            ),
                            SizedBox(
                              width: widthOfWholeScreen / 7,
                              height: widthOfWholeScreen / 7,
                              child: FloatingActionButton(
                                heroTag: "AddFloatingActionButton",
                                onPressed: () {
                                  Navigator.of(contextOfWholeScreen)
                                      .push(slideTransition());
                                },
                                backgroundColor:
                                    const Color.fromARGB(255, 0, 122, 255),
                                child: Icon(
                                  Add.add,
                                  size: widthOfWholeScreen / 13.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // Bottom Navigation Bar
            Container(
              padding: const EdgeInsets.only(
                left: 11,
                right: 11,
              ),
              margin: const EdgeInsets.only(
                right: 25,
                left: 25,
                bottom: 50,
              ),
              alignment: Alignment.center,
              height: widthOfWholeScreen / 5.5,
              decoration: BoxDecoration(
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromARGB(45, 0, 0, 0),
                    offset: Offset(0, 20),
                    blurRadius: 40,
                  ),
                ],
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(widthOfWholeScreen),
                ),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton.icon(
                      icon: AnimatedCrossFade(
                        firstChild: Icon(
                          alarm_icon.Alarm.alarm,
                          color: const Color.fromARGB(255, 0, 0, 255),
                          size: widthOfWholeScreen / 12,
                        ),
                        secondChild: Icon(
                          alarm_icon.Alarm.alarm,
                          color: const Color.fromARGB(255, 140, 140, 140),
                          size: widthOfWholeScreen / 10,
                        ),
                        crossFadeState:
                            (currentTap == BottomNavigaionBarIndex.alarm)
                                ? CrossFadeState.showFirst
                                : CrossFadeState.showSecond,
                        duration: const Duration(
                          milliseconds: 500,
                        ),
                        firstCurve: Curves.decelerate,
                        secondCurve: Curves.decelerate,
                      ),
                      label: AnimatedCrossFade(
                        firstChild: Text(
                          "  Alarm",
                          style: TextStyle(
                            fontFamily: "FredokaOne-Regular",
                            color: const Color.fromARGB(255, 0, 0, 255),
                            fontSize: widthOfWholeScreen / 21,
                          ),
                        ),
                        secondChild: const Text(
                          "",
                          style: TextStyle(
                            fontFamily: "FredokaOne-Regular",
                            color: Color.fromARGB(255, 0, 0, 255),
                          ),
                        ),
                        crossFadeState:
                            (currentTap == BottomNavigaionBarIndex.alarm)
                                ? CrossFadeState.showFirst
                                : CrossFadeState.showSecond,
                        duration: const Duration(
                          milliseconds: 500,
                        ),
                        firstCurve: Curves.decelerate,
                        secondCurve: Curves.decelerate,
                      ),
                      // iconSize: widthOfWholeScreen / 10,
                      onPressed: () {
                        setState(() {
                          currentTap = BottomNavigaionBarIndex.alarm;

                          bottomNavigationBarNumber = 0;

                          controller.animateToPage(
                            bottomNavigationBarNumber,
                            duration: const Duration(
                              milliseconds: 1000,
                            ),
                            curve: Curves.elasticOut,
                          );
                        });
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(widthOfWholeScreen),
                        ),
                      ),
                    ),
                    TextButton.icon(
                      icon: AnimatedCrossFade(
                        firstChild: Icon(
                          WorldClock.worldClock,
                          color: const Color.fromARGB(255, 0, 0, 255),
                          size: widthOfWholeScreen / 12,
                        ),
                        secondChild: Icon(
                          WorldClock.worldClock,
                          color: const Color.fromARGB(255, 140, 140, 140),
                          size: widthOfWholeScreen / 10,
                        ),
                        crossFadeState:
                            (currentTap == BottomNavigaionBarIndex.worldClock)
                                ? CrossFadeState.showFirst
                                : CrossFadeState.showSecond,
                        duration: const Duration(
                          milliseconds: 500,
                        ),
                        firstCurve: Curves.decelerate,
                        secondCurve: Curves.decelerate,
                      ),
                      label: AnimatedCrossFade(
                        firstChild: Text(
                          " World Clock",
                          style: TextStyle(
                            fontFamily: "FredokaOne-Regular",
                            color: const Color.fromARGB(255, 0, 0, 255),
                            fontSize: widthOfWholeScreen / 21,
                          ),
                        ),
                        secondChild: const Text(
                          "",
                          style: TextStyle(
                            fontFamily: "FredokaOne-Regular",
                            color: Color.fromARGB(255, 0, 0, 255),
                          ),
                        ),
                        crossFadeState:
                            (currentTap == BottomNavigaionBarIndex.worldClock)
                                ? CrossFadeState.showFirst
                                : CrossFadeState.showSecond,
                        duration: const Duration(
                          milliseconds: 500,
                        ),
                        firstCurve: Curves.decelerate,
                        secondCurve: Curves.decelerate,
                      ),
                      // iconSize: widthOfWholeScreen / 10,
                      onPressed: () {
                        setState(() {
                          currentTap = BottomNavigaionBarIndex.worldClock;

                          bottomNavigationBarNumber = 1;

                          controller.animateToPage(
                            bottomNavigationBarNumber,
                            duration: const Duration(
                              milliseconds: 1000,
                            ),
                            curve: Curves.elasticOut,
                          );
                        });
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(widthOfWholeScreen),
                        ),
                      ),
                    ),
                    TextButton.icon(
                      icon: AnimatedCrossFade(
                        firstChild: FittedBox(
                          child: Icon(
                            Stopwatch.stopwatch,
                            color: const Color.fromARGB(255, 0, 0, 255),
                            size: widthOfWholeScreen / 12,
                          ),
                        ),
                        secondChild: Icon(
                          Stopwatch.stopwatch,
                          color: const Color.fromARGB(255, 140, 140, 140),
                          size: widthOfWholeScreen / 10,
                        ),
                        crossFadeState:
                            (currentTap == BottomNavigaionBarIndex.stopwatch)
                                ? CrossFadeState.showFirst
                                : CrossFadeState.showSecond,
                        duration: const Duration(
                          milliseconds: 500,
                        ),
                        firstCurve: Curves.decelerate,
                        secondCurve: Curves.decelerate,
                      ),
                      label: AnimatedCrossFade(
                        firstChild: Text(
                          "  Stopwatch",
                          style: TextStyle(
                            fontFamily: "FredokaOne-Regular",
                            color: const Color.fromARGB(255, 0, 0, 255),
                            fontSize: widthOfWholeScreen / 21,
                          ),
                        ),
                        secondChild: const Text(
                          "",
                          style: TextStyle(
                            fontFamily: "FredokaOne-Regular",
                            color: Color.fromARGB(255, 0, 0, 255),
                          ),
                        ),
                        crossFadeState:
                            (currentTap == BottomNavigaionBarIndex.stopwatch)
                                ? CrossFadeState.showFirst
                                : CrossFadeState.showSecond,
                        duration: const Duration(
                          milliseconds: 500,
                        ),
                        firstCurve: Curves.decelerate,
                        secondCurve: Curves.decelerate,
                      ),
                      // iconSize: widthOfWholeScreen / 10,
                      onPressed: () {
                        setState(() {
                          currentTap = BottomNavigaionBarIndex.stopwatch;

                          bottomNavigationBarNumber = 2;

                          controller.animateToPage(
                            bottomNavigationBarNumber,
                            duration: const Duration(
                              milliseconds: 1000,
                            ),
                            curve: Curves.elasticOut,
                          );
                        });
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(widthOfWholeScreen),
                        ),
                      ),
                    ),
                    TextButton.icon(
                      icon: AnimatedCrossFade(
                        firstChild: Icon(
                          Timer.timer,
                          color: const Color.fromARGB(255, 0, 0, 255),
                          size: widthOfWholeScreen / 12,
                        ),
                        secondChild: Icon(
                          Timer.timer,
                          color: const Color.fromARGB(255, 140, 140, 140),
                          size: widthOfWholeScreen / 10,
                        ),
                        crossFadeState:
                            (currentTap == BottomNavigaionBarIndex.timer)
                                ? CrossFadeState.showFirst
                                : CrossFadeState.showSecond,
                        duration: const Duration(
                          milliseconds: 500,
                        ),
                        firstCurve: Curves.decelerate,
                        secondCurve: Curves.decelerate,
                      ),
                      label: AnimatedCrossFade(
                        firstChild: Text(
                          "Timer",
                          style: TextStyle(
                            fontFamily: "FredokaOne-Regular",
                            color: const Color.fromARGB(255, 0, 0, 255),
                            fontSize: widthOfWholeScreen / 21,
                          ),
                        ),
                        secondChild: const Text(
                          "",
                          style: TextStyle(
                            fontFamily: "FredokaOne-Regular",
                            color: Color.fromARGB(255, 0, 0, 255),
                          ),
                        ),
                        crossFadeState:
                            (currentTap == BottomNavigaionBarIndex.timer)
                                ? CrossFadeState.showFirst
                                : CrossFadeState.showSecond,
                        duration: const Duration(
                          milliseconds: 500,
                        ),
                        firstCurve: Curves.decelerate,
                        secondCurve: Curves.decelerate,
                      ),
                      // iconSize: widthOfWholeScreen / 10,
                      onPressed: () {
                        setState(() {
                          currentTap = BottomNavigaionBarIndex.timer;

                          bottomNavigationBarNumber = 3;

                          controller.animateToPage(
                            bottomNavigationBarNumber,
                            duration: const Duration(
                              milliseconds: 1000,
                            ),
                            curve: Curves.elasticOut,
                          );
                        });
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(widthOfWholeScreen),
                        ),
                      ),
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

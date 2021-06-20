import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:meeting_timer/picker.dart';
import 'package:meeting_timer/timer.dart';
import 'package:page_transition/page_transition.dart';
import 'customPageRoute.dart';
import 'display.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meeting Timer',
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late DateTime now;

  late int currentAmPmIndex;
  late List<PickerItem<String>> amPmPickerOptions;
  late ValueNotifier<bool> isAm = new ValueNotifier(false);

  late int currentHourIndex;
  late List<PickerItem<String>> hourPickerOptions;
  late ValueNotifier<int> hourPicked = new ValueNotifier(0);

  late int currentMinuteIndex;
  late List<PickerItem<String>> minutePickerOptions;
  late ValueNotifier<int> minutePicked = new ValueNotifier(0);

  @override
  void initState() {
    //layout the options
    amPmPickerOptions = [
      PickerItem(value: "AM"),
      PickerItem(value: "PM"),
    ];
    hourPickerOptions = getPickerItemListOfNumber(
      1,
      12,
    );
    minutePickerOptions = getPickerItemListOfNumber(
      0,
      59,
    );

    //select an option based on the current time
    now = DateTime.now();
    int hour0To23 = now.hour;
    currentAmPmIndex = (hour0To23 < 12) ? 0 : 1;
    isAm.value = currentAmPmIndex == 0;

    //conver to normal time
    int hour1To12;
    if (hour0To23 == 0) {
      hour1To12 = 12;
    } else if (hour0To23 > 13) {
      hour1To12 = hour0To23 - 12;
    } else {
      hour1To12 = hour0To23;
    }
    //1 to 12 is 1 based, current hour is 0 based
    currentHourIndex = hour1To12 - 1;
    hourPicked.value = hour1To12;

    //minutes are 0 to 59, 0 based index
    currentMinuteIndex = now.minute;
    minutePicked.value = currentMinuteIndex;

    //start up tries to help them picker their deadline
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double itemExtent = 48;
    double height = itemExtent * 2;
    double fontSize = itemExtent / 2;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(
                color: Colors.black,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(24),
                    ),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 24,
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            bottom: 16,
                          ),
                          child: Text(
                            "Select Deadline",
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: MyPicker(
                                selected: hourPicked,
                                selectedOption: currentHourIndex,
                                options: hourPickerOptions,
                                looping: true,
                                itemExtent: itemExtent,
                                fontSize: fontSize,
                                height: height,
                              ),
                            ),
                            Text(
                              ":",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 46,
                                color: Colors.black,
                              ),
                            ),
                            Expanded(
                              child: MyPicker(
                                selected: minutePicked,
                                selectedOption: currentMinuteIndex,
                                options: minutePickerOptions,
                                itemExtent: itemExtent,
                                fontSize: fontSize,
                                height: height,
                              ),
                            ),
                            Expanded(
                              child: MyPicker(
                                selected: isAm,
                                selectedOption: currentAmPmIndex,
                                options: amPmPickerOptions,
                                itemExtent: itemExtent,
                                fontSize: fontSize,
                                height: height,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Container(
              color: Colors.black,
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 16,
                ),
                child: StartTimer(
                  isAm: isAm,
                  hourPicked: hourPicked,
                  minutePicked: minutePicked,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StartTimer extends StatefulWidget {
  const StartTimer({
    Key? key,
    required this.isAm,
    required this.hourPicked,
    required this.minutePicked,
  }) : super(key: key);

  final ValueNotifier<bool> isAm;
  final ValueNotifier<int> hourPicked;
  final ValueNotifier<int> minutePicked;

  @override
  _StartTimerState createState() => _StartTimerState();
}

class _StartTimerState extends State<StartTimer> {
  updateState() {
    if (mounted) {
      setState(() {});
    }
  }

  automaticReload() async {
    await Future.delayed(
      Duration(milliseconds: 50),
    );

    if (mounted) {
      setState(() {});
      automaticReload();
    }
  }

  @override
  void initState() {
    widget.isAm.addListener(updateState);
    widget.hourPicked.addListener(updateState);
    widget.minutePicked.addListener(updateState);
    automaticReload();
    super.initState();
  }

  @override
  void dispose() {
    widget.isAm.removeListener(updateState);
    widget.hourPicked.removeListener(updateState);
    widget.minutePicked.removeListener(updateState);
    super.dispose();
  }

  intToString(int value, String label) {
    String? string;
    if (value > 0) {
      string = value.toString() + label + ((value != 1) ? "s" : "");
    }
    return string;
  }

  @override
  Widget build(BuildContext context) {
    //the timer will run from now... to the time we selected
    DateTime now = DateTime.now();
    int thisHour = now.hour;
    int thisMinute = now.minute;
    int thisSecond = now.second;

    //adjust hour back to 0To23
    int finalHour = widget.hourPicked.value;
    //0 | 1->12 | 13 -> 23
    if (finalHour == 12) {
      if (widget.isAm.value) {
        finalHour = 0;
      }
    } else {
      if (widget.isAm.value == false) {
        finalHour += 12;
      }
    }
    //minutes and seconds are easy
    int finalMinute = widget.minutePicked.value;
    int finalSecond = 0;

    //timer hours...
    DateTime thisTime = DateTime(1, 1, 1, thisHour, thisMinute, thisSecond);
    DateTime finalTime = DateTime(1, 1, 1, finalHour, finalMinute, finalSecond);
    Duration difference = finalTime.difference(thisTime);
    if (finalTime.isBefore(thisTime)) {
      difference = Duration(hours: 24) - difference.abs();
    }

    //print as one might expect
    return Material(
      elevation: 8,
      borderRadius: BorderRadius.circular(24),
      color: Colors.green,
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushReplacement(
            VerticalSlidePageTransition(
              animateDown: false,
              childCurrent: Home(),
              child: Theme(
                data: ThemeData.dark(),
                child: Timer(
                  deadline: widget.hourPicked.value.toString() +
                      ":" +
                      intToDoubleDigit(widget.minutePicked.value) +
                      " " +
                      (widget.isAm.value ? "AM" : "PM"),
                  timerDuration: difference,
                ),
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(24),
        child: Container(
          height: 56,
          child: Center(
            child: DefaultTextStyle(
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      right: 16,
                    ),
                    child: Text("Start"),
                  ),
                  MyTimerDisplay(
                    duration: difference,
                    textColor: Colors.white,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: 16,
                    ),
                    child: Text("Timer"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

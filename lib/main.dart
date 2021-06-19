import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:meeting_timer/picker.dart';

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
                  horizontal: 8,
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
    print("auto reload soon");
    await Future.delayed(
      Duration(milliseconds: 50),
    );

    print("reload");
    if (mounted) {
      print("ctn");
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

  getDurationDescription(Duration duration) {
    int hours = duration.inHours;

    //adjust minutes
    int minutes = duration.inMinutes % 60;

    //adjust seconds
    int seconds = duration.inSeconds - (minutes * 60) - (hours * 3600);

    //convert
    String? hoursString = intToString(hours, "h");
    String? minutesString = intToString(minutes, "m");
    String? secondsString = intToString(seconds, "s");

    //add spaces where they are required

    //none of them are null
    if (hoursString != null && minutesString != null && secondsString != null) {
      return hoursString + ", " + minutesString + " and " + secondsString;
    } else {
      //all of them are null
      if (hoursString == null &&
          minutesString == null &&
          secondsString == null) {
        return "00:00:00";
      } else {
        //one of them IS NULL
        if (hoursString == null &&
            minutesString != null &&
            secondsString != null) {
          //hours is null
          return minutesString + " and " + secondsString;
        } else if (hoursString != null &&
            minutesString == null &&
            secondsString != null) {
          //minutes is null
          return hoursString + " and " + secondsString;
        } else if (hoursString != null &&
            minutesString != null &&
            secondsString == null) {
          //seconds is null
          return hoursString + " and " + minutesString;
        } else {
          //one of them IS NOT NULL
          return (hoursString ?? "") +
              (minutesString ?? "") +
              (secondsString ?? "");
        }
      }
    }
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
    print("final hour: " + finalHour.toString());
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

    print("THIS hour: " +
        thisHour.toString() +
        " minute: " +
        thisMinute.toString() +
        " second: " +
        thisSecond.toString());

    print("FINAL hour: " +
        finalHour.toString() +
        " minute: " +
        finalMinute.toString() +
        " second: " +
        finalSecond.toString());

    Duration difference = finalTime.difference(thisTime);
    print("dif: " + difference.toString());
    if (finalTime.isBefore(thisTime)) {
      difference = Duration(hours: 24) - difference.abs();
    }
    print("aff: " + difference.toString());

    //print as one might expect
    return Material(
      elevation: 8,
      borderRadius: BorderRadius.circular(56),
      color: Colors.green,
      child: InkWell(
        onTap: () {},
        child: Container(
          height: 56,
          child: Center(
            child: Text(
              "Start " + getDurationDescription(difference) + " Timer",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

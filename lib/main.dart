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
  late int currentAmPmIndex;
  late List<PickerItem<String>> amPmPickerOptions;

  late int currentHourIndex;
  late List<PickerItem<String>> hourPickerOptions;

  late int currentMinuteIndex;
  late List<PickerItem<String>> minutePickerOptions;

  late int currentSecond;
  late List<PickerItem<String>> secondPickerOptions;

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
    secondPickerOptions = getPickerItemListOfNumber(
      0,
      45,
      increments: 15,
    );

    //select an option based on the current time
    DateTime now = DateTime.now();
    int hour0To23 = now.hour;
    currentAmPmIndex = (hour0To23 < 12) ? 0 : 1;

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

    //minutes are 0 to 59, 0 based index
    currentMinuteIndex = now.minute;

    //0:0, 1:15, 2:30, 3:45, 4
    int rawSecondsIndex = 0; //now.second ~/ 15;
    currentSecond = rawSecondsIndex;

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
                        Container(
                          padding: EdgeInsets.only(
                            bottom: 16,
                          ),
                          child: Text(
                            "Select Deadline",
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 36,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: MyPicker(
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
                                selectedOption: currentMinuteIndex,
                                options: minutePickerOptions,
                                itemExtent: itemExtent,
                                fontSize: fontSize,
                                height: height,
                              ),
                            ),
                            /*
                            Text(
                              ",",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 46,
                                color: Colors.black,
                              ),
                            ),
                            Expanded(
                              child: MyPicker(
                                selectedOption: currentSecond,
                                options: secondPickerOptions,
                                itemExtent: itemExtent,
                                fontSize: fontSize,
                                height: height,
                              ),
                            ),
                            */
                            Expanded(
                              child: MyPicker(
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
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 8,
                ),
                child: Material(
                  elevation: 8,
                  borderRadius: BorderRadius.circular(56),
                  color: Colors.green,
                  child: InkWell(
                    onTap: () {},
                    child: Container(
                      height: 56,
                      child: Center(
                        child: Text(
                          "Start 00:00 Timer",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

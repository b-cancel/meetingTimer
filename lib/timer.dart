import 'package:flutter/material.dart';
import 'package:meeting_timer/display.dart';

import 'customPageRoute.dart';
import 'main.dart';

class Timer extends StatefulWidget {
  const Timer({
    required this.deadline,
    required this.timerDuration,
    Key? key,
  }) : super(key: key);

  final String deadline;
  final Duration timerDuration;

  @override
  _TimerState createState() => _TimerState();
}

class _TimerState extends State<Timer> {
  late DateTime timerStarted;
  late DateTime calculatedDeadline;

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
    timerStarted = DateTime.now();
    calculatedDeadline = timerStarted.add(widget.timerDuration);
    automaticReload();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    double screenWidth = MediaQuery.of(context).size.width;

    //calc max
    double screenHeight = MediaQuery.of(context).size.height;
    double toolbarHeight = MediaQuery.of(context).padding.top;
    double buttonAndPaddingHeight = 56 + (16 * 2);
    double maxHeight = screenHeight - toolbarHeight - buttonAndPaddingHeight;

    //determine if negative
    Duration passedTime = calculatedDeadline.difference(now);
    Duration passedTimeAbs = passedTime.abs();
    bool isNeg = passedTime != passedTimeAbs;

    //determine heights
    num positiveHeight;
    Duration totalTime = calculatedDeadline.difference(timerStarted);
    num ratio = passedTimeAbs.inMicroseconds / totalTime.inMicroseconds;
    num negativeHeight = (ratio * maxHeight);
    positiveHeight = maxHeight - negativeHeight;

    //build
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(
                color: Colors.black,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Stack(
                    children: [
                      //blue is on bottom
                      Positioned.fill(
                        child: Container(
                          color: Colors.blue,
                          width: screenWidth,
                        ),
                      ),
                      //black grows from bottom until it fills creen
                      Positioned(
                        bottom: 0,
                        child: Container(
                          height: isNeg ? maxHeight : positiveHeight.toDouble(),
                          color: ThemeData.dark().primaryColor,
                          width: screenWidth,
                        ),
                      ),
                      //start filling in from the top
                      Positioned(
                        top: 0,
                        child: Visibility(
                          visible: isNeg,
                          child: Container(
                            color: Colors.red,
                            height: (negativeHeight > maxHeight)
                                ? maxHeight
                                : negativeHeight.toDouble(),
                            width: screenWidth,
                          ),
                        ),
                      ),
                      //the timer on top of everything
                      Positioned.fill(
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.all(24),
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child: MyTimerDisplay(
                              duration: passedTimeAbs,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              color: Colors.black,
              padding: EdgeInsets.symmetric(
                vertical: 16,
              ),
              child: Theme(
                data: ThemeData.light(),
                child: GoBack(
                  timerDuration: widget.timerDuration,
                  deadline: widget.deadline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GoBack extends StatelessWidget {
  const GoBack({
    required this.deadline,
    required this.timerDuration,
    Key? key,
  }) : super(key: key);

  final String deadline;
  final Duration timerDuration;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 8,
      borderRadius: BorderRadius.circular(24),
      color: Colors.white,
      child: InkWell(
        onLongPress: () {
          Navigator.of(context).pushReplacement(
            VerticalSlidePageTransition(
              animateDown: true,
              childCurrent: Timer(
                timerDuration: timerDuration,
                deadline: deadline,
              ),
              child: Theme(
                data: ThemeData.light(),
                child: Home(),
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(24),
        child: Container(
          height: 56,
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Long Press To Change"),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 6,
                  ),
                  child: Text(
                    deadline,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text("Deadline")
              ],
            ),
          ),
        ),
      ),
    );
  }
}

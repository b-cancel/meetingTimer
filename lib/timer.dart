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
  late DateTime caculatedDeadline;

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
    caculatedDeadline = timerStarted.add(widget.timerDuration);
    automaticReload();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Duration duration = caculatedDeadline.difference(DateTime.now());
    Duration durationAbs = duration.abs();
    bool isNeg = duration != durationAbs;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              color: isNeg == false ? Colors.blue : Colors.red,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(24),
              child: FittedBox(
                fit: BoxFit.contain,
                child: MyTimerDisplay(
                  duration: durationAbs,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
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
      borderRadius: BorderRadius.circular(56),
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
        borderRadius: BorderRadius.circular(56),
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

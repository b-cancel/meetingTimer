import 'package:flutter/material.dart';

intToDoubleDigit(int value) {
  String init = value.toString();
  if (init.length == 1) {
    return "0" + init;
  } else {
    return init;
  }
}

List<String> getDurationDescription(Duration duration) {
  int hours = duration.inHours;

  //adjust minutes
  int minutes = duration.inMinutes % 60;

  //adjust seconds
  int seconds = duration.inSeconds - (minutes * 60) - (hours * 3600);

  //convert
  String hoursString = intToDoubleDigit(hours);
  String minutesString = intToDoubleDigit(minutes);
  String secondsString = intToDoubleDigit(seconds);

  //ship it all
  return [hoursString, minutesString, secondsString];
}

class MyTimerDisplay extends StatelessWidget {
  const MyTimerDisplay({
    Key? key,
    required this.duration,
  }) : super(key: key);

  final Duration duration;

  @override
  Widget build(BuildContext context) {
    List<String> durationSplit = getDurationDescription(duration);
    return DefaultTextStyle(
      style: TextStyle(
        fontWeight: FontWeight.bold,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Visibility(
            visible: durationSplit[0] != "00",
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                DurationColumn(
                  duration: durationSplit[0],
                  label: "HR",
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 4,
                  ),
                  child: Transform.translate(
                    offset: Offset(0, -3),
                    child: Text(
                      ":",
                      style: TextStyle(
                        fontSize: 48,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          DurationColumn(
            duration: durationSplit[1],
            label: "MIN",
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 4,
            ),
            child: Transform.translate(
              offset: Offset(0, -3),
              child: Text(
                ":",
                style: TextStyle(
                  fontSize: 48,
                ),
              ),
            ),
          ),
          DurationColumn(
            duration: durationSplit[2],
            label: "SEC",
          ),
        ],
      ),
    );
  }
}

class DurationColumn extends StatelessWidget {
  const DurationColumn({
    required this.duration,
    required this.label,
    Key? key,
  }) : super(key: key);

  final String duration;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          duration,
          style: TextStyle(
            fontSize: 22,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

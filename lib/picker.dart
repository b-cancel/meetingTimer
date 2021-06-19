import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';

List<PickerItem<String>> getPickerItemListOfNumber(
  int fromInclusive,
  int toInclusive, {
  int increments: 1,
}) {
  List<PickerItem<String>> pickerItems = [];
  for (int i = fromInclusive; i <= toInclusive; i += increments) {
    pickerItems.add(
      PickerItem(value: i.toString()),
    );
  }
  return pickerItems;
}

class MyPicker extends StatelessWidget {
  const MyPicker({
    required this.options,
    required this.selectedOption,
    this.looping: false,
    required this.itemExtent,
    required this.height,
    required this.fontSize,
    Key? key,
  }) : super(key: key);

  final List<PickerItem<String>> options;
  final int selectedOption;
  final bool looping;
  final double itemExtent;
  final double fontSize;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Picker(
      //cancel and confirm button not required
      hideHeader: true,
      //resets
      backgroundColor: Colors.transparent,
      containerColor: Colors.transparent,
      columnPadding: EdgeInsets.all(0),
      //options
      looping: looping,
      //entire widget height
      height: height,
      //height of selected
      itemExtent: itemExtent,
      //extra on top of already passed sizes
      textScaleFactor: 1,
      selectionOverlay: CupertinoPickerDefaultSelectionOverlay(),
      textStyle: TextStyle(
        color: Colors.black,
        fontSize: fontSize,
      ),
      selectedTextStyle: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: fontSize,
      ),
      //basics
      selecteds: [selectedOption],
      adapter: PickerDataAdapter<String>(
        data: options,
      ),
      onSelect: (Picker picker, int index, List<int> ints) {
        /*
        //haptics
        Vibrator.vibrateOnce(
          duration: Duration(milliseconds: 250),
        );

        //grab minutes and seconds
        List selections = picker.getSelectedValues();
        int newMinutes = int.parse(selections[0]);
        int newSeconds = int.parse(selections[1]);

        //seconds affects minutes
        minutesSeconds = separateMinutesAndSeconds(widget.duration.value);

        //update duration
        widget.duration.value = Duration(
          minutes: newMinutes, 
          seconds: newSeconds,
        );
        */
      },
    ).makePicker();
  }
}

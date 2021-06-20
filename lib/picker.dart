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
    required this.selected,
    Key? key,
  }) : super(key: key);

  final List<PickerItem<String>> options;
  final int selectedOption;
  final bool looping;
  final double itemExtent;
  final double fontSize;
  final double height;
  final ValueNotifier selected;

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
        print("index: " + index.toString());
        List selections = picker.getSelectedValues();
        int newIntValue = int.tryParse(selections[0]) ?? -1;
        if (newIntValue != -1) {
          selected.value = newIntValue;
        } else {
          if (selections[0] == "AM") {
            selected.value = true;
          } else {
            selected.value = false;
          }
        }
      },
    ).makePicker();
  }
}

import 'package:flutter/material.dart';

class LeaveStatusDropdown extends StatelessWidget {
  final String dropdownValue;
  final List dropdownList;
  final Function(String?) onChange;

  const LeaveStatusDropdown(
      {super.key,
      required this.dropdownValue,
      required this.dropdownList,
      required this.onChange});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      child: DropdownButton(
        isExpanded: true,
        value: dropdownValue,
        onChanged: onChange,
        items: dropdownList.map((value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Center(child: Text(value)),
          );
        }).toList(),
      ),
    );
  }
}

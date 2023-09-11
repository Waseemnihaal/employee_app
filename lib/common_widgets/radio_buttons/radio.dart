import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class RadioButton extends StatelessWidget {
  int value, type;
  final String title;
  final Function(int?) onChanged;

  RadioButton(
      {required this.value,
      required this.type,
      required this.title,
      required this.onChanged});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 45.w,
      child: RadioListTile(
        value: value,
        groupValue: type,
        onChanged: onChanged,
        title: Text('${title}'),
      ),
    );
  }
}


// class RadioButton extends StatefulWidget {
//   int value, type;
//   final String title;

//   RadioButton({required this.value, required this.type, required this.title});

//   @override
//   State<RadioButton> createState() => _RadioButtonState();
// }

// class _RadioButtonState extends State<RadioButton> {
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: 45.w,
//       child: RadioListTile(
//         value: 2,
//         groupValue: widget.type,
//         onChanged: (value) {
//           setState(() {
//             widget.type = value!;
//           });
//         },
//         title: Text('${widget.title}'),
//       ),
//     );
//   }
// }

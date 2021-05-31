// import 'package:flutter/material.dart';


// class DropDownList extends StatefulWidget {
//   DropDownList({
//     Key key,
//     this.chapters,
//   }) : super(key: key);
//   List chapters = [];
//   @override
//   _DropDownListState createState() => _DropDownListState();
// }

// class _DropDownListState extends State<DropDownList> {
//   String dropdownValue = 'Chương 1:...';
//   @override
//   Widget build(BuildContext context) {
//     return DropdownButton<String>(
//       isExpanded: true,
//       value: dropdownValue,
//       icon: Icon(Icons.arrow_drop_down),
//       iconSize: 24,
//       elevation: 16,
//       style: TextStyle(color: Colors.deepPurple),
//       underline: Container(
//         height: 2,
//         color: Colors.deepPurpleAccent,
//       ),
//       onChanged: (String newValue) {
//         setState(() {
//           dropdownValue = newValue;
//         });
//       },
//       items: <String>['Chương 1:...', 'Chương 2:...', 'Chương 3:...', 'Chương 4:...']
//           .map<DropdownMenuItem<String>>((String value) {
//         return DropdownMenuItem<String>(
//           value: value,
//           child: Text(value),
//         );
//       }).toList(),
//     );
//   }
// }
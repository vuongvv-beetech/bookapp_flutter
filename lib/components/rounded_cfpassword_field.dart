import 'package:flutter/material.dart';
import 'package:book_app/components/text_field_container.dart';
import 'package:book_app/consttants.dart';

class RoundedCfPasswordField extends StatelessWidget {
  final ValueChanged<String> onChanged;
  const RoundedCfPasswordField({
    Key key,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        obscureText: true,
        onChanged: onChanged,
        cursorColor: kPrimaryColor,
        decoration: InputDecoration(
          hintText: "Confirm Password",
          icon: Icon(
            Icons.lock_outline,
            color: kPrimaryColor,
          ),
          suffixIcon: Icon(
            Icons.visibility,
            color: kPrimaryColor,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class EditText extends StatelessWidget {
  final TextEditingController controller;
  final FormFieldSetter<String> onSaved;
  final TextInputType keyboardType;
  final String errorText;
  final String labelText;
  final FocusNode focusNode;
  final bool obscureText;
  EditText(
      {this.focusNode,
      this.controller,
      this.onSaved,
      this.keyboardType,
      this.errorText,
      this.labelText,
      this.obscureText = false});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        focusNode: focusNode,
        controller: controller,
        obscureText: obscureText,
        onSaved: onSaved,
        keyboardType: keyboardType,
        validator: (e) {
          if (e.isEmpty) {
            return errorText;
          }
        },
        decoration: InputDecoration(
            labelText: labelText,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(16.0))),
      ),
    );
  }
}

class ButtonClick extends StatelessWidget {
  final VoidCallback onPressed;
  final String labelText;
  ButtonClick({this.onPressed, this.labelText});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(20.0),
        child: MaterialButton(
          onPressed: onPressed,
          color: Colors.blue,
          height: 50.0,
          child: Text(
            labelText,
            style: TextStyle(color: Colors.white, fontSize: 16.0),
          ),
        ),
      ),
    );
  }
}

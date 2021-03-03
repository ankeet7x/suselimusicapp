import 'package:flutter/material.dart';

class StyledTf extends StatelessWidget {
  final TextEditingController getController;
  final String hintText;
  final String artistN;
  final String labelText;
  // final TextEditingController _
  StyledTf({this.getController, this.hintText, this.artistN, this.labelText});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        height: size.height * 0.06,
        width: size.width * 0.89,
        // color: Colors.blue,
        decoration: BoxDecoration(
            color: Color(0xFF03C6C7), borderRadius: BorderRadius.circular(12)),
        child: TextFormField(
          controller: getController,
          validator: (val) =>
              val.length < 3 ? "Check if this textfield is valid" : null,
          decoration: InputDecoration(
            disabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            border: InputBorder.none,
            // prefixIcon: Icon(Icons.title),
            hintStyle: TextStyle(color: Colors.white),
            counterStyle: TextStyle(color: Colors.blue),
            helperStyle: TextStyle(color: Colors.blue),
            prefixStyle: TextStyle(color: Colors.blue),
            labelStyle: TextStyle(color: Colors.white),
            contentPadding: EdgeInsets.fromLTRB(10, 6, 0, 0),
            hintText: hintText,
            labelText: labelText,
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class TextWid extends StatelessWidget {
  final String value;
  final FontWeight fontWeight;
  final double fontSize;
  TextWid({this.value,this.fontSize, this.fontWeight});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Row(children: [
      SizedBox(width:size.width*0.12),
      Text(value,
      style: TextStyle(
        color: Colors.black,
        fontWeight: fontWeight,
        fontSize: fontSize,
      ),
      ),
    ]);
  }
}

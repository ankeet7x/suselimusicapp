import 'package:flutter/material.dart';

class StyledTf extends StatelessWidget {
  final TextEditingController getController;
  final double providedHeight;
  final String hintText;
  final int maxLines;
  final String artistN;
  final String labelText;
  // final TextEditingController _
  StyledTf({this.getController,this.maxLines, this.providedHeight, this.hintText, this.artistN, this.labelText});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Column(
          children: [
            SizedBox(height: size.height*0.009),
            Row(
              children: [
                SizedBox(width: size.width*0.05),
                Container(child: Text(hintText, style: TextStyle(
                  color: Color(0xFF5654B4),
                  fontSize: 18
                ),),),
                Container(child: Text("*", style: TextStyle(
                  color: Color(0xFFFF0000),
                  fontSize: 18
                ),),),
                Container()
              ],
            ),
            Container(
              height: providedHeight,
              width: size.width * 0.89,
              // color: Colors.blue,
              decoration: BoxDecoration(
                border: Border.all(width:1, color: Color(0xFF5654B4)),
                  color: Colors.white, borderRadius: BorderRadius.circular(8)),
              child: TextFormField(
                maxLines: maxLines,
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
                  // labelStyle: TextStyle(color: Colors.white),
                  contentPadding: EdgeInsets.fromLTRB(10, 6, 0, 0),
                  // hintText: hintText,
                  // labelText: labelText,
                ),
              ),
            ),
          ],
        ),
    
    );
  }
}

import 'package:flutter/material.dart';


class ProfileButton extends StatelessWidget {
  final onPressed;
  ProfileButton({this.onPressed});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: size.height*0.03,
        decoration: BoxDecoration(
          color: Color(0xFF480CA8),
          borderRadius: BorderRadius.circular(7)
        ),
        child: Text("Edit Profile"),
      ),
      
    );
  }
}
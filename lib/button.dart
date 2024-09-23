import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  Button({
    required this.text,
    required this.onPressed,
    required this.state,
    Key? key,
  }) : super(key: key);
  String text;
  VoidCallback onPressed;
  final bool state;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: state ? const Color(0XFFFFD369) : const Color(0XFF393E46),
          shape: BoxShape.circle,
        ),
        height: 125,
        width: 125,
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
                color: Color(0XFFEEEEEE), //393E46
                fontSize: 30,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

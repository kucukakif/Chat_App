import 'package:flutter/material.dart';

import '../utils/colors.dart';

class LoginButton extends StatelessWidget {
  final VoidCallback function;
  final IconData icon;
  final double size;
  const LoginButton({
    super.key,
    required this.width,
    required this.height,
    required this.function,
    required this.icon,
    required this.size,
  });

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width * .27,
      height: height * .08,
      child: IconButton(
        onPressed: function,
        icon: Icon(
          icon,
          color: myWhite,
          size: size,
        ),
        style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll<Color>(myBlack),
            shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ))),
      ),
    );
  }
}

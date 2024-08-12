import 'package:flutter/material.dart';

class LeftWidget extends StatefulWidget {
  final String message;
  final String date;
  final int length;
  const LeftWidget(
      {super.key,
      required this.message,
      required this.date,
      required this.length});

  @override
  State<LeftWidget> createState() => _LeftWidgetState();
}

class _LeftWidgetState extends State<LeftWidget> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double right = width * .5;
    double heightValue = height * .055;
    if (widget.length > 15 && widget.length <= 26) {
      setState(() {
        right = width * .25;
      });
    } else if (widget.length > 26 && widget.length < 40) {
      setState(() {
        right = width * .05;
      });
    } else if (widget.length > 40) {
      setState(() {
        right = width * .05;
        heightValue = height * .11;
      });
    }
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
      margin: EdgeInsets.only(left: 10, top: width * .02, right: right),
      height: heightValue,
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.message,
            style: const TextStyle(
              fontSize: 18,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                widget.date,
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.bold),
              ),
            ],
          )
        ],
      ),
    );
  }
}

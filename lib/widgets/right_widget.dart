import 'package:flutter/material.dart';

class RightWidget extends StatefulWidget {
  final String message;
  final String date;
  final int length;
  const RightWidget(
      {super.key,
      required this.message,
      required this.date,
      required this.length});

  @override
  State<RightWidget> createState() => _RightWidgetState();
}

class _RightWidgetState extends State<RightWidget> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double left = width * .5;
    double heightValue = height * .055;
    if (widget.length > 15 && widget.length <= 26) {
      setState(() {
        left = width * .25;
      });
    } else if (widget.length > 26 && widget.length < 40) {
      setState(() {
        left = width * .05;
      });
    } else if (widget.length > 40) {
      setState(() {
        left = width * .05;
        heightValue = height * .11;
      });
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
      margin: EdgeInsets.only(left: left, top: width * .02, right: 10),
      height: heightValue,
      decoration: BoxDecoration(
          color: Colors.blue.shade300,
          borderRadius: const BorderRadius.all(Radius.circular(15))),
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

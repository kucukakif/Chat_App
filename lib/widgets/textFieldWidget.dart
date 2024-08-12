import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import '../utils/colors.dart';

class TextFieldWidget extends StatefulWidget {
  final String text;
  final String hint;
  final String errText;
  final bool err;
  final bool iconValue;
  final bool? validatorValue;
  final TextInputType keyboardType;
  TextFieldWidget({
    super.key,
    required this.height,
    required this.emailContoller,
    required this.text,
    required this.hint,
    required this.errText,
    required this.err,
    required this.iconValue,
    required this.keyboardType,
    required this.validatorValue,
  });

  final double height;
  final TextEditingController emailContoller;

  @override
  State<TextFieldWidget> createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  bool value = false;
  @override
  void initState() {
    setState(() {
      value = widget.validatorValue!;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: widget.height,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.text,
            style: TextStyle(
              color: myWhite,
              fontFamily: "Lato",
              fontSize: 18,
              fontStyle: FontStyle.italic,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 4),
            child: Form(
              autovalidateMode: AutovalidateMode.onUnfocus,
              child: TextFormField(
                onTapOutside: (event) {
                  FocusScope.of(context).unfocus();
                },
                obscureText: !value,
                validator: widget.validatorValue == true
                    ? (text) => (EmailValidator.validate(text!)
                        ? null
                        : "Please enter a valid email")
                    : null,
                style: TextStyle(
                  color: myWhite,
                  fontSize: 18,
                  fontFamily: "Lato",
                  fontStyle: FontStyle.italic,
                ),
                keyboardType: widget.keyboardType,
                controller: widget.emailContoller,
                decoration: InputDecoration(
                    filled: true,
                    suffixIcon: widget.iconValue == false
                        ? null
                        : InkWell(
                            onTap: () {
                              setState(() {
                                value = !value;
                              });
                            },
                            child: Icon(
                              value ? Icons.visibility : Icons.visibility_off,
                              color: myWhite,
                            )),
                    fillColor: myBlack,
                    hintText: widget.hint,
                    labelStyle: TextStyle(
                      color: myGreen,
                      fontSize: 18,
                      fontFamily: "Lato",
                      fontStyle: FontStyle.italic,
                    ),
                    errorText: widget.err == true ? widget.errText : null,
                    errorStyle: const TextStyle(
                        color: Colors.red,
                        fontFamily: "lato",
                        fontSize: 14,
                        fontStyle: FontStyle.italic),
                    hintStyle: TextStyle(color: textHintColor),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
            ),
          )
        ],
      ),
    );
  }
}

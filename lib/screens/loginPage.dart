import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:text_divider/text_divider.dart';
import '../repository/auth_repository.dart';
import '../utils/colors.dart';
import '../widgets/loginButton.dart';
import '../widgets/textFieldWidget.dart';
import 'chatPage.dart';

class LoginPage extends StatefulWidget {
  static const routeName = "/loginPage";
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? errorMessage = "";
  bool isLogin = true;
  bool switchValue = false;
  bool isLoading = false;
  bool signUpIsLogin = true;
  bool passwordError = false;
  int pageId = 0;

  final TextEditingController emailContoller = TextEditingController();
  final TextEditingController passwordContoller = TextEditingController();
  final TextEditingController signUpEmailContoller = TextEditingController();
  final TextEditingController signUpPasswordContoller = TextEditingController();
  final TextEditingController confirmPasswordContoller =
      TextEditingController();

  Future<void> createUserWithEmailAndPassword(BuildContext context) async {
    double width = MediaQuery.of(context).size.width;
    try {
      if (signUpPasswordContoller.text == confirmPasswordContoller.text) {
        await Auth().createUserWithEmailAndPassword(
            email: signUpEmailContoller.text,
            password: signUpPasswordContoller.text);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Center(
            child: Text(
              "Account is created",
              style: TextStyle(color: myWhite, fontSize: 18),
            ),
          ),
          duration: const Duration(milliseconds: 1500),
          backgroundColor: Colors.green,
          width: width * .6,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ));
        Navigator.pushNamed(context, LoginPage.routeName);
      } else {
        passwordError = true;
      }
    } on FirebaseAuthException catch (e) {
      print(e.toString());
    }
  }

  Future<void> signInWithEmailAndPassword() async {
    try {
      await Auth().signInWithEmailAndPassword(
          email: emailContoller.text, password: passwordContoller.text);
      Navigator.pushNamed(context, ChatPage.routeName, arguments: {
        "email": emailContoller.text,
        "userId": Auth().currentUser!.uid,
      });
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Future<void> loginWithGoogle() async {
    try {
      if (Auth().currentUser == null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("")));
      } else {
        setState(() {
          isLoading = true;
        });
        await Auth().loginWithGoogle();
        setState(() {
          isLoading = false;
        });
        Navigator.pushNamed(context, ChatPage.routeName, arguments: {
          "email": emailContoller.text,
          "userId": Auth().currentUser!.uid,
        });
      }
    } on FirebaseAuthException catch (e) {
      print(e.toString());
    }
  }

  function() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.get('remember') != null) {
      setState(() {
        emailContoller.text = prefs.get('email').toString();
        passwordContoller.text = prefs.get('password').toString();
        switchValue = true;
      });
    }
  }

  @override
  void initState() {
    function();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(
            color: myBlack,
            image: const DecorationImage(
                image: AssetImage('assets/backGroundImage.jpeg'),
                fit: BoxFit.fill)),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width * .06),
          child: pageId == 0
              ? Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: height * .13),
                      child: Text(
                        "Login",
                        style: TextStyle(
                          color: myWhite,
                          fontSize: 35,
                          fontFamily: "Lato",
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                    TextFieldWidget(
                        height: height * .12,
                        emailContoller: emailContoller,
                        text: "Email",
                        hint: "Email Address",
                        errText: "Please enter a valid email",
                        err: false,
                        iconValue: false,
                        validatorValue: true,
                        keyboardType: TextInputType.emailAddress),
                    TextFieldWidget(
                        height: height * .02,
                        emailContoller: passwordContoller,
                        text: "Password",
                        hint: "Password",
                        errText: "Password is not true",
                        err: false,
                        iconValue: true,
                        validatorValue: false,
                        keyboardType: TextInputType.visiblePassword),
                    Padding(
                      padding: EdgeInsets.only(top: height * .01),
                      child: Row(
                        children: [
                          Transform.scale(
                            scale: 0.8,
                            child: Switch(
                              activeColor: Colors.green,
                              inactiveTrackColor: myBrown,
                              inactiveThumbColor: myWhite,
                              thumbColor:
                                  WidgetStatePropertyAll<Color>(myWhite),
                              value: switchValue,
                              onChanged: (value) async {
                                setState(() {
                                  switchValue = value;
                                });
                                if (switchValue == true) {
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  prefs.setString("email", emailContoller.text);
                                  prefs.setString(
                                      "password", passwordContoller.text);
                                  prefs.setBool("remember", true);
                                } else {
                                  setState(() {
                                    switchValue = false;
                                  });
                                }
                              },
                            ),
                          ),
                          Text(
                            "Remember me",
                            style: TextStyle(
                                fontFamily: "Lato",
                                fontSize: 15,
                                fontStyle: FontStyle.italic,
                                color: myWhite),
                          ),
                          SizedBox(
                            width: width * .15,
                          ),
                          TextButton(
                              onPressed: () {},
                              child: Text(
                                "Forgot password?",
                                style: TextStyle(
                                    fontSize: 15,
                                    fontFamily: "Lato",
                                    fontStyle: FontStyle.italic,
                                    color: myWhite),
                              ))
                        ],
                      ),
                    ),
                    Container(
                      width: width.toDouble(),
                      height: height * .07,
                      margin: EdgeInsets.symmetric(vertical: height * .02),
                      child: TextButton(
                        onPressed: () async {
                          await signInWithEmailAndPassword();
                        },
                        style: ButtonStyle(
                            backgroundColor:
                                const WidgetStatePropertyAll<Color>(
                                    Colors.green),
                            shape:
                                WidgetStatePropertyAll<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ))),
                        child: Text(
                          "Login",
                          style: TextStyle(
                              fontFamily: "Lato",
                              fontSize: 20,
                              color: myWhite,
                              fontStyle: FontStyle.italic),
                        ),
                      ),
                    ),
                    SizedBox(
                        height: height * .05,
                        child: TextDivider.horizontal(
                            color: myGrey,
                            text: Text(
                              "Or login with",
                              style: TextStyle(
                                  color: myGrey,
                                  fontFamily: "Lato",
                                  fontStyle: FontStyle.italic,
                                  fontSize: 15),
                            ))),
                    Row(
                      children: [
                        isLoading
                            ? const CircularProgressIndicator()
                            : LoginButton(
                                width: width,
                                height: height,
                                function: () async {
                                  await loginWithGoogle();
                                },
                                icon: Icons.g_mobiledata_outlined,
                                size: 45,
                              ),
                        SizedBox(
                          width: width * .035,
                        ),
                        LoginButton(
                          width: width,
                          height: height,
                          function: () {},
                          icon: Icons.apple,
                          size: 35,
                        ),
                        SizedBox(
                          width: width * .035,
                        ),
                        LoginButton(
                          width: width,
                          height: height,
                          function: () {},
                          icon: Icons.facebook,
                          size: 30,
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: height * .05,
                          right: width * .11,
                          left: width * .19),
                      child: Row(
                        children: [
                          Text(
                            "Don't have an account?",
                            style: TextStyle(
                                fontFamily: "Lato",
                                fontSize: 15,
                                color: myWhite,
                                fontStyle: FontStyle.italic),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                pageId = 1;
                              });
                            },
                            child: const Text(
                              "  Signup",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontStyle: FontStyle.italic,
                                  color: Colors.green),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                )
              ///////////////////////////////////////////////////////////////////////////////////////// SignUp Page //////////////////////////////////////////////////////////////////////////////////////////////////////////
              : Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          top: passwordError == true
                              ? height * .10
                              : height * .13),
                      child: Text(
                        "Signup",
                        style: TextStyle(
                          color: myWhite,
                          fontSize: 35,
                          fontFamily: "Lato",
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                    TextFieldWidget(
                      height: height * .04,
                      emailContoller: signUpEmailContoller,
                      text: "Email",
                      hint: "Email Address",
                      errText: "Please enter a valid email",
                      err: false,
                      iconValue: false,
                      validatorValue: true,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    TextFieldWidget(
                      height: height * .02,
                      emailContoller: signUpPasswordContoller,
                      text: "Password",
                      hint: "Password",
                      errText: "Not same passwords",
                      err: passwordError,
                      iconValue: true,
                      validatorValue: false,
                      keyboardType: TextInputType.visiblePassword,
                    ),
                    TextFieldWidget(
                      height: height * .02,
                      emailContoller: confirmPasswordContoller,
                      text: "Confirm password",
                      hint: "Confirm password",
                      errText: "Not same passwords",
                      err: passwordError,
                      iconValue: true,
                      validatorValue: false,
                      keyboardType: TextInputType.visiblePassword,
                    ),
                    Container(
                      width: width.toDouble(),
                      height: height * .07,
                      margin: EdgeInsets.only(
                          bottom: height * .02,
                          top: passwordError == true
                              ? height * .02
                              : height * .05),
                      child: TextButton(
                        onPressed: () {
                          createUserWithEmailAndPassword(context);
                        },
                        style: ButtonStyle(
                            backgroundColor:
                                const WidgetStatePropertyAll<Color>(
                                    Colors.green),
                            shape:
                                WidgetStatePropertyAll<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ))),
                        child: Text(
                          "Signup",
                          style: TextStyle(
                              fontFamily: "Lato",
                              fontSize: 20,
                              color: myWhite,
                              fontStyle: FontStyle.italic),
                        ),
                      ),
                    ),
                    SizedBox(
                        height: height * .05,
                        child: TextDivider.horizontal(
                            color: myGrey,
                            text: Text(
                              "Or signup with",
                              style: TextStyle(
                                  color: myGrey,
                                  fontFamily: "Lato",
                                  fontStyle: FontStyle.italic,
                                  fontSize: 15),
                            ))),
                    Row(
                      children: [
                        LoginButton(
                          width: width,
                          height: height,
                          function: () {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Center(
                                child: Text(
                                  "Account is created",
                                  style:
                                      TextStyle(color: myWhite, fontSize: 18),
                                ),
                              ),
                              duration: const Duration(milliseconds: 1500),
                              backgroundColor: Colors.green,
                              width: width * .6,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ));
                          },
                          icon: Icons.g_mobiledata_outlined,
                          size: 45,
                        ),
                        SizedBox(
                          width: width * .035,
                        ),
                        LoginButton(
                          width: width,
                          height: height,
                          function: () {},
                          icon: Icons.apple,
                          size: 35,
                        ),
                        SizedBox(
                          width: width * .035,
                        ),
                        LoginButton(
                          width: width,
                          height: height,
                          function: () {},
                          icon: Icons.facebook,
                          size: 30,
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: height * .05,
                          right: width * .11,
                          left: width * .19),
                      child: Row(
                        children: [
                          Text(
                            "Don't have an account?",
                            style: TextStyle(
                                fontFamily: "Lato",
                                fontSize: 15,
                                color: myWhite,
                                fontStyle: FontStyle.italic),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                pageId = 0;
                              });
                            },
                            child: const Text(
                              "  Login",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontStyle: FontStyle.italic,
                                  color: Colors.green),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
        ),
      ),
    );
  }
}

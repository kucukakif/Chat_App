import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../utils/colors.dart';
import '../widgets/left_widget.dart';
import '../widgets/right_widget.dart';

class ChatPage extends StatefulWidget {
  static const routeName = '/chatScreen';
  const ChatPage(
    Object? arguments, {
    super.key,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController messageController = TextEditingController();
  Query dbRef = FirebaseDatabase.instance.ref().child('messages');

  @override
  Widget build(BuildContext context) {
    final routes =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Chat',
          style: TextStyle(color: Colors.black, fontSize: 25),
        ),
        leading: Container(),
        centerTitle: true,
        backgroundColor: appBarColor,
        elevation: 1,
      ),
      body: Container(
        color: appBarColor,
        child: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: height * .82,
                  child: FirebaseAnimatedList(
                      scrollDirection: Axis.vertical,
                      query: dbRef,
                      itemBuilder: (context, snapshot, animation, index) {
                        Map message = snapshot.value as Map;
                        message['key'] = snapshot.key;
                        return SizedBox(
                          height: height * .055,
                          child: message['email'] == routes['email']
                              ? RightWidget(
                                  message: message['message'].toString(),
                                  date: message['date'].toString(),
                                  length: message['message'].toString().length,
                                )
                              : LeftWidget(
                                  message: message['message'].toString(),
                                  date: message['date'].toString(),
                                  length: message['message'].toString().length,
                                ),
                        );
                      }),
                ),
                Container(
                  color: myWhite,
                  width: width.toDouble(),
                  height: height * .07,
                  child: Row(
                    children: [
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.add,
                            color: Colors.black,
                            size: 30,
                          )),
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: const EdgeInsets.only(
                          top: 5,
                          bottom: 5,
                        ),
                        width: width * .65,
                        child: TextField(
                          onTapOutside: (event) {
                            FocusScope.of(context).unfocus();
                          },
                          maxLines: 30,
                          textCapitalization: TextCapitalization.words,
                          textAlign: TextAlign.start,
                          controller: messageController,
                          decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 15),
                              fillColor: Colors.white,
                              filled: true,
                              border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.white,
                                      style: BorderStyle.none),
                                  borderRadius: BorderRadius.circular(25))),
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                      IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.camera_alt,
                            color: myBlack,
                            size: 30,
                          )),
                      InkWell(
                        onTap: () async {
                          final now = DateTime.now();
                          var time = DateFormat.Hm().format(now);
                          DatabaseReference databaseReference =
                              FirebaseDatabase.instance.ref("messages");
                          await databaseReference.push().set({
                            'date': time,
                            'email': routes['email'],
                            'message': messageController.text,
                          });
                          setState(() {
                            messageController.text = "";
                            FocusScope.of(context).unfocus();
                          });
                        },
                        child: Container(
                          width: width * .09,
                          height: height * .05,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(25)),
                          child: const Icon(
                            Icons.send,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ]),
        ),
      ),
    );
  }
}

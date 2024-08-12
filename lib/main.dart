import 'package:chat_app1/firebase_options.dart';
import 'package:chat_app1/screens/chatPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'screens/loginPage.dart';
import 'utils/colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: myWhite),
        useMaterial3: true,
      ),
      home: const LoginPage(),
      routes: {
        ChatPage.routeName: (context) =>
            ChatPage(ModalRoute.of(context)!.settings.arguments),
        LoginPage.routeName: (context) => const LoginPage(),
      },
    );
  }
}

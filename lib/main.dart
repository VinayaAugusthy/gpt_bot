import 'package:flutter/material.dart';
import 'package:gpt_bot/chat_screen.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        primarySwatch: Colors.amber,
        appBarTheme: const AppBarTheme(
          color: Colors.amberAccent,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
      ),
      home: ChatScreen(),
      debugShowCheckedModeBanner:
          false, //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
    );
  }
}

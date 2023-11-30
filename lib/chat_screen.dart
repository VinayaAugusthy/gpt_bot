import 'dart:async';

import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter/material.dart';
import 'package:gpt_bot/chat_message.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController _controller = TextEditingController();
  List<ChatMessage> messages = [];
  OpenAI? chatGPT;
  StreamSubscription? _subscription;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'GPT BOT',
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 10,
            left: 16,
            right: 16,
          ),
          child: Column(
            children: [
              Flexible(
                child: ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (BuildContext context, int index) =>
                      messages[index],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: size.width,
                height: size.height * 0.1,
                child: TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        15,
                      ),
                      borderSide: const BorderSide(
                        color: Colors.amberAccent,
                        width: 2.0,
                      ),
                    ),
                    suffixIconColor: Colors.amberAccent,
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () => sendMessage(),
                    ),
                  ),
                  controller: _controller,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void sendMessage() {
    ChatMessage message = ChatMessage(text: _controller.text, sender: 'Vinaya');
    setState(() {
      messages.insert(0, message);
    });
    _controller.clear();
  }
}

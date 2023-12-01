// ignore_for_file: library_private_types_in_public_api, avoid_print

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'chat_message.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  List<ChatMessage> messages = [];
  late OpenAI? chatGPT;
  StreamSubscription? _subscription;

  @override
  void initState() {
    chatGPT = OpenAI.instance.build(
      token: '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',
      baseOption:
          HttpSetup(receiveTimeout: const Duration(milliseconds: 60000)),
    );
    super.initState();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  Future<String> getBotResponse(String userMessage) async {
    const apiKey = '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';
    const apiUrl = 'https://api.openai.com/v1/engines/davinci/completions';

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        'prompt': userMessage,
        'max_tokens': 50,
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['choices'][0]['text'];
    } else {
      throw Exception('Failed to send message');
    }
  }

  void sendMessage() async {
    ChatMessage message = ChatMessage(text: _controller.text, sender: 'User');
    setState(() {
      messages.insert(0, message);
    });
    _controller.clear();

    try {
      final request = CompleteText(
        prompt: message.text,
        model: kTextDavinci3,
        maxTokens: 200,
      );

      await Future.delayed(const Duration(seconds: 2));

      _subscription = chatGPT!
          .build(token: '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')
          .onCompletionStream(request: request)
          .listen((response) {
        print(response!.choices[0].text);
        getBotResponse(response.choices[0].text).then((botResponse) {
          ChatMessage botMessage =
              ChatMessage(text: botResponse, sender: 'Bot');
          setState(() {
            messages.insert(0, botMessage);
          });
        });
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ChatGPT Bot'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: messages.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(
                    '${messages[index].sender}: ${messages[index].text}',
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Enter your message...',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

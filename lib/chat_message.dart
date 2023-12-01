import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  const ChatMessage({
    Key? key,
    required this.text,
    required this.sender,
    this.isImage = false,
  }) : super(key: key);

  final String text;
  final String sender;
  final bool isImage;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: sender == 'user' ? Colors.red[200] : Colors.amberAccent,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              sender,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: isImage
                  ? AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Image.network(
                        text,
                        loadingBuilder: (context, child, loadingProgress) =>
                            loadingProgress == null
                                ? child
                                : const CircularProgressIndicator.adaptive(),
                      ),
                    )
                  : Text(
                      text,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
// class ChatMessage {
//   final String text;
//   final String sender;

//   ChatMessage({required this.text, required this.sender});
// }

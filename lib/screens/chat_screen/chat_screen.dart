import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quickcart/constants/constants.dart';

import '../../constants/asset_images.dart';
import 'widgets/chat_message.dart';
import 'widgets/three_dots.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<ChatMessage> _messages = [];
  late OpenAI openAI;

  bool _isTyping = false;

  @override
  void initState() {
    openAI = OpenAI.instance.build(
        token: const String.fromEnvironment('API_KEY'),
        baseOption: HttpSetup(receiveTimeout: const Duration(seconds: 5)));
    super.initState();
  }

  void _sendMessage() async {
    if (_controller.text.isEmpty) return;
    ChatMessage message = ChatMessage(
      text: _controller.text,
      sender: "user",
    );

    setState(() {
      _messages.insert(0, message);
      _isTyping = true;
    });

    _controller.clear();

    final request = ChatCompleteText(messages: [
      Map.of({"role": "user", "content": message.text})
    ], maxToken: 200, model: ChatModel.gptTurbo);

    try {
      final response = await openAI.onChatCompletion(request: request);
      insertNewData(response!.choices[0].message!.content);
    } catch (e) {
      showMessage(e.toString());
      debugPrint(e.toString());
    }
  }

  void insertNewData(String response) {
    ChatMessage botMessage = ChatMessage(
      text: response,
      sender: "bot",
    );

    setState(() {
      _isTyping = false;
      _messages.insert(0, botMessage);
    });
  }

  Widget _buildTextComposer() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 7.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              onSubmitted: (value) => _sendMessage(),
              decoration: const InputDecoration(
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  hintText: "Hi! How can we help you?",
                  hintStyle: TextStyle(color: Colors.white70)),
              style: const TextStyle(color: Colors.white),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: Colors.white),
            onPressed: () {
              _sendMessage();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          title: const Text(
            "Chat with our AI",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Flexible(
                child: _messages.isEmpty
                    ? Center(
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                AssetsImages.instance.emptyChat,
                                semanticsLabel: 'Empty chat',
                                width: 150,
                                height: 150,
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              const Text("Start a conversation",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(
                                height: 25,
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 35.0),
                                child: Text(
                                  'All messages will be deleted after closing this screen for privacy reasons.',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontStyle: FontStyle.italic),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const SizedBox(
                                height: 60,
                              ),
                            ],
                          ),
                        ),
                      )
                    : ListView.builder(
                        reverse: true,
                        padding: const EdgeInsets.all(8),
                        itemCount: _messages.length,
                        itemBuilder: (context, index) {
                          return _messages[index];
                        },
                      ),
              ),
              if (_isTyping) const ThreeDots(),
              const SizedBox(
                height: 7.0,
              ),
              Container(
                decoration: const BoxDecoration(
                  color: Colors.red,
                ),
                child: _buildTextComposer(),
              )
            ],
          ),
        ));
  }
}

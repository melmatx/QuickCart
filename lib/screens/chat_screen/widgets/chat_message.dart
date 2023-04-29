import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickcart/provider/app_provider.dart';

class ChatMessage extends StatelessWidget {
  const ChatMessage({super.key, required this.text, required this.sender});

  final String text;
  final String sender;

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(
      context,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.center,
            child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: sender == "user" ? Colors.green[400] : Colors.red[400],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: sender == "user"
                    ? appProvider.getUserInformation.image == null ||
                            appProvider.getUserInformation.image!.isEmpty
                        ? const Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 24,
                          )
                        : CircleAvatar(
                            backgroundImage: NetworkImage(
                                appProvider.getUserInformation.image!),
                            radius: 12,
                          )
                    : const Icon(
                        Icons.support_agent,
                        color: Colors.white,
                        size: 24,
                      )),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              child: Text(
                text.trim(),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

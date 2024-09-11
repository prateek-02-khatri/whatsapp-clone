import 'package:flutter/material.dart';
import 'package:whatsapp_clone/resource/theme/extension/custom_theme_extension.dart';

class EncryptionCard extends StatelessWidget {
  const EncryptionCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
      decoration: BoxDecoration(
        color: context.theme.yellowCardBgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(10),
      child: Text(
        'Message and calls are end-to-end encrypted. No one outside of this chat, not even WhatsApp, can read or listen to them. Tap to learn more. ',
        style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: context.theme.yellowCardTextColor
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

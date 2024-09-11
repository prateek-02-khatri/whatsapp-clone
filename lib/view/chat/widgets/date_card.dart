import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp_clone/resource/theme/extension/custom_theme_extension.dart';

class DateCard extends StatelessWidget {
  const DateCard({super.key, required this.timeSend});

  final DateTime timeSend;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      decoration: BoxDecoration(
        color: context.theme.receiverChatCardBg,
        borderRadius: BorderRadius.circular(8)
      ),
      child: Text(
        DateFormat.yMMMd().format(timeSend),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: context.theme.greyColor,
        ),
      ),
    );
  }
}

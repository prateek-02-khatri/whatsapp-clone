import 'package:flutter/material.dart';
import 'package:whatsapp_clone/resource/theme/extension/custom_theme_extension.dart';

class CustomListTile extends StatelessWidget {
  const CustomListTile({super.key, required this.title, this.subtitle, required this.leading, this.trailing});

  final String title;
  final IconData leading;
  final String? subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.fromLTRB(25, 5, 5, 10),

      leading: Icon(
        leading,
        size: 26,
      ),

      title: Text(
        title,
        style: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.bold
        ),
      ),

      subtitle: subtitle == null ? null :
        Text(
          subtitle ?? '',
          style: TextStyle(
            fontSize: 15,
            color: context.theme.greyColor
          ),
        ),

      trailing: trailing,
    );
  }
}

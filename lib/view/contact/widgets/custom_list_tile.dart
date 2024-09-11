import 'package:flutter/material.dart';
import 'package:whatsapp_clone/resource/app_colors.dart';

class CustomListTile extends StatelessWidget {
  const CustomListTile({super.key, required this.leading, required this.text, this.trailing});

  final IconData leading;
  final String text;
  final IconData? trailing;

  @override
  Widget build(BuildContext context) {
    return ListTile(

      contentPadding: const EdgeInsets.only(top: 10, left: 20, right: 10),

      leading: CircleAvatar(
        radius: 20,
        backgroundColor: AppColors.greenDark,
        child: Icon(
          leading,
          color: Colors.white,
        ),
      ),

      title: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500
        ),
      ),

      trailing: Icon(
        trailing,
        color: AppColors.greyDark,
      ),
    );
  }
}

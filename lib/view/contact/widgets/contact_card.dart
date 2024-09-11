import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_clone/model/user_model.dart';
import 'package:whatsapp_clone/resource/theme/extension/custom_theme_extension.dart';

import '../../../resource/app_colors.dart';

class ContactCard extends StatelessWidget {
  const ContactCard({super.key, required this.contactSource, required this.onTap});

  final UserModel contactSource;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.only(
        left: 20,
        right: 10
      ),

      leading: CircleAvatar(
        backgroundColor: context.theme.greyColor!.withOpacity(0.3),
        radius: 20,
        backgroundImage: contactSource.profileUrl.isNotEmpty ? CachedNetworkImageProvider(contactSource.profileUrl) : null,
        child: contactSource.profileUrl.isEmpty ?
        const Icon(
          Icons.person,
          size: 30,
          color: Colors.white,
        ) : null,
      ),

      title: Text (
        contactSource.username,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500
        )
      ),

      subtitle: contactSource.userId.isEmpty ? null :
        Text(
          "Hey there! I'm using WhatsApp",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: context.theme.greyColor
          ),
        ),

      trailing: contactSource.userId.isNotEmpty ? null :
        TextButton(
          onPressed: onTap,
          style: TextButton.styleFrom(
            foregroundColor: AppColors.greenDark
          ),
          child: const Text('INVITE')
        ),


    );
  }
}

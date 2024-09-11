import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_clone/model/user_model.dart';
import 'package:whatsapp_clone/resource/app_colors.dart';
import 'package:whatsapp_clone/resource/theme/extension/custom_theme_extension.dart';
import 'package:whatsapp_clone/view_model/chat_provider.dart';

import '../../../model/last_message_model.dart';
import '../../../utils/routes/routes.dart';

class ChatHomePage extends StatelessWidget {
  const ChatHomePage({super.key});

  navigateToContactPage(context) {
    Navigator.pushNamed(context, Routes.contact);
  }

  navigateToChatPage(context, LastMessageModel lastMessageData) {
    Navigator.pushNamed(context, Routes.chat,
        arguments: UserModel(
            username: lastMessageData.username,
            userId: lastMessageData.contactId,
            profileUrl: lastMessageData.profileImageUrl,
            phoneNumber: '+91123',
            groupId: [],
            active: true,
            lastSeen: 0
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    ChatProvider provider = Provider.of<ChatProvider>(context, listen: false);

    return Scaffold(
      body: StreamBuilder(
          stream: provider.getAllLastMessageList(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: AppColors.greenDark,
                ),
              );
            }

            try {
              return ListView.builder(
                  itemCount: snapshot.data!.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final lastMessageData = snapshot.data![index];
                    return ListTile(
                      leading: CircleAvatar(
                        radius: 24,
                        backgroundImage: CachedNetworkImageProvider(
                            lastMessageData.profileImageUrl),
                      ),

                      title: InkWell(
                        onTap: () {
                          navigateToChatPage(context, lastMessageData);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(lastMessageData.username),
                            Text(
                              DateFormat.Hm().format(lastMessageData.timeSend),
                              style: TextStyle(
                                  fontSize: 13, color: context.theme.greyColor),
                            ),
                          ],
                        ),
                      ),

                      subtitle: InkWell(
                        onTap: () {
                          navigateToChatPage(context, lastMessageData);
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 3.0),
                          child: Text(
                            lastMessageData.lastMessage,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: context.theme.greyColor),
                          ),
                        ),
                      ),
                    );
                  });
            } catch (e) {
              return const Center(
                  child: CircularProgressIndicator(
                color: Colors.red,
              ));
            }
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => navigateToContactPage(context),
        child: const Icon(Icons.chat),
      ),
    );
  }
}

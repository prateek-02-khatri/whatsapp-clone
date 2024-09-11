import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:custom_clippers/custom_clippers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:whatsapp_clone/model/user_model.dart';
import 'package:whatsapp_clone/resource/theme/extension/custom_theme_extension.dart';
import 'package:whatsapp_clone/resource/components/custom_icon_button.dart';
import 'package:whatsapp_clone/utils/routes/routes.dart';
import 'package:whatsapp_clone/utils/utils.dart';
import 'package:whatsapp_clone/view/chat/widgets/chat_text_field.dart';
import 'package:whatsapp_clone/view/chat/widgets/date_card.dart';
import 'package:whatsapp_clone/view/chat/widgets/encryption_card.dart';
import 'package:whatsapp_clone/view/chat/widgets/message_card.dart';
import 'package:whatsapp_clone/view_model/chat_provider.dart';

import '../../../view_model/auth_provider.dart' as auth;

class ChatPage extends StatefulWidget {
  const ChatPage({super.key, required this.user});

  final UserModel user;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

final pageStorageBucket = PageStorageBucket();

class _ChatPageState extends State<ChatPage> {

  late auth.AuthProvider provider;
  late ChatProvider chatProvider;

  String status = '';

  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    chatProvider = Provider.of<ChatProvider>(context, listen: false);
    provider = Provider.of<auth.AuthProvider>(context, listen: false);
    provider.getUserPresenceStatus(userId: widget.user.userId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: context.theme.chatPageBgColor,

      appBar: AppBar(

        leading: InkWell(
          onTap: () {
            provider.setFetching(true);
            Navigator.pop(context);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.arrow_back),

              Hero(
                tag: 'profile',
                child: CircleAvatar(
                  radius: 16,
                  backgroundImage: widget.user.profileUrl != '' ? CachedNetworkImageProvider(widget.user.profileUrl) : null,
                  backgroundColor: context.theme.greyColor!.withOpacity(0.9),
                  child:
                  widget.user.profileUrl != '' ? null :
                  const Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        title: InkWell(
          onTap: () {
            Navigator.pushNamed(
              context,
              Routes.profile,
              arguments: {
                'user': widget.user,
                'status': status,
              }
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 5),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.user.username,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white
                  ),
                ),

                const SizedBox(height: 3,),

                Consumer<auth.AuthProvider>(
                  builder: (BuildContext context, auth.AuthProvider value, Widget? child) {
                    status = value.isFetching ? 'connecting':
                      value.active ?
                      'online' :
                      'last seen ${Utils.lastSeenMessage(provider.lastSeen)} ago';
                    return Text(
                      status,
                      style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),

        actions: [
          CustomIconButton(
            onPressed: () {},
            icon: Icons.video_call,
          ),

          CustomIconButton(
            onPressed: () {},
            icon: Icons.call,
          ),

          CustomIconButton(
            onPressed: () {},
            icon: Icons.more_vert_sharp,
          )
        ],
      ),

      body: Stack(
        children: [
          Image(
            height: double.maxFinite,
            width: double.maxFinite,
            image: const AssetImage('assets/images/doodle_bg.png'),
            fit: BoxFit.cover,
            color: context.theme.chatPageBgColor,
          ),

          Padding(
            padding: const EdgeInsets.only(bottom: 60),
            child: StreamBuilder(
                stream: chatProvider.getAllOneToOneMessage(widget.user.userId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return ListView.builder(
                        itemCount: 15,
                        itemBuilder: (context, index) {
                          final random = Random().nextInt(15);
                          return Container(
                            alignment: random.isEven ? Alignment.centerRight : Alignment.centerLeft,
                            margin: EdgeInsets.only(
                              top: 5,
                              bottom: 5,
                              left: random.isEven ? 150 : 15,
                              right: random.isEven ? 15 : 150,
                            ),
                            child: ClipPath(
                              clipper: UpperNipMessageClipperTwo(
                                random.isEven ? MessageType.send : MessageType.receive,
                                nipWidth: 8,
                                nipHeight: 10,
                                bubbleRadius: 12,
                              ),
                              child: Shimmer.fromColors(
                                  baseColor: random.isEven ? context.theme.greyColor!.withOpacity(0.3) : context.theme.greyColor!.withOpacity(0.2),
                                  highlightColor: random.isEven ? context.theme.greyColor!.withOpacity(0.4) : context.theme.greyColor!.withOpacity(0.3),
                                  child:  Container(
                                    height: 40,
                                    width: 170 + double.parse((random*2).toString()),
                                    color: Colors.red,
                                  )
                              ),
                            ),
                          );
                        }
                    );
                  }

                  return PageStorage(
                    bucket: pageStorageBucket,
                    key: const PageStorageKey('chat_page_list'),
                    child: ListView.builder(
                        itemCount: snapshot.data!.length,
                        controller: scrollController,
                        itemBuilder: (context, index) {

                          final message = snapshot.data![index];

                          final isSender = message.senderId == FirebaseAuth.instance.currentUser!.uid;

                          if (!isSender) {
                            message.isSeen = true;
                          }

                          final haveNip = (index == 0) ||
                              (index == snapshot.data!.length -1
                                  && message.senderId != snapshot.data![index-1].senderId) ||
                              (message.senderId != snapshot.data![index-1].senderId
                                  && message.senderId == snapshot.data![index+1].senderId) ||
                              (message.senderId != snapshot.data![index-1].senderId
                                  && message.senderId == snapshot.data![index+1].senderId);

                          final isShowDateCard = (index == 0) ||
                              ((index == snapshot.data!.length-1) &&
                                  (message.timeSend.day > snapshot.data![index-1].timeSend.day)) ||
                              (message.timeSend.day > snapshot.data![index-1].timeSend.day) &&
                                  (message.timeSend.day <= snapshot.data![index-1].timeSend.day);

                          return Column(
                            children: [

                              if (index == 0) const EncryptionCard(),

                              if (isShowDateCard) DateCard(timeSend: message.timeSend),

                              MessageCard(
                                message: message,
                                isSender: isSender,
                                haveNip: haveNip
                              ),
                            ],
                          );
                        }
                    ),
                  );
                }
            ),
          ),

          Container(
            alignment: const Alignment(0, 1),
            child: ChatTextField(
              receiverId: widget.user.userId,
              provider: chatProvider,
              scrollController: scrollController,
            ),
          ),
        ],
      ),
    );
  }
}

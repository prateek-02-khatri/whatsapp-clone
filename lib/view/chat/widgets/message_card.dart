import 'package:cached_network_image/cached_network_image.dart';
import 'package:custom_clippers/custom_clippers.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp_clone/model/message_model.dart';
import 'package:whatsapp_clone/resource/theme/extension/custom_theme_extension.dart';
import 'package:whatsapp_clone/data/message_type.dart' as type;

class MessageCard extends StatelessWidget {
  const MessageCard({super.key, required this.message, required this.isSender, required this.haveNip});

  final MessageModel message;
  final bool isSender;
  final bool haveNip;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      margin: EdgeInsets.only(
        top: 3,
        bottom: 3,
        left: isSender ? 80 : haveNip ? 10 : 15,
        right: isSender ? haveNip ? 10 : 15 : 80,
      ),
      child: ClipPath(
        clipper: haveNip ? UpperNipMessageClipperTwo(
          isSender ? MessageType.send : MessageType.receive,
          nipWidth: 8,
          nipHeight: 10,
          bubbleRadius: 12,
        ) : null,
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: isSender ? context.theme.senderChatCardBg : context.theme.receiverChatCardBg,
                  borderRadius: haveNip ? null : BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(color: Colors.black38)
                  ]
              ),
              // Message
              child: message.type == type.MessageType.image ?
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image(
                      image: CachedNetworkImageProvider(message.textMessage)
                    ),
                  ),
                ) :
                Padding(
                  padding: EdgeInsets.only(
                    top: 3,
                    bottom: 10,
                    left: isSender ? 8 : 10,
                    right: isSender ? 15 : 10,
                  ),
                  child: Text(
                    '${message.textMessage}             ',
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
            ),

            // Time
            Positioned(
                bottom: message.type == type.MessageType.text ? 8 : 4,
                right: message.type == type.MessageType.text ? isSender ? 15 : 10 : 4,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    message.type == type.MessageType.text ?
                      Text(
                        DateFormat.Hm().format(message.timeSend),
                        style: TextStyle(
                          fontSize: 11,
                          color: context.theme.greyColor,
                        ),
                      ):
                      Padding(
                        padding: const EdgeInsets.only(left: 90, right: 10, bottom: 10, top: 20),
                        child: Text(
                          DateFormat.Hm().format(message.timeSend),
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.white,
                          ),
                        ),
                      ),

                    const SizedBox(width: 3,),

                    if (isSender)
                      Icon(
                        Icons.done_sharp,
                        size: 16,
                        color: message.isSeen ? Colors.lightBlue : context.theme.greyColor,
                      )
                  ],
                ),
            )
          ],
        ),
      ),
    );
  }
}

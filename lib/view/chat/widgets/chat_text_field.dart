
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whatsapp_clone/data/message_type.dart';
import 'package:whatsapp_clone/resource/app_colors.dart';
import 'package:whatsapp_clone/resource/components/custom_icon_button.dart';
import 'package:whatsapp_clone/resource/theme/extension/custom_theme_extension.dart';
import 'package:whatsapp_clone/view_model/chat_provider.dart';

import '../../../utils/utils.dart';

class ChatTextField extends StatefulWidget {
  const ChatTextField({super.key, required this.receiverId, required this.provider, required this.scrollController});

  final String receiverId;
  final ChatProvider provider;
  final ScrollController scrollController;

  @override
  State<ChatTextField> createState() => _ChatTextFieldState();
}

class _ChatTextFieldState extends State<ChatTextField> {

  late TextEditingController messageController;
  bool isMessageIconEnabled = false;
  bool showCard = false;

  void sendImageMessageFromGallery() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image != null) {
        await sendFileMessage(File(image.path), MessageType.image);
        showCard = false;
      }
    } catch (e) {
      Utils.showAlertDialog(context: context, message: e.toString());
    }
    setState(() {
      showCard = false;
    });
  }


  pickImageFromCamera() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image != null) {
        setState(() {
          // imageCamera = File(image.path);
          // imageGallery = null;
        });
      } else {
        Utils.showAlertDialog(context: context, message: 'No File Selected..!!');
      }
    } catch (e) {
      Utils.showAlertDialog(context: context, message: e.toString());
    }
  }


  Future<void> sendFileMessage(var file, MessageType messageType) async {
    widget.provider.sendFileMessage(
        context: context,
        file: file,
        receiverId: widget.receiverId,
        messageType: messageType
    );

    await Future.delayed(const Duration(milliseconds: 500));
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      widget.scrollController.animateTo(
          widget.scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut
      );
    });
  }

  void sendTextMessage() async {
    if (isMessageIconEnabled) {
      widget.provider.sendTextMessage(
        context: context,
        textMessage: messageController.text.trim(),
        receiverId: widget.receiverId
      );
      isMessageIconEnabled = false;
      messageController.clear();
    }

    await Future.delayed(const Duration(milliseconds: 100));
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      widget.scrollController.animateTo(
          widget.scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut
      );
    });
  }

  @override
  void initState() {
    messageController = TextEditingController();
    super.initState();
  }

  iconWithText({
    required VoidCallback onPressed,
    required IconData icon,
    required String text,
    required Color background,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomIconButton(
          onPressed: onPressed,
          icon: icon,
          background: background,
          iconColor: Colors.white,
          minWidth: 50,
          border: Border.all(
            color: context.theme.greyColor!.withOpacity(0.2),
            width: 1
          ),
        ),
        const SizedBox(height: 5),
        Text(
          text,
          style: TextStyle(
            color: context.theme.greyColor
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showCard)
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.symmetric(horizontal: 10),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            decoration: BoxDecoration(
              color: context.theme.receiverChatCardBg,
              borderRadius: BorderRadius.circular(15)
            ),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        iconWithText(
                          onPressed: () {},
                          icon: Icons.file_open,
                          text: 'Document',
                          background: const Color(0xFF7F66FE)
                        ),

                        iconWithText(
                            onPressed: () {},
                            icon: Icons.camera_alt,
                            text: 'Camera',
                            background: const Color(0xFFFE2E74)
                        ),

                        iconWithText(
                            onPressed: sendImageMessageFromGallery,
                            icon: Icons.photo,
                            text: 'Gallery',
                            background: const Color(0xFFC861F9)
                        )
                      ],
                    ),

                    const SizedBox(height: 20,),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        iconWithText(
                            onPressed: () {},
                            icon: Icons.headphones,
                            text: 'Audio',
                            background: const Color(0xFFF96533)
                        ),

                        iconWithText(
                            onPressed: () {},
                            icon: Icons.location_on,
                            text: 'Location',
                            background: const Color(0xFF1FA855)
                        ),

                        iconWithText(
                            onPressed: () {},
                            icon: Icons.person,
                            text: 'Contact',
                            background: const Color(0xFF009DE1)
                        )
                      ],
                    ),

                    const SizedBox(height: 20,),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        iconWithText(
                            onPressed: () {},
                            icon: Icons.bar_chart_sharp,
                            text: 'Poll',
                            background: const Color.fromRGBO(2, 165, 152, 1.0)
                        ),

                        iconWithText(
                            onPressed: () {},
                            icon: Icons.add_photo_alternate_outlined,
                            text: 'Imagine',
                            background: const Color.fromRGBO(0, 99, 204, 1.0)
                        ),

                        const SizedBox(width: 50,)
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: messageController,
                  maxLines: 4,
                  minLines: 1,
                  onChanged: (value) {
                    value.isEmpty ? isMessageIconEnabled = false : isMessageIconEnabled = true;
                    setState(() {});
                  },
                  decoration: InputDecoration(
                    hintText: 'Message',
                    hintStyle: TextStyle(color: context.theme.greyColor),

                    filled: true,
                    fillColor: context.theme.chatTextFieldBg,

                    isDense: true,

                    border: OutlineInputBorder(
                      borderSide: const BorderSide(
                          style: BorderStyle.none,
                          width: 0
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),

                    prefixIcon: CustomIconButton(
                        onPressed: () {},
                        icon: Icons.emoji_emotions_outlined,
                        iconColor: Theme.of(context).listTileTheme.iconColor,
                    ),

                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        CustomIconButton(
                          onPressed: () {
                            setState(() {
                              showCard = !showCard;
                            });
                          },
                          icon: Icons.attach_file_sharp,
                          iconColor: Theme.of(context).listTileTheme.iconColor,
                        ),

                        CustomIconButton(
                          onPressed: () {},
                          icon: Icons.currency_rupee,
                          iconColor: Theme.of(context).listTileTheme.iconColor,
                        ),

                        CustomIconButton(
                          onPressed: () {},
                          icon: Icons.camera_alt_outlined,
                          iconColor: Theme.of(context).listTileTheme.iconColor,
                        ),
                      ],
                    ),

                  ),
                ),
              ),

              const SizedBox(width: 10,),

              CustomIconButton(
                onPressed: () {
                  sendTextMessage();
                  setState(() {});
                },
                icon: isMessageIconEnabled ? Icons.send : Icons.mic_none_outlined,
                background: AppColors.greenDark,
                iconColor: Colors.white,
              )
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }
}

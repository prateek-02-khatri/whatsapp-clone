import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_clone/resource/theme/extension/custom_theme_extension.dart';
import 'package:whatsapp_clone/utils/utils.dart';
import 'package:whatsapp_clone/view_model/auth_provider.dart';

import '../../../resource/app_colors.dart';
import '../../../resource/components/custom_elevated_button.dart';
import '../../../resource/components/custom_icon_button.dart';
import '../../../resource/components/short_h_bar.dart';
import '../widgets/custom_text_field.dart';


class UserInfoPage extends StatefulWidget {
  const UserInfoPage({super.key, this.profileImageUrl});

  final String? profileImageUrl;

  @override
  State<UserInfoPage> createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {

  File? imageCamera;
  File? imageGallery;

  late TextEditingController usernameController;

  @override
  void initState() {
    usernameController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        title: Text(
          'Profile Info',
          style: TextStyle(
            color: context.theme.authAppbarTextColor
          ),
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Text(
              'Please provide your name and an optional profile photo',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: context.theme.greyColor
              ),
            ),

            const SizedBox(height: 40,),

            GestureDetector(
              onTap: imagePickerTypeBottomSheet,
              child: Container(
                padding: const EdgeInsets.all(26),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: context.theme.photoIconBgColor,
                  border: Border.all(
                    color: imageCamera == null && imageGallery == null ? Colors.transparent : context.theme.greyColor!.withOpacity(0.4),
                  ),
                  image:
                  imageCamera != null || imageGallery != null || (widget.profileImageUrl != null && widget.profileImageUrl != '')
                      ?
                  DecorationImage(
                      fit: BoxFit.cover,
                      image: imageGallery != null
                          ?
                      FileImage(imageGallery!) as ImageProvider
                          :
                      widget.profileImageUrl != null ? NetworkImage(widget.profileImageUrl!) : FileImage(imageCamera!) as ImageProvider
                  )
                      :
                  null
                ),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 3, right: 3),
                  child: Icon(
                    Icons.add_a_photo_rounded,
                    size: 48,
                    color: imageCamera == null && imageGallery == null && widget.profileImageUrl == null ? context.theme.photoIconColor : Colors.transparent,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40,),

            Row(
              children: [
                const SizedBox(width: 20),

                Expanded(
                  child: CustomTextField(
                    controller: usernameController,
                    hintText: 'Type your name here',
                    textAlign: TextAlign.left,
                    autoFocus: true,
                  )
                ),

                const SizedBox(width: 10),

                Icon(
                  Icons.emoji_emotions_outlined,
                  color: context.theme.photoIconColor,
                ),

                const SizedBox(width: 20),
              ],
            )
          ],
        ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

      floatingActionButton: CustomElevatedButton(
        onPressed: saveUseDataToFirebase,
        text: 'NEXT',
        buttonWidth: 90,
      ),
    );
  }

  saveUseDataToFirebase() {
    String username = usernameController.text;

    if (username.isEmpty) {
      return Utils.showAlertDialog(context: context, message: 'Please provide a username');
    } else if (username.length < 3 || username.length > 20) {
      return Utils.showAlertDialog(context: context, message: 'A username length should be between 3-20');
    }

    AuthProvider provider = Provider.of<AuthProvider>(context, listen: false);

    provider.saveUserInfoToFirestore(
        username: username,
        profileImage: imageCamera ?? imageGallery ?? widget.profileImageUrl ?? '',
        context: context,
        mounted: mounted
    );
  }

  imagePickerTypeBottomSheet() {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const ShortHBar(),

              Row(
                children: [
                  const SizedBox(width: 20,),

                  const Text('Profile Photo', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),),

                  const Spacer(),

                  CustomIconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icons.close,

                  ),

                  const SizedBox(width: 15),
                ],
              ),

              Divider(color: context.theme.greyColor!.withOpacity(0.3),),

              const SizedBox(width: 5),

              Row(
                children: [
                  const SizedBox(width: 20,),

                  imagePickerIcon(
                      onTap: pickImageFromCamera,
                      icon: Icons.camera_alt_rounded,
                      text: 'Camera'
                  ),

                  const SizedBox(width: 15,),

                  imagePickerIcon(
                      // onTap: () async{
                      //   Navigator.pop(context);
                      //   final image = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ImagePickerPage()));
                      //   if (image == null) return;
                      //   setState(() {
                      //     imageGallery = image;
                      //     imageCamera = null;
                      //   });
                      // },
                      onTap: pickImageFromGallery,
                      icon: Icons.photo_camera_back_rounded,
                      text: 'Gallery'
                  ),
                ],
              ),

              const SizedBox(height: 15,),

            ],
          );
        }
    );
  }

  pickImageFromCamera() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image != null) {
        setState(() {
          imageCamera = File(image.path);
          imageGallery = null;
        });
      } else {
        Utils.showAlertDialog(context: context, message: 'No File Selected..!!');
      }
    } catch (e) {
      Utils.showAlertDialog(context: context, message: e.toString());
    }
  }

  pickImageFromGallery() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          imageGallery = File(image.path);
          imageCamera = null;
        });
      } else {
        Utils.showAlertDialog(context: context, message: 'No File Selected..!!');
      }
      Navigator.pop(context);
    } catch (e) {
      Utils.showAlertDialog(context: context, message: e.toString());
    }
  }

  imagePickerIcon({required VoidCallback onTap, required IconData icon, required String text}) {
    return Column(
      children: [
        CustomIconButton(
          onPressed: onTap,
          icon: icon,
          iconColor: AppColors.greenDark,
          minWidth: 50,
          border: Border.all(
              color: context.theme.greyColor!.withOpacity(0.2),
              width: 1
          ),
        ),

        const SizedBox(height: 5,),

        Text(text, style: TextStyle(color: context.theme.greyColor),)
      ],
    );
  }
}
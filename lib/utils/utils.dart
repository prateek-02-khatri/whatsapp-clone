import 'package:flutter/material.dart';
import 'package:whatsapp_clone/resource/theme/extension/custom_theme_extension.dart';

import '../resource/app_colors.dart';

class Utils {
  static showAlertDialog({
    required BuildContext context,
    required String message,
    String? btnText,
  }) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(
            message,
            style: TextStyle(
              color: context.theme.greyColor,
              fontSize: 15,
            ),
          ),
          contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          actions: [
            TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  btnText ?? "OK",
                  style: TextStyle(color: context.theme.circleImageColor),
                )
            )
          ],
        );
      },
    );
  }

  static showLoadingDialog({
    required BuildContext context,
    required String message,
  }) async{
    return await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    const CircularProgressIndicator(color: AppColors.greenDark),

                    const SizedBox(width: 20,),

                    Expanded(
                        child: Text(
                          message,
                          style: TextStyle(fontSize: 15, color: context.theme.greyColor, height: 1.5),
                        )
                    )
                  ],
                )
              ],
            ),
          );
        }
    );
  }

  static String lastSeenMessage(lastSeen) {
    DateTime now = DateTime.now();
    DateTime lastSeenDateTime = DateTime.fromMillisecondsSinceEpoch(lastSeen);
    Duration differenceDuration = now.difference(lastSeenDateTime);
    String finalMessage  = '';
    if (differenceDuration.inSeconds <= 59) {
      finalMessage = "few moments";
    } else if (differenceDuration.inMinutes <= 59) {
      finalMessage = "${differenceDuration.inMinutes} ${differenceDuration.inMinutes == 1 ? 'minute' : 'minutes'}";
    } else if (differenceDuration.inHours <= 23) {
      finalMessage = "${differenceDuration.inHours} ${differenceDuration.inHours == 1 ? 'hour' : 'hours'}";
    } else {
      finalMessage = "${differenceDuration.inDays} ${differenceDuration.inDays == 1 ? 'day' : 'days'}";
    }
    return finalMessage;
  }
}
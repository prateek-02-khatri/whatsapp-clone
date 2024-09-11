import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_clone/resource/theme/extension/custom_theme_extension.dart';
import 'package:whatsapp_clone/view_model/auth_provider.dart';

import '../../../resource/components/custom_icon_button.dart';
import '../widgets/custom_text_field.dart';

class VerificationPage extends StatelessWidget {
  const VerificationPage({super.key, required this.smsCodeId, required this.phoneNumber});

  final String smsCodeId;
  final String phoneNumber;

  @override
  Widget build(BuildContext context) {
    AuthProvider provider = Provider.of<AuthProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        title: Text(
          'Verify your number',
          style: TextStyle(
            color: context.theme.authAppbarTextColor,
          ),
        ),
        centerTitle: true,
        actions: [
          CustomIconButton(
            onPressed: (){},
            icon: Icons.more_vert
          )
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(
                    color: context.theme.greyColor,
                    height: 1.5
                  ),
                  children: [
                    TextSpan(
                      text: "You've tried to register $phoneNumber before requesting an SMS or call with your code. "
                    ),
                    TextSpan(
                      text: 'Wrong number?',
                      style: TextStyle(
                        color: context.theme.blueColor
                      )
                    )
                  ]
                ),
              ),
            ),

            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 80),
              child: CustomTextField(
                hintText: '- - -  - - -',
                fontSize: 30,
                autoFocus: true,
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  if (value.length == 6) {
                    return provider.verifySMSCode(context: context, smsCodeId: smsCodeId, smsCode: value, mounted: true);
                  }
                },
              ),
            ),

            const SizedBox(height: 20),

            Text(
              'Enter 6-digit code',
              style: TextStyle(
                color: context.theme.greyColor
              ),
            ),

            const SizedBox(height: 30),

            Row(
              children: [
                Icon(
                  Icons.message,
                  color: context.theme.greyColor,
                ),
                const SizedBox(width: 20),
                Text(
                  'Resend SMS',
                  style: TextStyle(
                    color: context.theme.greyColor
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10,),

            Divider(
              color: context.theme.blueColor!.withOpacity(0.2),
            ),

            const SizedBox(height: 10),

            Row(
              children: [
                Icon(
                  Icons.phone,
                  color: context.theme.greyColor,
                ),
                const SizedBox(width: 20),
                Text(
                  'Call Me',
                  style: TextStyle(
                      color: context.theme.greyColor
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

}

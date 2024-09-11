import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_clone/resource/theme/extension/custom_theme_extension.dart';
import 'package:whatsapp_clone/utils/utils.dart';
import 'package:whatsapp_clone/view_model/auth_provider.dart';

import '../../../resource/app_colors.dart';
import '../../../resource/components/custom_elevated_button.dart';
import '../../../resource/components/custom_icon_button.dart';
import '../widgets/custom_text_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  late TextEditingController countryNameController;
  late TextEditingController countryCodeController;
  late TextEditingController phoneNumberController;

  late AuthProvider provider;

  @override
  void initState() {
    countryNameController = TextEditingController(text: 'India');
    countryCodeController = TextEditingController(text: '91');
    phoneNumberController = TextEditingController();
    provider = Provider.of<AuthProvider>(context, listen: false);
    super.initState();
  }

  @override
  void dispose() {
    countryNameController.dispose();
    countryCodeController.dispose();
    phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
          title: Text('Enter your phone number', style: TextStyle(color: context.theme.authAppbarTextColor),),
          centerTitle: true,
          actions: [
            CustomIconButton(onPressed: (){}, icon: Icons.more_vert)
          ]
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: 'WhatsApp will need to verify your phone number. ',
                style: TextStyle(
                  color: context.theme.greyColor,
                  height: 1.5
                ),
                children: [
                  TextSpan(
                    text: "What's my number?",
                    style: TextStyle(
                      color: context.theme.blueColor
                    )
                  )
                ]
              ),
            ),
          ),

          const SizedBox(height: 10,),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: CustomTextField(
              onTap: showCountryCodePicker,
              controller: countryNameController,
              readOnly: true,
              suffixIcon: const Icon(Icons.arrow_drop_down, color: AppColors.greyDark,),
            ),
          ),

          const SizedBox(height: 10,),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Row(
              children: [
                SizedBox(
                  width: 70,
                  child: CustomTextField(
                    onTap: showCountryCodePicker,
                    controller: countryCodeController,
                    prefixText: '+',
                    readOnly: true,
                  ),
                ),

                const SizedBox(width: 10,),

                Expanded(
                    child: CustomTextField(
                      controller: phoneNumberController,
                      hintText: 'phone number',
                      textAlign: TextAlign.left,
                      keyboardType: TextInputType.number,
                    )
                ),
              ],
            ),
          ),

          const SizedBox(height: 20,),

          Text(
            'Carrier charges may apply',
            style: TextStyle(
              color: context.theme.greyColor
            ),
          )
        ],
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

      floatingActionButton: CustomElevatedButton(
        onPressed: sendCodeToPhone,
        text: 'NEXT',
        buttonWidth: 90,
      ),
    );
  }

  sendCodeToPhone() {
    final phoneNumber = phoneNumberController.text;
    final countryName = countryNameController.text;
    final countryCode = countryCodeController.text;

    if (phoneNumber.isEmpty) {
      return Utils.showAlertDialog(
          context: context,
          message: 'Please enter your phone number'
      );
    }
    else if (phoneNumber.length < 9) {
      return Utils.showAlertDialog(
          context: context,
          message: 'The Phone number you entered is too short for the country: $countryName.\n\n'
      );
    } else if (phoneNumber.length > 10) {
      return Utils.showAlertDialog(
          context: context,
          message: 'The Phone number you entered is too long for the country: $countryName.'
      );
    }

    // Request a Verification Code
    provider.sendSMSCode(context: context, phoneNumber: '+$countryCode$phoneNumber');
  }

  showCountryCodePicker() {
    showCountryPicker(
        context: context,
        showPhoneCode: true,
        countryListTheme: CountryListThemeData(
          bottomSheetHeight: 600,
          backgroundColor: Theme.of(context).colorScheme.surface,
          flagSize: 22,
          borderRadius: BorderRadius.circular(20),
          textStyle: TextStyle(color: context.theme.greyColor),
          inputDecoration: InputDecoration(
            labelStyle: TextStyle(color: context.theme.greyColor),
            prefixIcon: const Icon(Icons.language, color: AppColors.greenDark),
            hintText: 'Search country code or name',
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: context.theme.greyColor!.withOpacity(0.2)),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.greenDark),
            ),
          ),
        ),
        onSelect: (country) {
          countryNameController.text = country.name;
          countryCodeController.text = country.phoneCode;
        }
    );
  }
}


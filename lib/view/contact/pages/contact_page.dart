import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_clone/resource/theme/extension/custom_theme_extension.dart';
import 'package:whatsapp_clone/view/contact/widgets/contact_card.dart';
import 'package:whatsapp_clone/view/contact/widgets/custom_list_tile.dart';
import 'package:whatsapp_clone/view_model/contacts_provider.dart';

import '../../../model/user_model.dart';
import '../../../resource/components/custom_icon_button.dart';
import '../../../utils/routes/routes.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  shareSMSLink(phoneNumber) async {
    Uri sms = Uri.parse("sms:$phoneNumber?body=Let's chat on WhatsApp! It's a fast, simple, and secure app we can use to message and call each other for free. Get it at https://whatsapp.com/dl/");
    await launchUrl(sms);
  }

  late ContactProvider provider;

  @override
  void initState() {
    super.initState();
    provider = Provider.of<ContactProvider>(context, listen: false);
    fetchAllContacts();
  }

  fetchAllContacts() async{
    await provider.getAllContacts();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Contact',
              style: TextStyle(color: Colors.white),
            ),

            const SizedBox(height: 3,),

            Consumer<ContactProvider>(
              builder: (BuildContext context, ContactProvider value, Widget? child) {
                return provider.isLoading ?
                  const Text(
                    'counting',
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ):
                  Text(
                    provider.allContacts.isEmpty ?
                    "No Contacts" :
                    "${provider.allContacts[0].length} contact${provider.allContacts[0].length == 1 ? '' : 's'}",
                    style: const TextStyle(
                        fontSize: 13
                    ),
                  );
              },
            ),
          ],
        ),

        actions: [
          CustomIconButton(onPressed: (){}, icon: Icons.search),
          CustomIconButton(onPressed: (){}, icon: Icons.more_vert),
        ],
      ),

      body: Consumer<ContactProvider>(
        builder: (BuildContext context, ContactProvider value, Widget? child) {
          final allContacts = value.allContacts;
          return provider.isLoading ?
            Center (
              child: CircularProgressIndicator(
                color: context.theme.authAppbarTextColor,
              ),
            ) :
            allContacts.isEmpty ?
            const Center(
              child: Text(
                'No Contacts',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold
                ),
              ),
            ):
            ListView.builder(
              itemCount: allContacts[0].length + allContacts[1].length,
              itemBuilder: (context, index) {
                late UserModel firebaseContacts;
                late UserModel phoneContacts;
                if (index < allContacts[0].length) {
                  firebaseContacts = allContacts[0][index];
                } else {
                  phoneContacts = allContacts[1][index - allContacts[0].length];
                }
                return
                  index < allContacts[0].length
                      ?
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (index == 0)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const CustomListTile(
                              leading: Icons.group_add,
                              text: 'New group'
                            ),

                            const CustomListTile(
                              leading: Icons.person_add_alt_1,
                              text: 'New contact',
                              trailing: Icons.qr_code,
                            ),

                            const CustomListTile(
                              leading: Icons.groups,
                              text: 'New community',
                            ),

                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              child: Text(
                                'Contacts on WhatsApp',
                                style: TextStyle(fontWeight: FontWeight.w600, color: context.theme.greyColor),
                              ),
                            ),
                          ],
                        ),

                      ContactCard(
                        contactSource: firebaseContacts,
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            Routes.chat,
                            arguments: firebaseContacts,
                          );
                        }
                      )
                    ],
                  )
                      :
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (index == allContacts[0].length)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          child: Text(
                            'Invite to WhatsApp',
                            style: TextStyle(fontWeight: FontWeight.w600, color: context.theme.greyColor),
                          ),
                        ),

                      ContactCard(
                        contactSource: phoneContacts,
                        onTap: () => shareSMSLink(phoneContacts.phoneNumber)
                      )
                    ],
                  )
                ;
              }
          );
        }
      ),
    );
  }
}

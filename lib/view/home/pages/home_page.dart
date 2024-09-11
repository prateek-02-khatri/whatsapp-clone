import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../resource/components/custom_icon_button.dart';
import '../../../view_model/auth_provider.dart';
import 'call_home_page.dart';
import 'chat_home_page.dart';
import 'status_home_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late Timer timer;
  late AuthProvider provider;

  @override
  void initState() {
    provider = Provider.of<AuthProvider>(context, listen: false);
    provider.updateUserPresence(isConnected: true);

    timer = Timer.periodic(const Duration(minutes: 1), (timer) => setState(() {}));

    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          appBar: AppBar(
            title: const Text('WhatsApp', style: TextStyle(letterSpacing: 1),),
            elevation: 1,
            actions: [
              CustomIconButton(onPressed: (){
                log(DateTime.now().millisecondsSinceEpoch.toString());
              }, icon: Icons.search),
              CustomIconButton(onPressed: (){
                provider.logout(context);
              }, icon: Icons.logout),
            ],
            bottom: const TabBar(
              indicatorWeight: 3,
              dividerColor: Colors.transparent,
              labelStyle: TextStyle(fontWeight: FontWeight.bold),
              splashFactory: NoSplash.splashFactory,
              tabs: [
                Tab(text: 'CHATS',),
                Tab(text: 'STATUS',),
                Tab(text: 'CALLS',),
              ],
            ),
          ),
          body: const TabBarView(
            children: [
              ChatHomePage(),
              StatusHomePage(),
              CallHomePage(),
            ],
          )
      ),
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_clone/resource/theme/light_theme.dart';
import 'package:whatsapp_clone/view/home/pages/home_page.dart';
import 'package:whatsapp_clone/view/welcome/pages/welcome_page.dart';
import 'package:whatsapp_clone/view_model/chat_provider.dart';
import 'package:whatsapp_clone/view_model/contacts_provider.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'package:whatsapp_clone/resource/theme/dark_theme.dart';
import 'package:whatsapp_clone/utils/routes/routes.dart';
import 'package:whatsapp_clone/view_model/auth_provider.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const WhatsappMessenger());
}

class WhatsappMessenger extends StatelessWidget {
  const WhatsappMessenger({super.key});

  @override
  Widget build(BuildContext context) {

    Widget? nextPage;
    firebase.User? user = firebase.FirebaseAuth.instance.currentUser;

    if (user == null) {
      nextPage = const WelcomePage();
    } else {
      nextPage = const HomePage();
    }

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ContactProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
      ],
      builder: (context, child) {
        FlutterNativeSplash.remove();
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'WhatsApp Messenger',
          theme: lightTheme(),
          darkTheme: darkTheme(),
          themeMode: ThemeMode.system,
          home: nextPage,
          onGenerateRoute: Routes.onGenerateRoute,
        );
      }
    );
  }

}

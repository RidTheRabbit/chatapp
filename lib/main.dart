
import 'package:chatapp/firebase_options.dart';
import 'package:chatapp/screens/chat_buble.dart';
import 'package:chatapp/screens/login.dart';
import 'package:chatapp/screens/register.dart';
import 'package:chatapp/utils/notification_setup.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() async {
WidgetsFlutterBinding.ensureInitialized();
await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  if (!kIsWeb) {
    await setupFlutterNotifications();
  }

// Ideal time to initialize
// await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  runApp(const ScholarChat());
}

class ScholarChat extends StatelessWidget {
  const ScholarChat({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        RegisterScreen.id :(context) => const RegisterScreen(),
        LoginScreen.id :(context) => const LoginScreen(),
        ChatBubleScreen.id :(context) => const ChatBubleScreen(),
      },
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}


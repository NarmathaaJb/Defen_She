import 'package:defenshe/pages/auth_page.dart';
import 'package:defenshe/pages/login_page.dart';
import 'package:defenshe/pages/signup_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
  );
  await EasyLocalization.ensureInitialized();
  await SharedPreferences.getInstance();
  FirebaseAuth.instance.setLanguageCode('en'); 
runApp( 
  EasyLocalization(
    supportedLocales: [Locale('en'), Locale('ta')],
    path: 'assets/langs',
    fallbackLocale: Locale('en'),
    useOnlyLangCode: true,
    child: MyApp(),
  ),
);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      home: const AuthPage()
      //const AuthPage(),
    );
  }
}

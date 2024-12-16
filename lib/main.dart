import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:hadadi/pages/base_layout/player/base_layout.dart';

import 'pages/authentication/login_page/change_password_screen.dart';
import 'pages/welcome_page/welcome_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  var delegate = await LocalizationDelegate.create(
    fallbackLocale: 'he',
    supportedLocales: ['en', 'he'],
  );
  await delegate.changeLocale(const Locale('he'));

  runApp(
    LocalizedApp(
      delegate,
      const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    var localizationDelegate = LocalizedApp.of(context).delegate;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF1F1F1),
      ),
      routes: {
        '/home': (context) => const BaseLayout(isGuest: false),
        '/changePassword': (context) => const ChangePasswordScreen(),
        '/welcome': (context) => const WelcomePage(),
      },
      locale: localizationDelegate.currentLocale,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        localizationDelegate
      ],
      supportedLocales: localizationDelegate.supportedLocales,
      home: _buildHomePage(),
    );
  }

  Widget _buildHomePage() {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      return const BaseLayout(isGuest: false);
    } else {
      return const WelcomePage();
    }
  }
}

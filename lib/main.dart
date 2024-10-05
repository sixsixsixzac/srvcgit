import 'package:flutter/material.dart';
import 'package:srvc/Auth/AuthController.dart';
import 'package:provider/provider.dart';
import 'package:srvc/Models/Family.dart';
import 'package:srvc/Pages/HomePage.dart';
import 'package:srvc/Pages/LoginPage.dart';
import 'package:srvc/Pages/PlanPage.dart';
import 'package:srvc/Pages/SettingPage.dart';
import 'package:srvc/Pages/StudyPage.dart';
import 'package:srvc/Pages/WalletPage.dart';
import 'package:srvc/Providers/FetchingHome.dart';
import 'package:srvc/Services/IndexProvider.dart';
import 'package:srvc/Services/auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => IndexProvider()),
        ChangeNotifierProvider(create: (_) => FamilyModel()),
        ChangeNotifierProvider(create: (_) => UserDataProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const baseTextStyle = TextStyle(
      color: Colors.black,
      fontFamily: 'thaifont',
    );
    return MaterialApp(
      routes: {
        '/Home': (context) => const HomePage(),
        '/Login': (context) => const LoginPage(),
        '/Study': (context) => const StudyPage(),
        '/Setting': (context) => const SettingPage(),
        '/Report': (context) => const ReportPage(),
        '/Wallet': (context) => const WalletPage(),
      },
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          primary: Colors.deepPurple,
          secondary: Colors.amber,
          surface: Colors.white,
          background: Colors.grey[100]!,
          error: Colors.red,
          onPrimary: Colors.white,
          onSecondary: Colors.black,
          onSurface: Colors.black,
          onBackground: Colors.black,
          onError: Colors.white,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.deepPurple,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        buttonTheme: const ButtonThemeData(
          buttonColor: Colors.deepPurple,
          textTheme: ButtonTextTheme.primary,
        ),
        textTheme: const TextTheme(
          titleSmall: baseTextStyle,
          titleMedium: baseTextStyle,
          titleLarge: baseTextStyle,
          bodyMedium: baseTextStyle,
          bodySmall: baseTextStyle,
          bodyLarge: baseTextStyle,
          displaySmall: baseTextStyle,
          displayMedium: baseTextStyle,
          displayLarge: baseTextStyle,
          headlineSmall: baseTextStyle,
          headlineMedium: baseTextStyle,
          headlineLarge: baseTextStyle,
          labelSmall: baseTextStyle,
          labelMedium: baseTextStyle,
          labelLarge: baseTextStyle,
        ),
        cardTheme: CardTheme(
          color: Colors.white,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
        ),
      ),
      home: const Authcontroller(),
    );
  }
}

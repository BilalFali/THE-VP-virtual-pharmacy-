import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:the_vp/services/category.dart';
import 'package:the_vp/services/google_signin.dart';
import 'package:the_vp/services/medcine.dart';
import 'package:the_vp/services/user.dart';
import 'package:the_vp/views/splashScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider<GoogleSignInProvider>(
        create: (context) => GoogleSignInProvider()),
    ChangeNotifierProvider<MedicineCategoryProvider>(
        create: (context) => MedicineCategoryProvider()),
    ChangeNotifierProvider<MedicineProvider>(
        create: (context) => MedicineProvider()),
    ChangeNotifierProvider<UserProvider>(create: (context) => UserProvider()),
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        localizationsDelegates: [
          GlobalCupertinoLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [
          Locale("ar", "AE"), // OR Locale('ar', 'AE') OR Other RTL locales
        ],
        debugShowCheckedModeBanner: false,
        title: '',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: SplashScreenView());
  }
}

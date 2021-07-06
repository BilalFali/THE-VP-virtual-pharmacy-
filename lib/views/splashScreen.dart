import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:the_vp/utils/tools.dart';
import 'package:the_vp/views/login.dart';
import 'package:the_vp/views/start.dart';

class SplashScreenView extends StatelessWidget {
  const SplashScreenView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 3,
      navigateAfterSeconds: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            return StartPage();
          } else if (snapshot.hasError) {
            return Center(child: Text("Has error"));
          } else {
            return LoginPage();
          }
        },
      ),
      loaderColor: Tools.greenColor1,
      image: Image.asset('assets/images/logo.png'),
      backgroundColor: Tools.whiteColor,
      photoSize: 150.0,
    );
  }

  Future<bool> _checkConnectivity() async {
    var connResult = await (Connectivity().checkConnectivity());
    if (connResult == ConnectivityResult.none) {
      return false;
    }
    if (connResult == ConnectivityResult.mobile ||
        connResult == ConnectivityResult.wifi) {
      return true;
    }
  }
}

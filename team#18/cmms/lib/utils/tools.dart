import 'package:cmms/pages/homepage.dart';
import 'package:cmms/pages/register.dart';
import 'package:cmms/pages/splashScreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Tools {
  static void changeLanguage(bool isHindi) {}

  static signInHandler() {
    return StreamBuilder<FirebaseUser>(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting ||
            snapshot.connectionState == ConnectionState.none) {
          return SplashScreen();
        } else {
          if (snapshot.hasData) {
            return HomePage(
              user: snapshot.data,
            );
          }
          return Register();
        }
      },
    );
  }
}

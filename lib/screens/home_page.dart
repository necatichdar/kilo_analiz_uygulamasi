import 'package:flutter/material.dart';
import 'package:kilo_analiz_uygulamasi/screens/login_page.dart';
import 'package:kilo_analiz_uygulamasi/screens/splash_screen.dart';
import 'package:kilo_analiz_uygulamasi/screens/user_screen.dart';
import 'package:kilo_analiz_uygulamasi/services/db.dart';
import 'package:kilo_analiz_uygulamasi/services/user_repository.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var userRepo = Provider.of<UserRepository>(context);
    // return Consumer(builder: (context, UserRepository userRepo, child) {
    //
    // });
    final db = DatabaseService();
    switch (userRepo.durum) {
      case userDurumu.IDLE:
        print("IDLE");
        return SplashScreen();
      case userDurumu.OTURUMACILIYOR:
      case userDurumu.OTURUMACILMAMIS:
        print("OTURUMACILMAMIS");
        return LoginPage();
      case userDurumu.OTURUMACIK:
        print("OTURUMACIK");
        return UserScreen();
    }
  }
}

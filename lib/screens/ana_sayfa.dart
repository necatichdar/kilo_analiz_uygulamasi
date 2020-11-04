import 'package:flutter/material.dart';
import 'package:kilo_analiz_uygulamasi/services/yetkilendirme_servisi.dart';

class AnaSayfa extends StatefulWidget {
  @override
  _AnaSayfaState createState() => _AnaSayfaState();
}

class _AnaSayfaState extends State<AnaSayfa> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: InkWell(
              onTap: () async{
                await YetkilendirmeServisi().cikisYap();
              },
              child: Text("Cikis Yap"))),
    );
  }
}

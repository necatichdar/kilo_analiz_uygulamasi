import 'package:flutter/material.dart';
import 'package:kilo_analiz_uygulamasi/screens/ana_sayfa.dart';
import 'package:kilo_analiz_uygulamasi/screens/giris_sayfasi.dart';
import 'package:kilo_analiz_uygulamasi/services/yetkilendirme_servisi.dart';

import 'models/kullanici.dart';

class Yonlendirme extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: YetkilendirmeServisi().durumTakipcisi,
      builder: (context, snapshot) {
        //Baglanti Bekleniyorsa
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        //Kullanici Objesi Varsa
        if (snapshot.hasData) {
          Kullanici aktifKullanici = snapshot.data;
          return AnaSayfa();
        } else {
          return GirisSayfasi();
        }
      },
    );
  }
}

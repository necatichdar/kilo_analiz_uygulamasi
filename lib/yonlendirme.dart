import 'package:flutter/material.dart';
import 'package:kilo_analiz_uygulamasi/screens/ana_sayfa.dart';
import 'package:kilo_analiz_uygulamasi/screens/giris_sayfasi.dart';
import 'package:kilo_analiz_uygulamasi/services/yetkilendirme_servisi.dart';
import 'package:provider/provider.dart';

import 'models/kullanici.dart';

class Yonlendirme extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _yetkilendirmeServisi =
        Provider.of<YetkilendirmeServisi>(context, listen: false);
    return StreamBuilder(
      stream: _yetkilendirmeServisi.durumTakipcisi,
      builder: (context, snapshot) {
        //Baglanti Bekleniyorsa
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        //Kullanici Objesi Varsa
        if (snapshot.hasData) {
          Kullanici aktifKullanici = snapshot.data;
          _yetkilendirmeServisi.aktifKullaniciId = aktifKullanici.id;
          return AnaSayfa();
        } else {
          return GirisSayfasi();
        }
      },
    );
  }
}

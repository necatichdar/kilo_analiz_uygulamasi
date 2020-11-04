import 'package:flutter/material.dart';
import 'package:kilo_analiz_uygulamasi/models/kullanici.dart';
import 'package:kilo_analiz_uygulamasi/services/firestore_servisi.dart';
import 'package:kilo_analiz_uygulamasi/services/yetkilendirme_servisi.dart';
import 'package:provider/provider.dart';

class PageFive extends StatefulWidget {
  final String profilSahibiId;

  const PageFive({Key key, this.profilSahibiId}) : super(key: key);

  @override
  _PageFiveState createState() => _PageFiveState();
}

class _PageFiveState extends State<PageFive> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Kullanici Adi'),
        backgroundColor: Colors.transparent,
        elevation: 1,
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app_outlined),
            onPressed: _cikisYap,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
          return await Future.delayed(Duration(seconds: 1));
        },
        child: FutureBuilder<Object>(
            future: FirestoreServisi().kullaniciGetir(widget.profilSahibiId),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return ListView(
                children: [
                  _profilDetaylari(snapshot.data),
                ],
              );
            }),
      ),
    );
  }

  Widget _profilDetaylari(Kullanici profildata) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.red,
                radius: 50,
                backgroundImage: profildata.fotoUrl.isEmpty
                    ? NetworkImage(profildata.fotoUrl)
                    : AssetImage("assets/images/defaultprofillogo.png"),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _sayac(baslik: "Gönderiler", sayi: 20),
                    _sayac(baslik: "Takipçi", sayi: 384),
                    _sayac(baslik: "Takip", sayi: 22),
                  ],
                ),
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            profildata.kullaniciAdi,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(profildata.hakkinda),
          SizedBox(
            height: 25,
          ),
          _profiliDuzenle()
        ],
      ),
    );
  }

  Widget _profiliDuzenle() {
    return Container(
      width: double.infinity,
      child: OutlineButton(
        onPressed: () {},
        child: Text("Profili Duzenle"),
      ),
    );
  }

  Widget _sayac({String baslik, int sayi}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          sayi.toString(),
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 2,
        ),
        Text(
          baslik,
          style: TextStyle(
            fontSize: 15,
          ),
        )
      ],
    );
  }

  void _cikisYap() {
    Provider.of<YetkilendirmeServisi>(context, listen: false).cikisYap();
  }
}

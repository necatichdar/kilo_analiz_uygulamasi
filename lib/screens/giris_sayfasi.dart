import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kilo_analiz_uygulamasi/screens/hesap_olustur.dart';

class GirisSayfasi extends StatefulWidget {
  @override
  _GirisSayfasiState createState() => _GirisSayfasiState();
}

class _GirisSayfasiState extends State<GirisSayfasi> {
  final _formAnahtari = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
        children: [
          _sayfaElemanlari(size),
          _loadingAnimation(),
        ],
      ),
    );
  }

  Widget _loadingAnimation() {
    if (loading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return Center();
    }
  }

  Widget _sayfaElemanlari(Size size) {
    return Form(
      key: _formAnahtari,
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 60),
        children: [
          Image.network(
            'https://cdn.pixabay.com/photo/2017/08/24/07/40/abstract-2675672_1280.png',
            height: size.height * 0.25,
          ),
          SizedBox(
            height: 0,
          ),
          TextFormField(
            autocorrect: true, //Otomatik Tamamlama
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: "E-mail adresini giriniz",
              labelText: "E-mail",
              errorStyle: TextStyle(fontSize: 16),
              prefixIcon: Icon(
                Icons.email,
                color: Colors.red,
              ),
            ),
            validator: (girilenDeger) {
              var regex = RegExp(
                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
              //Bu fonksiyon bos dondururse girilen degerde hata yok demektir.
              girilenDeger.trim();
              if (!regex.hasMatch(girilenDeger)) {
                return "Geçerli bir mail adresi giriniz.";
              }
              return null;
            },
          ),
          SizedBox(
            height: 20,
          ),
          TextFormField(
            autocorrect: true, //Otomatik Tamamlama
            obscureText: true,
            decoration: InputDecoration(
              hintText: "Şifreyi giriniz",
              labelText: "Şifre",
              errorStyle: TextStyle(fontSize: 16),
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.red,
              ),
            ),
            validator: (girilenDeger) {
              //Bu fonksiyon bos dondururse girilen degerde hata yok demektir.
              if (girilenDeger.isEmpty) {
                return "Sifre alanı boş bırakılamaz.";
              } else if (girilenDeger.trim().length < 6) {
                return "Sifre 6 karakterden az olamaz!";
              }
              return null;
            },
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Expanded(
                child: FlatButton(
                  color: Theme.of(context).primaryColor,
                  onPressed: () {
                    Navigator.of(context).push(CupertinoPageRoute(
                      builder: (context) => HesapOlustur(),
                    ));
                  },
                  child: Text(
                    "Hesap Olustur",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 30),
              Expanded(
                child: FlatButton(
                  color: Theme.of(context).primaryColorDark,
                  onPressed: () {
                    _girisYap();
                  },
                  child: Text(
                    "Giriş Yap",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Center(child: Text("veya")),
          SizedBox(
            height: 20,
          ),
          Center(
              child: Text(
            "Google Ile Giris Yap",
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
          )),
          SizedBox(
            height: 20,
          ),
          Center(child: Text("Sifremi Unuttum")),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  void _girisYap() {
    if (_formAnahtari.currentState.validate()) {
      print("Giris islemi yapilabilir.");
      setState(() {
        loading = true;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Oturum Açılamadı"),
      ));
    }
  }
}

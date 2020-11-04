import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kilo_analiz_uygulamasi/screens/hesap_olustur.dart';
import 'package:kilo_analiz_uygulamasi/services/yetkilendirme_servisi.dart';
import 'package:provider/provider.dart';

class GirisSayfasi extends StatefulWidget {
  @override
  _GirisSayfasiState createState() => _GirisSayfasiState();
}

class _GirisSayfasiState extends State<GirisSayfasi> {
  final _formAnahtari = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool loading = false;
  String email, sifre;

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
            autocorrect: true,
            //Otomatik Tamamlama
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
            onSaved: (newValue) => email = newValue,
          ),
          SizedBox(
            height: 20,
          ),
          TextFormField(
            autocorrect: true,
            //Otomatik Tamamlama
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
            onSaved: (newValue) => sifre = newValue,
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
              child: InkWell(
            onTap: googleIleGiris,
            child: Text(
              "Google Ile Giris Yap",
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
            ),
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

  Future<void> _girisYap() async {
    final _yetkilendirmeServisi =
        Provider.of<YetkilendirmeServisi>(context, listen: false);
    var _formState = _formAnahtari.currentState;
    if (_formState.validate()) {
      _formState.save();
      print("Giris islemi yapilabilir.");

      setState(() {
        loading = true;
      });
      try {
        await _yetkilendirmeServisi.mailIleGiris(email, sifre);
      } catch (hata) {
        setState(() {
          loading = false;
        });
        uyariGoster(hataKodu: hata.code);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Lütfen alanları doldurunuz."),
      ));
    }
  }

  void googleIleGiris() async {
    final _yetkilendirmeServisi =
        Provider.of<YetkilendirmeServisi>(context, listen: false);

    setState(() {
      loading = true;
    });
    try{
      await _yetkilendirmeServisi.googleIleGiris(email, sifre);
    }catch(hata){
      setState(() {
        loading = false;
      });
      uyariGoster(hataKodu: hata.code);
    }
  }

  uyariGoster({hataKodu}) {
    String hataMesaji = "";

    if (hataKodu == "user-disabled") {
      hataMesaji = "Kullanıcı devre dışı.";
    } else if (hataKodu == "invalid-email") {
      hataMesaji = "Girdiğiniz mail adresi geçersizdir";
    } else if (hataKodu == "user-not-found") {
      hataMesaji = "Girilen kullanıcı adı hatalı";
    } else if (hataKodu == "wrong-password") {
      hataMesaji = "Girilen şifre hatalı";
    } else {
      hataMesaji = "Tanımlanamayan bir hata oluştu";
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(hataMesaji),
      ),
    );
  }
}
/*
**invalid-email**:
Thrown if the email address is not valid.
**user-disabled**:
Thrown if the user corresponding to the given email has been disabled.
**user-not-found**:
Thrown if there is no user corresponding to the given email.
**wrong-password**:
Thrown if the password is invalid for the given email, or the account corresponding to the email does not have a password set.
 */

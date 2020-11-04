import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kilo_analiz_uygulamasi/services/yetkilendirme_servisi.dart';
import 'package:provider/provider.dart';

class HesapOlustur extends StatefulWidget {
  @override
  _HesapOlusturState createState() => _HesapOlusturState();
}

class _HesapOlusturState extends State<HesapOlustur> {
  bool loading = false;
  final _formAnahtari = GlobalKey<FormState>();
  String kullaniciAdi, email, sifre;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hesap Oluştur"),
      ),
      body: ListView(
        children: [
          loading
              ? LinearProgressIndicator()
              : SizedBox(
                  height: 4,
                ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formAnahtari,
              child: Column(
                children: [
                  TextFormField(
                    autocorrect: true,
                    //Otomatik Tamamlama
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      hintText: "Kullanıcı adını giriniz",
                      labelText: "Kullanıcı Adı",
                      errorStyle: TextStyle(fontSize: 16),
                      prefixIcon: Icon(
                        Icons.account_circle,
                        color: Colors.red,
                      ),
                    ),
                    validator: (girilenDeger) {
                      if (girilenDeger.isEmpty) {
                        return "Kullanıcı adı boş bırakılamaz.";
                      } else if (girilenDeger.trim().length < 4 ||
                          girilenDeger.trim().length > 12) {
                        return "En az 4 en fazla 12 karakter olabilir!";
                      }
                      return null;
                    },
                    onSaved: (newValue) => kullaniciAdi = newValue.trim(),
                  ),
                  SizedBox(
                    height: 10,
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
                    height: 10,
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
                    height: 30,
                  ),
                  Container(
                    width: double.infinity,
                    child: FlatButton(
                      color: Theme.of(context).primaryColor,
                      onPressed: () {
                        _kullaniciOlustur();
                      },
                      child: Text(
                        "Hesap Olustur",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> _kullaniciOlustur() async {
    final _yetkilendirmeServisi =
        Provider.of<YetkilendirmeServisi>(context, listen: false);
    var _formState = _formAnahtari.currentState;
    if (_formState.validate()) {
      _formState.save();
      setState(() {
        loading = true;
      });
      try {
        await _yetkilendirmeServisi.mailIleKayit(email, sifre);
        Navigator.pop(context);
      } catch (hata) {
        print(hata.code);
        setState(() {
          loading = false;
        });
        uyariGoster(hataKodu: hata.code);
      }
    }
  }

  uyariGoster({hataKodu}) {
    String hataMesaji = "";

    if (hataKodu == "email-already-in-use") {
      hataMesaji = "Girdiğiniz mail adresi kayıtlıdır.";
    } else if (hataKodu == "invalid-email") {
      hataMesaji = "Girdiğiniz mail adresi geçersizdir";
    } else if (hataKodu == "operation-not-allowed") {
      hataMesaji = "İşleme izin verilemiyor.";
    } else if (hataKodu == "weak-password") {
      hataMesaji = "Daha zor bir şifre tercih edin";
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

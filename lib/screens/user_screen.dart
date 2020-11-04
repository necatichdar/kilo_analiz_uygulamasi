import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kilo_analiz_uygulamasi/models/models.dart';
import 'package:kilo_analiz_uygulamasi/services/db.dart';
import 'package:kilo_analiz_uygulamasi/services/user_repository.dart';
import 'package:provider/provider.dart';

class UserScreen extends StatefulWidget {
  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  var formKey = GlobalKey<FormState>();
  final _nameKey = TextEditingController();
  final _kiloKey = TextEditingController();
  final _yasKey = TextEditingController();
  final _boyKey = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var userRepo = Provider.of<UserRepository>(context);
    final db = DatabaseService();
//    var kisi;
    return StreamBuilder<Model>(
        stream: db.streamModel(userRepo.user.uid),
        builder: (context, snapshot) {
          var kisi = snapshot.data;
          if (kisi != null) {
            return Scaffold(
              appBar: AppBar(
                title: Text("Kilo Analiz Uygulaması"),
                automaticallyImplyLeading: false,
                actions: [
                  IconButton(
                    icon: Icon(Icons.settings),
                    onPressed: () {
                      // Navigator.pushReplacement(
                      //     context,
                      //     MaterialPageRoute(
                      //      // builder: (context) => BilgileriGir(userRepo, db),
                      //     ));
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.exit_to_app_outlined),
                    onPressed: () {
                      userRepo.signOut();
                    },
                  ),
                ],
              ),
              body: Column(
                children: [
                  Text(
                    "Hero Dolu",
                    style: TextStyle(fontSize: 40),
                  ),
                  Text(
                    kisi.kilo.toString(),
                    style: TextStyle(fontSize: 40),
                  ),
                  Text(
                    kisi.yas.toString(),
                    style: TextStyle(fontSize: 40),
                  ),
                ],
              ),
            );
          } else {
            print("Kisi verileri yok");
            return Scaffold(
              appBar: AppBar(
                title: Text("Bilgi Girişi"),
                automaticallyImplyLeading: false,
                actions: [
                  IconButton(
                    icon: Icon(Icons.exit_to_app_outlined),
                    onPressed: () {
                      userRepo.signOut();
                    },
                    tooltip: "Çıkış Yap",
                  )
                ],
              ),
              body: Container(
                //    padding: EdgeInsets.symmetric(horizontal: 50),
                child: Form(
                  key: formKey,
                  child: ListView(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    shrinkWrap: true,
                    //mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      buildTextFormFieldName(),
                      Divider(),
                      buildTextFormFieldKilo(),
                      Divider(),
                      buildTextFormFieldYas(),
                      Divider(),
                      buildTextFormFieldBoy(),
                      Divider(),
                      Row(
                        children: [
                          RaisedButton(
                            child: Text("Geri Gel"),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          RaisedButton(
                            child: Text("Kaydet"),
                            onPressed: () {
                              db.createUser(
                                user: userRepo.user,
                                name: _nameKey.text,
                                boy: int.parse(_boyKey.text),
                                kilo: int.parse(_kiloKey.text),
                                yas: int.parse(_yasKey.text),
                              );
                            },
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          }
        });
  }


  TextFormField buildTextFormFieldName() {
    return TextFormField(
      controller: _nameKey,
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.person),
        labelText: "Name",
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        bool nameValid =
        RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%\s-]').hasMatch(value);
        if (nameValid) {
          return null;
        } else {
          return "Lütfen geçerli bir isim giriniz";
        }
      },
    );
  }

  TextFormField buildTextFormFieldKilo() {
    return TextFormField(
      controller: _kiloKey,
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
        prefixIcon: Padding(
          child: FaIcon(FontAwesomeIcons.dumbbell),
          padding: EdgeInsets.all(10),
        ),
        labelText: "Kilo (KG)",
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (20 < value.length && value.length < 300) {
          return null;
        } else {
          return "Lütfen geçerli bir kilo giriniz.";
        }
      },
    );
  }

  TextFormField buildTextFormFieldYas() {
    return TextFormField(
      controller: _yasKey,
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: const EdgeInsets.all(10.0),
          child: FaIcon(FontAwesomeIcons.birthdayCake),
        ),
        labelText: "Yaş",
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (2 < value.length && value.length < 150) {
          return null;
        } else {
          return "Lütfen geçerli bir yaş giriniz.";
        }
      },
    );
  }

  TextFormField buildTextFormFieldBoy() {
    return TextFormField(
      controller: _boyKey,
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: const EdgeInsets.all(10.0),
          child: FaIcon(FontAwesomeIcons.rulerVertical),
        ),
        labelText: "Boy (CM)",
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (50 < value.length && value.length < 300) {
          return null;
        } else {
          return "Lütfen geçerli bir boy giriniz.";
        }
      },
    );
  }
}

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class PageThree extends StatefulWidget {
  @override
  _PageThreeState createState() => _PageThreeState();
}

class _PageThreeState extends State<PageThree> {
  File dosya;
  bool yukleniyor = false;

  TextEditingController aciklamaTextController = TextEditingController();
  TextEditingController konumTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return dosya == null ? yukleButonu() : gonderiFormu();
  }

  Widget yukleButonu() {
    return IconButton(
      icon: Icon(Icons.file_upload),
      onPressed: () {
        fotografSec();
      },
    );
  }

  Widget gonderiFormu() {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Gonderi Oluştur"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              setState(() {
                dosya = null;
              });
            },
          ),
          actions: [
            IconButton(
              onPressed: () {
                print(aciklamaTextController.text);
                print(konumTextController.text);
              },
              icon: Icon(Icons.send),
            )
          ],
        ),
        body: ListView(
          children: [
            yukleniyor
                ? LinearProgressIndicator()
                : SizedBox(
                    height: 0,
                  ),
            AspectRatio(
              aspectRatio: 16.0 / 9.0,
              child: Image.file(
                dosya,
                fit: BoxFit.fitWidth,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                maxLines: 4,
                minLines: 1,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
                controller: aciklamaTextController,
                autocorrect: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Açıklama Ekle",
                  contentPadding: EdgeInsets.symmetric(horizontal: 15),
                ),
              ),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                maxLines: 1,
                autocorrect: true,
                controller: konumTextController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Konum Ekle",
                  contentPadding: EdgeInsets.symmetric(horizontal: 15),
                ),
              ),
            ),
            SizedBox(
              height: 40,
            ),
          ],
        ),
      ),
    );
  }

  fotografSec() {
    return showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Text("Gönderi Oluştur"),
          children: [
            SimpleDialogOption(
              child: Text("Fotoğraf Çek"),
              onPressed: () {
                fotoSec();
              },
            ),
            SimpleDialogOption(
              child: Text("Galeriden Yukle"),
              onPressed: () {
                galeridenSec();
              },
            ),
            SimpleDialogOption(
              child: Text("İptal"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  fotoSec() async {
    try {
      Navigator.pop(context);
      var image = await ImagePicker().getImage(
          source: ImageSource.camera,
          maxWidth: 800,
          maxHeight: 600,
          imageQuality: 70);
      setState(() {
        dosya = File(image.path);
      });
    } catch (hata) {
      print("Hata Var! ");
    }
  }

  galeridenSec() async {
    try {
      Navigator.pop(context);
      var image = await ImagePicker().getImage(
          source: ImageSource.gallery,
          maxWidth: 800,
          maxHeight: 600,
          imageQuality: 10);
      setState(() {
        dosya = File(image.path);
      });
    } catch (hata) {
      print("Hata Var! ");
    }
  }
}

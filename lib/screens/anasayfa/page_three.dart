import 'dart:io';

import 'package:flutter/material.dart';

class PageThree extends StatefulWidget {
  @override
  _PageThreeState createState() => _PageThreeState();
}

class _PageThreeState extends State<PageThree> {
  File dosya;

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
    return Center(child: Text("Yüklenen resim ve text alanları gelecek"));
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
              onPressed: () {},
            ),
            SimpleDialogOption(
              child: Text("Galeriden Yukle"),
              onPressed: () {},
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
}

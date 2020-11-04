import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreServisi {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final DateTime zaman = DateTime.now();

  kullaniciOlustur({id,email,kullaniciAdi}){
    _firestore.collection("users").doc(id).set({
      "kullaniciAdi" : kullaniciAdi,
      "email" :email,
      "fotoUrl" :"",
      "hakkinda" : "",
      "olusturulmaZamani": zaman,
    });
  }

}

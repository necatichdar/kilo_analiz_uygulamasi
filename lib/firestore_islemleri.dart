import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirestoreIslemleri extends StatefulWidget {
  @override
  _FirestoreIslemleriState createState() => _FirestoreIslemleriState();
}

class _FirestoreIslemleriState extends State<FirestoreIslemleri> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("FireStore Islemleri"),
      ),
      body: Container(
        child: Center(
            child: Column(
          children: [
            RaisedButton(
              child: Text("Veri Ekle"),
              onPressed: () {
                _veriEkle();
              },
              color: Colors.pinkAccent,
            ),
            RaisedButton(
              child: Text("Transaction Ekle"),
              onPressed: () {
                _transactionEkle();
              },
              color: Colors.lightBlueAccent,
            ),
            RaisedButton(
              child: Text("Veri Sil"),
              onPressed: () {
                _veriSil();
              },
              color: Colors.deepOrangeAccent,
            ),
            RaisedButton(
              child: Text("Veri Oku"),
              onPressed: () {
                _veriOku();
              },
              color: Colors.redAccent,
            ),
            RaisedButton(
              child: Text("Veri Sorgula"),
              onPressed: () {
                _veriSorgula();
              },
              color: Colors.cyanAccent,
            )
          ],
        )),
      ),
    );
  }

  _veriEkle() {
    Map<String, dynamic> necatiEkle = Map();
    necatiEkle['ad'] = 'Necati updated';
    necatiEkle['soyisim'] = 'Çuhadar';
    necatiEkle['para'] = 400;
    //  necatiEkle['lisansmezunu'] = true;
    _firestore
        .collection("users")
        .doc("necati_cuhadar")
        .set(necatiEkle)
        .then((value) => debugPrint("necati eklendi"));

    _firestore
        .collection("users")
        .doc("isa_cuhadar")
        .set({'ad': "Isa", 'soyad': 'Çuhadar', 'para': 100}).whenComplete(
            () => debugPrint("Isa eklendi"));
  }

  void _transactionEkle() {
    //Ilgili dökümanın kumandası
    final DocumentReference necatiRef = _firestore.doc("users/necati_cuhadar");
    _firestore.runTransaction((transaction) async {
      DocumentSnapshot necatiData = await necatiRef.get();
      if (necatiData.exists) {
        var necatininParasi = necatiData.data()['para'];
        if (necatininParasi > 100) {
          transaction.update(necatiRef, {'para': necatininParasi - 100});
          transaction.update(_firestore.doc("users/isa_cuhadar"),
              {'para': FieldValue.increment(100)});
        } else {
          debugPrint("Yetersiz Bakiye");
        }
      } else {
        debugPrint("necati dokumani yok");
      }
    });
    Duration(seconds: 2);
  }

  void _veriSil() {
    //Dokuman Silme
    _firestore
        .doc("users/ayse")
        .delete()
        .then((value) => debugPrint("silindi"))
        .catchError((onError) {
      debugPrint("Hata");
    });

    _firestore.doc('users/isa_cuhadar').update({'para': FieldValue.delete()});
  }

  Future _veriOku() async {
    //Tek bir dökümanın okunması .. ..
    DocumentSnapshot documentSnapshot =
        await _firestore.doc("users/necati_cuhadar").get();
    debugPrint("Id : " + documentSnapshot.id);
    debugPrint("Exits : " + documentSnapshot.exists.toString());
    debugPrint("Döküman stringi: " + documentSnapshot.toString());
    debugPrint("Bekleyen yazma : metadata hasPendingWrites : " +
        documentSnapshot.metadata.hasPendingWrites.toString());
    debugPrint("Cache den mi geliyor. : " +
        documentSnapshot.metadata.isFromCache.toString());
    debugPrint(".data().toString( : " + documentSnapshot.data().toString());
    debugPrint(
        "data()['ad'].toString( : " + documentSnapshot.data()['ad'].toString());
    documentSnapshot.data().forEach((key, value) {
      print("key : $key  ==== value  :  $value");
    });

    //Koleksiyonun Okunmasi
    _firestore.collection("users").get().then((querySnapshots) {
      debugPrint(querySnapshots.docs.length.toString());
      for (int i = 0; i < querySnapshots.docs.length; i++) {
        debugPrint(querySnapshots.docs[i].data().toString());
      }
    });

    //anlik degisikliklerin dinlenmesi
    DocumentReference ref =
        _firestore.collection("users").doc("necati_cuhadar");
    ref.snapshots().listen((event) {
      debugPrint("anlik  : ${event.data().toString()}");
    });

    _firestore.collection("users").snapshots().listen((event) {
      debugPrint(event.docs.length.toString());
    });
  }

  void _veriSorgula() async {
    var dokumanlar = await _firestore
        .collection("users")
        .where('email', isEqualTo: "emre@emre.com")
        .get();
 //   for (var dokuman in dokumanlar.docs) debugPrint(dokuman.data().toString());


    var limitliGetir = await _firestore.collection("users").limit(2).get();
    for (var dokuman in limitliGetir.docs) debugPrint(dokuman.data().toString());
  }
}

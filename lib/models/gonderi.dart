import 'package:cloud_firestore/cloud_firestore.dart';

class Gonderi {
  final String id;
  final String gonderiResmiUrl;
  final String aciklama;
  final String yayinlayanId;
  final int begeniSayisi;
  final String konum;

  Gonderi(
      {this.id,
      this.gonderiResmiUrl,
      this.aciklama,
      this.yayinlayanId,
      this.begeniSayisi,
      this.konum});

  //Dokumandan kullanici objesi uretir.
  //Firestore da kayitli kullaniciyi Kullaniciya atar.
  factory Gonderi.dokumandanUret(DocumentSnapshot doc) {
    return Gonderi(
      id: doc.id,
      gonderiResmiUrl: doc['gonderiResmiUrl'],
      aciklama: doc['aciklama'],
      yayinlayanId: doc['yayinlayanId'],
      begeniSayisi: doc['begeniSayisi'],
      konum: doc['konum'],
    );
  }
}

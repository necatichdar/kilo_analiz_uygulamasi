import 'package:cloud_firestore/cloud_firestore.dart';

class Model {
  final String name;
  final int kilo;
  final int yas;
  final int boy;


  Model({this.name, this.kilo, this.yas, this.boy});

  factory Model.fromMap(Map data) {
    return Model(
      name: data['name'] ?? 'Kullanici',
      kilo: data['kilo'] ?? 75,
      yas: data['yas'] ?? 25,
      boy: data['boy'] ?? 175,

    );
  }
}

// class Weapon {
//   final String id;
//   final String name;
//   final int hitpoints;
//   final String img;
//
//   Weapon({
//     this.id,
//     this.name,
//     this.hitpoints,
//     this.img,
//   });
//
//   factory Weapon.fromFirestore(DocumentSnapshot doc) {
//     Map data = doc.data();
//
//     return Weapon(
//         id: doc.id,
//         name: data['name'] ?? '',
//         hitpoints: data['hitpoints'] ?? 0,
//         img: data['img'] ?? '');
//   }
// }

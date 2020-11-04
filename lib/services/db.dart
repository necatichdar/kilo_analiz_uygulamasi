import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kilo_analiz_uygulamasi/models/models.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<Model> getHero(String id) async {
    var snap = await _db.collection('users').doc(id).get();

    return Model.fromMap(snap.data());
  }

  /// Get a stream of a single document
  Stream<Model> streamModel(String id) {
    return _db
        .collection('users')
        .doc(id)
        .snapshots()
        .map((snap) => Model.fromMap(snap.data()));
  }

  // /// Query a subcollection
  // Stream<List<Weapon>> streamWeapons(User user) {
  //   var ref = _db.collection('users').doc(user.uid).collection('weapons');
  //
  //   return ref.snapshots().map((list) =>
  //       list.docs.map((doc) => Weapon.fromFirestore(doc)).toList());
  // }

  Future<void> createModel(User user) {
    return _db
        .collection('users')
        .doc(user.uid)
        .set({'name': 'Kullanıcı : ${user.uid.substring(0, 5)}'});
  }

  Future<void> createUser(
      {User user, String name, int kilo, int yas, int boy}) {
    try {
      print("User olusturuldu");
      return _db.collection('users').doc(user.uid).set(
          {'name': name, 'kilo': kilo, 'yas': yas, 'boy': boy, 'id': user.uid});
    } catch (e) {
      print("createUser hata");
      return null;
    }
  }

// Future<void> addWeapon(User user, dynamic weapon) {
//   return _db
//       .collection('users')
//       .doc(user.uid)
//       .collection('weapons')
//       .add(weapon);
// }
//
// Future<void> removeWeapon(User user, String id) {
//   return _db
//       .collection('users')
//       .doc(user.uid)
//       .collection('weapons')
//       .doc(id)
//       .delete();
// }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

enum userDurumu { IDLE, OTURUMACILMAMIS, OTURUMACILIYOR, OTURUMACIK }

class UserRepository with ChangeNotifier {
  FirebaseAuth _auth;
  User _user;
  userDurumu _durum = userDurumu.IDLE;
  GoogleSignIn _googleSignIn;

  UserRepository() {
    _auth = FirebaseAuth.instance;
    _googleSignIn = GoogleSignIn();
    _auth.authStateChanges().listen(_authStateChanges);
  }

  User get user => _user;

  set user(User value) {
    _user = value;
  }

  userDurumu get durum => _durum;

  set durum(userDurumu value) {
    _durum = value;
  }

  Future<bool> signIn(String email, String sifre) async {
    try {
      _durum = userDurumu.OTURUMACILIYOR;
      notifyListeners();
      await _auth.signInWithEmailAndPassword(email: email, password: sifre);
      return true;
    } catch (e) {
      _durum = userDurumu.OTURUMACILMAMIS;
      print("signIn Error $e");
      notifyListeners();
      return false;
    }
  }

  void _register(email, sifre) async {
    final User user = (await _auth.createUserWithEmailAndPassword(
      email: email,
      password: sifre,
    ))
        .user;
  }

  Future signOut() async {
    _auth.signOut();
    _googleSignIn.signOut();
    _durum = userDurumu.OTURUMACILMAMIS;
    notifyListeners();
    return Future.delayed(Duration.zero);
  }

  Future<bool> signWithGoogle() async {
    try {
      _durum = userDurumu.OTURUMACILIYOR;
      notifyListeners();
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      await _auth.signInWithCredential(credential);
      return true;
    } catch (e) {
      debugPrint(e);
      _durum = userDurumu.OTURUMACILMAMIS;
      notifyListeners();
      return false;
    }
  }

  Future<void> _authStateChanges(User user) async {
    if (user == null) {
      _durum = userDurumu.OTURUMACILMAMIS;
    } else {
      _user = user;
      _durum = userDurumu.OTURUMACIK;
    }
    notifyListeners();
  }
}

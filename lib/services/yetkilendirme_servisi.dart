import 'package:firebase_auth/firebase_auth.dart';
import 'package:kilo_analiz_uygulamasi/models/kullanici.dart';

class YetkilendirmeServisi {
  //Authectication Objesi
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  //Yeni bir kullanici olusturmayi saglar
  Kullanici _kullaniciOlustur(User kullanici) {
    return kullanici == null ? null : Kullanici.firebasedenUret(kullanici);
  }

  //
  Stream<Kullanici> get durumTakipcisi {
    return _firebaseAuth.authStateChanges().map(_kullaniciOlustur);
  }

  Future<Kullanici> mailIleKayit(String eposta, String sifre) async {
    var girisKarti = await _firebaseAuth.createUserWithEmailAndPassword(
        email: eposta, password: sifre);
    return _kullaniciOlustur(girisKarti.user);
  }

  Future<Kullanici> mailIleGiris(String eposta, String sifre) async {
    var girisKarti = await _firebaseAuth.signInWithEmailAndPassword(
        email: eposta, password: sifre);
    return _kullaniciOlustur(girisKarti.user);
  }

  Future<void> cikisYap() async {
    return await _firebaseAuth.signOut();
  }
}

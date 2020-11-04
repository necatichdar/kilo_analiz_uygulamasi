import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kilo_analiz_uygulamasi/models/kullanici.dart';

class YetkilendirmeServisi {
  //Authectication Objesi
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static GoogleSignIn _googleSignIn = GoogleSignIn();

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
    await _firebaseAuth.signOut();//Google icin tek basina yeterli degil.
    //await FirebaseAuth.instance.signOut();
    await _googleSignIn.signOut();
  }

  Future<Kullanici> googleIleGiris(String eposta, String sifre) async {
    //  GoogleSignInAccount googleHesabi = await GoogleSignIn().signIn();
    GoogleSignInAccount googleHesabi = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleYetkiKartim =
        await googleHesabi.authentication;
    OAuthCredential sifresizGirisBelgesi = GoogleAuthProvider.credential(
        accessToken: googleYetkiKartim.accessToken,
        idToken: googleYetkiKartim.idToken);
    UserCredential girisKarti =
        await _firebaseAuth.signInWithCredential(sifresizGirisBelgesi);
    return _kullaniciOlustur(girisKarti.user);
  }
}

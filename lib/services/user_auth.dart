import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserAuth extends ChangeNotifier {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<User?> mysignInAnonymously() async {

    try{
      UserCredential _userCredantial = await _firebaseAuth.signInAnonymously();

      return _userCredantial.user;
    } on FirebaseAuthException catch(error) {
      print('Yakalanan Hata Kodu: ${error.code}');
      print('Yakalanan Hata Mesajı: ${error.message}');
      rethrow;
    }

  }

  /// e-mail ile bir kullanıcı hesabı oluşturur ve otomatik olarak login olmasını sağlar.
  Future<User?> myCreateUserWithEmailAndPassword(
      {required String email, required String password}) async {

    try {
      UserCredential _userCredantial = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      return _userCredantial.user;
    } on FirebaseAuthException catch(error) {
      print('Yakalanan Hata Kodu: ${error.code}');
      print('Yakalanan Hata Mesajı: ${error.message}');
      rethrow;
    }

  }

  Future<User?> mySignInWithEmailAndPassword(
      {required String email, required String password}) async {

    try {
      UserCredential _userCredantial = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      return _userCredantial.user;
    } on FirebaseAuthException catch(error) {
      print('Yakalanan Hata Kodu: ${error.code}');
      print('Yakalanan Hata Mesajı: ${error.message}');
      rethrow;
    }

  }

  Future<void> mySignOut() async {

    try {
      await _firebaseAuth.signOut();
      await GoogleSignIn().signOut();
    } on FirebaseAuthException catch(error) {
      print('Yakalanan Hata Kodu: ${error.code}');
      print('Yakalanan Hata Mesajı: ${error.message}');
      rethrow;
    }

  }

  Future<void> myAuthStateChanges() async {

    try{
      var user =
      await FirebaseAuth.instance.authStateChanges().listen((User? user) {
        if (user == null) {
          print('user signed in');
        } else {
          print('user signed out');
        }
      });
    } on FirebaseAuthException catch(error) {
      print('Yakalanan Hata Kodu: ${error.code}');
      print('Yakalanan Hata Mesajı: ${error.message}');
      rethrow;
    }


  }

  Future<void> mySendEmailVerification() async {

    try {
      _firebaseAuth.currentUser?.sendEmailVerification();
    } on FirebaseAuthException catch(error) {
      print('Yakalanan Hata Kodu: ${error.code}');
      print('Yakalanan Hata Mesajı: ${error.message}');
      rethrow;
    }

  }

  Future<void> mySendPasswordResetEmail({required String email}) async {

    try {
      _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch(error) {
      print('Yakalanan Hata Kodu: ${error.code}');
      print('Yakalanan Hata Mesajı: ${error.message}');
      rethrow;
    }

  }

  Future<User?> mySignInWithGoogle() async {

    try {
      // Google'da oturum açma işlemini başlatıyor
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // GoogleSignInAuthentication nesnesi, Google oturum açma işlemini doğrulamak için kullanılan bir nesnedir.
      // sign olduktan sonra accessToken ve idToken bilgisini tutar.
      final GoogleSignInAuthentication? googleAuth =
      await googleUser?.authentication;

      // GoogleAuthProvider sınıfı, Google oturum açma işlemini gerçekleştiren bir sınıftır
      // credential metodu,  Google oturum açma işlemini doğrulamak için kullanılan bir credential nesnesi oluşturur.
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      UserCredential _userCredential =
      await FirebaseAuth.instance.signInWithCredential(credential);

      return _userCredential.user;
    } on FirebaseAuthException catch(error) {
      print('Yakalanan Hata Kodu: ${error.code}');
      print('Yakalanan Hata Mesajı: ${error.message}');
      rethrow;
    }

  }

}

import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<UserModel?> get userStream {
    return _auth.authStateChanges().map((user) {
      if (user == null) return null;
      return UserModel(uid: user.uid, email: user.email);
    });
  }

  Future<UserModel?> signIn(String email, String password) async {
    final cred = await _auth.signInWithEmailAndPassword(email: email, password: password);
    final u = cred.user;
    return u == null ? null : UserModel(uid: u.uid, email: u.email);
  }

  Future<UserModel?> register(String email, String password) async {
    final cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    final u = cred.user;
    return u == null ? null : UserModel(uid: u.uid, email: u.email);
  }

  Future<void> signOut() => _auth.signOut();
  User? get currentUser => _auth.currentUser;
}

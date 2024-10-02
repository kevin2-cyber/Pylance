import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:timily/app/auth/repository/auth_repository.dart';
import 'package:timily/app/auth/repository/user_firestore.dart';


class AuthenticationProvider extends ChangeNotifier {
  AuthRepository repository = AuthRepository();
  AuthFirestore firestore = AuthFirestore();

  User? _user;

  User? get user => _user;

  Stream onAuthStateChanges() => repository.authStateChanges;

  AuthenticationProvider() {
    repository.authStateChanges.listen(_onAuthStateChanged);
  }

  // sign in with email and password
  Future<void> emailSignIn(String email, String password) async {
    try {
      await repository.login(email,password);
    } catch (e) {
      rethrow;
    }
  }

  // sign in with google
  Future<void> loginWithGoogle() async {
    try {
      final user = await repository.signInWithGoogle();
      await firestore.saveData(user!.uid);
    } catch (e) {
      rethrow;
    }
  }

  // register with email and password
  Future<void> emailRegistration(String name, String email, String password) async {
    try {
      final user = await repository.register(name, email, password);
      await firestore.saveData(user!.uid, email, name);
    } catch (e) {
      rethrow;
    }
  }

  // log out
  Future<void> logout() async {
    try {
      await repository.signOut();
    } catch (e) {
      rethrow;
    }
  }

  // reset password
  Future<void> resetPassword(String email) async {
    try {
      await repository.resetPassword(email);
    }  catch (e) {
      rethrow;
    }
  }

  void _onAuthStateChanged(User? user) {
    _user = user;
    notifyListeners();
  }
}


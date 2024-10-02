import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthenProvider with ChangeNotifier {
  User? _user;
  String? _role;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get user => _user;
  String? get role => _role;

  AuthenProvider() {
    _checkAuthState();
  }

  Future<void> _checkAuthState() async {
    _user = _auth.currentUser;
    if (_user != null) {
      await _fetchUserRole();
    }
    notifyListeners();
  }

  Future<void> signInWithEmail(String email, String password) async {
    UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
    _user = result.user;
    await _fetchUserRole();
    notifyListeners();
  }

  Future<void> registerWithEmail(String email, String password, String name, String role) async {
    UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    _user = result.user;

    // Store user data in Firestore
    await FirebaseFirestore.instance.collection('users').doc(_user!.uid).set({
      'email': email,
      'name': name,
      'role': role,
    });

    _role = role;
    notifyListeners();
  }

  Future<void> signOut() async {
    await _auth.signOut();
    _user = null;
    _role = null;
    notifyListeners();
  }

  Future<void> _fetchUserRole() async {
    if (_user != null) {
      DocumentSnapshot doc = await FirebaseFirestore.instance.collection('users').doc(_user!.uid).get();
      _role = doc['role'];
    }
  }

  Stream<User?> onAuthStateChange() {
    return _auth.authStateChanges();
  }
}

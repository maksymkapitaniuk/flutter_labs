import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> signUp(
    String email,
    String password,
    String firstName,
    String lastName,
  ) async {
    try {
      final UserCredential credential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      if (credential.user != null) {
        await _firestore.collection('users').doc(credential.user!.uid).set({
          'uid': credential.user!.uid,
          'email': email,
          'firstName': firstName,
          'lastName': lastName,
          'registrationDate': FieldValue.serverTimestamp(),
          'role': 'user',
        });
      }

      return credential.user;
    } on FirebaseAuthException {
      rethrow;
    }
  }

  Future<User?> signIn(String email, String password) async {
    try {
      final UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } on FirebaseAuthException {
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  User? get currentUser => _auth.currentUser;

  Future<DocumentSnapshot> getUserData() async {
    if (currentUser == null) throw Exception('No user logged in');
    return await _firestore.collection('users').doc(currentUser!.uid).get();
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eltracker_app/models/user_model.dart';

// ignore: constant_identifier_names
const String USER_COLLECTION_REF = 'users';

class DbService {
  final _firestore = FirebaseFirestore.instance;

  late final CollectionReference<UserModel> _userRef;

  DbService() {
    _userRef = _firestore
        .collection(USER_COLLECTION_REF)
        .withConverter<UserModel>(
          fromFirestore: (snapshot, _) => UserModel.fromJson(snapshot.data()!),
          toFirestore: (user, _) => user.toJson(),
        );
  }

  Stream<QuerySnapshot> getUsers() {
    return _userRef.snapshots();
  }

  void addUser(UserModel user, String uid) async {
    _userRef.doc(uid).set(user);
  }

  Future<UserModel?> getUser(String userId) async {
    try {
      DocumentSnapshot<UserModel> snapshot = await _userRef.doc(userId).get();
      return snapshot.data();
    } catch (e) {
      // ignore: avoid_print
      print('Error getting user: $e');
      return null;
    }
  }

  // NEW: Get user as a stream (for real-time updates)
  Stream<UserModel?> getUserStream(String userId) {
    return _userRef.doc(userId).snapshots().map((snapshot) => snapshot.data());
  }
}

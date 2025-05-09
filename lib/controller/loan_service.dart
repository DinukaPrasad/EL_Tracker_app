import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eltracker_app/models/loan_modal.dart';

class LoanService {
  static const String _loanCollectionRef = 'loans';
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late final CollectionReference<LoanModal> _loansRef;

  LoanService() {
    _loansRef = _firestore
        .collection(_loanCollectionRef)
        .withConverter(
          fromFirestore: (snapshot, _) => LoanModal.fromJson(snapshot.data()!),
          toFirestore: (loan, _) => loan.toJson(),
        );
  }

  // 1. Add new loan
  Future<String> addLoan(LoanModal loan) async {
    try {
      final docRef = await _loansRef.add(loan);
      return docRef.id; // Return the auto-generated document ID
    } on FirebaseException catch (e) {
      throw Exception('Failed to add loan: ${e.message}');
    }
  }

  // 2. Get all loans (stream for real-time updates)
  Stream<QuerySnapshot<LoanModal>> getAllLoans() {
    return _loansRef.orderBy('receiveDate', descending: true).snapshots();
  }

  // 3. Get loans for a specific client
  Stream<QuerySnapshot<LoanModal>> getLoansByClient(String clientId) {
    return _loansRef
        .where('clientId', isEqualTo: clientId)
        .orderBy('receiveDate', descending: true)
        .snapshots();
  }

  // 4. Get single loan by ID
  Future<LoanModal?> getLoanById(String loanId) async {
    try {
      final doc = await _loansRef.doc(loanId).get();
      return doc.data();
    } on FirebaseException catch (e) {
      throw Exception('Failed to get loan: ${e.message}');
    }
  }

  // 5. Update loan details
  Future<void> updateLoan(String loanId, LoanModal updatedLoan) async {
    try {
      await _loansRef.doc(loanId).update(updatedLoan.toJson());
    } on FirebaseException catch (e) {
      throw Exception('Failed to update loan: ${e.message}');
    }
  }

  // 6. Delete loan
  Future<void> deleteLoan(String loanId) async {
    try {
      await _loansRef.doc(loanId).delete();
    } on FirebaseException catch (e) {
      throw Exception('Failed to delete loan: ${e.message}');
    }
  }

  // 7. Get loans with pagination (optional)
  Future<QuerySnapshot<LoanModal>> getLoansPaginated({
    required int limit,
    DocumentSnapshot? lastDocument,
  }) async {
    Query<LoanModal> query = _loansRef
        .orderBy('receiveDate', descending: true)
        .limit(limit);

    if (lastDocument != null) {
      query = query.startAfterDocument(lastDocument);
    }

    return await query.get();
  }
}

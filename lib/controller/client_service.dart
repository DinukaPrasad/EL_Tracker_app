import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eltracker_app/models/client_modal.dart';

class ClientService {
  static const String _clientCollectionRef = 'clients';
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late final CollectionReference<ClientModal> _clientsRef;

  ClientService() {
    _clientsRef = _firestore
        .collection(_clientCollectionRef)
        .withConverter(
          fromFirestore:
              (snapshot, _) => ClientModal.fromJson(snapshot.data()!),
          toFirestore: (client, _) => client.toJson(),
        );
  }

  // 1. Add new client
  Future<void> addClient(ClientModal client) async {
    try {
      await _clientsRef.add(client);
    } on FirebaseException catch (e) {
      throw Exception('Failed to add client: ${e.message}');
    }
  }

  // 2. Get all clients (stream for real-time updates)
  Stream<QuerySnapshot<ClientModal>> getClients() {
    return _clientsRef.snapshots();
  }

  // 3. Get specific client by ID
  Future<ClientModal?> getClientById(String clientId) async {
    try {
      final doc = await _clientsRef.doc(clientId).get();
      return doc.data();
    } on FirebaseException catch (e) {
      throw Exception('Failed to get client: ${e.message}');
    }
  }

  // 4. Update client details
  Future<void> updateClient(String clientId, ClientModal updatedClient) async {
    try {
      await _clientsRef.doc(clientId).update(updatedClient.toJson());
    } on FirebaseException catch (e) {
      throw Exception('Failed to update client: ${e.message}');
    }
  }

  // 5. Delete client
  Future<void> deleteClient(String clientId) async {
    try {
      await _clientsRef.doc(clientId).delete();
    } on FirebaseException catch (e) {
      throw Exception('Failed to delete client: ${e.message}');
    }
  }

  // 6. Get clients with pagination (optional)
  Future<QuerySnapshot<ClientModal>> getClientsPaginated({
    required int limit,
    DocumentSnapshot? lastDocument,
  }) async {
    Query<ClientModal> query = _clientsRef
        .orderBy('createdAt', descending: true)
        .limit(limit);

    if (lastDocument != null) {
      query = query.startAfterDocument(lastDocument);
    }

    return await query.get();
  }
}

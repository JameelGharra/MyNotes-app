import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mynotes/services/cloud/notes_service/cloud_storage_constants.dart';

class CloudNote {
  final String documentId;
  final String ownerUserId;
  final String text;
  final DateTime timeUtc;
  bool isFavoured;

  CloudNote({
    required this.documentId,
    required this.ownerUserId,
    required this.text,
    required this.timeUtc,
    required this.isFavoured,
  });
  CloudNote.fromSnapShot(DocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.id,
        ownerUserId = snapshot.data()![ownerUserIdFieldName] as String,
        text = snapshot.data()![textFieldName] as String,
        timeUtc = (snapshot.data()![timeFieldName] as Timestamp).toDate(),
        isFavoured = snapshot.data()![isFavouredFieldName] as bool;
}

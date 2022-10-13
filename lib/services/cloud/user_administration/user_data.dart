import 'package:mynotes/services/cloud/notes_service/cloud_note.dart';

class UserData {
  late String sharingDocumentId;
  String? userId;
  String? userEmail;
  List<dynamic> blockedUserIds = [];
  List<String> blockedUserEmails = [];
  List<dynamic> sharedNotesIds = [];
  List<CloudNote> sharedNotes = [];
  static final _shared = UserData._sharedInstance();

  UserData._sharedInstance();

  factory UserData() => _shared;
}

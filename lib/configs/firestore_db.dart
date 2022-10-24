import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

final Future<FirebaseApp> firebaseInitialization = Firebase.initializeApp();
FirebaseAuth auth = FirebaseAuth.instance;
FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

class FirestoreDb {
  //for Adding Alarm Data to FireStore
  static addNotes(Notes notes) async {
    await firebaseFirestore
        .collection('notes')
        .doc(auth.currentUser!.uid)
        .collection('notesData')
        .add({
      'documentId': notes.documentId,
      'title': notes.title,
      'date': notes.date,
      'description': notes.description,
    });
  }

//for Fetching Notes Data from FireStore
  Stream<List<Notes>> fetchAlarmStream() {
    return firebaseFirestore
        .collection('notes')
        .doc(auth.currentUser!.uid)
        .collection('notesData')
        .snapshots()
        .map((QuerySnapshot query) {
      List<Notes> notes = [];
      for (var todo in query.docs) {
        final alarmCreated = Notes.fromDocumentSnapshot(documentSnapshot: todo);
        notes.add(alarmCreated);
      }
      return notes;
    });
  }

//change the Value of isActive in FireStore
  static updateStatus(bool isActive, documentId) {
    firebaseFirestore
        .collection('notes')
        .doc(auth.currentUser!.uid)
        .collection('notesData')
        .doc(documentId)
        .update(
      {
        'isActive': isActive,
      },
    );
  }

//TO Delete the Alarm from FireStore when the Alarm is Deleted from the App
  deleteNotes(dynamic documentId) async {
    firebaseFirestore
        .collection('notes')
        .doc(auth.currentUser!.uid)
        .collection('notesData')
        .doc(documentId)
        .delete();
  }
}

class Notes {
  String? documentId;
  String? title;
  String? description;
  String? date;
  Notes({
    this.documentId,
    this.title,
    this.description,
    this.date,
  });

  Notes.fromDocumentSnapshot({required DocumentSnapshot documentSnapshot}) {
    documentId = documentSnapshot.id;
    title = documentSnapshot["title"];
    description = documentSnapshot["description"];
    date = documentSnapshot["date"];
  }
}

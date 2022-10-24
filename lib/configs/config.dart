import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NoteMakerApp {
  static late User user;
  static late FirebaseAuth auth;
  static late FirebaseFirestore firestore;

  static String collectionUser = 'users';

  //date formate
  static String dateFormat = 'dd MMM yyyy';

  String formattedDate(String date) {
    DateTime dateTime = DateTime.parse(date);
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }
}

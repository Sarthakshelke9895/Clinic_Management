import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  FirestoreService._();

  static final FirestoreService instance =
  FirestoreService._();

  final FirebaseFirestore firestore =
      FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get patients =>
      firestore.collection("patients");

  CollectionReference<Map<String, dynamic>> get queue =>
      firestore.collection("queue");

  CollectionReference<Map<String, dynamic>> get sessions =>
      firestore.collection("sessions");

  CollectionReference<Map<String, dynamic>> get users =>
      firestore.collection("users");
}
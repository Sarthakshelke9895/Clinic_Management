import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class DashboardRepository {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  String get today =>
      DateFormat('yyyy-MM-dd').format(DateTime.now());

  //==================================================
  // Total Registered Patients
  //==================================================

  Stream<int> totalPatients() {
    return firestore
        .collection("patients")
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }
  //==================================================
// Today's Queue Count (Reception Dashboard)
//==================================================

  Stream<int> todayQueueCount() {
    return firestore
        .collection("queue")
        .where("queueDate", isEqualTo: today)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  //==================================================
  // Today's Waiting Queue
  //==================================================

  Stream<int> waitingPatients() {
    return firestore
        .collection("queue")
        .where("queueDate", isEqualTo: today)
        .where("status", isEqualTo: "Waiting")
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  //==================================================
  // Today's Completed Queue
  //==================================================

  Stream<int> completedPatients() {
    return firestore
        .collection("queue")
        .where("queueDate", isEqualTo: today)
        .where("status", isEqualTo: "Completed")
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  //==================================================
  // Today's Sessions
  //==================================================

  Stream<int> todaySessions() {
    return firestore
        .collection("sessions")
        .where("sessionDate", isEqualTo: today)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }
}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

import '../../models/doctor/session_model.dart';

class SessionRepository {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final CollectionReference<Map<String, dynamic>> sessions =
  FirebaseFirestore.instance.collection("sessions");

  final CollectionReference<Map<String, dynamic>> queue =
  FirebaseFirestore.instance.collection("queue");

  //=========================================================
  // Save Session
  //=========================================================

  Future<String> saveSession(SessionModel session) async {

    final doc = await sessions.add(session.toMap());

    return doc.id;

  }

  //=========================================================
  // Update Session
  //=========================================================

  Future<void> updateSession(
      SessionModel session,
      ) async {

    if (session.id == null) {

      throw Exception(
        "Session document id is missing.",
      );

    }

    await sessions
        .doc(session.id)
        .update(session.toMap());

  }

  //=========================================================
  // Get All Sessions Of Patient
  //=========================================================

  Future<List<SessionModel>> getPatientSessions(
      String patientId) async {

    final snapshot = await sessions
        .where("patientId", isEqualTo: patientId)
        .orderBy("sessionNumber", descending: true)
        .get();

    return snapshot.docs
        .map(
          (doc) =>
          SessionModel.fromMap(doc.data(), doc.id),
    )
        .toList();
  }

  //=========================================================
  // Next Session Number
  //=========================================================

  Future<int> getNextSessionNumber(
      String patientId) async {

    final snapshot = await sessions
        .where("patientId", isEqualTo: patientId)
        .orderBy("sessionNumber", descending: true)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) {
      return 1;
    }

    final last = SessionModel.fromMap(
      snapshot.docs.first.data(),
      snapshot.docs.first.id,
    );

    return last.sessionNumber + 1;
  }

  //=========================================================
  // Delete Session
  //=========================================================

  Future<void> deleteSession(
      String sessionId) async {

    await sessions.doc(sessionId).delete();
  }

  //=========================================================
  // Mark Queue Completed
  //=========================================================

  Future<void> markPatientCompleted(
      String queueId) async {

    await queue.doc(queueId).update({

      "status": "Completed",

      "completedAt": Timestamp.now(),

    });
  }

  //=========================================================
  // Today's Completed Sessions
  //=========================================================

  Future<List<SessionModel>>
  getTodayCompletedSessions() async {

    final today =
    DateFormat('yyyy-MM-dd').format(DateTime.now());

    final snapshot = await sessions
        .where("sessionDate", isEqualTo: today)
        .orderBy("createdAt", descending: true)
        .get();

    return snapshot.docs
        .map(
          (doc) =>
          SessionModel.fromMap(doc.data(), doc.id),
    )
        .toList();
  }

  //=========================================================
  // Get Session By ID
  //=========================================================

  Future<SessionModel?> getSession(String sessionId) async {
    debugPrint("GET SESSION: collection = ${sessions.path}");
    debugPrint("GET SESSION: document id = $sessionId");

    final doc = await sessions.doc(sessionId).get();

    debugPrint("GET SESSION: exists = ${doc.exists}");

    if (!doc.exists) {
      return null;
    }

    return SessionModel.fromMap(
      doc.data()!,
      doc.id,
    );
  }


  //=========================================================
// Get Latest Session Of Patient
//=========================================================

  Future<SessionModel?> getLatestSession(
      String patientId,
      ) async {

    final snapshot = await sessions

        .where(
      "patientId",
      isEqualTo: patientId,
    )

        .orderBy(
      "sessionNumber",
      descending: true,
    )

        .limit(1)

        .get();

    if (snapshot.docs.isEmpty) {
      return null;
    }

    return SessionModel.fromMap(

      snapshot.docs.first.data(),

      snapshot.docs.first.id,

    );

  }

  //=========================================================
// Update Session Note  and date
//=========================================================

  Future<void> updateSessionNoteAndDate({
    required String sessionId,
    required String sessionNote,
    required String sessionDate,
    required String saveDate,
  }) async {
    await sessions
        .doc(sessionId)
        .update({
      // Updated Session Note
      "sessionNote": sessionNote,

      // Machine-Friendly Selected Date
      // Example: 2026-07-08
      "sessionDate": sessionDate,

      // Human-Readable Selected Date
      // Example: 8th July 2026
      "saveDate": saveDate,
    });
  }

}
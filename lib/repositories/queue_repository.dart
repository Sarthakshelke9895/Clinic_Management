import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import '../models/queue_model.dart';
import '../services/firebase/firestore_service.dart';
import '../models/patient_model.dart';

class QueueRepository {
  final _queue = FirestoreService.instance.queue;


  Future<void> updatePaymentStatus(
      String queueId,
      String paymentStatus,
      ) async {
    await FirebaseFirestore.instance
        .collection('queue')
        .doc(queueId)
        .update({
      'paymentStatus': paymentStatus,
    });
  }

  Future<void> addPatientToQueue(
      Patient patient, {
        required String doctorName,
      }) async {

    final exists =
    await isPatientAlreadyWaiting(patient.id!);

    if (exists) {
      throw Exception("Patient already in queue");
    }

    final queue = QueueModel(
      patientId: patient.id!,
      patientCode: patient.patientCode,
      patientName: patient.name,
      phone: patient.phone,
      doctorName: doctorName,


      status: "Waiting",

      queueDate:
      "${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}",

      createdAt: DateTime.now(),

      completedAt: null,

      sessionId: null,

      paymentAmount: "",

      paymentStatus: "Pending",
    );

    await addToQueue(queue);

  }
  Future<bool> isPatientInQueue(
      String patientId,
      ) async {

    return await isPatientAlreadyWaiting(
        patientId);

  }
  Future<void> addToQueue(QueueModel queueModel) async {
    await _queue.add(queueModel.toMap());
  }

  Future<List<QueueModel>> getQueue(String queueDate) async {

    debugPrint("Searching Queue Date: $queueDate");

    final snapshot = await _queue
        .where("queueDate", isEqualTo: queueDate)
        .orderBy("createdAt")
        .get();

    debugPrint("Documents Found: ${snapshot.docs.length}");

    return snapshot.docs
        .map((doc) => QueueModel.fromMap(doc.data(), doc.id))
        .toList();
  }
  Future<void> completeQueue({
    required String queueId,
    required String sessionId,
    required String paymentAmount,
    required String paymentStatus,
  }) async {

    await _queue.doc(queueId).update({

      "status": "Completed",

      "completedAt": Timestamp.now(),

      "sessionId": sessionId,

      "paymentAmount": paymentAmount,

      "paymentStatus": paymentStatus,

    });

  }

  Future<void> updateStatus(
      String id,
      String status,
      ) async {
    await _queue.doc(id).update({
      "status": status,
    });
  }

  Future<void> removePatient(String id) async {
    await _queue.doc(id).delete();
  }

  Future<bool> isPatientAlreadyWaiting(String patientId) async {

    final today =
    DateFormat('yyyy-MM-dd').format(DateTime.now());

    final result = await _queue
        .where("patientId", isEqualTo: patientId)
        .where("queueDate", isEqualTo: today)
        .where("status", isEqualTo: "Waiting")
        .get();

    return result.docs.isNotEmpty;

  }

  Future<List<QueueModel>> getWaitingQueue(String queueDate) async {

    final snapshot = await _queue
        .where("queueDate", isEqualTo: queueDate)
        .where("status", isEqualTo: "Waiting")
        .orderBy("createdAt")
        .get();

    return snapshot.docs
        .map(
          (doc) => QueueModel.fromMap(
        doc.data(),
        doc.id,
      ),
    )
        .toList();
  }

  //==================================================
// Complete Queue
//==================================================


  Future<List<QueueModel>> getCompletedQueue(
      String queueDate,
      ) async {

    final snapshot = await _queue
        .where("queueDate", isEqualTo: queueDate)
        .where("status", isEqualTo: "Completed")
        .orderBy("completedAt", descending: true)
        .get();

    return snapshot.docs
        .map(
          (doc) => QueueModel.fromMap(
        doc.data(),
        doc.id,
      ),
    )
        .toList();
  }

}

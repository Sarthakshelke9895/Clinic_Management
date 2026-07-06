import 'package:cloud_firestore/cloud_firestore.dart';

import '../services/firebase/firestore_service.dart';
import 'package:flutter/foundation.dart';
class CounterRepository {
  final FirebaseFirestore _firestore =
      FirestoreService.instance.firestore;

  Future<String> generatePatientCode() async {
    final counterRef = _firestore
        .collection("counters")
        .doc("patients");

    debugPrint("COUNTER: INCREMENT START");

    await counterRef.set(
      {
        "currentNumber": FieldValue.increment(1),
      },
      SetOptions(merge: true),
    );

    debugPrint("COUNTER: INCREMENT FINISHED");

    final snapshot = await counterRef.get();

    debugPrint("COUNTER: GET FINISHED");

    final data = snapshot.data();

    if (data == null || data["currentNumber"] == null) {
      throw Exception("Unable to generate patient code.");
    }

    final currentNumber = (data["currentNumber"] as num).toInt();

    final patientCode =
        "PT${currentNumber.toString().padLeft(6, '0')}";

    debugPrint("COUNTER: GENERATED $patientCode");

    return patientCode;
  }
}
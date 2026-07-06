import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../models/patient_model.dart';
import '../services/firebase/firestore_service.dart';

class PatientRepository {

  final CollectionReference<Map<String, dynamic>> _patients =
      FirestoreService.instance.patients;

  // ===============================
  // ADD PATIENT
  // ===============================

  Future<String> addPatient(Patient patient) async {

    final doc = await _patients.add(patient.toMap());

    return doc.id;

  }

  // ===============================
  // SEARCH BY PHONE
  // ===============================

  Future<Patient?> searchByPhone(String phone) async {

    final result = await _patients
        .where("phone", isEqualTo: phone)
        .limit(1)
        .get();

    if (result.docs.isEmpty) {
      return null;
    }

    return Patient.fromMap(
      result.docs.first.data(),
      result.docs.first.id,
    );
  }

  // ===============================
  // SEARCH BY NAME
  // ===============================

  Future<List<Patient>> searchByName(String name) async {

    final result = await _patients.get();

    return result.docs
        .map((doc) => Patient.fromMap(doc.data(), doc.id))
        .where((patient) =>
        patient.name
            .toLowerCase()
            .contains(name.toLowerCase()))
        .toList();
  }

  // ===============================
  // GET ALL PATIENTS
  // ===============================

  Future<List<Patient>> getAllPatients() async {

    final result = await _patients
        .orderBy("createdAt", descending: true)
        .get();

    return result.docs
        .map(
          (doc) => Patient.fromMap(
        doc.data(),
        doc.id,
      ),
    )
        .toList();
  }

  // ===============================
  // UPDATE PATIENT
  // ===============================

  Future<void> updatePatient(Patient patient) async {

    if (patient.id == null) {
      throw Exception("Patient document id missing.");
    }

    await _patients
        .doc(patient.id)
        .update(patient.toMap());

  }


  // ===============================
  // GENERATE PATIENT CODE
  // ===============================

  Future<String> generatePatientCode() async {

    final snapshot = await _patients.get();

    final count = snapshot.docs.length + 1;

    return "PT${count.toString().padLeft(6, '0')}";

  }

  Future<List<Patient>> searchPatients(String query) async {

    if (query.trim().isEmpty) {
      return [];
    }

    final snapshot = await _patients.get();

    final q = query.toLowerCase();

    return snapshot.docs
        .map((doc) => Patient.fromMap(doc.data(), doc.id))
        .where(
          (patient) =>
      patient.name.toLowerCase().contains(q) ||
          patient.phone.contains(query),
    )
        .toList();
  }


// ===============================
// GET PATIENT BY DOCUMENT ID
// ===============================

  Future<Patient?> getPatientById(String id) async {

    try {

      final doc = await _patients.doc(id).get();

      if (!doc.exists) {
        return null;
      }

      return Patient.fromMap(
        doc.data()!,
        doc.id,
      );

    } catch (e) {

      debugPrint(
        "Error getting patient: $e",
      );

      return null;

    }

  }

}
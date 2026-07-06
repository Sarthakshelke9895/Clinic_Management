import 'package:flutter/material.dart';

import '../models/patient_model.dart';
import '../repositories/patient_repository.dart';

class PatientSearchController {
  final PatientRepository repository = PatientRepository();

  final TextEditingController searchController =
  TextEditingController();

  Future<List<Patient>> getAllPatients() async {
    return await repository.getAllPatients();
  }

  Future<List<Patient>> searchPatients(
      String query) async {
    return await repository.searchPatients(query);
  }

  void dispose() {
    searchController.dispose();
  }
}
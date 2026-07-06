import 'package:flutter/material.dart';

import '../models/patient_model.dart';
import '../repositories/counter_repository.dart';
import '../repositories/patient_repository.dart';

class PatientFormController extends ChangeNotifier {
  final PatientRepository _patientRepository = PatientRepository();
  final CounterRepository _counterRepository = CounterRepository();

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final ageController = TextEditingController();
  final dobController = TextEditingController();
  final addressController = TextEditingController();

  String gender = "Male";

  // ===========================
  // REGISTER NEW PATIENT
  // ===========================
  Future<String> savePatient() async {
    try {
      debugPrint("1. SAVE START");

      setLoading(true);

      debugPrint("2. VALIDATING");

      if (!formKey.currentState!.validate()) {
        setLoading(false);
        return "Validation Failed";
      }

      debugPrint("3. VALIDATION SUCCESS");
      debugPrint("4. SEARCH PHONE START");

      final existing = await _patientRepository.searchByPhone(
        phoneController.text.trim(),
      );

      debugPrint("5. SEARCH PHONE FINISHED");

      if (existing != null) {
        setLoading(false);
        return "Patient already exists";
      }

      debugPrint("6. GENERATE CODE START");

      final patientCode =
      await _counterRepository.generatePatientCode();

      debugPrint("7. GENERATED CODE: $patientCode");

      final dobParts = dobController.text.split("/");

      debugPrint("8. CREATING PATIENT");

      final patient = Patient(
        patientCode: patientCode,
        name: nameController.text.trim(),
        phone: phoneController.text.trim(),
        age: int.parse(ageController.text),
        gender: gender,
        address: addressController.text.trim(),
        dob: DateTime(
          int.parse(dobParts[2]),
          int.parse(dobParts[1]),
          int.parse(dobParts[0]),
        ),
        createdAt: DateTime.now(),
      );

      debugPrint("9. PATIENT CREATED");
      debugPrint("10. ADD PATIENT START");

      await _patientRepository.addPatient(patient);

      debugPrint("11. ADD PATIENT FINISHED");

      setLoading(false);

      debugPrint("12. CLEAR FORM START");

      clearForm();

      debugPrint("13. SAVE SUCCESS");

      return "success";
    } catch (e, stackTrace) {
      debugPrint("========== SAVE PATIENT ERROR ==========");
      debugPrint("ERROR: $e");
      debugPrintStack(stackTrace: stackTrace);
      debugPrint("========================================");

      setLoading(false);

      return e.toString();
    }
  }

  // ===========================
  // UPDATE PATIENT
  // ===========================

  Future<String> updatePatient(Patient patient) async {
    try {
      setLoading(true);

      if (!formKey.currentState!.validate()) {
        setLoading(false);
        return "Validation Failed";
      }

      final dobParts = dobController.text.split("/");

      final updatedPatient = patient.copyWith(
        name: nameController.text.trim(),
        phone: phoneController.text.trim(),
        gender: gender,
        address: addressController.text.trim(),
        age: int.parse(ageController.text),
        dob: DateTime(
          int.parse(dobParts[2]),
          int.parse(dobParts[1]),
          int.parse(dobParts[0]),
        ),
      );

      await _patientRepository.updatePatient(updatedPatient);

      setLoading(false);

      clearForm();

      return "success";
    } catch (e) {
      setLoading(false);
      return e.toString();
    }
  }

  // ===========================
  // LOAD PATIENT FOR EDIT
  // ===========================

  void loadPatient(Patient patient) {
    nameController.text = patient.name;
    phoneController.text = patient.phone;
    ageController.text = patient.age.toString();
    addressController.text = patient.address;
    gender = patient.gender;

    dobController.text =
    "${patient.dob.day}/${patient.dob.month}/${patient.dob.year}";
  }

  // ===========================
  // CLEAR FORM
  // ===========================

  void clearForm() {
    nameController.clear();
    phoneController.clear();
    ageController.clear();
    dobController.clear();
    addressController.clear();

    gender = "Male";
  }

  // ===========================
  // DATE PICKER
  // ===========================

  Future<void> selectDOB(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1940),
      lastDate: DateTime.now(),
    );

    if (picked == null) return;

    dobController.text =
    "${picked.day}/${picked.month}/${picked.year}";

    final today = DateTime.now();

    int age = today.year - picked.year;

    if (today.month < picked.month ||
        (today.month == picked.month &&
            today.day < picked.day)) {
      age--;
    }

    ageController.text = age.toString();
  }

  // ===========================
  // VALIDATIONS
  // ===========================

  String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Please enter patient name";
    }

    return null;
  }

  String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Enter phone number";
    }

    if (value.length != 10) {
      return "Phone must contain 10 digits";
    }

    return null;
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    ageController.dispose();
    dobController.dispose();
    addressController.dispose();
    super.dispose();
  }
}
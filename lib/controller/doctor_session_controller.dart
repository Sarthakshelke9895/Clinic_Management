import 'package:flutter/material.dart';

import '../../models/patient_model.dart';
import '../../models/doctor/session_model.dart';
import '../../repositories/patient_repository.dart';
import '../../repositories/queue_repository.dart';
import '../../repositories/doctor/session_repository.dart';

class DoctorSessionController extends ChangeNotifier {

  //==========================================================
  // Repositories
  //==========================================================

  final PatientRepository patientRepository =
  PatientRepository();

  final QueueRepository queueRepository =
  QueueRepository();

  final SessionRepository sessionRepository =
  SessionRepository();

  //==========================================================
  // Selected Patient
  //==========================================================

  Patient? selectedPatient;

  String? selectedQueueId;

  //==========================================================
  // Previous Sessions
  //==========================================================

  List<SessionModel> sessions = [];

  //==========================================================
  // Loading
  //==========================================================

  bool isLoading = false;

  //==========================================================
  // History
  //==========================================================

  final chiefComplaintController =
  TextEditingController();

  final durationController =
  TextEditingController();

  //==========================================================
  // OPQRST
  //==========================================================

  final onsetController =
  TextEditingController();

  final provocationController =
  TextEditingController();

  final qualityController =
  TextEditingController();

  final regionController =
  TextEditingController();

  final severityController =
  TextEditingController();

  final timingController =
  TextEditingController();

  //==========================================================
  // SINSS
  //==========================================================

  final sinssSeverityController =
  TextEditingController();

  final irritabilityController =
  TextEditingController();

  final natureController =
  TextEditingController();

  final stageController =
  TextEditingController();

  final stabilityController =
  TextEditingController();

  //==========================================================
  // Origin
  //==========================================================

  final List<String> origins = const [

    "Myogenic",

    "Arthrogenic",

    "Neurogenic",

    "Osteogenic",

    "Spinal",

    "Central",

    "Peripheral",

    "Mechanical",

    "Degenerative",

  ];

  List<String> selectedOrigins = [];

  //==========================================================
  // Assessment
  //==========================================================

  final biomechanicalController =
  TextEditingController();

  final osteopathicController =
  TextEditingController();

  final otherFindingsController =
  TextEditingController();

  //==========================================================
  // Rx Goal
  //==========================================================

  final treatmentGoalController =
  TextEditingController();

  final treatmentGivenController =
  TextEditingController();

  final homeExerciseController =
  TextEditingController();

  final adviceController =
  TextEditingController();

  //==========================================================
  // Constructor
  //==========================================================

  DoctorSessionController();

  //==========================================================
  // Dispose
  //==========================================================

  @override
  void dispose() {

    chiefComplaintController.dispose();

    durationController.dispose();

    onsetController.dispose();

    provocationController.dispose();

    qualityController.dispose();

    regionController.dispose();

    severityController.dispose();

    timingController.dispose();

    sinssSeverityController.dispose();

    irritabilityController.dispose();

    natureController.dispose();

    stageController.dispose();

    stabilityController.dispose();

    biomechanicalController.dispose();

    osteopathicController.dispose();

    otherFindingsController.dispose();

    treatmentGoalController.dispose();

    treatmentGivenController.dispose();

    homeExerciseController.dispose();

    adviceController.dispose();

    super.dispose();

  }

}
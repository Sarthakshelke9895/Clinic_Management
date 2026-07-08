import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/patient_model.dart';
import '../../models/queue_model.dart';
import '../../repositories/patient_repository.dart';
import '../../repositories/queue_repository.dart';
import '../../controller/doctor_session_controller.dart';

import '../doctor/session_details_screen.dart';
import '../../services/pdf/pdf_service.dart';


import '../../models/doctor/session_model.dart';
import '../../repositories/doctor/session_repository.dart';

import '../../widgets/doctor/previous_session_card.dart';
import '../../widgets/doctor/section_card.dart';
import '../../utils/app_colors.dart';

class DoctorWorkspace extends StatefulWidget {
  const DoctorWorkspace({super.key});

  @override
  State<DoctorWorkspace> createState() => _DoctorWorkspaceState();
}

class _DoctorWorkspaceState extends State<DoctorWorkspace> {



  final GlobalKey<FormState> consultationFormKey =
  GlobalKey<FormState>();

  Widget _buildTextField(
      String label,
      TextEditingController controller, {
        bool isRequired = true,
      }) {
    return SizedBox(
      width: 260,
      child: TextFormField(
        controller: controller,

        autovalidateMode:
        AutovalidateMode.onUserInteraction,

        validator: isRequired
            ? (value) {
          if (value == null ||
              value.trim().isEmpty) {
            return "$label is required";
          }

          return null;
        }
            : null,

        decoration: InputDecoration(
          labelText:
          isRequired ? "$label *" : label,

          border: OutlineInputBorder(
            borderRadius:
            BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _buildMultilineField(
      String label,
      TextEditingController controller, {
        int maxLines = 3,
        bool isRequired = true,
      }) {
    return TextFormField(
      controller: controller,

      maxLines: maxLines,

      autovalidateMode:
      AutovalidateMode.onUserInteraction,

      validator: isRequired
          ? (value) {
        if (value == null ||
            value.trim().isEmpty) {
          return "$label is required";
        }

        return null;
      }
          : null,

      decoration: InputDecoration(
        labelText:
        isRequired ? "$label *" : label,

        alignLabelWithHint: true,

        border: OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(12),
        ),
      ),
    );
  }
  //==========================================================
  // Repositories
  //==========================================================

  final QueueRepository queueRepository = QueueRepository();

  final PatientRepository patientRepository = PatientRepository();
  final SessionRepository sessionRepository = SessionRepository();

  //==========================================================
// Edit Session
//==========================================================

  bool isEditing = false;
  SessionModel? editingSession;
  bool sessionSavedForCurrentQueueVisit = false;


  String? currentQueueVisitSessionId;
  String currentQueueVisitPaymentAmount = "";
  String currentQueueVisitPaymentStatus = "Completed";

  //==========================================================
  // Queue
  //==========================================================

  late Future<List<QueueModel>> queueFuture;

  String selectedDate =
  DateFormat('yyyy-MM-dd').format(DateTime.now());

  //==========================================================
  // Selected Patient
  //==========================================================

  QueueModel? selectedQueue;

  Patient? selectedPatient;

  //==========================================================
  // History
  //==========================================================

  final TextEditingController chiefComplaintController =
  TextEditingController();

  final TextEditingController durationController =
  TextEditingController();

  //==========================================================
  // OPQRST
  //==========================================================

  final TextEditingController onsetController =
  TextEditingController();

  final TextEditingController provocationController =
  TextEditingController();

  final TextEditingController qualityController =
  TextEditingController();

  final TextEditingController regionController =
  TextEditingController();

  final TextEditingController severityController =
  TextEditingController();

  final TextEditingController timingController =
  TextEditingController();

  //==========================================================
  // SINSS
  //==========================================================

  final TextEditingController sinssSeverityController =
  TextEditingController();

  final TextEditingController irritabilityController =
  TextEditingController();

  final TextEditingController natureController =
  TextEditingController();

  final TextEditingController stageController =
  TextEditingController();

  final TextEditingController stabilityController =
  TextEditingController();

  //==========================================================
// Payment
//==========================================================



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

  final TextEditingController biomechanicalController =
  TextEditingController();

  final TextEditingController osteopathicController =
  TextEditingController();

  final TextEditingController otherFindingsController =
  TextEditingController();

  //==========================================================
  // Rx Goal
  //==========================================================

  final TextEditingController treatmentGoalController =
  TextEditingController();

  final TextEditingController treatmentGivenController =
  TextEditingController();

  final TextEditingController homeExerciseController =
  TextEditingController();

  final TextEditingController adviceController =
  TextEditingController();

  final paymentAmountController =
  TextEditingController();

  final TextEditingController sessionNoteController =
  TextEditingController();



  String paymentStatus = "Completed";


  //==========================================================
  // Session History
  //==========================================================

  List<dynamic> sessions = [];

  //==========================================================
  // Init
  //==========================================================

  @override
  void initState() {

    super.initState();

    loadQueue();

  }

  //==========================================================
  // Queue
  //==========================================================

  void loadQueue() {

    queueFuture =
        queueRepository.getWaitingQueue(selectedDate);

  }

  Future<void> refreshQueue() async {

    loadQueue();

    if (!mounted) return;

    setState(() {});

  }
  //==========================================================
  // Date Picker
  //==========================================================

  Future<void> pickDate() async {

    final picked = await showDatePicker(

      context: context,

      initialDate: DateTime.now(),

      firstDate: DateTime(2024),

      lastDate: DateTime(2100),

    );

    if (picked == null) return;

    selectedDate =
        DateFormat('yyyy-MM-dd').format(picked);

    refreshQueue();

  }

  //==========================================================
  // Load Patient
  //==========================================================
  //==========================================================
// Load Patient
//==========================================================
  Future<void> loadPatient(
      String patientId,
      ) async {
    try {
      //--------------------------------------------------
      // Load Patient
      //--------------------------------------------------

      final patient =
      await patientRepository.getPatientById(
        patientId,
      );

      if (patient == null) {
        return;
      }

      //--------------------------------------------------
      // Reset Current Workspace State
      //--------------------------------------------------

      isEditing = false;

      editingSession = null;

      sessionSavedForCurrentQueueVisit = false;

      currentQueueVisitSessionId = null;

      currentQueueVisitPaymentAmount = "";

      currentQueueVisitPaymentStatus = "Completed";

      //--------------------------------------------------
      // Load Latest Session
      //--------------------------------------------------

      final latestSession =
      await sessionRepository.getLatestSession(
        patient.id!,
      );

      //--------------------------------------------------
      // Load Previous Sessions
      //--------------------------------------------------

      final patientSessions =
      await sessionRepository.getPatientSessions(
        patient.id!,
      );

      //--------------------------------------------------
      // Check Widget Still Exists
      //--------------------------------------------------

      if (!mounted) {
        return;
      }

      //--------------------------------------------------
      // Update Workspace UI Once
      //--------------------------------------------------

      setState(() {
        selectedPatient = patient;

        sessions = patientSessions;

        if (latestSession != null) {
          populateForm(
            latestSession,
          );
        } else {
          clearForm();
        }
      });
    } catch (e) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Failed to load patient: $e",
          ),
        ),
      );
    }
  }

  void clearForm() {
    chiefComplaintController.clear();
    durationController.clear();
    onsetController.clear();
    provocationController.clear();
    qualityController.clear();
    regionController.clear();
    severityController.clear();
    timingController.clear();
    sinssSeverityController.clear();
    irritabilityController.clear();
    natureController.clear();
    stageController.clear();
    stabilityController.clear();
    biomechanicalController.clear();
    osteopathicController.clear();
    otherFindingsController.clear();
    treatmentGoalController.clear();
    treatmentGivenController.clear();
    homeExerciseController.clear();
    adviceController.clear();
    paymentAmountController.clear();
    paymentStatus = "Completed";
    selectedOrigins.clear();

  }

  //==========================================================
// Populate Form From Previous Session
//==========================================================
  void populateForm(
      SessionModel session,
      ) {
    //--------------------------------------------------
    // History
    //--------------------------------------------------

    chiefComplaintController.text =
        session.chiefComplaint;

    durationController.text =
        session.duration;

    //--------------------------------------------------
    // OPQRST
    //--------------------------------------------------

    onsetController.text =
        session.onset;

    provocationController.text =
        session.provocation;

    qualityController.text =
        session.quality;

    regionController.text =
        session.region;

    severityController.text =
        session.severity;

    timingController.text =
        session.timing;

    //--------------------------------------------------
    // SINSS
    //--------------------------------------------------

    sinssSeverityController.text =
        session.sinssSeverity;

    irritabilityController.text =
        session.irritability;

    natureController.text =
        session.nature;

    stageController.text =
        session.stage;

    stabilityController.text =
        session.stability;

    //--------------------------------------------------
    // Origin
    //--------------------------------------------------

    selectedOrigins =
    List<String>.from(
      session.origins,
    );

    //--------------------------------------------------
    // Assessment
    //--------------------------------------------------

    biomechanicalController.text =
        session.biomechanicalFindings;

    osteopathicController.text =
        session.osteopathicFindings;

    otherFindingsController.text =
        session.otherFindings;

    //--------------------------------------------------
    // Rx Goal / Advice
    //--------------------------------------------------

    treatmentGoalController.text =
        session.treatmentGoals;

    treatmentGivenController.text =
        session.treatmentGiven;

    homeExerciseController.text =
        session.homeExerciseProgram;

    adviceController.text =
        session.advice;

    //--------------------------------------------------
    // Session Note
    //--------------------------------------------------

    sessionNoteController.text =
        session.sessionNote;

    //--------------------------------------------------
    // Payment
    //
    // IMPORTANT:
    // Payment belongs to the current visit.
    // Never carry payment from the previous session.
    //--------------------------------------------------

    paymentAmountController.clear();

    paymentStatus = "Completed";
  }




  Future<void> completeConsultation() async {
    //==========================================================
    // Validate Selected Patient And Queue
    //==========================================================

    if (selectedPatient == null ||
        selectedQueue == null ||
        selectedQueue!.id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Please select a patient from the waiting queue.",
          ),
        ),
      );

      return;
    }

    //==========================================================
    // Require Session Saved During Current Queue Visit
    //==========================================================

    if (!sessionSavedForCurrentQueueVisit ||
        currentQueueVisitSessionId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Please save at least one session before completing the consultation.",
          ),
        ),
      );

      return;
    }

    //==========================================================
    // Confirmation Dialog
    //==========================================================

    final confirm = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),

          title: const Row(
            children: [
              Icon(
                Icons.task_alt_rounded,
              ),
              SizedBox(width: 10),
              Text(
                "Complete Consultation",
              ),
            ],
          ),

          content: Text(
            isEditing
                ? "You are currently editing a session. "
                "Completing the consultation will discard unsaved changes "
                "and remove ${selectedPatient!.name} from the waiting queue."
                : "Complete the consultation for "
                "${selectedPatient!.name} and remove the patient from the waiting queue?",
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  false,
                );
              },
              child: const Text(
                "Cancel",
              ),
            ),

            FilledButton.icon(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  true,
                );
              },
              icon: const Icon(
                Icons.check_rounded,
              ),
              label: const Text(
                "Complete",
              ),
            ),
          ],
        );
      },
    );

    if (confirm != true) {
      return;
    }

    //==========================================================
    // Copy Required Values Before Async Operation
    //==========================================================

    final queueId =
    selectedQueue!.id!;

    final sessionId =
    currentQueueVisitSessionId!;

    final savedPaymentAmount =
        currentQueueVisitPaymentAmount;

    final savedPaymentStatus =
        currentQueueVisitPaymentStatus;

    try {
      //========================================================
      // Complete Queue Entry
      //========================================================

      await queueRepository.completeQueue(
        queueId: queueId,
        sessionId: sessionId,
        paymentAmount: savedPaymentAmount,
        paymentStatus: savedPaymentStatus,
      );

      //========================================================
      // Check Widget Still Exists
      //========================================================

      if (!mounted) {
        return;
      }

      //========================================================
      // Clear Workspace State
      //========================================================

      selectedPatient = null;

      selectedQueue = null;

      sessions = [];

      isEditing = false;

      editingSession = null;

      sessionSavedForCurrentQueueVisit = false;

      currentQueueVisitSessionId = null;

      currentQueueVisitPaymentAmount = "";

      currentQueueVisitPaymentStatus =
      "Completed";

      clearForm();

      //========================================================
      // Refresh Waiting Queue
      //========================================================

      await refreshQueue();

      if (!mounted) {
        return;
      }

      setState(() {});

      //========================================================
      // Success Message
      //========================================================

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Consultation Completed Successfully",
          ),
        ),
      );
    } catch (e) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Failed to complete consultation: $e",
          ),
        ),
      );
    }
  }

  void loadSession(SessionModel session) {

    //=========================================
    // Patient Details
    //=========================================

    selectedPatient = Patient(

      id: session.patientId,

      patientCode: session.patientCode,

      name: session.patientName,

      phone: session.phone,

      age: session.age,

      gender: session.gender,

      address: session.address,

      dob: DateTime.now(),
      createdAt: session.createdAt,

    );

    //=========================================
    // History
    //=========================================

    chiefComplaintController.text =
        session.chiefComplaint;

    durationController.text =
        session.duration;

    //=========================================
    // OPQRST
    //=========================================

    onsetController.text =
        session.onset;

    provocationController.text =
        session.provocation;

    qualityController.text =
        session.quality;

    regionController.text =
        session.region;

    severityController.text =
        session.severity;

    timingController.text =
        session.timing;

    //=========================================
    // SINSS
    //=========================================

    sinssSeverityController.text =
        session.sinssSeverity;

    irritabilityController.text =
        session.irritability;

    natureController.text =
        session.nature;

    stageController.text =
        session.stage;

    stabilityController.text =
        session.stability;

    //=========================================
    // Origin
    //=========================================

    selectedOrigins =
    List<String>.from(session.origins);

    //=========================================
    // Assessment
    //=========================================

    biomechanicalController.text =
        session.biomechanicalFindings;

    osteopathicController.text =
        session.osteopathicFindings;

    otherFindingsController.text =
        session.otherFindings;

    //=========================================
    // Rx
    //=========================================

    treatmentGoalController.text =
        session.treatmentGoals;

    treatmentGivenController.text =
        session.treatmentGiven;

    homeExerciseController.text =
        session.homeExerciseProgram;

    adviceController.text =
        session.advice;

    paymentAmountController.text =
        session.paymentAmount;

    paymentStatus =
    session.paymentStatus == "Pending"
        ? "Pending"
        : "Completed";

    isEditing = true;

    editingSession = session;

    setState(() {});  }

  //==========================================================
  // Dispose
  //==========================================================
  Future<void> saveNewSession(
      String sessionNote,
      DateTime selectedSessionDate,
      ) async {
    try {
      //=========================================
      // Safety Validation
      //=========================================

      if (selectedPatient == null) {
        return;
      }

      final patient = selectedPatient!;

      //=========================================
      // Actual Save Timestamp
      //=========================================

      final now = DateTime.now();

      //=========================================
      // Selected Clinical Session Date
      //=========================================

      final sessionDate =
      DateFormat('yyyy-MM-dd').format(
        selectedSessionDate,
      );

      // Example: 8th July 2026

      final formattedSaveDate =
      formatSessionSaveDate(
        selectedSessionDate,
      );

      //=========================================
      // Get Next Session Number
      //=========================================

      final sessionNumber =
      await sessionRepository.getNextSessionNumber(
        patient.id!,
      );

      //=========================================
      // Create Complete Session Snapshot
      //=========================================

      final session = SessionModel(
        patientId: patient.id!,

        queueId: selectedQueue?.id ?? "",

        //=======================================
        // Patient Information
        //=======================================

        patientCode: patient.patientCode,

        patientName: patient.name,

        phone: patient.phone,

        age: patient.age,

        gender: patient.gender,

        address: patient.address,

        //=======================================
        // Session Information
        //=======================================

        sessionNumber: sessionNumber,

        // Doctor-selected date
        // Example: 2026-07-08

        sessionDate: sessionDate,

        // Doctor-selected formatted date
        // Example: 8th July 2026

        saveDate: formattedSaveDate,

        // Actual time when record was created

        createdAt: now,

        //=======================================
        // History
        //=======================================

        chiefComplaint:
        chiefComplaintController.text.trim(),

        duration:
        durationController.text.trim(),

        //=======================================
        // OPQRST
        //=======================================

        onset:
        onsetController.text.trim(),

        provocation:
        provocationController.text.trim(),

        quality:
        qualityController.text.trim(),

        region:
        regionController.text.trim(),

        severity:
        severityController.text.trim(),

        timing:
        timingController.text.trim(),

        //=======================================
        // SINSS
        //=======================================

        sinssSeverity:
        sinssSeverityController.text.trim(),

        irritability:
        irritabilityController.text.trim(),

        nature:
        natureController.text.trim(),

        stage:
        stageController.text.trim(),

        stability:
        stabilityController.text.trim(),

        //=======================================
        // Origin
        //=======================================

        origins: List<String>.from(
          selectedOrigins,
        ),

        //=======================================
        // Assessment
        //=======================================

        biomechanicalFindings:
        biomechanicalController.text.trim(),

        osteopathicFindings:
        osteopathicController.text.trim(),

        otherFindings:
        otherFindingsController.text.trim(),

        //=======================================
        // Treatment
        //=======================================

        treatmentGoals:
        treatmentGoalController.text.trim(),

        treatmentGiven:
        treatmentGivenController.text.trim(),

        homeExerciseProgram:
        homeExerciseController.text.trim(),

        advice:
        adviceController.text.trim(),

        //=======================================
        // Payment
        //=======================================

        paymentAmount:
        paymentAmountController.text.trim(),

        paymentStatus: paymentStatus,

        //=======================================
        // Session Note
        //=======================================

        sessionNote: sessionNote,
      );

      //=========================================
      // Save Session
      //=========================================

      final savedSessionId =
      await sessionRepository.saveSession(
        session,
      );

      //=========================================
      // Track Current Queue Visit Session
      //=========================================

      sessionSavedForCurrentQueueVisit = true;

      currentQueueVisitSessionId =
          savedSessionId;

      currentQueueVisitPaymentAmount =
          session.paymentAmount;

      currentQueueVisitPaymentStatus =
          session.paymentStatus;

      //=========================================
      // Reload Previous Sessions
      //=========================================

      sessions =
      await sessionRepository.getPatientSessions(
        patient.id!,
      );

      //=========================================
      // Prepare Form For Next Session
      //=========================================

      prepareFormAfterSessionSave(
        session,
      );

      if (!mounted) {
        return;
      }

      //=========================================
      // Refresh UI
      //=========================================

      setState(() {});

      //=========================================
      // Success Message
      //=========================================

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Session $sessionNumber Saved Successfully for $formattedSaveDate",
          ),
        ),
      );
    } catch (e) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Failed to save session: $e",
          ),
        ),
      );
    }
  }
  void prepareFormAfterSessionSave(
      SessionModel savedSession,
      ) {
    //=========================================
    // Carry Forward History
    //=========================================

    chiefComplaintController.text =
        savedSession.chiefComplaint;

    durationController.text =
        savedSession.duration;

    //=========================================
    // Carry Forward OPQRST
    //=========================================

    onsetController.text =
        savedSession.onset;

    provocationController.text =
        savedSession.provocation;

    qualityController.text =
        savedSession.quality;

    regionController.text =
        savedSession.region;

    severityController.text =
        savedSession.severity;

    timingController.text =
        savedSession.timing;

    //=========================================
    // Carry Forward SINSS
    //=========================================

    sinssSeverityController.text =
        savedSession.sinssSeverity;

    irritabilityController.text =
        savedSession.irritability;

    natureController.text =
        savedSession.nature;

    stageController.text =
        savedSession.stage;

    stabilityController.text =
        savedSession.stability;

    //=========================================
    // Carry Forward Origin
    //=========================================

    selectedOrigins =
    List<String>.from(
      savedSession.origins,
    );

    //=========================================
    // Carry Forward Assessment
    //=========================================

    biomechanicalController.text =
        savedSession.biomechanicalFindings;

    osteopathicController.text =
        savedSession.osteopathicFindings;

    otherFindingsController.text =
        savedSession.otherFindings;

    //=========================================
    // Carry Forward Rx Goal / Advice
    //=========================================

    treatmentGoalController.text =
        savedSession.treatmentGoals;

    treatmentGivenController.text =
        savedSession.treatmentGiven;

    homeExerciseController.text =
        savedSession.homeExerciseProgram;

    adviceController.text =
        savedSession.advice;

    //=========================================
    // Clear ONLY Payment Information
    //=========================================

    paymentAmountController.clear();

    paymentStatus = "Completed";

    //=========================================
    // Clear Session Note
    //
    // Session note is entered in Add Session
    // dialog, so old note should not carry
    // forward into the next session.
    //=========================================

    sessionNoteController.clear();
  }
  Future<void> showSessionNoteDialog(
      SessionModel session,
      ) async {
    final controller = TextEditingController(
      text: session.sessionNote,
    );

    // Parse existing machine-friendly date.
    // Example: 2026-07-08

    DateTime selectedSessionDate =
        DateTime.tryParse(session.sessionDate) ??
            DateTime.now();

    bool isEditingSession = false;
    bool isUpdating = false;

    await showDialog(
      context: context,
      barrierDismissible: false,

      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),

              //=========================================
              // Title + Close Button
              //=========================================

              title: Row(
                children: [
                  const Icon(
                    Icons.sticky_note_2_outlined,
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: Text(
                      "Session ${session.sessionNumber}",
                    ),
                  ),

                  IconButton(
                    tooltip: "Close",

                    onPressed: isUpdating
                        ? null
                        : () {
                      Navigator.pop(
                        dialogContext,
                      );
                    },

                    icon: const Icon(
                      Icons.close_rounded,
                    ),
                  ),
                ],
              ),

              //=========================================
              // Dialog Content
              //=========================================

              content: SizedBox(
                width: 520,

                child: Column(
                  mainAxisSize: MainAxisSize.min,

                  crossAxisAlignment:
                  CrossAxisAlignment.start,

                  children: [
                    //===================================
                    // Session Date
                    //===================================

                    const Text(
                      "Session Date",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 8),

                    InkWell(
                      borderRadius:
                      BorderRadius.circular(12),

                      // Date picker only enabled
                      // while editing.

                      onTap: !isEditingSession ||
                          isUpdating
                          ? null
                          : () async {
                        final pickedDate =
                        await showDatePicker(
                          context: dialogContext,

                          initialDate:
                          selectedSessionDate,

                          firstDate:
                          DateTime(2020),

                          lastDate:
                          DateTime(2100),
                        );

                        if (pickedDate == null) {
                          return;
                        }

                        setDialogState(() {
                          selectedSessionDate =
                              pickedDate;
                        });
                      },

                      child: InputDecorator(
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.calendar_month_outlined,
                          ),

                          suffixIcon: isEditingSession
                              ? const Icon(
                            Icons
                                .keyboard_arrow_down_rounded,
                          )
                              : null,

                          filled: !isEditingSession,

                          fillColor: !isEditingSession
                              ? Colors.grey.shade100
                              : null,

                          border: OutlineInputBorder(
                            borderRadius:
                            BorderRadius.circular(12),
                          ),
                        ),

                        child: Text(
                          formatSessionSaveDate(
                            selectedSessionDate,
                          ),

                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    //===================================
                    // Session Note
                    //===================================

                    TextFormField(
                      controller: controller,

                      readOnly: !isEditingSession,

                      autofocus: isEditingSession,

                      maxLines: 8,

                      decoration: InputDecoration(
                        labelText: "Session Note",

                        alignLabelWithHint: true,

                        filled: !isEditingSession,

                        fillColor: !isEditingSession
                            ? Colors.grey.shade100
                            : null,

                        border: OutlineInputBorder(
                          borderRadius:
                          BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              //=========================================
              // Bottom Button
              //=========================================

              actions: [
                SizedBox(
                  width: double.infinity,
                  height: 48,

                  child: FilledButton.icon(
                    icon: isUpdating
                        ? const SizedBox(
                      width: 20,
                      height: 20,

                      child:
                      CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    )
                        : Icon(
                      isEditingSession
                          ? Icons.update_outlined
                          : Icons.edit_outlined,
                    ),

                    label: Text(
                      isUpdating
                          ? "Updating..."
                          : isEditingSession
                          ? "Update Session"
                          : "Edit Session",
                    ),

                    onPressed: isUpdating
                        ? null
                        : () async {
                      //=============================
                      // Enable Editing
                      //=============================

                      if (!isEditingSession) {
                        setDialogState(() {
                          isEditingSession = true;
                        });

                        return;
                      }

                      //=============================
                      // Validate Note
                      //=============================

                      final updatedNote =
                      controller.text.trim();

                      if (updatedNote.isEmpty) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Session Note cannot be empty.",
                            ),
                          ),
                        );

                        return;
                      }

                      //=============================
                      // Calculate Updated Dates
                      //=============================

                      final updatedSessionDate =
                      DateFormat('yyyy-MM-dd')
                          .format(
                        selectedSessionDate,
                      );

                      final updatedSaveDate =
                      formatSessionSaveDate(
                        selectedSessionDate,
                      );

                      //=============================
                      // Check Whether Anything Changed
                      //=============================

                      final noteChanged =
                          updatedNote !=
                              session.sessionNote;

                      final dateChanged =
                          updatedSessionDate !=
                              session.sessionDate;

                      if (!noteChanged &&
                          !dateChanged) {
                        setDialogState(() {
                          isEditingSession = false;
                        });

                        return;
                      }

                      //=============================
                      // Start Loading
                      //=============================

                      setDialogState(() {
                        isUpdating = true;
                      });

                      //=============================
                      // Update Note + Date
                      //=============================

                      final success =
                      await updateSessionNoteAndDate(
                        session: session,

                        updatedNote:
                        updatedNote,

                        updatedSessionDate:
                        updatedSessionDate,

                        updatedSaveDate:
                        updatedSaveDate,
                      );

                      if (!dialogContext.mounted) {
                        return;
                      }

                      if (success) {
                        Navigator.pop(
                          dialogContext,
                        );

                        return;
                      }

                      setDialogState(() {
                        isUpdating = false;
                      });
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );

    controller.dispose();
  }
  Future<void> updateSession() async {
    try {
      //-------------------------------------------------------
      // Validate Editing Session
      //-------------------------------------------------------

      if (editingSession == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "No session selected for editing.",
            ),
          ),
        );

        return;
      }

      //-------------------------------------------------------
      // Validate Selected Patient
      //-------------------------------------------------------

      if (selectedPatient == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "No patient selected.",
            ),
          ),
        );

        return;
      }

      //-------------------------------------------------------
      // Create Updated Session
      //-------------------------------------------------------

      final updatedSession = SessionModel(
        id: editingSession!.id,

        patientId:
        selectedPatient!.id!,

        queueId:
        editingSession!.queueId,

        //-----------------------------------------------------
        // Patient Information
        //-----------------------------------------------------

        patientCode:
        selectedPatient!.patientCode,

        patientName:
        selectedPatient!.name,

        phone:
        selectedPatient!.phone,

        age:
        selectedPatient!.age,

        gender:
        selectedPatient!.gender,

        address:
        selectedPatient!.address,

        //-----------------------------------------------------
        // Keep Original Session Information
        //-----------------------------------------------------

        sessionNumber:
        editingSession!.sessionNumber,

        // Keep original session date
        sessionDate:
        editingSession!.sessionDate,

        // Keep original save date
        // Example: 8th July 2026
        saveDate:
        editingSession!.saveDate,

        // Keep original creation timestamp
        createdAt:
        editingSession!.createdAt,

        //-----------------------------------------------------
        // History
        //-----------------------------------------------------

        chiefComplaint:
        chiefComplaintController.text.trim(),

        duration:
        durationController.text.trim(),

        //-----------------------------------------------------
        // OPQRST
        //-----------------------------------------------------

        onset:
        onsetController.text.trim(),

        provocation:
        provocationController.text.trim(),

        quality:
        qualityController.text.trim(),

        region:
        regionController.text.trim(),

        severity:
        severityController.text.trim(),

        timing:
        timingController.text.trim(),

        //-----------------------------------------------------
        // SINSS
        //-----------------------------------------------------

        sinssSeverity:
        sinssSeverityController.text.trim(),

        irritability:
        irritabilityController.text.trim(),

        nature:
        natureController.text.trim(),

        stage:
        stageController.text.trim(),

        stability:
        stabilityController.text.trim(),

        //-----------------------------------------------------
        // Origin
        //-----------------------------------------------------

        origins:
        List<String>.from(
          selectedOrigins,
        ),

        //-----------------------------------------------------
        // Assessment
        //-----------------------------------------------------

        biomechanicalFindings:
        biomechanicalController.text.trim(),

        osteopathicFindings:
        osteopathicController.text.trim(),

        otherFindings:
        otherFindingsController.text.trim(),

        //-----------------------------------------------------
        // Treatment
        //-----------------------------------------------------

        treatmentGoals:
        treatmentGoalController.text.trim(),

        treatmentGiven:
        treatmentGivenController.text.trim(),

        homeExerciseProgram:
        homeExerciseController.text.trim(),

        advice:
        adviceController.text.trim(),

        //-----------------------------------------------------
        // Payment
        //-----------------------------------------------------

        paymentAmount:
        paymentAmountController.text.trim(),

        paymentStatus:
        paymentStatus,

        //-----------------------------------------------------
        // Preserve Existing Session Note
        //-----------------------------------------------------

        sessionNote:
        editingSession!.sessionNote,
      );

      //-------------------------------------------------------
      // Update Session In Firestore
      //-------------------------------------------------------

      await sessionRepository.updateSession(
        updatedSession,
      );

      //-------------------------------------------------------
      // Reload Previous Sessions
      //-------------------------------------------------------

      sessions =
      await sessionRepository.getPatientSessions(
        selectedPatient!.id!,
      );

      //-------------------------------------------------------
      // Exit Editing Mode
      //-------------------------------------------------------

      isEditing = false;

      editingSession = null;

      //-------------------------------------------------------
      // Reload Latest Session
      //-------------------------------------------------------

      final latestSession =
      await sessionRepository.getLatestSession(
        selectedPatient!.id!,
      );

      //-------------------------------------------------------
      // Check Widget Still Exists
      //-------------------------------------------------------

      if (!mounted) {
        return;
      }

      //-------------------------------------------------------
      // Restore Latest Session Into Main Form
      //-------------------------------------------------------

      if (latestSession != null) {
        populateForm(
          latestSession,
        );
      } else {
        clearForm();
      }

      //-------------------------------------------------------
      // Refresh UI
      //-------------------------------------------------------

      setState(() {});

      //-------------------------------------------------------
      // Success Message
      //-------------------------------------------------------

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Session Updated Successfully",
          ),
        ),
      );
    } catch (e) {
      //-------------------------------------------------------
      // Error Handling
      //-------------------------------------------------------

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Failed to update session: $e",
          ),
        ),
      );
    }
  }

  Future<void> showAddSessionDialog() async {
    //=========================================
    // Always Start With Empty Session Note
    //=========================================

    sessionNoteController.clear();

    //=========================================
    // Default Session Date = Today
    //=========================================

    DateTime selectedSessionDate = DateTime.now();

    await showDialog(
      context: context,
      barrierDismissible: false,

      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),

              //=========================================
              // Title
              //=========================================

              title: const Row(
                children: [
                  Icon(
                    Icons.note_add_outlined,
                  ),

                  SizedBox(width: 10),

                  Text(
                    "Add Session",
                  ),
                ],
              ),

              //=========================================
              // Dialog Content
              //=========================================

              content: SizedBox(
                width: 520,

                child: Column(
                  mainAxisSize: MainAxisSize.min,

                  crossAxisAlignment:
                  CrossAxisAlignment.start,

                  children: [
                    //===================================
                    // Session Date Label
                    //===================================

                    const Text(
                      "Session Date *",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 8),

                    //===================================
                    // Session Date Picker
                    //===================================

                    InkWell(
                      borderRadius:
                      BorderRadius.circular(12),

                      onTap: () async {
                        final pickedDate =
                        await showDatePicker(
                          context: dialogContext,

                          initialDate:
                          selectedSessionDate,

                          firstDate:
                          DateTime(2020),

                          lastDate:
                          DateTime(2100),
                        );

                        if (pickedDate == null) {
                          return;
                        }

                        setDialogState(() {
                          selectedSessionDate =
                              pickedDate;
                        });
                      },

                      child: InputDecorator(
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.calendar_month_outlined,
                          ),

                          suffixIcon: const Icon(
                            Icons.keyboard_arrow_down_rounded,
                          ),

                          border: OutlineInputBorder(
                            borderRadius:
                            BorderRadius.circular(12),
                          ),
                        ),

                        child: Text(
                          formatSessionSaveDate(
                            selectedSessionDate,
                          ),

                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    //===================================
                    // Session Note Field
                    //===================================

                    TextFormField(
                      controller:
                      sessionNoteController,

                      autofocus: true,

                      maxLines: 8,

                      decoration: InputDecoration(
                        labelText:
                        "Session Note *",

                        hintText:
                        "Enter session note...",

                        alignLabelWithHint: true,

                        border: OutlineInputBorder(
                          borderRadius:
                          BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              //=========================================
              // Actions
              //=========================================

              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(
                      dialogContext,
                    );
                  },

                  child: const Text(
                    "Cancel",
                  ),
                ),

                FilledButton.icon(
                  icon: const Icon(
                    Icons.save_outlined,
                  ),

                  label: const Text(
                    "Save Session",
                  ),

                  onPressed: () async {
                    final note =
                    sessionNoteController.text.trim();

                    //=================================
                    // Session Note Validation
                    //=================================

                    if (note.isEmpty) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Please enter Session Note.",
                          ),
                        ),
                      );

                      return;
                    }

                    //=================================
                    // Copy Values Before Closing Dialog
                    //=================================

                    final noteToSave = note;

                    final dateToSave =
                        selectedSessionDate;

                    //=================================
                    // Close Dialog
                    //=================================

                    Navigator.pop(
                      dialogContext,
                    );

                    //=================================
                    // Save Complete Session
                    //=================================

                    await saveNewSession(
                      noteToSave,
                      dateToSave,
                    );
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
  Future<void> cancelSessionEditing() async {
    isEditing = false;
    editingSession = null;

    if (selectedPatient == null) {
      clearForm();

      if (mounted) {
        setState(() {});
      }

      return;
    }

    final latestSession =
    await sessionRepository.getLatestSession(
      selectedPatient!.id!,
    );

    if (!mounted) {
      return;
    }

    if (latestSession != null) {
      populateForm(latestSession);
    } else {
      clearForm();
    }

    setState(() {});
  }

  Future<bool> updateSessionNoteAndDate({
    required SessionModel session,
    required String updatedNote,
    required String updatedSessionDate,
    required String updatedSaveDate,
  }) async {
    try {
      //=========================================
      // Validate Session
      //=========================================

      if (session.id == null) {
        throw Exception(
          "Session ID is missing.",
        );
      }

      //=========================================
      // Validate Selected Patient
      //=========================================

      if (selectedPatient == null) {
        throw Exception(
          "No patient selected.",
        );
      }

      //=========================================
      // Update Session Note + Dates
      //=========================================

      await sessionRepository.updateSessionNoteAndDate(
        sessionId: session.id!,

        sessionNote: updatedNote,

        sessionDate: updatedSessionDate,

        saveDate: updatedSaveDate,
      );

      //=========================================
      // Reload Previous Sessions
      //=========================================

      sessions =
      await sessionRepository.getPatientSessions(
        selectedPatient!.id!,
      );

      //=========================================
      // Check Widget Still Exists
      //=========================================

      if (!mounted) {
        return false;
      }

      //=========================================
      // Refresh UI
      //=========================================

      setState(() {});

      //=========================================
      // Success Message
      //=========================================

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Session ${session.sessionNumber} Updated Successfully",
          ),
        ),
      );

      return true;
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Failed to update session: $e",
            ),
          ),
        );
      }

      return false;
    }
  }
  String getOrdinalDay(int day) {
    if (day >= 11 && day <= 13) {
      return "${day}th";
    }

    switch (day % 10) {
      case 1:
        return "${day}st";

      case 2:
        return "${day}nd";

      case 3:
        return "${day}rd";

      default:
        return "${day}th";
    }
  }

  String formatSessionSaveDate(DateTime date) {
    final ordinalDay =
    getOrdinalDay(date.day);

    final monthYear =
    DateFormat('MMMM yyyy').format(date);

    return "$ordinalDay $monthYear";
  }




  Future<void> handleAddSession() async {

    if (selectedPatient == null) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Please select a patient first.",
          ),
        ),
      );

      return;
    }


    //=========================================
    // Validate Form
    //=========================================

    final isFormValid =
        consultationFormKey.currentState?.validate()
            ?? false;


    //=========================================
    // Validate Origin
    //=========================================

    final isOriginValid =
        selectedOrigins.isNotEmpty;


    if (!isFormValid || !isOriginValid) {

      String message =
          "Please fill all required consultation fields.";

      if (!isOriginValid) {
        message =
        "Please select at least one Origin.";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );

      return;
    }


    //=========================================
    // Open Session Dialog
    //=========================================

    await showAddSessionDialog();
  }
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
    paymentAmountController.dispose();
    sessionNoteController.dispose();


    super.dispose();

  }

  //==========================================================
  // UI
  //==========================================================

  @override
  Widget build(BuildContext context) {

    final controller =
    context.watch<DoctorSessionController>();

    return Scaffold(



      body: Row(

        children: [

          //--------------------------------------------------
          // Queue Panel
          //--------------------------------------------------

          SizedBox(

            width: 340,

            child: _buildQueuePanel(),

          ),

          const VerticalDivider(width: 1),

          //--------------------------------------------------
          // Patient Workspace
          //--------------------------------------------------

          Expanded(

            child: _buildPatientWorkspace(),

          ),

        ],

      ),

    );

  }

  //==========================================================
  // Queue Panel
  //==========================================================

  //==========================================================
// Queue Panel
//==========================================================

  Widget _buildQueuePanel() {
    return Container(
      color: Colors.grey.shade100,

      child: Column(
        children: [

          //====================================================
          // Header
          //====================================================



          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
            color: AppColors.primary,
            child: Row(
              children: [
                IconButton(
                  tooltip: "Back",
                  onPressed: () {
                    Navigator.maybePop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back_rounded,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(width: 8),

                const Text(
                  "Today's Queue",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
          //====================================================
          // Date Picker
          //====================================================

          Padding(
            padding: const EdgeInsets.all(15),
            child: SizedBox(
              height: 50,
              child: InkWell(
                onTap: pickDate,
                borderRadius: BorderRadius.circular(12),
                child: InputDecorator(
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.calendar_today_outlined),
                    suffixIcon: const Icon(Icons.keyboard_arrow_down_rounded),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 0,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.grey.shade300,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.grey.shade300,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                        width: 1.5,
                      ),
                    ),
                  ),
                  child: Text(
                    DateFormat('dd MMM yyyy').format(
                      DateTime.parse(selectedDate),
                    ),
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ),

          //====================================================
          // Queue
          //====================================================

          Expanded(
            child: FutureBuilder<List<QueueModel>>(

              future: queueFuture,

              builder: (context, snapshot) {

                if (snapshot.connectionState ==
                    ConnectionState.waiting) {

                  return const Center(
                    child: CircularProgressIndicator(),
                  );

                }

                if (snapshot.hasError) {

                  return Center(
                    child: Text(
                      snapshot.error.toString(),
                    ),
                  );

                }

                final queue = snapshot.data ?? [];

                if (queue.isEmpty) {

                  return const Center(
                    child: Text(
                      "No Patients In Queue",
                    ),
                  );

                }

                return RefreshIndicator(

                  onRefresh: refreshQueue,

                  child: ListView.builder(

                    padding: const EdgeInsets.only(
                      bottom: 20,
                    ),

                    itemCount: queue.length,

                    itemBuilder: (context, index) {

                      final patient = queue[index];

                      final isSelected =
                          selectedPatient?.id ==
                              patient.patientId;

                      return Card(

                        elevation: isSelected ? 5 : 1,

                        color: isSelected
                            ? Colors.blue.shade50
                            : Colors.white,

                        margin:
                        const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),

                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),

                          onTap: () async {
                            setState(() {
                              selectedQueue = patient;
                            });

                            await loadPatient(patient.patientId);
                          },

                          leading: CircleAvatar(
                            radius: 22,
                            backgroundColor: isSelected
                                ? Theme.of(context).primaryColor
                                : Colors.grey.shade200,
                            child: Text(
                              "${index + 1}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isSelected
                                    ? Colors.white
                                    : Colors.black87,
                              ),
                            ),
                          ),

                          title: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  patient.patientName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),

                              const SizedBox(width: 8),

                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: patient.status == "Waiting"
                                      ? Colors.orange.shade100
                                      : Colors.green.shade100,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  patient.status,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: patient.status == "Waiting"
                                        ? Colors.orange.shade800
                                        : Colors.green.shade800,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 1),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [





                                Text(
                                  "Arrived : ${patient.arrivalTime}",
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )

                      );

                    },

                  ),

                );

              },

            ),

          ),

        ],
      ),
    );
  }

  //==========================================================
  // Patient Workspace
  //==========================================================
//==========================================================
// Patient Workspace
//==========================================================
  Widget _compactInfo(
      IconData icon,
      String value,
      ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [

        Icon(
          icon,
          size: 16,
          color: Colors.grey.shade600,
        ),

        const SizedBox(width: 6),

        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),

      ],
    );
  }

  Widget _buildPatientWorkspace() {

    if (selectedPatient == null) {

      return const Center(

        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,

          children: [

            Icon(
              Icons.person_search,
              size: 90,
              color: Colors.grey,
            ),

            SizedBox(height: 20),

            Text(
              "Select a patient from the queue",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),

            SizedBox(height: 10),

            Text(
              "Patient details and session form will appear here.",
              style: TextStyle(
                color: Colors.grey,
              ),
            ),

          ],

        ),

      );

    }

    return SingleChildScrollView(

      padding: const EdgeInsets.all(20),
        child: Form(
          key: consultationFormKey,

      child: Column(

        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          //==================================================
          // Patient Details Card
          //==================================================

          Card(
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),
              child: Column(
                children: [

                  //--------------------------------------------------
                  // Row 1
                  //--------------------------------------------------

                  Row(
                    children: [

                      CircleAvatar(
                        radius: 22,
                        backgroundColor: Theme.of(context).primaryColor,
                        child: Text(
                          selectedPatient!.name[0].toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),

                      const SizedBox(width: 14),

                      Expanded(
                        child: Text(
                          selectedPatient!.name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .primaryColor
                              .withOpacity(.08),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          selectedPatient!.patientCode,
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  //--------------------------------------------------
                  // Row 2
                  //--------------------------------------------------

                  Wrap(
                    spacing: 24,
                    runSpacing: 10,
                    children: [

                      _compactInfo(
                        Icons.phone_outlined,
                        selectedPatient!.phone,
                      ),

                      _compactInfo(
                        Icons.person_outline,
                        selectedPatient!.gender,
                      ),

                      _compactInfo(
                        Icons.cake_outlined,
                        "${selectedPatient!.age} Years",
                      ),

                      _compactInfo(
                        Icons.location_on_outlined,
                        selectedPatient!.address,
                      ),

                    ],
                  ),

                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          //==================================================
          // History Section
          //==================================================

          SectionCard(
            title: "History",
            icon: Icons.history_edu_outlined,
            initiallyExpanded: true,

            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                SizedBox(
                  width: 420,
                  child: TextFormField(
                    controller:
                    chiefComplaintController,

                    autovalidateMode:
                    AutovalidateMode.onUserInteraction,

                    validator: (value) {
                      if (value == null ||
                          value.trim().isEmpty) {
                        return "Chief Complaint is required";
                      }

                      return null;
                    },

                    decoration: InputDecoration(
                      labelText: "Chief Complaint *",

                      border: OutlineInputBorder(
                        borderRadius:
                        BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 20),

                SizedBox(
                  width: 220,
                  child: TextFormField(
                    controller:
                    durationController,

                    autovalidateMode:
                    AutovalidateMode.onUserInteraction,

                    validator: (value) {
                      if (value == null ||
                          value.trim().isEmpty) {
                        return "Duration is required";
                      }

                      return null;
                    },

                    decoration: InputDecoration(
                      labelText: "Duration *",

                      border: OutlineInputBorder(
                        borderRadius:
                        BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),

              ],
            )
          ),



          //==================================================
// Symptom Evaluation
//==================================================

          SectionCard(
            title: "Symptom Evaluation",
            icon: Icons.monitor_heart_outlined,
            initiallyExpanded: false,

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                //--------------------------------------------------
                // OPQRST
                //--------------------------------------------------

                const Text(
                  "OPQRST",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 20),

                Row(
                  children: [

                    _buildTextField(
                      "O - Onset",
                      onsetController,
                    ),

                    const SizedBox(width: 20),

                    _buildTextField(
                      "P - Provocation",
                      provocationController,
                    ),

                    const SizedBox(width: 20),

                    _buildTextField(
                      "Q - Quality",
                      qualityController,
                    ),

                  ],
                ),

                const SizedBox(height: 18),

                Row(
                  children: [

                    _buildTextField(
                      "R - Region",
                      regionController,
                    ),

                    const SizedBox(width: 20),

                    _buildTextField(
                      "S - Severity",
                      severityController,
                    ),

                    const SizedBox(width: 20),

                    _buildTextField(
                      "T - Timing",
                      timingController,
                    ),

                  ],
                ),

                const SizedBox(height: 30),

                Divider(color: Colors.grey.shade300),

                const SizedBox(height: 25),

                //--------------------------------------------------
                // SINSS
                //--------------------------------------------------

                const Text(
                  "SINSS",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 20),

                Row(
                  children: [

                    _buildTextField(
                      "Severity",
                      sinssSeverityController,
                    ),

                    const SizedBox(width: 20),

                    _buildTextField(
                      "Irritability",
                      irritabilityController,
                    ),

                    const SizedBox(width: 20),

                    _buildTextField(
                      "Nature",
                      natureController,
                    ),

                  ],
                ),

                const SizedBox(height: 18),

                Row(
                  children: [

                    _buildTextField(
                      "Stage",
                      stageController,
                    ),

                    const SizedBox(width: 20),

                    _buildTextField(
                      "Stability",
                      stabilityController,
                    ),

                  ],
                ),

              ],
            ),
          ),



//==================================================
// Origin
//==================================================

          SectionCard(
            title: "Origin",
            icon: Icons.hub_outlined,
            initiallyExpanded: false,

            child: Wrap(
              spacing: 12,
              runSpacing: 12,

              children: origins.map((origin) {

                final selected = selectedOrigins.contains(origin);

                return FilterChip(

                  label: Text(
                    origin,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: selected
                          ? Colors.white
                          : Colors.black87,
                    ),
                  ),

                  selected: selected,

                  showCheckmark: false,

                  selectedColor: Theme.of(context).primaryColor,

                  backgroundColor: Colors.grey.shade100,

                  side: BorderSide(
                    color: selected
                        ? Theme.of(context).primaryColor
                        : Colors.grey.shade300,
                  ),

                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),

                  onSelected: (value) {

                    setState(() {

                      if (value) {

                        selectedOrigins.add(origin);

                      } else {

                        selectedOrigins.remove(origin);

                      }

                    });

                  },

                );

              }).toList(),
            ),
          ),




          //==================================================
// Assessment
//==================================================

          SectionCard(
            title: "Assessment",
            icon: Icons.medical_information_outlined,
            initiallyExpanded: false,
            child: Column(
              children: [
                _buildMultilineField(
                  "Biomechanical Findings",
                  biomechanicalController,
                ),
                const SizedBox(height: 20),
                _buildMultilineField(
                  "Osteopathic Findings",
                  osteopathicController,
                ),
                const SizedBox(height: 20),
                _buildMultilineField(
                  "Other Findings",
                  otherFindingsController,
                ),
              ],
            ),
          ),



//==================================================
// Rx Goal / Advice
//==================================================

          SectionCard(
            title: "Rx Goal / Advice",
            icon: Icons.healing_outlined,
            initiallyExpanded: false,

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                _buildMultilineField(
                  "Treatment Goals",
                  treatmentGoalController,
                ),

                const SizedBox(height: 20),

                _buildMultilineField(
                  "Treatment Given",
                  treatmentGivenController,
                ),

                const SizedBox(height: 20),

                _buildMultilineField(
                  "Home Exercise Program",
                  homeExerciseController,
                ),

                const SizedBox(height: 20),

                _buildMultilineField(
                  "Advice",
                  adviceController,
                  maxLines: 4,
                ),

              ],
            ),
          ),


//==========================================================
// Payment Details
//==========================================================

          SectionCard(
            title: "Payment",
            icon: Icons.payments_outlined,
            initiallyExpanded: false,

            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                //==================================================
                // Payment Amount
                //==================================================

                Expanded(
                  child: TextFormField(
                    controller: paymentAmountController,

                    keyboardType: TextInputType.number,

                    autovalidateMode:
                    AutovalidateMode.onUserInteraction,

                    validator: (value) {
                      if (value == null ||
                          value.trim().isEmpty) {
                        return "Payment Amount is required";
                      }

                      final amount =
                      double.tryParse(value.trim());

                      if (amount == null) {
                        return "Enter a valid amount";
                      }

                      if (amount < 0) {
                        return "Amount cannot be negative";
                      }

                      return null;
                    },

                    decoration: InputDecoration(
                      labelText: "Amount Paid *",

                      prefixIcon: const Icon(
                        Icons.currency_rupee,
                      ),

                      border: OutlineInputBorder(
                        borderRadius:
                        BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 20),

                //==================================================
                // Payment Status
                //==================================================

                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: paymentStatus,

                    decoration: InputDecoration(
                      labelText: "Payment Status",

                      prefixIcon: const Icon(
                        Icons.payments_outlined,
                      ),

                      border: OutlineInputBorder(
                        borderRadius:
                        BorderRadius.circular(12),
                      ),
                    ),

                    items: const [
                      DropdownMenuItem(
                        value: "Completed",
                        child: Text("Completed"),
                      ),

                      DropdownMenuItem(
                        value: "Pending",
                        child: Text("Pending"),
                      ),
                    ],

                    onChanged: (value) {
                      if (value == null) return;

                      setState(() {
                        paymentStatus = value;
                      });
                    },
                  ),
                ),

              ],
            ),
          ),

          //==================================================
// Session History
//==================================================

          SectionCard(
            title:
            "Previous Sessions (${sessions.length})",

            icon:
            Icons.history_outlined,

            initiallyExpanded:
            false,

            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [

                //=========================================
                // Add Session Button
                //=========================================

                Row(
                  mainAxisAlignment:
                  MainAxisAlignment.end,

                  children: [

                    FilledButton.icon(

                      onPressed: isEditing
                          ? null
                          : handleAddSession,

                      icon: const Icon(
                        Icons.add_rounded,
                      ),

                      label: const Text(
                        "Add Session",
                      ),

                    ),

                  ],
                ),


                const SizedBox(height: 16),


                //=========================================
                // Empty State
                //=========================================

                if (sessions.isEmpty)

                  Container(
                    width:
                    double.infinity,

                    padding:
                    const EdgeInsets.all(40),

                    decoration:
                    BoxDecoration(

                      color:
                      Colors.grey.shade100,

                      borderRadius:
                      BorderRadius.circular(12),

                    ),

                    child:
                    const Column(

                      children: [

                        Icon(
                          Icons.folder_open_outlined,
                          size: 60,
                          color: Colors.grey,
                        ),

                        SizedBox(height: 15),

                        Text(
                          "No Previous Sessions",

                          style: TextStyle(
                            fontSize: 18,
                            fontWeight:
                            FontWeight.w600,
                          ),
                        ),

                      ],

                    ),
                  )


                //=========================================
                // Sessions List
                //=========================================

                else

                  Builder(
                    builder: (context) {

                      //=====================================
                      // Create Copy Of Sessions
                      //
                      // Do not directly sort the original
                      // sessions list inside build().
                      //=====================================

                      final sortedSessions =
                      List<SessionModel>.from(
                        sessions.cast<SessionModel>(),
                      );


                      //=====================================
                      // Sort Sessions
                      //
                      // Primary:
                      // sessionDate DESCENDING
                      //
                      // 3rd July
                      // 2nd July
                      // 1st July
                      //
                      // Secondary:
                      // Higher sessionNumber first when
                      // dates are equal.
                      //=====================================

                      sortedSessions.sort(
                            (a, b) {

                          final aDate =
                          DateTime.tryParse(
                            a.sessionDate,
                          );

                          final bDate =
                          DateTime.tryParse(
                            b.sessionDate,
                          );


                          //=================================
                          // Handle Invalid / Empty Dates
                          //=================================

                          if (aDate == null &&
                              bDate == null) {

                            return b.sessionNumber.compareTo(
                              a.sessionNumber,
                            );
                          }


                          if (aDate == null) {
                            return 1;
                          }


                          if (bDate == null) {
                            return -1;
                          }


                          //=================================
                          // Compare Session Dates
                          //=================================

                          final dateComparison =
                          bDate.compareTo(
                            aDate,
                          );


                          //=================================
                          // Different Dates
                          //=================================

                          if (dateComparison != 0) {
                            return dateComparison;
                          }


                          //=================================
                          // Same Date
                          //
                          // Higher Session Number First
                          //=================================

                          return b.sessionNumber.compareTo(
                            a.sessionNumber,
                          );

                        },
                      );


                      //=====================================
                      // Display Sorted Sessions
                      //=====================================

                      return ListView.separated(

                        shrinkWrap:
                        true,

                        physics:
                        const NeverScrollableScrollPhysics(),

                        itemCount:
                        sortedSessions.length,

                        separatorBuilder:
                            (_, __) =>
                        const SizedBox(
                          height: 12,
                        ),

                        itemBuilder:
                            (context, index) {

                          final session =
                          sortedSessions[index];


                          return PreviousSessionCard(

                            session:
                            session,


                            //=================================
                            // Open Session Note
                            //=================================

                            onTap: () {

                              showSessionNoteDialog(
                                session,
                              );

                            },


                            //=================================
                            // Edit Session
                            //=================================

                            onEdit: () {

                              loadSession(
                                session,
                              );

                            },


                            //=================================
                            // View Session
                            //=================================

                            onView: () {

                              Navigator.push(

                                context,

                                MaterialPageRoute(

                                  builder: (_) =>
                                      SessionDetailsScreen(

                                        session:
                                        session,

                                      ),

                                ),

                              );

                            },


                            //=================================
                            // Generate PDF
                            //=================================

                            onPdf: () async {

                              await PdfService.instance
                                  .generateSessionPdf(

                                session,

                              );

                            },


                            //=================================
                            // Delete Session
                            //=================================

                            onDelete: () async {

                              final confirm =
                              await showDialog<bool>(

                                context:
                                context,

                                builder:
                                    (_) =>
                                    AlertDialog(

                                      title:
                                      const Text(
                                        "Delete Session",
                                      ),

                                      content:
                                      const Text(
                                        "Are you sure you want to delete this session?",
                                      ),

                                      actions: [

                                        TextButton(

                                          onPressed:
                                              () {

                                            Navigator.pop(
                                              context,
                                              false,
                                            );

                                          },

                                          child:
                                          const Text(
                                            "Cancel",
                                          ),

                                        ),

                                        FilledButton(

                                          onPressed:
                                              () {

                                            Navigator.pop(
                                              context,
                                              true,
                                            );

                                          },

                                          child:
                                          const Text(
                                            "Delete",
                                          ),

                                        ),

                                      ],

                                    ),

                              );


                              if (confirm != true) {
                                return;
                              }


                              await sessionRepository
                                  .deleteSession(

                                session.id!,

                              );


                              //=================================
                              // Reload Sessions
                              //=================================

                              sessions =
                              await sessionRepository
                                  .getPatientSessions(

                                selectedPatient!.id!,

                              );


                              if (!mounted) {
                                return;
                              }


                              setState(() {});


                              ScaffoldMessenger.of(context)
                                  .showSnackBar(

                                const SnackBar(

                                  content:
                                  Text(
                                    "Session Deleted Successfully",
                                  ),

                                ),

                              );

                            },

                          );

                        },

                      );

                    },
                  ),

              ],
            ),
          ),

          const SizedBox(height: 20),

//==========================================================
// Consultation Action Row
//==========================================================

          Row(
            children: [
              //========================================================
              // Complete Consultation
              //========================================================

              Expanded(
                flex: isEditing ? 2 : 1,

                child: SizedBox(
                  height: 55,

                  child: FilledButton.icon(
                    onPressed: completeConsultation,

                    style: FilledButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),

                    icon: const Icon(
                      Icons.task_alt_rounded,
                    ),

                    label: const Text(
                      "Complete Consultation",

                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),

              //========================================================
              // Editing Controls
              //========================================================

              if (isEditing) ...[
                const SizedBox(width: 12),

                Expanded(
                  child: SizedBox(
                    height: 55,

                    child: FilledButton.icon(
                      onPressed: updateSession,

                      style: FilledButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),

                      icon: const Icon(
                        Icons.edit_document,
                      ),

                      label: Text(
                        "Update Session ${editingSession?.sessionNumber ?? ""}",

                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                SizedBox(
                  width: 55,
                  height: 55,

                  child: IconButton.outlined(
                    tooltip: "Cancel Editing",

                    onPressed: cancelSessionEditing,

                    style: IconButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),

                    icon: const Icon(
                      Icons.close_rounded,
                    ),
                  ),
                ),
              ],
            ],
          ),

          const SizedBox(height: 40),

//==================================================
// Save Session
//==================================================


          const SizedBox(height: 40),

        ],

      ),

        ),

    );

  }

  Widget _infoCard(

      IconData icon,

      String title,

      String value,

      ) {

    return Container(

      width: 200,

      padding: const EdgeInsets.all(15),

      decoration: BoxDecoration(

        color: Colors.grey.shade100,

        borderRadius:
        BorderRadius.circular(12),

      ),

      child: Row(

        children: [

          Icon(icon),

          const SizedBox(width: 12),

          Expanded(

            child: Column(

              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [

                Text(

                  title,

                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),

                ),

                const SizedBox(height: 4),

                Text(

                  value,

                  style: const TextStyle(
                    fontWeight:
                    FontWeight.bold,
                  ),

                ),

              ],

            ),

          ),

        ],

      ),

    );

  }

}
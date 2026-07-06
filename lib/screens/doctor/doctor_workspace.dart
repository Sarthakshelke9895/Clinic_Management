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

  Widget _buildTextField(
      String label,
      TextEditingController controller,
      ) {
    return SizedBox(
      width: 260,
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
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
    // Load Latest Session
    //--------------------------------------------------

    final latestSession =
    await sessionRepository.getLatestSession(
      patient.id!,
    );

    //--------------------------------------------------
    // Update UI
    //--------------------------------------------------

    setState(() {

      selectedPatient = patient;

      if (latestSession != null) {

        populateForm(
          latestSession,
        );

      } else {

        clearForm();

      }

    });

    //--------------------------------------------------
    // Refresh Previous Sessions
    //--------------------------------------------------

    sessions = await sessionRepository
        .getPatientSessions(
      patient.id!,
    );

    setState(() {});

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

    durationController.clear();

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
    // Today's Treatment
    //--------------------------------------------------

    treatmentGoalController.clear();
    treatmentGivenController.clear();
    homeExerciseController.clear();
    adviceController.clear();
    paymentAmountController.clear();
    paymentStatus = "Completed";

  }

  Future<void> saveSession() async {
    try {
      //=========================================
      // Validation
      //=========================================

      if (selectedPatient == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Please select a patient."),
          ),
        );
        return;
      }

      //=========================================
      // Get Next Session Number
      //=========================================

      final sessionNumber = await sessionRepository
          .getNextSessionNumber(selectedPatient!.id!);

      //=========================================
      // Create Session Model
      //=========================================

      final session = SessionModel(
        patientId: selectedPatient!.id!,
        queueId: selectedQueue?.id ?? "",

        patientCode: selectedPatient!.patientCode,
        patientName: selectedPatient!.name,
        phone: selectedPatient!.phone,
        age: selectedPatient!.age,
        gender: selectedPatient!.gender,
        address: selectedPatient!.address,

        sessionNumber: sessionNumber,
        sessionDate: DateFormat('yyyy-MM-dd').format(DateTime.now()),
        createdAt: DateTime.now(),

        chiefComplaint: chiefComplaintController.text.trim(),
        duration: durationController.text.trim(),

        onset: onsetController.text.trim(),
        provocation: provocationController.text.trim(),
        quality: qualityController.text.trim(),
        region: regionController.text.trim(),
        severity: severityController.text.trim(),
        timing: timingController.text.trim(),

        sinssSeverity: sinssSeverityController.text.trim(),
        irritability: irritabilityController.text.trim(),
        nature: natureController.text.trim(),
        stage: stageController.text.trim(),
        stability: stabilityController.text.trim(),

        origins: List<String>.from(selectedOrigins),

        biomechanicalFindings:
        biomechanicalController.text.trim(),

        osteopathicFindings:
        osteopathicController.text.trim(),

        otherFindings:
        otherFindingsController.text.trim(),

        treatmentGoals:
        treatmentGoalController.text.trim(),

        treatmentGiven:
        treatmentGivenController.text.trim(),

        homeExerciseProgram:
        homeExerciseController.text.trim(),

        advice:
        adviceController.text.trim(),

        paymentAmount:
        paymentAmountController.text.trim(),

        paymentStatus:
        paymentStatus,
      );

      //=========================================
      // Save Session
      //=========================================

      final sessionId =
      await sessionRepository.saveSession(session);

      //=========================================
      // Mark Queue Completed
      //=========================================

      if (selectedQueue != null) {

        await queueRepository.completeQueue(
          queueId: selectedQueue!.id!,
          sessionId: sessionId,

          paymentAmount: paymentAmountController.text.trim(),

          paymentStatus: paymentStatus,
        );
      }

      //=========================================
      // Reload Previous Sessions
      //=========================================

      sessions = await sessionRepository.getPatientSessions(
        selectedPatient!.id!,
      );

      //=========================================
      // Refresh Waiting Queue
      //=========================================

      await refreshQueue();

      //=========================================
      // Update UI
      //=========================================
      clearForm();
      setState(() {});

      //=========================================
      // Success Message
      //=========================================

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Session Saved Successfully"),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
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

    isEditing = true;

    editingSession = session;

    setState(() {});  }

  //==========================================================
  // Dispose
  //==========================================================


  Future<void> updateSession() async {

    try {

      if (editingSession == null) {

        ScaffoldMessenger.of(context).showSnackBar(

          const SnackBar(
            content: Text("No session selected for editing."),
          ),

        );

        return;

      }

      final updatedSession = SessionModel(

        id: editingSession!.id,

        patientId: selectedPatient!.id!,
        queueId: editingSession!.queueId,

        patientCode: selectedPatient!.patientCode,
        patientName: selectedPatient!.name,
        phone: selectedPatient!.phone,
        age: selectedPatient!.age,
        gender: selectedPatient!.gender,
        address: selectedPatient!.address,

        // Keep original values
        sessionNumber: editingSession!.sessionNumber,
        sessionDate: editingSession!.sessionDate,
        createdAt: editingSession!.createdAt,

        // Updated Form Values
        chiefComplaint: chiefComplaintController.text.trim(),
        duration: durationController.text.trim(),

        onset: onsetController.text.trim(),
        provocation: provocationController.text.trim(),
        quality: qualityController.text.trim(),
        region: regionController.text.trim(),
        severity: severityController.text.trim(),
        timing: timingController.text.trim(),

        sinssSeverity: sinssSeverityController.text.trim(),
        irritability: irritabilityController.text.trim(),
        nature: natureController.text.trim(),
        stage: stageController.text.trim(),
        stability: stabilityController.text.trim(),

        origins: List<String>.from(selectedOrigins),

        biomechanicalFindings:
        biomechanicalController.text.trim(),

        osteopathicFindings:
        osteopathicController.text.trim(),

        otherFindings:
        otherFindingsController.text.trim(),

        treatmentGoals:
        treatmentGoalController.text.trim(),

        treatmentGiven:
        treatmentGivenController.text.trim(),

        homeExerciseProgram:
        homeExerciseController.text.trim(),

        advice:
        adviceController.text.trim(),

        paymentAmount:
        paymentAmountController.text.trim(),

        paymentStatus:
        paymentStatus,

      );


      //-------------------------------------------------------
      // Update Firestore
      //-------------------------------------------------------

      await sessionRepository.updateSession(
        updatedSession,
      );

      //-------------------------------------------------------
      // Reload Previous Sessions
      //-------------------------------------------------------

      sessions = await sessionRepository
          .getPatientSessions(selectedPatient!.id!);

      //-------------------------------------------------------
      // Exit Edit Mode
      //-------------------------------------------------------

      isEditing = false;

      editingSession = null;

      clearForm();

      setState(() {});

      //-------------------------------------------------------
      // Success
      //-------------------------------------------------------

      ScaffoldMessenger.of(context).showSnackBar(

        const SnackBar(

          content: Text(
            "Session Updated Successfully",
          ),

        ),

      );

    } catch (e) {

      ScaffoldMessenger.of(context).showSnackBar(

        SnackBar(
          content: Text(e.toString()),
        ),

      );

    }

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
  Widget _buildMultilineField(
      String label,
      TextEditingController controller, {
        int maxLines = 3,
      }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        alignLabelWithHint: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
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
                    controller: chiefComplaintController,
                    decoration: InputDecoration(
                      labelText: "Chief Complaint",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 20),

                SizedBox(
                  width: 220,
                  child: TextFormField(
                    controller: durationController,
                    decoration: InputDecoration(
                      labelText: "Duration",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
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

                SizedBox(
                  width: 250,
                  child: TextFormField(
                    controller: paymentAmountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Amount Paid",
                      prefixIcon: const Icon(Icons.currency_rupee),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 20),

                SizedBox(
                  width: 250,
                  child: DropdownButtonFormField<String>(
                    value: paymentStatus,
                    decoration: InputDecoration(
                      labelText: "Payment Status",
                      prefixIcon: const Icon(Icons.payments_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
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
                      setState(() {
                        paymentStatus = value!;
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
            title: "Previous Sessions (${sessions.length})",
            icon: Icons.history_outlined,
            initiallyExpanded: false,

            child: sessions.isEmpty

            //--------------------------------------------------
            // Empty State
            //--------------------------------------------------

                ? Container(
              width: double.infinity,
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Column(
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
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                ],
              ),
            )

            //--------------------------------------------------
            // Previous Sessions List
            //--------------------------------------------------

                : ListView.separated(

              shrinkWrap: true,

              physics:
              const NeverScrollableScrollPhysics(),

              itemCount: sessions.length,

              separatorBuilder: (_, __) =>
              const SizedBox(height: 12),

              itemBuilder: (context, index) {

                final session = sessions[index];

                return PreviousSessionCard(

                  session: session,

                  //------------------------------------------------
                  // Edit
                  //------------------------------------------------

                  onEdit: () {

                    loadSession(session);

                  },

                  //------------------------------------------------
                  // View
                  //------------------------------------------------

                  onView: () {

                    Navigator.push(

                      context,

                      MaterialPageRoute(

                        builder: (_) =>

                            SessionDetailsScreen(

                              session: session,

                            ),

                      ),

                    );

                  },

                  //------------------------------------------------
                  // PDF
                  //------------------------------------------------

                  onPdf: () async {

                    await PdfService.instance
                        .generateSessionPdf(
                      session,
                    );

                  },

                  //------------------------------------------------
                  // Delete
                  //------------------------------------------------

                  onDelete: () async {

                    final confirm =
                    await showDialog<bool>(

                      context: context,

                      builder: (_) => AlertDialog(

                        title: const Text(
                          "Delete Session",
                        ),

                        content: const Text(
                          "Are you sure you want to delete this session?",
                        ),

                        actions: [

                          TextButton(

                            onPressed: () {

                              Navigator.pop(
                                context,
                                false,
                              );

                            },

                            child: const Text(
                              "Cancel",
                            ),

                          ),

                          FilledButton(

                            onPressed: () {

                              Navigator.pop(
                                context,
                                true,
                              );

                            },

                            child: const Text(
                              "Delete",
                            ),

                          ),

                        ],

                      ),

                    );

                    if (confirm != true) return;

                    await sessionRepository
                        .deleteSession(
                      session.id!,
                    );

                    sessions =
                    await sessionRepository
                        .getPatientSessions(
                      selectedPatient!.id!,
                    );

                    if (!mounted) return;

                    setState(() {});

                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(

                      const SnackBar(

                        content: Text(
                          "Session Deleted Successfully",
                        ),

                      ),

                    );

                  },

                );

              },

            ),
          ),

          const SizedBox(height: 10),

//==================================================
// Save Session
//==================================================

          SizedBox(

            width: double.infinity,

            height: 55,

            child: FilledButton.icon(

              icon: Icon(

                isEditing
                    ? Icons.edit_document
                    : Icons.save,

              ),

              label: Text(

                isEditing
                    ? "Update Session"
                    : "Save Session",

                style: const TextStyle(

                  fontSize: 18,

                  fontWeight: FontWeight.bold,

                ),

              ),

              onPressed: selectedPatient == null
                  ? null
                  : () {

                if (isEditing) {

                  updateSession();

                } else {

                  saveSession();

                }

              },

            ),

          ),

          const SizedBox(height: 40),

        ],

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
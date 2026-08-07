import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/queue_model.dart';
import '../../repositories/queue_repository.dart';
import 'patient_workspace.dart';
import '../../repositories/doctor/session_repository.dart';
import '../../services/pdf/pdf_service.dart';
import '../../services/auth/auth_service.dart';



class CompletedPatientsScreen extends StatefulWidget {
  const CompletedPatientsScreen({super.key});

  @override
  State<CompletedPatientsScreen> createState() =>
      _CompletedPatientsScreenState();
}

class _CompletedPatientsScreenState
    extends State<CompletedPatientsScreen> {

//==========================================================
// Repository
//==========================================================

  final QueueRepository queueRepository =  QueueRepository();
  final SessionRepository sessionRepository = SessionRepository();

//==========================================================
// Controllers
//==========================================================

  final TextEditingController searchController =
  TextEditingController();

//==========================================================
// Variables
//==========================================================

  late Future<List<QueueModel>> completedFuture;

  List<QueueModel> completedPatients = [];

  List<QueueModel> filteredPatients = [];

  DateTime selectedDate = DateTime.now();

  bool isSearching = false;

//==========================================================
// Init
//==========================================================

  @override
  void initState() {
    super.initState();

    loadCompletedPatients();
  }

//==========================================================
// Load Completed Patients
//==========================================================

  Future<void> loadCompletedPatients() async {
    try {
      final date =
      DateFormat('yyyy-MM-dd').format(
        selectedDate,
      );

      final data =
      await queueRepository.getCompletedQueue(
        date,
      );

      if (!mounted) return;

      setState(() {
        completedPatients = data;
        filteredPatients = data;
      });
    } catch (e) {
      debugPrint(
        "LOAD COMPLETED PATIENTS ERROR: $e",
      );
    }
  }

//==========================================================
// Refresh
//==========================================================

  Future<void> refreshCompletedPatients() async {
    await loadCompletedPatients();
  }

//==========================================================
// Search
//==========================================================

  void searchPatient(String value) {
    final query = value.toLowerCase().trim();

    if (query.isEmpty) {
      setState(() {
        filteredPatients = completedPatients;

        isSearching = false;
      });

      return;
    }

    setState(() {
      isSearching = true;

      filteredPatients = completedPatients.where((patient) {
        return patient.patientName
            .toLowerCase()
            .contains(query) ||

            patient.patientCode
                .toLowerCase()
                .contains(query) ||

            patient.phone
                .contains(query);
      }).toList();
    });
  }

//==========================================================
// Pick Date
//==========================================================

  Future<void> pickDate() async {
    final picked = await showDatePicker(

      context: context,

      initialDate: selectedDate,

      firstDate: DateTime(2024),

      lastDate: DateTime.now(),

    );

    if (picked == null) return;

    setState(() {
      selectedDate = picked;
    });

    await loadCompletedPatients();
  }

//==========================================================
// Dispose
//==========================================================

  @override
  void dispose() {
    searchController.dispose();

    super.dispose();
  }

//==========================================================
// UI
//==========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(



      body: RefreshIndicator(

        onRefresh: refreshCompletedPatients,

        child: Column(

          children: [


//==================================================
// Search Bar
//==================================================

            Padding(
              padding: const EdgeInsets.fromLTRB(
                16,
                15,
                16,
                12,
              ),
              child: Row(
                children: [
                  //--------------------------------------------------
                  // Back Button
                  //--------------------------------------------------

                  SizedBox(
                    width: 45,
                    height: 45,
                    child: IconButton(
                      tooltip: "Back",
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        }
                      },
                    ),
                  ),

                  const SizedBox(width: 10),

                  //--------------------------------------------------
                  // Date Filter
                  //--------------------------------------------------

                  SizedBox(
                    width: 700,
                    height: 45,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.grey.shade300,
                        ),
                      ),
                      child: InkWell(
                        onTap: pickDate,
                        child: Row(
                          children: [
                            const Icon(
                              Icons.calendar_today,
                              size: 19,
                            ),

                            const SizedBox(width: 10),

                            Expanded(
                              child: Text(
                                DateFormat(
                                  "dd MMM yyyy",
                                ).format(selectedDate),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),

                            const Icon(
                              Icons.keyboard_arrow_down,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  //--------------------------------------------------
                  // Push Right Side Controls To End
                  //--------------------------------------------------

                  const Spacer(),

                  //--------------------------------------------------
                  // Completed Patient Count
                  //--------------------------------------------------

                  Container(
                    width: 200,
                    height: 45,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.check_circle,
                          size: 18,
                          color: Colors.green.shade700,
                        ),

                        const SizedBox(width: 8),

                        Text(
                          "${filteredPatients.length} Completed",
                          style: TextStyle(
                            color: Colors.green.shade700,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 10),

                  //--------------------------------------------------
                  // Refresh Button
                  //--------------------------------------------------

                  SizedBox(
                    width: 45,
                    height: 45,
                    child: IconButton(
                      tooltip: "Refresh Completed Patients",
                      onPressed: () {
                        // Add your existing refresh/load method here
                      },
                      icon: const Icon(
                        Icons.refresh_rounded,
                        size: 22,
                      ),
                      style: IconButton.styleFrom(
                        foregroundColor: Colors.green.shade700,
                        backgroundColor: Colors.white,
                        side: BorderSide(
                          color: Colors.grey.shade300,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

//==================================================
// Date Filter
//==================================================



            const SizedBox(height: 15),

//==================================================
// Completed Patients
//==================================================

            Expanded(
              child: filteredPatients.isEmpty
                  ? const Center(
                child: Text(
                  "No Completed Patients",
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              )
                  : ListView.builder(
                padding: const EdgeInsets.only(
                  bottom: 20,
                ),
                itemCount: filteredPatients.length,
                itemBuilder: (context, index) {
                  final patient =
                  filteredPatients[index];

                  return buildPatientCard(
                    patient,
                  );
                },
              ),
            ),

          ],

        ),

      ),

    );
  }

  //==========================================================
  // Patient Card
  //==========================================================

//==========================================================
// Patient Card
//==========================================================


  Widget buildPatientCard(QueueModel patient) {
    final bool paymentCompleted =
        patient.paymentStatus == "Completed";

    return Container(
      margin: const EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: 8,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      // ==========================================================
      // CARD CLICK FUNCTIONALITY
      // ==========================================================

      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),

        child: InkWell(
          borderRadius: BorderRadius.circular(16),

          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => PatientWorkspace(
                  patientId: patient.patientId,
                ),
              ),
            );
          },

          child: Row(
            children: [
              //--------------------------------------------------
              // Completed Icon
              //--------------------------------------------------

              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check,
                  color: Colors.green.shade700,
                ),
              ),

              const SizedBox(width: 14),

              //--------------------------------------------------
              // Patient Information
              //--------------------------------------------------

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    //--------------------------------------------------
                    // First Row
                    //--------------------------------------------------

                    Row(
                      children: [
                        //--------------------------------------------------
                        // Patient Name
                        //--------------------------------------------------

                        Expanded(
                          child: Text(
                            patient.patientName,
                            maxLines: 1,
                            overflow:
                            TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),

                        //--------------------------------------------------
                        // Completed Time
                        //--------------------------------------------------

                        SizedBox(
                          width: 85,
                          child: patient.completedAt != null
                              ? Row(
                            mainAxisAlignment:
                            MainAxisAlignment.end,
                            children: [
                              Icon(
                                Icons.access_time,
                                size: 14,
                                color:
                                Colors.grey.shade600,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                DateFormat(
                                  "hh:mm a",
                                ).format(
                                  patient.completedAt!,
                                ),
                                style: TextStyle(
                                  color:
                                  Colors.grey.shade700,
                                  fontSize: 11,
                                  fontWeight:
                                  FontWeight.w600,
                                ),
                              ),
                            ],
                          )
                              : const SizedBox(),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    //--------------------------------------------------
                    // Second Row
                    //--------------------------------------------------

                    Row(
                      children: [
                        //--------------------------------------------------
                        // Patient Code + Phone
                        //--------------------------------------------------

                        Expanded(
                          child: Row(
                            children: [
                              Text(
                                patient.patientCode,
                                style: TextStyle(
                                  color:
                                  Colors.grey.shade700,
                                  fontSize: 12,
                                  fontWeight:
                                  FontWeight.w500,
                                ),
                              ),

                              const SizedBox(width: 14),

                              Icon(
                                Icons.phone_outlined,
                                size: 14,
                                color:
                                Colors.grey.shade600,
                              ),

                              const SizedBox(width: 5),

                              Text(
                                patient.phone,
                                style: TextStyle(
                                  color:
                                  Colors.grey.shade700,
                                  fontSize: 12,
                                  fontWeight:
                                  FontWeight.w500,
                                ),
                              ),

                              const SizedBox(width: 18),

                              //--------------------------------------------------
                              // Assigned Doctor
                              //--------------------------------------------------

                              Icon(
                                Icons
                                    .medical_services_outlined,
                                size: 15,
                                color:
                                Colors.blue.shade700,
                              ),

                              const SizedBox(width: 5),

                              Flexible(
                                child: Text(
                                  patient.doctorName.isEmpty
                                      ? "Doctor not assigned"
                                      : patient.doctorName,
                                  maxLines: 1,
                                  overflow:
                                  TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: patient
                                        .doctorName
                                        .isEmpty
                                        ? Colors
                                        .grey
                                        .shade500
                                        : Colors
                                        .blue
                                        .shade700,
                                    fontSize: 12,
                                    fontWeight:
                                    FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        //--------------------------------------------------
                        // View Patient
                        //--------------------------------------------------

                        //--------------------------------------------------
                        // PDF - Doctor Only
                        //--------------------------------------------------

                        //--------------------------------------------------
                        // Payment Amount
                        // Visible For Doctor + Reception
                        //--------------------------------------------------

                        Container(
                          width: 100,
                          height: 38,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius:
                            BorderRadius.circular(6),
                            border: Border.all(
                              color:
                              Colors.blue.shade200,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.currency_rupee,
                                size: 15,
                                color:
                                Colors.blue.shade800,
                              ),

                              const SizedBox(width: 2),

                              Flexible(
                                child: Text(
                                  patient.paymentAmount
                                      .isEmpty
                                      ? "0"
                                      : patient
                                      .paymentAmount,
                                  maxLines: 1,
                                  overflow:
                                  TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color:
                                    Colors.blue.shade800,
                                    fontSize: 13,
                                    fontWeight:
                                    FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 8),

                        //--------------------------------------------------
                        // Reception - Editable Payment Status
                        //--------------------------------------------------

                        if (AuthService.isReception)
                          Container(
                            width: 180,
                            height: 38,
                            padding:
                            const EdgeInsets.symmetric(
                              horizontal: 10,
                            ),
                            decoration: BoxDecoration(
                              color: paymentCompleted
                                  ? Colors.green.shade50
                                  : Colors.orange.shade50,
                              borderRadius:
                              BorderRadius.circular(6),
                              border: Border.all(
                                color: paymentCompleted
                                    ? Colors.green.shade300
                                    : Colors.orange.shade300,
                              ),
                            ),
                            child:
                            DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: paymentCompleted
                                    ? "Completed"
                                    : "Pending",

                                isExpanded: true,

                                icon: Icon(
                                  Icons.keyboard_arrow_down,
                                  size: 20,
                                  color: paymentCompleted
                                      ? Colors.green.shade700
                                      : Colors.orange.shade700,
                                ),

                                style: TextStyle(
                                  color: paymentCompleted
                                      ? Colors.green.shade700
                                      : Colors.orange.shade700,
                                  fontSize: 12,
                                  fontWeight:
                                  FontWeight.w600,
                                ),

                                items: const [
                                  DropdownMenuItem<String>(
                                    value: "Pending",
                                    child: Text(
                                      "Payment Pending",
                                    ),
                                  ),
                                  DropdownMenuItem<String>(
                                    value: "Completed",
                                    child: Text(
                                      "Payment Completed",
                                    ),
                                  ),
                                ],

                                //--------------------------------------------------
                                // PAYMENT FUNCTIONALITY
                                // KEEPING WORKING VERSION
                                //--------------------------------------------------

                                onChanged:
                                    (String? value) async {
                                  if (value == null ||
                                      patient.id == null) {
                                    return;
                                  }

                                  try {
                                    debugPrint(
                                      "================================",
                                    );
                                    debugPrint(
                                      "PAYMENT STATUS UPDATE",
                                    );
                                    debugPrint(
                                      "QUEUE ID: ${patient.id}",
                                    );
                                    debugPrint(
                                      "SESSION ID: ${patient.sessionId}",
                                    );
                                    debugPrint(
                                      "NEW STATUS: $value",
                                    );
                                    debugPrint(
                                      "================================",
                                    );

                                    //==================================================
                                    // 1. UPDATE QUEUE PAYMENT STATUS
                                    //==================================================

                                    await queueRepository
                                        .updatePaymentStatus(
                                      patient.id!,
                                      value,
                                    );

                                    debugPrint(
                                      "QUEUE PAYMENT STATUS UPDATED",
                                    );

                                    //==================================================
                                    // 2. UPDATE SESSION PAYMENT STATUS
                                    //==================================================

                                    if (patient.sessionId !=
                                        null &&
                                        patient.sessionId!
                                            .isNotEmpty) {
                                      try {
                                        await sessionRepository
                                            .updatePaymentStatus(
                                          patient.sessionId!,
                                          value,
                                        );

                                        debugPrint(
                                          "SESSION PAYMENT STATUS UPDATED",
                                        );
                                      } catch (
                                      sessionError) {
                                        // Session document may not exist.
                                        // Do not fail the queue payment update.

                                        debugPrint(
                                          "SESSION PAYMENT UPDATE FAILED: $sessionError",
                                        );
                                      }
                                    } else {
                                      debugPrint(
                                        "NO SESSION ID FOUND",
                                      );
                                    }

                                    //==================================================
                                    // 3. RELOAD COMPLETED PATIENTS
                                    //==================================================

                                    if (!mounted) return;

                                    await loadCompletedPatients();

                                    debugPrint(
                                      "COMPLETED PATIENTS RELOADED",
                                    );
                                  } catch (e) {
                                    debugPrint(
                                      "QUEUE PAYMENT UPDATE ERROR: $e",
                                    );

                                    if (!mounted) return;

                                    ScaffoldMessenger.of(
                                        context)
                                        .showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          "Failed to update payment status: $e",
                                        ),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                          ),

                        //--------------------------------------------------
                        // Doctor - Read Only Payment Status
                        //--------------------------------------------------

                        if (AuthService.isDoctor)
                          Container(
                            width: 180,
                            height: 38,
                            padding:
                            const EdgeInsets.symmetric(
                              horizontal: 12,
                            ),
                            decoration: BoxDecoration(
                              color: paymentCompleted
                                  ? Colors.green.shade50
                                  : Colors.orange.shade50,
                              borderRadius:
                              BorderRadius.circular(6),
                              border: Border.all(
                                color: paymentCompleted
                                    ? Colors.green.shade300
                                    : Colors.orange.shade300,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  paymentCompleted
                                      ? Icons
                                      .check_circle_outline
                                      : Icons.schedule,
                                  size: 16,
                                  color: paymentCompleted
                                      ? Colors.green.shade700
                                      : Colors.orange.shade700,
                                ),

                                const SizedBox(width: 6),

                                Expanded(
                                  child: Text(
                                    paymentCompleted
                                        ? "Payment Completed"
                                        : "Payment Pending",
                                    maxLines: 1,
                                    overflow:
                                    TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: paymentCompleted
                                          ? Colors.green.shade700
                                          : Colors.orange.shade700,
                                      fontSize: 12,
                                      fontWeight:
                                      FontWeight.w600,
                                    ),
                                  ),
                                ),

                                const SizedBox(width: 4),

                                Icon(
                                  Icons.lock_outline,
                                  size: 15,
                                  color: paymentCompleted
                                      ? Colors.green.shade700
                                      : Colors.orange.shade700,
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



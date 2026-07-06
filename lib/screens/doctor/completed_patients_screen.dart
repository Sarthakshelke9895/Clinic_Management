import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/queue_model.dart';
import '../../repositories/queue_repository.dart';
import 'patient_workspace.dart';
import '../../repositories/doctor/session_repository.dart';
import '../../services/pdf/pdf_service.dart';
import '../../models/doctor/session_model.dart';



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
    final date =
    DateFormat('yyyy-MM-dd').format(selectedDate);

    completedFuture =
        queueRepository.getCompletedQueue(date);

    final data = await completedFuture;

    setState(() {
      completedPatients = data;

      filteredPatients = data;
    });
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
                  IconButton(
                    tooltip: "Back",
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      }
                    },
                  ),

                  Expanded(
                    child: Container(
                      height: 50,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
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
                              size: 20,
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

                  const SizedBox(width: 12),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius:
                      BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [

                        Icon(
                          Icons.check_circle,
                          size: 18,
                          color: Colors.green.shade700,
                        ),

                        const SizedBox(width: 6),

                        Text(
                          "${filteredPatients.length}",
                          style: TextStyle(
                            color: Colors.green.shade700,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),

                      ],
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

              child: FutureBuilder<List<QueueModel>>(

                future: completedFuture,

                builder: (context, snapshot) {
                  if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(

                      child:
                      CircularProgressIndicator(),

                    );
                  }

                  if (snapshot.hasError) {
                    return Center(

                      child: Text(

                        snapshot.error.toString(),

                      ),

                    );
                  }

                  if (filteredPatients.isEmpty) {
                    return const Center(

                      child: Column(

                        mainAxisAlignment:
                        MainAxisAlignment.center,

                        children: [



                          SizedBox(height: 15),

                          Text(

                            "No Completed Patients",

                            style: TextStyle(

                              fontSize: 14,



                            ),

                          ),

                        ],

                      ),

                    );
                  }

                  return ListView.builder(

                    padding: const EdgeInsets.only(
                      bottom: 20,
                    ),

                    itemCount:
                    filteredPatients.length,

                    itemBuilder: (context, index) {
                      final patient =
                      filteredPatients[index];

                      return buildPatientCard(
                        patient,
                      );
                    },

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
            color: Colors.black.withOpacity(.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],

      ),

      child: Row(

        crossAxisAlignment: CrossAxisAlignment.start,

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
          // Information
          //--------------------------------------------------

          Expanded(

            child: Column(

              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [

                //--------------------------------------------------
                // NAME
                //--------------------------------------------------

                Row(

                  children: [

                    Expanded(

                      child: Text(

                        patient.patientName,

                        maxLines: 1,

                        overflow:
                        TextOverflow.ellipsis,

                        style: const TextStyle(

                          fontSize: 16,

                          fontWeight:
                          FontWeight.w700,

                        ),

                      ),

                    ),

                    Container(

                      padding:
                      const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),

                      decoration: BoxDecoration(

                        color:
                        Colors.green.shade50,

                        borderRadius:
                        BorderRadius.circular(
                            20),

                        border: Border.all(
                          color:
                          Colors.green.shade200,
                        ),

                      ),

                      child: Row(

                        mainAxisSize:
                        MainAxisSize.min,

                        children: [

                          Icon(

                            Icons.circle,

                            size: 8,

                            color:
                            Colors.green.shade700,

                          ),

                          const SizedBox(width: 5),

                          Text(

                            "Completed",

                            style: TextStyle(

                              color:
                              Colors.green.shade700,

                              fontSize: 11,

                              fontWeight:
                              FontWeight.w600,

                            ),

                          ),

                        ],

                      ),

                    ),

                    const SizedBox(width: 10),

                    if (patient.completedAt != null)

                      Row(

                        children: [

                          Icon(

                            Icons.access_time,

                            size: 15,

                            color:
                            Colors.grey.shade600,

                          ),

                          const SizedBox(width: 4),

                          Text(

                            DateFormat("hh:mm a")
                                .format(
                              patient.completedAt!,
                            ),

                            style: TextStyle(

                              color:
                              Colors.grey.shade700,

                              fontSize: 12,

                              fontWeight:
                              FontWeight.w600,

                            ),

                          ),

                        ],

                      ),

                  ],

                ),

                const SizedBox(height: 8),

                //--------------------------------------------------
                // SECOND LINE
                //--------------------------------------------------

                Row(

                  children: [

                    Expanded(

                      child: Text(

                        "${patient.patientCode} • 📞 ${patient.phone}",

                        overflow:
                        TextOverflow.ellipsis,

                        style: TextStyle(

                          color:
                          Colors.grey.shade700,

                          fontSize: 12,

                        ),

                      ),

                    ),

                    //--------------------------------------------------
                    // View
                    //--------------------------------------------------

                    Tooltip(

                      message: "View Patient",

                      child: IconButton(

                        visualDensity:
                        VisualDensity.compact,

                        splashRadius: 18,

                        hoverColor:
                        Colors.blue.withOpacity(.08),

                        onPressed: () {

                          Navigator.push(

                            context,

                            MaterialPageRoute(

                              builder: (_) =>
                                  PatientWorkspace(
                                    patientId:
                                    patient.patientId,
                                  ),

                            ),

                          );

                        },

                        icon: const Icon(

                          Icons.visibility_outlined,

                          color: Colors.blue,

                          size: 20,

                        ),

                      ),

                    ),

                    //--------------------------------------------------
                    // PDF
                    //--------------------------------------------------

                    Tooltip(

                      message: "Download PDF",

                      child: IconButton(

                        visualDensity:
                        VisualDensity.compact,

                        splashRadius: 18,

                        hoverColor:
                        Colors.red.withOpacity(.08),

                        onPressed: () async {
                          try {
                            debugPrint("PDF BUTTON CLICKED");

                            debugPrint("SESSION ID: ${patient.sessionId}");

                            if (patient.sessionId == null ||
                                patient.sessionId!.isEmpty) {
                              debugPrint("PDF STOPPED: SESSION ID IS MISSING");
                              return;
                            }

                            debugPrint("GET SESSION START");

                            final session = await sessionRepository.getSession(
                              patient.sessionId!,
                            );

                            debugPrint("GET SESSION FINISHED");

                            if (session == null) {
                              debugPrint("PDF STOPPED: SESSION NOT FOUND");
                              return;
                            }

                            debugPrint("CALLING PDF SERVICE");

                            await PdfService.instance.generateSessionPdf(session);

                            debugPrint("PDF SERVICE FINISHED");
                          } catch (e, stackTrace) {
                            debugPrint("PDF ERROR: $e");
                            debugPrintStack(stackTrace: stackTrace);
                          }
                        },

                        icon: const Icon(

                          Icons.picture_as_pdf_outlined,

                          color: Colors.red,

                          size: 20,

                        ),

                      ),

                    ),

                    //--------------------------------------------------
                    // Payment
                    //--------------------------------------------------

                    Container(

                      margin:
                      const EdgeInsets.only(
                        left: 6,
                      ),

                      padding:
                      const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),

                      decoration: BoxDecoration(

                        color: paymentCompleted
                            ? Colors.green.shade50
                            : Colors.orange.shade50,

                        borderRadius:
                        BorderRadius.circular(
                            20),

                      ),

                      child: Text(

                        patient.paymentAmount.isEmpty
                            ? "₹0"
                            : "₹${patient.paymentAmount}",

                        style: TextStyle(

                          color: paymentCompleted
                              ? Colors.green.shade700
                              : Colors.orange.shade700,

                          fontWeight:
                          FontWeight.bold,

                          fontSize: 11,

                        ),

                      ),

                    ),

                  ],

                ),

              ],

            ),

          ),

        ],

      ),

    );

  }
}



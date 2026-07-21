import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/queue_model.dart';
import '../../repositories/queue_repository.dart';


import '../services/auth/auth_service.dart';
import '../screens/doctor/doctor_workspace.dart';

class QueueScreen extends StatefulWidget {
  final bool embedded;

  const QueueScreen({
    super.key,
    this.embedded = false,
  });

  @override
  State<QueueScreen> createState() => _QueueScreenState();
}

class _QueueScreenState extends State<QueueScreen> {

  String selectedDate = "";

  String displayDate = "";
  final QueueRepository repository = QueueRepository();

  late Future<List<QueueModel>> queueFuture;

  @override
  void initState() {
    super.initState();
    selectedDate =
        DateFormat('yyyy-MM-dd').format(DateTime.now());

    displayDate =
        DateFormat('dd MMM yyyy').format(DateTime.now());

    queueFuture =
        repository.getWaitingQueue(selectedDate);
  }


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

    displayDate =
        DateFormat('dd MMM yyyy').format(picked);

    refreshQueue();

  }
  Future<void> refreshQueue() async {
    setState(() {
      queueFuture =
          repository.getWaitingQueue(selectedDate);
    });
  }


  void openPatientWorkspace(QueueModel patient) {
    if (!AuthService.isDoctor) {
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DoctorWorkspace(
          initialQueue: patient,
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(




      body: Column(
        children: [

          // ===========================
          // Queue Date Filter
          // ===========================

          Padding(
            padding: const EdgeInsets.fromLTRB(
              16,
              16,
              16,
              12,
            ),
            child: Row(
              children: [
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
                      borderRadius: BorderRadius.circular(6),
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
                              displayDate,
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

                // Push Queue and Refresh to the right
                const Spacer(),

                //--------------------------------------------------
                // Queue Button
                //--------------------------------------------------

                Container(
                  width: 200,
                  height: 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.groups,
                        size: 18,
                        color: Colors.blue,
                      ),

                      SizedBox(width: 6),

                      Text(
                        "Queue",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
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
                  width: 50,
                  height: 45,
                  child: IconButton(
                    tooltip: "Refresh Queue",
                    onPressed: () {
                      refreshQueue();
                    },
                    icon: const Icon(
                      Icons.refresh_rounded,
                      size: 24,
                    ),
                    style: IconButton.styleFrom(
                      foregroundColor: Theme.of(context).primaryColor,
                      backgroundColor: Colors.white,
                      side: BorderSide(
                        color: Colors.grey.shade300,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ===========================
          // Queue List
          // ===========================

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
                    child: Text(snapshot.error.toString()),
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

                return Column(
                  children: [

                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        16,
                        0,
                        16,
                        12,
                      ),
                      child: Row(
                        children: [

                          const Text(
                            "Today's Queue",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const Spacer(),

                          Text(
                            "${queue.length} Patients",
                            style: TextStyle(
                              color: Colors.grey,

                              fontSize: 12,
                            ),
                          ),

                        ],
                      ),
                    ),

                    Expanded(
                      child: RefreshIndicator(
                     onRefresh: refreshQueue,

                child: ListView.builder(

                itemCount: queue.length,

                itemBuilder: (_, index) {

                final patient = queue[index];

                return Material(
                  color: Colors.transparent,
                  child: InkWell(
                    // Only doctors can click the patient row.
                    // Receptionist gets null, so the row is not clickable.
                    onTap: AuthService.isDoctor
                        ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DoctorWorkspace(
                            initialQueue: patient,
                          ),
                        ),
                      );
                    }
                        : null,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      margin: const EdgeInsets.only(
                        left: 16,
                        right: 16,
                        bottom: 1,
                      ),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
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
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //--------------------------------------------------
                          // Queue Number
                          //--------------------------------------------------

                          Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                "${index + 1}",
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 10),

                          //--------------------------------------------------
                          // Patient Details
                          //--------------------------------------------------

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //--------------------------------------------------
                                // Name + Time
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
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ),

                                    //--------------------------------------------------
                                    // Waiting Chip
                                    //--------------------------------------------------

                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.orange.shade50,
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(
                                          color: Colors.orange.shade200,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.circle,
                                            size: 8,
                                            color: Colors.orange.shade700,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            "Waiting",
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.orange.shade700,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    const SizedBox(width: 10),

                                    //--------------------------------------------------
                                    // Arrival Time
                                    //--------------------------------------------------

                                    Row(
                                      children: [
                                        Icon(
                                          Icons.access_time_rounded,
                                          size: 15,
                                          color: Colors.grey.shade600,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          patient.arrivalTime,
                                          style: TextStyle(
                                            color: Colors.grey.shade700,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 1),

                                //--------------------------------------------------
                                // Code + Phone + Doctor
                                //--------------------------------------------------

                                Row(
                                  children: [
                                    Expanded(
                                      child: Row(
                                        children: [
                                          //--------------------------------------------------
                                          // Patient Code
                                          //--------------------------------------------------

                                          Text(
                                            patient.patientCode,
                                            style: TextStyle(
                                              color: Colors.grey.shade700,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),

                                          const SizedBox(width: 14),

                                          //--------------------------------------------------
                                          // Phone
                                          //--------------------------------------------------

                                          Icon(
                                            Icons.phone_outlined,
                                            size: 14,
                                            color: Colors.grey.shade600,
                                          ),

                                          const SizedBox(width: 5),

                                          Text(
                                            patient.phone,
                                            style: TextStyle(
                                              color: Colors.grey.shade700,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),

                                          const SizedBox(width: 18),

                                          //--------------------------------------------------
                                          // Assigned Doctor
                                          //--------------------------------------------------

                                          Icon(
                                            Icons.medical_services_outlined,
                                            size: 15,
                                            color: Colors.blue.shade700,
                                          ),

                                          const SizedBox(width: 5),

                                          Flexible(
                                            child: Text(
                                              patient.doctorName.isEmpty
                                                  ? "Doctor not assigned"
                                                  : patient.doctorName,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                color: patient.doctorName.isEmpty
                                                    ? Colors.grey.shade500
                                                    : Colors.blue.shade700,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    //--------------------------------------------------
                                    // Remove Button
                                    //--------------------------------------------------

                                    Tooltip(
                                      message: "Remove from Queue",
                                      child: Material(
                                        color: Colors.transparent,
                                        borderRadius: BorderRadius.circular(8),
                                        child: InkWell(
                                          borderRadius: BorderRadius.circular(8),
                                          hoverColor:
                                          Colors.red.withValues(alpha: .08),
                                          splashColor:
                                          Colors.red.withValues(alpha: .15),

                                          // This continues to work for both
                                          // receptionist and doctor.
                                          onTap: () async {
                                            await repository.removePatient(
                                              patient.id!,
                                            );

                                            await refreshQueue();
                                          },

                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 6,
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(
                                                  Icons.close_rounded,
                                                  size: 18,
                                                  color: Colors.red.shade600,
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  "Remove",
                                                  style: TextStyle(
                                                    color: Colors.red.shade600,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
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
                    ),
                  ),
                );

                },

                ),

                )
                    ),
                  ],
                );

              },

            ),
          ),

        ],
      ),

    );

  }

}
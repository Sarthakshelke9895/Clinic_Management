import 'package:flutter/material.dart';

import '../../models/patient_model.dart';
import '../../patient/patient_search_controller.dart';
import 'patient_details.dart';
import 'register_patient.dart';
import '../../repositories/queue_repository.dart';

class PatientSearchScreen extends StatefulWidget {
  final bool embedded;

  const PatientSearchScreen({
    super.key,
    this.embedded = false,
  });

  @override
  State<PatientSearchScreen> createState() =>
      _PatientSearchScreenState();
}

class _PatientSearchScreenState
    extends State<PatientSearchScreen> {

  Future<String?> showDoctorAssignDialog() async {
    String? selectedDoctor;

    final doctors = [
      "Dr. Rahul Patil",
      "Dr. Sneha Sharma",
      "Dr. Amit Kulkarni",
      "Dr. Priya Deshmukh",
      "Dr. Rohan Joshi",
    ];

    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),

              title: const Row(
                children: [
                  Icon(
                    Icons.medical_services_outlined,
                    size: 22,
                  ),
                  SizedBox(width: 10),
                  Text(
                    "Assign Doctor",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              content: SizedBox(
                width: 400,
                child: DropdownButtonFormField<String>(
                  value: selectedDoctor,
                  isExpanded: true,
                  decoration: InputDecoration(
                    labelText: "Select Doctor",
                    prefixIcon: const Icon(
                      Icons.person_outline,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  items: doctors.map((doctor) {
                    return DropdownMenuItem<String>(
                      value: doctor,
                      child: Text(doctor),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setDialogState(() {
                      selectedDoctor = value;
                    });
                  },
                ),
              ),

              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                  },
                  child: const Text("Cancel"),
                ),

                ElevatedButton(
                  onPressed: selectedDoctor == null
                      ? null
                      : () {
                    Navigator.pop(
                      dialogContext,
                      selectedDoctor,
                    );
                  },
                  child: const Text(
                    "Assign & Add",
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }





  final PatientSearchController controller =
  PatientSearchController();

  List<Patient> patients = [];

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadPatients();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> loadPatients() async {
    setState(() {
      isLoading = true;
    });

    patients = await controller.getAllPatients();

    setState(() {
      isLoading = false;
    });
  }

  Future<void> searchPatient(String value) async {
    setState(() {
      isLoading = true;
    });

    if (value.trim().isEmpty) {
      patients = await controller.getAllPatients();
    } else {
      patients = await controller.searchPatients(value);
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(




      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [

            Row(
              children: [
                //--------------------------------------------------
                // Search Bar
                //--------------------------------------------------
                SizedBox(
                  width: 700,
                  height: 45,
                  child: TextField(
                    controller: controller.searchController,
                    onChanged: searchPatient,
                    decoration: InputDecoration(
                      hintText: "Search by Name or Mobile Number",
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 0,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: BorderSide(
                          color: Colors.grey.shade300,
                        ),
                      ),
                    ),
                  ),
                ),
                const Spacer(),

                const SizedBox(width: 12),

                //--------------------------------------------------
                // Register Button
                //--------------------------------------------------
                SizedBox(
                  height: 42,
                  width: 200,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                      ),
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    onPressed: () async {
                      final refresh = await showDialog<bool>(
                        context: context,
                        barrierDismissible: false,
                        builder: (_) {
                          return const RegisterPatientScreen();
                        },
                      );

                      if (!context.mounted) return;

                      if (refresh == true) {
                        loadPatients();
                      }
                    },
                    icon: const Icon(
                      Icons.person_add_alt_1,
                      size: 20,
                    ),
                    label: const Text(
                      "Register",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                //--------------------------------------------------
                // Refresh Button
                //--------------------------------------------------
                SizedBox(
                  height: 42,
                  width: 42,
                  child: IconButton(
                    tooltip: "Refresh Patients",
                    onPressed: () {
                      controller.searchController.clear();
                      loadPatients();
                    },
                    icon: const Icon(
                      Icons.refresh_rounded,
                      size: 22,
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

            const SizedBox(height: 15),

            Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
              children: [

                const Text(
                  "All Patients",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),

                Text(
                  "${patients.length} Patients",
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            Expanded(
              child: isLoading
                  ? const Center(
                child:
                CircularProgressIndicator(),
              )
                  : patients.isEmpty
                  ? Center(
                child: Column(
                  mainAxisAlignment:
                  MainAxisAlignment
                      .center,
                  children: [

                    const Icon(
                      Icons.person_off,
                      size: 90,
                      color: Colors.grey,
                    ),

                    const SizedBox(
                        height: 15),

                    const Text(
                      "Patient Not Found",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight:
                        FontWeight
                            .bold,
                      ),
                    ),

                    const SizedBox(
                        height: 8),

                    const Text(
                      "Register a new patient.",
                    ),

                    const SizedBox(
                        height: 20),

                    SizedBox(
                      height: 40,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                          ),
                          backgroundColor: Theme.of(context).primaryColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        onPressed: () async {

                          final refresh = await showDialog<bool>(
                            context: context,
                            barrierDismissible: false,
                            builder: (_) {
                              return const RegisterPatientScreen();
                            },
                          );

                          if (!context.mounted) return;

                          if (refresh == true) {
                            loadPatients();
                          }

                        },
                        icon: const Icon(Icons.person_add_alt_1, size: 20),
                        label: const Text(
                          "Register000",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
                  : ListView.builder(
                itemCount:
                patients.length,
                itemBuilder:
                    (context, index) {

                  final patient =
                  patients[index];

                  return FutureBuilder<bool>(
                    future: QueueRepository().isPatientInQueue(patient.id!),
                    builder: (_, snapshot) {
                      final waiting = snapshot.data ?? false;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 2),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.grey.shade300,
                            ),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            //------------------------------------------------
                            // Avatar
                            //------------------------------------------------

                            CircleAvatar(
                              radius: 18,
                              backgroundColor: Colors.blue.shade50,
                              child: const Icon(
                                Icons.person,
                                color: Colors.blue,
                                size: 20,
                              ),
                            ),

                            const SizedBox(width: 12),

                            //------------------------------------------------
                            // Patient Information
                            //------------------------------------------------

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  Row(
                                    children: [

                                      Expanded(
                                        child: Text(
                                          patient.name,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),

                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 3,
                                        ),
                                        decoration: BoxDecoration(
                                          color: waiting
                                              ? Colors.orange.shade100
                                              : Colors.green.shade100,
                                          borderRadius:
                                          BorderRadius.circular(30),
                                        ),
                                        child: Text(
                                          waiting
                                              ? "Waiting"
                                              : "Available",
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            color: waiting
                                                ? Colors.orange.shade800
                                                : Colors.green.shade800,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 6),

                                  Row(
                                    children: [


                                      Text(
                                        patient.patientCode,
                                        style: TextStyle(
                                          color: Colors.grey.shade700,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),




                                      const Text(
                                        " • ",
                                        style: TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),

                                      Text(
                                        "${patient.age}Y",
                                        style: TextStyle(
                                          color: Colors.grey.shade700,
                                          fontSize: 12,
                                        ),
                                      ),

                                      const Text(
                                        " • ",
                                        style: TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),

                                      const Icon(
                                        Icons.phone,
                                        size: 14,
                                        color: Colors.grey,
                                      ),

                                      const SizedBox(width: 4),

                                      Expanded(
                                        child: Text(
                                          patient.phone,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: Colors.grey.shade700,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),

                                      //------------------------------------------------
                                      // Actions
                                      //------------------------------------------------

                                      Tooltip(
                                        message: "View",
                                        child: IconButton(
                                          visualDensity:
                                          VisualDensity.compact,
                                          splashRadius: 18,
                                          icon: const Icon(
                                            Icons.visibility_outlined,
                                            size: 20,
                                            color: Colors.indigo,
                                          ),
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              barrierDismissible: true,
                                              builder: (_) {
                                                return PatientDetails(
                                                  patient: patient,
                                                );
                                              },
                                            );
                                          },
                                        ),
                                      ),

                                      Tooltip(
                                        message: "Edit",
                                        child: IconButton(
                                          visualDensity:
                                          VisualDensity.compact,
                                          splashRadius: 18,
                                          icon: const Icon(
                                            Icons.edit_outlined,
                                            size: 20,
                                            color: Colors.orange,
                                          ),
                                          onPressed: () async {

                                            final refresh = await showDialog<bool>(
                                              context: context,
                                              barrierDismissible: false,
                                              builder: (_) {
                                                return RegisterPatientScreen(
                                                  patient: patient,
                                                );
                                              },
                                            );

                                            if (refresh == true) {
                                              loadPatients();
                                            }

                                          },
                                        ),
                                      ),

                                      Tooltip(
                                        message: waiting
                                            ? "Already in Queue"
                                            : "Add to Queue",
                                        child: IconButton(
                                          visualDensity:
                                          VisualDensity.compact,
                                          splashRadius: 18,
                                          icon: Icon(
                                            waiting
                                                ? Icons.check_circle
                                                : Icons.add_circle_outline,
                                            color: waiting
                                                ? Colors.green
                                                : Colors.blue,
                                            size: 22,
                                          ),
                                          onPressed: waiting
                                              ? null
                                              : () async {
                                            //------------------------------------------------
                                            // Open Doctor Assignment Dialog
                                            //------------------------------------------------

                                            final selectedDoctor =
                                            await showDoctorAssignDialog();

                                            // User clicked Cancel
                                            if (selectedDoctor == null) {
                                              return;
                                            }

                                            try {
                                              //------------------------------------------------
                                              // Add Patient To Queue With Doctor
                                              //------------------------------------------------

                                              await QueueRepository().addPatientToQueue(
                                                patient,
                                                doctorName: selectedDoctor,
                                              );

                                              if (!mounted) return;

                                              //------------------------------------------------
                                              // Refresh Patient List / Button State
                                              //------------------------------------------------

                                              await loadPatients();

                                              if (!mounted) return;

                                              //------------------------------------------------
                                              // Success Message
                                              //------------------------------------------------

                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    "${patient.name} assigned to $selectedDoctor",
                                                  ),
                                                  backgroundColor: Colors.green,
                                                ),
                                              );
                                            } catch (e) {
                                              if (!mounted) return;

                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    e.toString(),
                                                  ),
                                                ),
                                              );
                                            }
                                          },

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
}
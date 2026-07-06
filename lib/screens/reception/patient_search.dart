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

                Expanded(
                  flex: 4,
                  child: SizedBox(
                    height: 50,
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
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                //--------------------------------------------------
                // Register Button
                //--------------------------------------------------

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
                      "Register",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
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
                                            try {
                                              await QueueRepository()
                                                  .addPatientToQueue(
                                                  patient);

                                              loadPatients();
                                            } catch (e) {
                                              ScaffoldMessenger.of(
                                                  context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                      e.toString()),
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
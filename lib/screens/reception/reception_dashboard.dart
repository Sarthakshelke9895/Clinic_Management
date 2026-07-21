import 'package:flutter/material.dart';
import 'dart:async';
import '../../repositories/dashboard_repository.dart';
import '../../screens/queue_screen.dart';
import '../../utils/app_colors.dart';
import '../../widgets/common/dashboard_tile.dart';
import '../../widgets/common/info_card.dart';
import 'patient_search.dart';
import 'package:intl/intl.dart';
import '../../screens/doctor/completed_patients_screen.dart';
import '../roles_screen.dart';

class ReceptionDashboard extends StatefulWidget {
  const ReceptionDashboard({super.key});

  @override
  State<ReceptionDashboard> createState() =>
      _ReceptionDashboardState();
}

class _ReceptionDashboardState
    extends State<ReceptionDashboard> {

  final DashboardRepository dashboardRepository =
  DashboardRepository();

  late Timer _timer;

  DateTime _currentTime = DateTime.now();
  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(
      const Duration(seconds: 1),
          (timer) {
        if (!mounted) return;

        setState(() {
          _currentTime = DateTime.now();
        });
      },
    );
  }
  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String getGreeting() {
    final hour = _currentTime.hour;

    if (hour < 12) {
      return "Good Morning 👋";
    } else if (hour < 17) {
      return "Good Afternoon ☀️";
    } else {
      return "Good Evening 🌙";
    }
  }

  String getCurrentDate() {
    return DateFormat(
      "EEEE, dd MMMM yyyy",
    ).format(_currentTime);
  }

  String getCurrentTime() {
    return DateFormat(
      "hh:mm:ss a",
    ).format(_currentTime);
  }
  @override
  Widget build(BuildContext context) {
    return PopScope(

        canPop: false,

        child: Scaffold(

      appBar: AppBar(

        automaticallyImplyLeading: false,

        title: const Text(
          "Reception Dashboard",
        ),

        backgroundColor: AppColors.primary,

        foregroundColor: Colors.white,

        centerTitle: true,

        actions: [

          IconButton(

            tooltip: "Logout",

            icon: const Icon(Icons.logout),

            onPressed: () async {

              final logout = await showDialog<bool>(

                context: context,

                builder: (_) => AlertDialog(

                  title: const Text("Logout"),

                  content: const Text(
                    "Are you sure you want to logout?",
                  ),

                  actions: [

                    TextButton(

                      onPressed: () {

                        Navigator.pop(context, false);

                      },

                      child: const Text("Cancel"),

                    ),

                    FilledButton(

                      onPressed: () {

                        Navigator.pop(context, true);

                      },

                      child: const Text("Logout"),

                    ),

                  ],

                ),

              );

              if (logout != true) return;

              if (!mounted) return;

              Navigator.pushAndRemoveUntil(

                context,

                MaterialPageRoute(

                  builder: (_) => const RoleSelectionScreen(),

                ),

                    (route) => false,

              );

            },

          ),

        ],

      ),

      body: Padding(
        padding: const EdgeInsets.all(16),


        child: ListView(
          children: [

            Text(
              getGreeting(),
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 5),

            Text(
              getCurrentTime(),
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
            Text(
              getCurrentDate(),
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 20),

            // =========================
            // First Row
            // =========================

            Row(
              children: [

                Expanded(
                  child: StreamBuilder<int>(
                    stream:
                    dashboardRepository.waitingPatients(),
                    builder: (context, snapshot) {

                      return InkWell(
                        borderRadius:
                        BorderRadius.circular(12),

                        onTap: () {

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                              const QueueScreen(),
                            ),
                          );

                        },

                        child: InfoCard(
                          title: "Today's"
                              " Queue",
                          value: snapshot.data
                              ?.toString() ??
                              "0",
                          icon: Icons.people,
                          color: Colors.blue,
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: StreamBuilder<int>(
                    stream:
                    dashboardRepository.waitingPatients(),
                    builder: (context, snapshot) {

                      return InkWell(
                        borderRadius:
                        BorderRadius.circular(12),

                        onTap: () {

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                              const QueueScreen(),
                            ),
                          );

                        },

                        child: InfoCard(
                          title: "Waiting",
                          value: snapshot.data
                              ?.toString() ??
                              "0",
                          icon: Icons.hourglass_bottom,
                          color: Colors.orange,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // =========================
            // Second Row
            // =========================

            Row(
              children: [

                Expanded(
                  child: StreamBuilder<int>(
                    stream: dashboardRepository
                        .completedPatients(),
                    builder: (context, snapshot) {

                      return InkWell(
                        borderRadius:
                        BorderRadius.circular(12),

                        onTap: () {

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                              const CompletedPatientsScreen(),
                            ),
                          );

                        },

                        child: InfoCard(
                          title: "Completed",
                          value: snapshot.data
                              ?.toString() ??
                              "0",
                          icon: Icons.check_circle,
                          color: Colors.green,
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: StreamBuilder<int>(
                    stream:
                    dashboardRepository.totalPatients(),
                    builder: (context, snapshot) {

                      return InkWell(
                        borderRadius:
                        BorderRadius.circular(12),

                        onTap: () {

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                              const PatientSearchScreen(),
                            ),
                          );

                        },

                        child: InfoCard(
                          title: "Patients",
                          value: snapshot.data
                              ?.toString() ??
                              "0",
                          icon: Icons.person,
                          color: Colors.purple,
                        ),
                      );
                    },
                  ),
                ),

              ],
            ),

            const SizedBox(height: 30),

            DashboardTile(
              title: "Search Patient",
              icon: Icons.search,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                    const PatientSearchScreen(),
                  ),
                );
              },
            ),

            const SizedBox(height: 15),

            DashboardTile(
              title: " Queue",
              icon: Icons.queue,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                    const QueueScreen(),
                  ),
                );
              },
            ),

          ],
        ),
      ),
    ),
    );
  }
}
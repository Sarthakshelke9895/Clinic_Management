import 'dart:async';

import 'package:REVERE/screens/queue_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../utils/app_colors.dart';

import '../../repositories/dashboard_repository.dart';
import 'doctor_workspace.dart';
import 'completed_patients_screen.dart';
import '../roles_screen.dart';

class DoctorDashboard extends StatefulWidget {
  const DoctorDashboard({super.key});

  @override
  State<DoctorDashboard> createState() =>
      _DoctorDashboardState();
}

class _DoctorDashboardState
    extends State<DoctorDashboard> {


  Future<void> refreshDashboard() async {

    setState(() {

      // Rebuilds the dashboard.
      // StreamBuilders will reconnect and fetch the latest data.

    });

  }
final DashboardRepository repository =
DashboardRepository();

late Timer timer;

DateTime currentTime = DateTime.now();

@override
void initState() {
super.initState();

timer = Timer.periodic(
const Duration(seconds: 1),
(_) {
setState(() {
currentTime = DateTime.now();
});
},
);
}

@override
void dispose() {
timer.cancel();
super.dispose();
}

String get greeting {

final hour = currentTime.hour;

if (hour < 12) {
return "Good Morning 👋";
}

if (hour < 17) {
return "Good Afternoon 👋";
}

return "Good Evening 👋";
}

@override
Widget build(BuildContext context) {

  return PopScope(

      canPop: false,

      child: Scaffold(

        appBar: AppBar(

          automaticallyImplyLeading: false,

          centerTitle: true,

          backgroundColor: AppColors.primary,

          foregroundColor: Colors.white,

          title: const Text(
            "Doctor Portal",
          ),

          actions: [

            IconButton(

              tooltip: "Logout",

              onPressed: logout,

              icon: const Icon(
                Icons.logout,
              ),

            ),

          ],

        ),

body: RefreshIndicator(
  onRefresh: refreshDashboard,

  child: SingleChildScrollView(

padding: const EdgeInsets.all(20),

child: Column(

crossAxisAlignment:
CrossAxisAlignment.start,

children: [



//------------------------------------------------

//------------------------------------------------
  // Greeting
  //------------------------------------------------

  Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [

      // LEFT
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text(
            greeting,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            "Welcome Back",
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 14,
            ),
          ),

        ],
      ),

      // RIGHT
      Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [

          Text(
            DateFormat("dd MMM yyyy").format(currentTime),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            DateFormat("hh:mm:ss a").format(currentTime),
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 14,
            ),
          ),

        ],
      ),

    ],
  ),
const SizedBox(height: 30),

//------------------------------------------------




  //------------------------------------------------
  // Today's Overview
  //------------------------------------------------

  const Text(
    "Today's Overview",
    style: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
    ),
  ),

  const SizedBox(height: 20),

  LayoutBuilder(
    builder: (context, constraints) {
      final isMobile = constraints.maxWidth < 700;

      return Flex(
        direction: isMobile ? Axis.vertical : Axis.horizontal,
        children: [
          Expanded(
            child: StreamBuilder<int>(
              stream: repository.waitingPatients(),
              builder: (_, snapshot) {
                return _dashboardCard(
                  context: context,
                  title: "Waiting",
                  subtitle: "Patients in queue",
                  value: snapshot.data ?? 0,
                  color: Colors.orange,
                  icon: Icons.hourglass_top_rounded,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const DoctorWorkspace(),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          SizedBox(
            width: isMobile ? 0 : 18,
            height: isMobile ? 18 : 0,
          ),

          Expanded(
            child: StreamBuilder<int>(
              stream: repository.completedPatients(),
              builder: (_, snapshot) {
                return _dashboardCard(
                  context: context,
                  title: "Completed",
                  subtitle: "Today's sessions",
                  value: snapshot.data ?? 0,
                  color: Colors.green,
                  icon: Icons.task_alt_rounded,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                        const CompletedPatientsScreen(),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      );
    },
  ),



  //------------------------------------------------
  // Start Consultation
  //------------------------------------------------

  const SizedBox(height: 35),

  //------------------------------------------------
  // Today's Waiting Queue
  //------------------------------------------------

  Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [

      const Text(
        "Today's Waiting Queue",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),

      TextButton.icon(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const DoctorWorkspace(),
            ),
          );
        },
        icon: const Icon(Icons.open_in_new),
        label: const Text("Open Workspace"),
      ),

    ],
  ),

  const SizedBox(height: 15),

  //------------------------------------------------
  // Embedded Waiting Queue Screen
  //------------------------------------------------

  SizedBox(
    height: 500,
    width: double.infinity,
    child: ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: const QueueScreen(),
    ),
  ),

  const SizedBox(height: 30),



],

),

),

),
  ),
  );

}
  Widget _dashboardCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required int value,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Ink(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.05),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Row(
            children: [
              Container(
                height: 62,
                width: 62,
                decoration: BoxDecoration(
                  color: color.withOpacity(.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 30,
                ),
              ),

              const SizedBox(width: 18),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),

              Text(
                value.toString(),
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> logout() async {

    final confirm = await showDialog<bool>(

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

    if (confirm != true) return;

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(

      context,

      MaterialPageRoute(

        builder: (_) =>
        const RoleSelectionScreen(),

      ),

          (route) => false,

    );

  }
//==========================================================
// Analytics Card
//==========================================================

Widget _analyticsCard({

  required String title,

  required String value,

  required IconData icon,

  required Color color,

}) {

  return Card(

    elevation: 3,

    shape: RoundedRectangleBorder(

      borderRadius:
      BorderRadius.circular(15),

    ),

    child: Padding(

      padding: const EdgeInsets.all(18),

      child: Column(

        children: [

          CircleAvatar(

            radius: 28,

            backgroundColor:
            color.withOpacity(.15),

            child: Icon(

              icon,

              color: color,

              size: 28,

            ),

          ),

          const SizedBox(height: 15),

          Text(

            value,

            style: const TextStyle(

              fontSize: 28,

              fontWeight: FontWeight.bold,

            ),

          ),

          const SizedBox(height: 5),

          Text(

            title,

            style: const TextStyle(

              color: Colors.grey,

            ),

          ),

        ],

      ),

    ),

  );

}

}
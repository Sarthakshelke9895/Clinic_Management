import 'dart:async';


import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../repositories/dashboard_repository.dart';
import '../../utils/app_colors.dart';
import '../roles_screen.dart';
import '../../screens/reception/patient_search.dart';
import '../queue_screen.dart';
import '../../screens/doctor/completed_patients_screen.dart';

class ReceptionPortal extends StatefulWidget {
  const ReceptionPortal({super.key});

  @override
  State<ReceptionPortal> createState() =>
      _ReceptionPortalState();
}

class _ReceptionPortalState
    extends State<ReceptionPortal> {

  //----------------------------------------------------------
  // Repository
  //----------------------------------------------------------

  final DashboardRepository dashboardRepository =
  DashboardRepository();

  //----------------------------------------------------------
  // Timer
  //----------------------------------------------------------

  late Timer timer;

  DateTime currentTime = DateTime.now();

  //----------------------------------------------------------
  // Navigation
  //----------------------------------------------------------

  int selectedPage = 0;

  //----------------------------------------------------------
  // Init
  //----------------------------------------------------------

  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(
      const Duration(seconds: 1),
          (_) {
        if (!mounted) return;

        setState(() {
          currentTime = DateTime.now();
        });
      },
    );
  }

  //----------------------------------------------------------
  // Dispose
  //----------------------------------------------------------

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  //----------------------------------------------------------
  // Greeting
  //----------------------------------------------------------

  String get greeting {

    final hour = currentTime.hour;

    if (hour < 12) {
      return "Good Morning 👋";
    }

    if (hour < 17) {
      return "Good Afternoon ☀️";
    }

    return "Good Evening 🌙";
  }

  //----------------------------------------------------------
  // Change Page
  //----------------------------------------------------------

  void changePage(int page) {

    if (selectedPage == page) return;

    setState(() {

      selectedPage = page;

    });

  }

  //----------------------------------------------------------
  //








  //----------------------------------------------------------

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

  //----------------------------------------------------------
  // UI
  //----------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    //----------------------------------------------------------
// Responsive
//----------------------------------------------------------

    final Size screenSize = MediaQuery.of(context).size;

    final double screenWidth = screenSize.width;

    final double screenHeight = screenSize.height;

    final bool isMobile = screenWidth < 700;

    final bool isTablet =
        screenWidth >= 700 && screenWidth < 1100;

    final bool isDesktop = screenWidth >= 1100;
    //----------------------------------------------------------
// Responsive Dimensions
//----------------------------------------------------------

    final double pagePadding =
    isMobile ? 12 : 20;

    final double sectionSpacing =
    isMobile ? 12 : 20;

    final double analyticsHeight =
    isMobile ? 150 : 80;

    final double navigationHeight =
    isMobile ? 110 : 55;

    final double cardRadius =
    isMobile ? 14 : 18;

    final double titleFont =
    isMobile ? 20 : 24;

    final double subtitleFont =
    isMobile ? 13 : 14;

    return PopScope(

      canPop: false,

      child: Scaffold(

        backgroundColor: Colors.grey.shade100,

        appBar: AppBar(

          automaticallyImplyLeading: false,

          centerTitle: true,

          backgroundColor: AppColors.primary,

          foregroundColor: Colors.white,

          title: const Text(
            "Reception Portal",
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

        body: Padding(

          padding: EdgeInsets.all(pagePadding),

          child: Column(

            crossAxisAlignment:
            CrossAxisAlignment.start,

            children: [

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

              const SizedBox(height: 1),
              //------------------------------------------------
              // Analytics
              //------------------------------------------------

              //------------------------------------------------
// Analytics Cards
//------------------------------------------------

              SizedBox(

                height: 80,
                width: 10000,

                child: Row(

                  children: [

                    //------------------------------------------------
                    // Patients
                    //------------------------------------------------

                    Expanded(

                      child: StreamBuilder<int>(

                        stream: dashboardRepository.totalPatients(),

                        builder: (_, snapshot) {

                          return _analyticsCard(

                            title: "Patients",

                            value: "${snapshot.data ?? 0}",

                            icon: Icons.people,

                            color: Colors.purple,

                            selected: false,

                          );

                        },

                      ),

                    ),

                    const SizedBox(width: 15),

                    //------------------------------------------------
                    // Today's Queue
                    //------------------------------------------------

                    Expanded(

                      child: StreamBuilder<int>(

                        stream: dashboardRepository.waitingPatients(),

                        builder: (_, snapshot) {

                          return _analyticsCard(

                            title: "Today's Queue",

                            value: "${snapshot.data ?? 0}",

                            icon: Icons.groups,

                            color: Colors.blue,

                            selected: false,

                          );

                        },

                      ),

                    ),

                    const SizedBox(width: 15),

                    //------------------------------------------------
                    // Waiting
                    //------------------------------------------------

                    Expanded(

                      child: StreamBuilder<int>(

                        stream: dashboardRepository.waitingPatients(),

                        builder: (_, snapshot) {

                          return _analyticsCard(

                            title: "Waiting",

                            value: "${snapshot.data ?? 0}",

                            icon: Icons.schedule,

                            color: Colors.orange,

                            selected: false,

                          );

                        },

                      ),

                    ),

                    const SizedBox(width: 15),

                    //------------------------------------------------
                    // Completed
                    //------------------------------------------------

                    Expanded(

                      child: StreamBuilder<int>(

                        stream: dashboardRepository.completedPatients(),

                        builder: (_, snapshot) {

                          return _analyticsCard(

                            title: "Completed",

                            value: "${snapshot.data ?? 0}",

                            icon: Icons.check_circle,

                            color: Colors.green,

                            selected: false,

                          );

                        },

                      ),

                    ),

                  ],

                ),

              ),

              const SizedBox(height: 10),

              //------------------------------------------------
              // Navigation
              //------------------------------------------------

              //------------------------------------------------
// Navigation Tabs
//------------------------------------------------

              Container(

                padding: const EdgeInsets.all(5),

                decoration: BoxDecoration(

                  color: Colors.grey.shade200,

                  borderRadius: BorderRadius.circular(15),

                ),

                child: isMobile

                //------------------------------------------------
                // Mobile
                //------------------------------------------------

                    ? Row(

                  children: [

                    Expanded(

                      child: _navigationButton(

                        title: "Patients",

                        icon: Icons.person,

                        index: 0,

                      ),

                    ),

                    const SizedBox(width: 8),

                    Expanded(

                      child: _navigationButton(

                        title: "Queue",

                        icon: Icons.groups,

                        index: 1,

                      ),

                    ),

                    const SizedBox(width: 8),

                    Expanded(

                      child: _navigationButton(

                        title: "Completed",

                        icon: Icons.check_circle,

                        index: 2,

                      ),

                    ),

                  ],

                )

                //------------------------------------------------
                // Desktop
                //------------------------------------------------

                    : Row(

                  children: [

                    Expanded(

                      child: _navigationButton(

                        title: "Patients",

                        icon: Icons.person,

                        index: 0,

                      ),

                    ),

                    const SizedBox(width: 8),

                    Expanded(

                      child: _navigationButton(

                        title: "Waiting Queue",

                        icon: Icons.groups,

                        index: 1,

                      ),

                    ),

                    const SizedBox(width: 8),

                    Expanded(

                      child: _navigationButton(

                        title: "Completed",

                        icon: Icons.check_circle,

                        index: 2,

                      ),

                    ),

                  ],

                ),

              ),

              const SizedBox(height: 5),

              //------------------------------------------------
              // Dynamic Body
              //------------------------------------------------

              Expanded(

                child: Container(

                  width: double.infinity,

                  decoration: BoxDecoration(

                    color: Colors.white,

                    borderRadius:
                    BorderRadius.circular(18),

                  ),

                  child: Center(

                    child:AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      child: selectedPage == 0
                          ? const PatientSearchScreen(
                        embedded: true,
                      )
                          : selectedPage == 1
                          ? const Center(
                        child: const QueueScreen(),
                      )
                          : const Center(
                        child: const CompletedPatientsScreen(),
                      ),
                    )

                  ),

                ),

              ),

            ],

          ),

        ),

      ),

    );

  }


  //======================================================
// Analytics Card
//======================================================

  Widget _analyticsCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required bool selected,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      height: 58,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: selected ? color : Colors.grey.shade300,
          width: selected ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
        child: Row(
          children: [
            // Icon
            CircleAvatar(
              radius: 15,
              backgroundColor: color.withOpacity(.12),
              child: Icon(
                icon,
                color: color,
                size: 17,
              ),
            ),

            const SizedBox(width: 10),

            // Title
            Expanded(
              child: Text(
                title,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            // Value
            Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  //======================================================
// Navigation Button
//======================================================

  Widget _navigationButton({

    required String title,

    required IconData icon,

    required int index,

  }) {

    final bool selected = selectedPage == index;

    return AnimatedContainer(

      duration: const Duration(milliseconds: 250),

      height: 55,

      decoration: BoxDecoration(

        color: selected
            ? AppColors.primary
            : Colors.transparent,

        borderRadius: BorderRadius.circular(12),

      ),

      child: Material(

        color: Colors.transparent,

        child: InkWell(

          borderRadius: BorderRadius.circular(12),

          onTap: () {

            changePage(index);

          },

          child: Row(

            mainAxisAlignment: MainAxisAlignment.center,

            children: [

              Icon(

                icon,

                size: 20,

                color: selected
                    ? Colors.white
                    : Colors.black87,

              ),

              const SizedBox(width: 8),

              Text(

                title,

                style: TextStyle(

                  fontWeight: FontWeight.bold,

                  color: selected
                      ? Colors.white
                      : Colors.black87,

                ),

              ),

            ],

          ),

        ),

      ),

    );

  }

}
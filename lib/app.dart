import 'package:flutter/material.dart';

import 'screens/splash_screen.dart';
import 'screens/roles_screen.dart';
import 'screens/login/doctor_login.dart';
import 'screens/login/receptionist_login.dart';
import 'screens/reception/reception_dashboard.dart';
import 'screens/doctor/doctor_dashboard.dart';


class ClinicApp extends StatelessWidget {
  const ClinicApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(

      debugShowCheckedModeBanner: false,

      title: 'Clinic Management',

      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
      ),

      initialRoute: '/',

      routes: {

        '/': (context) => const SplashScreen(),

        '/role': (context) => const RoleSelectionScreen(),

        '/doctor-login': (context) => const DoctorLoginScreen(),

        '/reception-login': (context) => const ReceptionistLoginScreen(),

        '/doctor-dashboard': (context) => const DoctorDashboard(),


        '/reception-dashboard': (context) =>  ReceptionDashboard(),

      },

    );

  }
}
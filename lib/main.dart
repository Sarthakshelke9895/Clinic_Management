import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'controller/doctor_session_controller.dart';
import '/patient/patient_form_controller.dart';

import 'app.dart';
import 'firebase_options.dart';

Future<void> main() async {
  // Initializes Flutter before using plugins like Firebase
  WidgetsFlutterBinding.ensureInitialized();

  // Connects the app to your Firebase project
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(

    MultiProvider(

      providers: [

        ChangeNotifierProvider(

          create: (_) => DoctorSessionController(),

        ),

      ],

      child: const ClinicApp(),

    ),

  );
}
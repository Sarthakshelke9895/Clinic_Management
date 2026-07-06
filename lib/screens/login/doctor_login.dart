import 'package:flutter/material.dart';

import '../../widgets/auth/login_form.dart';
import '../../services/auth/auth_service.dart';
import '../doctor/doctor_dashboard.dart';

class DoctorLoginScreen extends StatelessWidget {
  const DoctorLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Doctor Login"),
      ),

      body: LoginForm(
        title: "Doctor Login",

        onLogin: (email, password) {

          bool success = AuthService.login(
            role: "doctor",
            email: email,
            password: password,
          );

          if (success) {

            Navigator.pushAndRemoveUntil(

              context,

              MaterialPageRoute(

                builder: (_) => const DoctorDashboard(),

              ),

                  (route) => false,

            );

          } else {

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content:
                Text("Invalid Doctor Credentials"),
              ),
            );

          }
        },
      ),
    );
  }
}
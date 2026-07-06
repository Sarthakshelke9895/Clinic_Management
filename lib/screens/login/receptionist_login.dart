import 'package:flutter/material.dart';

import '../../widgets/auth/login_form.dart';
import '../../services/auth/auth_service.dart';
import '../reception/reception_portal.dart';

class ReceptionistLoginScreen extends StatelessWidget {
  const ReceptionistLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reception Login"),
      ),

      body: LoginForm(
        title: "Reception Login",

        onLogin: (email, password) {

          bool success = AuthService.login(
            role: "reception",
            email: email,
            password: password,
          );

          if (success) {

            Navigator.pushAndRemoveUntil(

              context,

              MaterialPageRoute(

                builder: (_) => const ReceptionPortal(),

              ),

                  (route) => false,

            );

          } else {

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                    "Invalid Reception Credentials"),
              ),
            );

          }
        },
      ),
    );
  }
}
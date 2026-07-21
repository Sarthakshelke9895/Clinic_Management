class AuthService {
  //--------------------------------------------------
  // Current Logged In User Role
  //--------------------------------------------------

  static String? currentRole;

  //--------------------------------------------------
  // Login
  //--------------------------------------------------

  static bool login({
    required String role,
    required String email,
    required String password,
  }) {
    if (role == "doctor") {
      final success =
          email == "d@gmail.com" &&
              password == "123";

      if (success) {
        currentRole = "doctor";
      }

      return success;
    }

    if (role == "reception") {
      final success =
          email == "r@gmail.com" &&
              password == "123";

      if (success) {
        currentRole = "reception";
      }

      return success;
    }

    return false;
  }

  //--------------------------------------------------
  // Role Helpers
  //--------------------------------------------------

  static bool get isDoctor {
    return currentRole == "doctor";
  }

  static bool get isReception {
    return currentRole == "reception";
  }

  //--------------------------------------------------
  // Logout
  //--------------------------------------------------

  static void logout() {
    currentRole = null;
  }
}
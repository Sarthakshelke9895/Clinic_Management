class AuthService {
  static bool login({
    required String role,
    required String email,
    required String password,
  }) {
    if (role == "doctor") {
      return email == "d@gmail.com" &&
          password == "123";
    }

    if (role == "reception") {
      return email == "r@gmail.com" &&
          password == "123";
    }

    return false;
  }
}
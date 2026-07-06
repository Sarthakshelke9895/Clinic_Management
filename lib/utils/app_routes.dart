class AppRoutes {
  AppRoutes._();

  static const splash = "/";
  static const role = "/role";

  static const doctorLogin = "/doctor-login";
  static const receptionLogin = "/reception-login";

  static const doctorDashboard = "/doctor-dashboard";
  static const receptionDashboard = "/reception-dashboard";

  // Reception Module
  static const registerPatient = "/register-patient";
  static const searchPatient = "/search-patient";
  static const queue = "/queue";

  // Doctor Module
  static const patientDetails = "/patient-details";
  static const session = "/session";
}
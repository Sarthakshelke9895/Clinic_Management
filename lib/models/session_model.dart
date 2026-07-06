class Session {

  final String sessionId;

  final String patientId;

  final int sessionNumber;

  final String complaint;

  final String history;

  final String assessment;

  final String management;

  final DateTime sessionDate;

  Session({

    required this.sessionId,

    required this.patientId,

    required this.sessionNumber,

    required this.complaint,

    required this.history,

    required this.assessment,

    required this.management,

    required this.sessionDate,

  });

}
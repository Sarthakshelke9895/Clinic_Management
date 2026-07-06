import 'package:cloud_firestore/cloud_firestore.dart';

class QueueModel {
  final String? id;

  final String patientId;

  final String patientCode;

  final String patientName;

  final String phone;

  final String status;

  final String queueDate;

  final DateTime createdAt;

  final DateTime? completedAt;

  final String? sessionId;

  //==========================================
  // Payment
  //==========================================

  final String paymentAmount;

  final String paymentStatus;

  const QueueModel({
    this.id,
    required this.patientId,
    required this.patientCode,
    required this.patientName,
    required this.phone,
    required this.status,
    required this.queueDate,
    required this.createdAt,
    required this.completedAt,
    required this.sessionId,

    required this.paymentAmount,
    required this.paymentStatus,
  });

  Map<String, dynamic> toMap() {
    return {
      "patientId": patientId,
      "patientCode": patientCode,
      "patientName": patientName,
      "phone": phone,
      "status": status,
      "queueDate": queueDate,
      "createdAt": createdAt.toIso8601String(),

      "completedAt": completedAt == null
          ? null
          : Timestamp.fromDate(completedAt!),

      "sessionId": sessionId,

      "paymentAmount": paymentAmount,

      "paymentStatus": paymentStatus,
    };
  }

  factory QueueModel.fromMap(
      Map<String, dynamic> map,
      String documentId,
      ) {
    return QueueModel(
      id: documentId,

      patientId: map["patientId"] ?? "",

      patientCode: map["patientCode"] ?? "",

      patientName: map["patientName"] ?? "",

      phone: map["phone"] ?? "",

      status: map["status"] ?? "",

      queueDate: map["queueDate"] ?? "",

      createdAt: DateTime.parse(map["createdAt"]),

      completedAt: map["completedAt"] == null
          ? null
          : (map["completedAt"] as Timestamp).toDate(),

      sessionId: map["sessionId"],

      paymentAmount: map["paymentAmount"] ?? "",

      paymentStatus: map["paymentStatus"] ?? "Pending",
    );
  }

  String get arrivalTime {
    final hour =
    createdAt.hour > 12
        ? createdAt.hour - 12
        : createdAt.hour;

    final minute =
    createdAt.minute.toString().padLeft(2, '0');

    final period =
    createdAt.hour >= 12 ? "PM" : "AM";

    return "$hour:$minute $period";
  }
}
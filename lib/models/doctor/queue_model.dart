import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class QueueModel {
  final String? id;

  final String patientId;

  final String patientCode;

  final String patientName;

  final String phone;

  final String status;

  final String queueDate;

  final String arrivalTime;

  final DateTime createdAt;

  final DateTime? completedAt;
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
    required this.arrivalTime,
    required this.createdAt,
    this.completedAt,
    required this.paymentStatus,
     required this.paymentAmount,
  });

  QueueModel copyWith({
    String? id,
    String? patientId,
    String? patientCode,
    String? patientName,
    String? phone,
    String? status,
    String? queueDate,
    String? arrivalTime,
    DateTime? createdAt,
    DateTime? completedAt,
    String? paymentStatus,
    String? paymentAmount,
  }) {
    return QueueModel(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      patientCode: patientCode ?? this.patientCode,
      patientName: patientName ?? this.patientName,
      phone: phone ?? this.phone,
      status: status ?? this.status,
      queueDate: queueDate ?? this.queueDate,
      arrivalTime: arrivalTime ?? this.arrivalTime,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
      paymentAmount: paymentAmount ?? this.paymentAmount,
      paymentStatus: paymentStatus ?? this.paymentStatus
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "patientId": patientId,
      "patientCode": patientCode,
      "patientName": patientName,
      "phone": phone,
      "status": status,
      "queueDate": queueDate,
      "arrivalTime": arrivalTime,
      "createdAt": Timestamp.fromDate(createdAt),
      "completedAt": completedAt == null
          ? null
          : Timestamp.fromDate(completedAt!),
    };
  }

  factory QueueModel.fromMap(
      Map<String, dynamic> map,
      String id,
      ) {
    return QueueModel(
      id: id,
      patientId: map["patientId"] ?? "",
      patientCode: map["patientCode"] ?? "",
      patientName: map["patientName"] ?? "",
      phone: map["phone"] ?? "",
      status: map["status"] ?? "Waiting",
      queueDate: map["queueDate"] ??
          DateFormat('yyyy-MM-dd').format(DateTime.now()),
      arrivalTime: map["arrivalTime"] ?? "",
      createdAt:
      (map["createdAt"] as Timestamp).toDate(),
      completedAt: map["completedAt"] == null
          ? null
          : (map["completedAt"] as Timestamp).toDate(),
      paymentStatus: map["paymentStatus"] ?? "",
      paymentAmount: map["paymentAmount"] ?? "",
    );
  }
}
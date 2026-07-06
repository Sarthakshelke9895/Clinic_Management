import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class SessionModel {
  //==================================================
  // Firestore Document ID
  //==================================================

  final String? id;

  //==================================================
  // Patient Information
  //==================================================

  final String patientId;

  final String patientCode;

  final String patientName;

  final String phone;

  final int age;

  final String gender;

  final String address;

  //==================================================
  // Session Information
  //==================================================

  final int sessionNumber;

  final String sessionDate;

  final DateTime createdAt;

  final String queueId;

  //==================================================
  // History
  //==================================================

  final String chiefComplaint;

  final String duration;

  //==================================================
  // OPQRST
  //==================================================

  final String onset;

  final String provocation;

  final String quality;

  final String region;

  final String severity;

  final String timing;

  //==================================================
  // SINSS
  //==================================================

  final String sinssSeverity;

  final String irritability;

  final String nature;

  final String stage;

  final String stability;

  //==================================================
  // Origin
  //==================================================

  final List<String> origins;

  //==================================================
  // Assessment
  //==================================================

  final String biomechanicalFindings;

  final String osteopathicFindings;

  final String otherFindings;

  //==================================================
  // Rx
  //==================================================

  final String treatmentGoals;

  final String treatmentGiven;

  final String homeExerciseProgram;

  final String advice;

  final String paymentAmount;

  final String paymentStatus;

  //==================================================
  // Constructor
  //==================================================

  const SessionModel({

    this.id,

    required this.patientId,
    required this.patientCode,
    required this.patientName,
    required this.phone,
    required this.age,
    required this.gender,
    required this.address,

    required this.sessionNumber,
    required this.sessionDate,
    required this.createdAt,
    required this.queueId,

    required this.chiefComplaint,
    required this.duration,

    required this.onset,
    required this.provocation,
    required this.quality,
    required this.region,
    required this.severity,
    required this.timing,

    required this.sinssSeverity,
    required this.irritability,
    required this.nature,
    required this.stage,
    required this.stability,

    required this.origins,

    required this.biomechanicalFindings,
    required this.osteopathicFindings,
    required this.otherFindings,

    required this.treatmentGoals,
    required this.treatmentGiven,
    required this.homeExerciseProgram,
    required this.advice,
    required this.paymentAmount,
    required this.paymentStatus,

  });

  //==================================================
  // Copy With
  //==================================================

  SessionModel copyWith({

    String? id,

    String? patientId,
    String? patientCode,
    String? patientName,
    String? phone,
    int? age,
    String? gender,
    String? address,

    int? sessionNumber,
    String? sessionDate,
    DateTime? createdAt,
    String? queueId,

    String? chiefComplaint,
    String? duration,

    String? onset,
    String? provocation,
    String? quality,
    String? region,
    String? severity,
    String? timing,

    String? sinssSeverity,
    String? irritability,
    String? nature,
    String? stage,
    String? stability,

    List<String>? origins,

    String? biomechanicalFindings,
    String? osteopathicFindings,
    String? otherFindings,

    String? treatmentGoals,
    String? treatmentGiven,
    String? homeExerciseProgram,
    String? advice,
    String? paymentAmount,
    String? paymentStatus,


  }) {

    return SessionModel(

      id: id ?? this.id,

      patientId: patientId ?? this.patientId,
      patientCode: patientCode ?? this.patientCode,
      patientName: patientName ?? this.patientName,
      phone: phone ?? this.phone,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      address: address ?? this.address,

      sessionNumber: sessionNumber ?? this.sessionNumber,
      sessionDate: sessionDate ?? this.sessionDate,
      createdAt: createdAt ?? this.createdAt,
      queueId: queueId ?? this.queueId,

      chiefComplaint:
      chiefComplaint ?? this.chiefComplaint,

      duration: duration ?? this.duration,

      onset: onset ?? this.onset,
      provocation:
      provocation ?? this.provocation,
      quality: quality ?? this.quality,
      region: region ?? this.region,
      severity: severity ?? this.severity,
      timing: timing ?? this.timing,

      sinssSeverity:
      sinssSeverity ?? this.sinssSeverity,

      irritability:
      irritability ?? this.irritability,

      nature: nature ?? this.nature,

      stage: stage ?? this.stage,

      stability:
      stability ?? this.stability,

      origins: origins ?? this.origins,

      biomechanicalFindings:
      biomechanicalFindings ??
          this.biomechanicalFindings,

      osteopathicFindings:
      osteopathicFindings ??
          this.osteopathicFindings,

      otherFindings:
      otherFindings ??
          this.otherFindings,

      treatmentGoals:
      treatmentGoals ??
          this.treatmentGoals,

      treatmentGiven:
      treatmentGiven ??
          this.treatmentGiven,

      homeExerciseProgram:
      homeExerciseProgram ??
          this.homeExerciseProgram,

      advice: advice ?? this.advice,

      paymentAmount:
      paymentAmount ?? this.paymentAmount,

      paymentStatus:
      paymentStatus ?? this.paymentStatus,

    );

  }

  //==================================================
  // To Map
  //==================================================

  Map<String, dynamic> toMap() {

    return {

      "patientId": patientId,
      "patientCode": patientCode,
      "patientName": patientName,
      "phone": phone,
      "age": age,
      "gender": gender,
      "address": address,

      "sessionNumber": sessionNumber,
      "sessionDate": sessionDate,
      "createdAt": Timestamp.fromDate(createdAt),
      "queueId": queueId,

      "chiefComplaint": chiefComplaint,
      "duration": duration,

      "onset": onset,
      "provocation": provocation,
      "quality": quality,
      "region": region,
      "severity": severity,
      "timing": timing,

      "sinssSeverity": sinssSeverity,
      "irritability": irritability,
      "nature": nature,
      "stage": stage,
      "stability": stability,

      "origins": origins,

      "biomechanicalFindings":
      biomechanicalFindings,

      "osteopathicFindings":
      osteopathicFindings,

      "otherFindings":
      otherFindings,

      "treatmentGoals":
      treatmentGoals,

      "treatmentGiven":
      treatmentGiven,

      "homeExerciseProgram":
      homeExerciseProgram,

      "advice": advice,
      "paymentAmount": paymentAmount,

      "paymentStatus": paymentStatus,

    };

  }

  //==================================================
  // From Map
  //==================================================

  factory SessionModel.fromMap(
      Map<String, dynamic> map,
      String id,
      ) {

    return SessionModel(

      id: id,

      patientId: map["patientId"] ?? "",
      patientCode: map["patientCode"] ?? "",
      patientName: map["patientName"] ?? "",
      phone: map["phone"] ?? "",
      age: map["age"] ?? 0,
      gender: map["gender"] ?? "",
      address: map["address"] ?? "",

      sessionNumber:
      map["sessionNumber"] ?? 1,

      sessionDate:
      map["sessionDate"] ?? "",

      createdAt:
      (map["createdAt"] as Timestamp)
          .toDate(),

      queueId:
      map["queueId"] ?? "",

      chiefComplaint:
      map["chiefComplaint"] ?? "",

      duration:
      map["duration"] ?? "",

      onset: map["onset"] ?? "",
      provocation:
      map["provocation"] ?? "",
      quality: map["quality"] ?? "",
      region: map["region"] ?? "",
      severity: map["severity"] ?? "",
      timing: map["timing"] ?? "",

      sinssSeverity:
      map["sinssSeverity"] ?? "",

      irritability:
      map["irritability"] ?? "",

      nature: map["nature"] ?? "",
      stage: map["stage"] ?? "",
      stability:
      map["stability"] ?? "",

      origins:
      List<String>.from(
        map["origins"] ?? [],
      ),

      biomechanicalFindings:
      map["biomechanicalFindings"] ?? "",

      osteopathicFindings:
      map["osteopathicFindings"] ?? "",

      otherFindings:
      map["otherFindings"] ?? "",

      treatmentGoals:
      map["treatmentGoals"] ?? "",

      treatmentGiven:
      map["treatmentGiven"] ?? "",

      homeExerciseProgram:
      map["homeExerciseProgram"] ?? "",

      advice:
      map["advice"] ?? "",
      paymentAmount:
      map["paymentAmount"] ?? "",

      paymentStatus:
      map["paymentStatus"] ?? "Completed",

    );

  }

}
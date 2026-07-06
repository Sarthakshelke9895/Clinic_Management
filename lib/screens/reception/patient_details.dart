import 'package:flutter/material.dart';

import '../../models/patient_model.dart';
import '../../models/queue_model.dart';
import '../../repositories/queue_repository.dart';

final QueueRepository queueRepository =
QueueRepository();

class PatientDetails extends StatelessWidget {
  final Patient patient;



  const PatientDetails({
    super.key,
    required this.patient,

  });


  @override
@override
Widget build(BuildContext context) {

final initials = patient.name
.trim()
.split(' ')
.where((e) => e.isNotEmpty)
.take(2)
.map((e) => e[0].toUpperCase())
.join();

return Dialog(

elevation: 0,

backgroundColor: Colors.transparent,

child: Container(

width: 500,

decoration: BoxDecoration(

color: Colors.white,

borderRadius: BorderRadius.circular(20),

),

child: Column(

mainAxisSize: MainAxisSize.min,

children: [

//----------------------------------------------------
// HEADER
//----------------------------------------------------

Padding(

padding: const EdgeInsets.fromLTRB(
20,
18,
16,
18,
),

child: Row(

children: [

const Text(

"Patient Details",

style: TextStyle(

fontSize: 18,

fontWeight: FontWeight.bold,

),

),

const Spacer(),

IconButton(

splashRadius: 20,

tooltip: "Close",

onPressed: () {

Navigator.pop(context);

},

icon: const Icon(
Icons.close,
),

),

],

),

),

Divider(
height: 1,
color: Colors.grey.shade300,
),

//----------------------------------------------------
// BODY
//----------------------------------------------------

Padding(

padding: const EdgeInsets.all(24),

child: Column(

children: [

//------------------------------------------------
// Avatar
//------------------------------------------------

CircleAvatar(

radius: 36,

backgroundColor: Colors.blue.shade50,

child: Text(

initials,

style: TextStyle(

color: Colors.blue.shade700,

fontWeight: FontWeight.bold,

fontSize: 22,

),

),

),

const SizedBox(height: 14),

Text(

patient.name,

style: const TextStyle(

fontSize: 20,

fontWeight: FontWeight.bold,

),

),

const SizedBox(height: 4),

Text(

patient.patientCode,

style: TextStyle(

color: Colors.grey.shade600,

fontWeight: FontWeight.w600,

),

),

const SizedBox(height: 24),
  //------------------------------------------------
  // Information Card
  //------------------------------------------------

  Container(

    decoration: BoxDecoration(

      color: Colors.grey.shade50,

      borderRadius: BorderRadius.circular(16),

      border: Border.all(
        color: Colors.grey.shade200,
      ),

    ),

    child: Column(

      children: [

        _infoTile(
          Icons.person_outline,
          "Gender",
          patient.gender,
        ),

        Divider(
          height: 1,
          color: Colors.grey.shade200,
        ),

        _infoTile(
          Icons.cake_outlined,
          "Age",
          "${patient.age} Years",
        ),

        Divider(
          height: 1,
          color: Colors.grey.shade200,
        ),

        _infoTile(
          Icons.phone_outlined,
          "Phone",
          patient.phone,
        ),

        Divider(
          height: 1,
          color: Colors.grey.shade200,
        ),

        _infoTile(
          Icons.location_on_outlined,
          "Address",
          patient.address,
        ),

      ],

    ),

  ),

  const SizedBox(height: 24),

  //------------------------------------------------
  // Button
  //------------------------------------------------

  SizedBox(

    width: double.infinity,

    height: 48,

    child: ElevatedButton.icon(

      style: ElevatedButton.styleFrom(

        elevation: 0,

        backgroundColor:
        Theme.of(context).primaryColor,

        foregroundColor: Colors.white,

        shape: RoundedRectangleBorder(

          borderRadius:
          BorderRadius.circular(12),

        ),

      ),

      onPressed: () async {

        final queue = QueueModel(

          patientId: patient.id!,

          patientCode: patient.patientCode,

          patientName: patient.name,

          phone: patient.phone,

          status: "Waiting",

          queueDate:
          "${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}",

          createdAt: DateTime.now(),

          completedAt: null,

          sessionId: null,

          paymentAmount: "",

          paymentStatus: "Pending",

        );

        final exists =
        await queueRepository
            .isPatientAlreadyWaiting(
            patient.id!);

        if (exists) {

          if (context.mounted) {

            ScaffoldMessenger.of(context)
                .showSnackBar(

              const SnackBar(

                content: Text(
                  "Patient is already in the queue",
                ),

              ),

            );

          }

          return;

        }

        await queueRepository.addToQueue(
          queue,
        );

        if (!context.mounted) return;

        ScaffoldMessenger.of(context)
            .showSnackBar(

          const SnackBar(

            content: Text(
              "Patient Added To Queue",
            ),

            backgroundColor: Colors.green,

          ),

        );

        Navigator.pop(context);

      },

      icon: const Icon(
        Icons.person_add_alt_1,
      ),

      label: const Text(
        "Add To Queue",
        style: TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),

    ),

  ),

],

),

),

],

),

),

);

  }



  Widget _infoTile(
      IconData icon,
      String title,
      String value,
      ) {

    return Padding(

      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),

      child: Row(

        children: [

          Icon(
            icon,
            color: Colors.grey.shade700,
            size: 20,
          ),

          const SizedBox(width: 12),

          SizedBox(

            width: 70,

            child: Text(

              title,

              style: TextStyle(

                color: Colors.grey.shade600,

                fontWeight: FontWeight.w600,

              ),

            ),

          ),

          Expanded(

            child: Text(

              value,

              style: const TextStyle(

                fontWeight: FontWeight.w600,

              ),

            ),

          ),

        ],

      ),

    );

  }
}
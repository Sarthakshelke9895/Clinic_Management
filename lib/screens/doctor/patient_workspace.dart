import 'package:flutter/material.dart';

import '../../models/patient_model.dart';
import '../../models/doctor/session_model.dart';

import '../../repositories/patient_repository.dart';
import '../../repositories/doctor/session_repository.dart';
import '../../services/pdf/pdf_service.dart';
import '../../utils/app_colors.dart';
import 'package:intl/intl.dart';

import '../doctor/session_details_screen.dart';

class PatientWorkspace extends StatefulWidget {

  final String patientId;

  const PatientWorkspace({
    super.key,
    required this.patientId,
  });

  @override
  State<PatientWorkspace> createState() =>
      _PatientWorkspaceState();
}

class _PatientWorkspaceState
    extends State<PatientWorkspace> {

//==========================================================
// Repositories
//==========================================================

final PatientRepository patientRepository =
PatientRepository();

final SessionRepository sessionRepository =
SessionRepository();

//==========================================================
// Variables
//==========================================================

Patient? patient;

List<SessionModel> sessions = [];

bool isLoading = true;

//==========================================================
// Init
//==========================================================

@override
void initState() {

super.initState();

loadData();

}

//==========================================================
// Load Patient + Sessions
//==========================================================

Future<void> loadData() async {

setState(() {

isLoading = true;

});

final loadedPatient =
await patientRepository.getPatientById(
widget.patientId,
);

final loadedSessions =
await sessionRepository.getPatientSessions(
widget.patientId,
);

setState(() {

patient = loadedPatient;

sessions = loadedSessions;

isLoading = false;

});

}

//==========================================================
// Refresh
//==========================================================

Future<void> refresh() async {

await loadData();

}

//==========================================================
// Delete Session
//==========================================================

Future<void> deleteSession(
SessionModel session,
) async {

final confirm =
await showDialog<bool>(

context: context,

builder: (context) {

return AlertDialog(

title: const Text(
"Delete Session",
),

content: const Text(
"Are you sure you want to delete this session?",
),

actions: [

TextButton(

onPressed: () {

Navigator.pop(
context,
false,
);

},

child: const Text("Cancel"),

),

FilledButton(

onPressed: () {

Navigator.pop(
context,
true,
);

},

child: const Text("Delete"),

),

],

);

},

);

if (confirm != true) return;

await sessionRepository.deleteSession(
session.id!,
);

await loadData();

if (!mounted) return;

ScaffoldMessenger.of(context).showSnackBar(

const SnackBar(

content: Text(
"Session Deleted Successfully",
),

),

);

}

//==========================================================
// View Session
//==========================================================

void viewSession(
SessionModel session,
) {

// Part 3

}

//==========================================================
// Download PDF
//==========================================================

Future<void> generatePdf(
SessionModel session,
) async {

// Part 3

}

//==========================================================
// UI
//==========================================================

@override
Widget build(BuildContext context) {

return Scaffold(

  appBar: AppBar(
    elevation: 0,
    backgroundColor: AppColors.primary,
    foregroundColor: Colors.white,
    titleSpacing: 8,
    title: const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Patient Record",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 2),
        Text(
          "Medical History",
          style: TextStyle(
            fontSize: 12,
            color: Colors.white70,
          ),
        ),
      ],
    ),
  ),

body: isLoading

? const Center(
child: CircularProgressIndicator(),
)

: patient == null

? const Center(
child: Text(
"Patient Not Found",
),
)

: RefreshIndicator(

onRefresh: refresh,

child: ListView(

padding: const EdgeInsets.all(16),

children: [

//==========================================
// Patient Details Card
//==========================================

  Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(10),
      border: const Border(
        bottom: BorderSide(
          color: AppColors.primary,
          width: 2,
        ),
      ),
    ),
    child: Column(
      children: [

        //==========================================
        // ROW 1
        //==========================================

        Row(
          children: [

            Expanded(
              child: buildHeaderItem(
                icon: Icons.person_outline,
                text: patient!.name,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                iconSize: 20,
              ),
            ),

            const SizedBox(width: 20),

            buildHeaderItem(
              icon: Icons.phone_outlined,
              text: patient!.phone,
            ),

            const SizedBox(width: 20),

            buildHeaderItem(
              icon: Icons.cake_outlined,
              text: "${patient!.age} Y",
            ),

          ],
        ),

        const SizedBox(height: 16),

        //==========================================
        // ROW 2
        //==========================================

        Row(
          children: [

            SizedBox(
              width: 140,
              child: buildHeaderItem(
                icon: Icons.badge_outlined,
                text: patient!.patientCode,
              ),
            ),

            Expanded(
              child: buildHeaderItem(
                icon: Icons.location_on_outlined,
                text: patient!.address,
              ),
            ),

            const SizedBox(width: 20),

            buildHeaderItem(
              icon: patient!.gender.toLowerCase() == "female"
                  ? Icons.female
                  : Icons.male,
              text: patient!.gender,
            ),

          ],
        ),

      ],
    ),
  ),

const SizedBox(height: 20),

//==========================================
// Session History
//==========================================

const Text(

"Previous Sessions",

style: TextStyle(

fontSize: 20,

fontWeight: FontWeight.bold,

),

),

const SizedBox(height: 15),

if (sessions.isEmpty)

const Card(

child: Padding(

padding: EdgeInsets.all(25),

child: Center(

child: Text(

"No Sessions Found",

),

),

),

)

else

...sessions.map(

(session) {

return buildSessionCard(
session,
);

},

),

const SizedBox(height: 30),

],

),

),

);

}

//==========================================================
// Info Row
//==========================================================

Widget buildInfoRow(

String title,

String value,

) {

return Padding(

padding: const EdgeInsets.only(
bottom: 14,
),

child: Row(

crossAxisAlignment:
CrossAxisAlignment.start,

children: [

SizedBox(

width: 130,

child: Text(

title,

style: const TextStyle(

fontWeight:
FontWeight.w600,

),

),

),

Expanded(

child: Text(value),

),

],

),

);

}

  Widget buildHeaderItem({
    required IconData icon,
    required String text,
    double fontSize = 15,
    FontWeight fontWeight = FontWeight.w500,
    double iconSize = 18,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [

        Icon(
          icon,
          color: Colors.black87,
          size: iconSize,
        ),

        const SizedBox(width: 6),

        Text(
          text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.black87,
            fontSize: fontSize,
            fontWeight: fontWeight,
          ),
        ),

      ],
    );
  }
  //==========================================================
  // Session Card
  //==========================================================

  Widget buildSessionCard(SessionModel session) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.border,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          //----------------------------------------------------
          // Session Number
          //----------------------------------------------------

          CircleAvatar(
            radius: 22,
            backgroundColor: AppColors.primary,
            child: Text(
              "${session.sessionNumber}",
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(width: 14),

          //----------------------------------------------------
          // Session Details
          //----------------------------------------------------

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  "Session ${session.sessionNumber}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 4),

                Row(
                  children: [

                    const Icon(
                      Icons.calendar_today_outlined,
                      size: 14,
                      color: AppColors.textSecondary,
                    ),

                    const SizedBox(width: 6),

                    Text(
                      formatSessionDate(session.sessionDate),
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                  ],
                ),

              ],
            ),
          ),

          //----------------------------------------------------
          // Actions
          //----------------------------------------------------

          buildActionButton(
            icon: Icons.visibility_outlined,
            color: AppColors.primary,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SessionDetailsScreen(
                    session: session,
                  ),
                ),
              );
            },
          ),

          const SizedBox(width: 8),

          buildActionButton(
            icon: Icons.picture_as_pdf_outlined,
            color: Colors.orange,
            onTap: () async {
              await PdfService.instance.generateSessionPdf(
                session,
              );
            },
          ),

          const SizedBox(width: 8),

          buildActionButton(
            icon: Icons.delete_outline,
            color: Colors.red,
            onTap: () {
              deleteSession(session);
            },
          ),
        ],
      ),
    );
  }

  Widget buildActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: color.withOpacity(.10),
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Container(
          height: 38,
          width: 38,
          alignment: Alignment.center,
          child: Icon(
            icon,
            size: 20,
            color: color,
          ),
        ),
      ),
    );
  }
  Widget buildCompactInfo(
      IconData icon,
      String value,
      ) {

    return Row(

      children: [

        Icon(

          icon,

          size: 18,

          color: AppColors.primary,

        ),

        const SizedBox(width: 6),

        Expanded(

          child: Text(

            value,

            style: const TextStyle(

              fontSize: 14,

              fontWeight: FontWeight.w600,

            ),

            overflow: TextOverflow.ellipsis,

          ),

        ),

      ],

    );



  }
  String formatSessionDate(String date) {
    final DateTime parsedDate = DateTime.parse(date);

    final int day = parsedDate.day;

    String suffix = "th";

    if (day != 11 && day != 12 && day != 13) {
      switch (day % 10) {
        case 1:
          suffix = "st";
          break;
        case 2:
          suffix = "nd";
          break;
        case 3:
          suffix = "rd";
          break;
      }
    }

    return "$day$suffix ${DateFormat('MMMM yyyy').format(parsedDate)}";
  }

}
import 'package:flutter/material.dart';
import '../../models/doctor/session_model.dart';

import '../../services/pdf/pdf_service.dart';
import '../../utils/app_colors.dart';


class SessionDetailsScreen extends StatelessWidget {
  final SessionModel session;

  const SessionDetailsScreen({
    super.key,
    required this.session,
  });

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
              "Session Details",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 2),

            Text(
              "Patient Medical Record",
              style: TextStyle(
                fontSize: 12,
                color: Colors.white70,
              ),
            ),

          ],
        ),
      ),

     body: ListView(

      padding: const EdgeInsets.all(16),

      children: [

        //////////////////////////////////////////////////////
        // Patient Header
        //////////////////////////////////////////////////////

        Container(

          padding: const EdgeInsets.all(20),

          decoration: BoxDecoration(

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

              //--------------------------------------------------
              // Row 1
              //--------------------------------------------------

              Row(

                children: [

                  Expanded(

                    child: buildHeaderItem(

                      icon: Icons.person_outline,

                      text: session.patientName,

                      fontSize: 18,

                      fontWeight: FontWeight.bold,

                      iconSize: 20,

                    ),

                  ),

                  const SizedBox(width: 18),

                  buildHeaderItem(

                    icon: Icons.phone_outlined,

                    text: session.phone,

                  ),

                  const SizedBox(width: 18),

                  buildHeaderItem(

                    icon: Icons.cake_outlined,

                    text: "${session.age} Y",

                  ),

                ],

              ),

              const SizedBox(height: 16),

              //--------------------------------------------------
              // Row 2
              //--------------------------------------------------

              Row(

                children: [

                  SizedBox(

                    width: 150,

                    child: buildHeaderItem(

                      icon: Icons.badge_outlined,

                      text: session.patientCode,

                    ),

                  ),

                  Expanded(

                    child: buildHeaderItem(

                      icon: Icons.location_on_outlined,

                      text: session.address,

                    ),

                  ),

                  const SizedBox(width: 18),

                  buildHeaderItem(

                    icon: session.gender.toLowerCase() == "female"
                        ? Icons.female
                        : Icons.male,

                    text: session.gender,

                  ),

                ],

              ),

            ],

          ),

        ),

        const SizedBox(height: 24),

        //////////////////////////////////////////////////////
        // Session Summary Card
        //////////////////////////////////////////////////////

        Container(

          padding: const EdgeInsets.all(18),

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

          child: Column(

            crossAxisAlignment: CrossAxisAlignment.start,

            children: [

              const Row(

                children: [

                  Icon(
                    Icons.folder_shared_outlined,
                    color: AppColors.primary,
                  ),

                  SizedBox(width: 10),

                  Text(

                    "Session Summary",

                    style: TextStyle(

                      fontSize: 18,

                      fontWeight: FontWeight.bold,

                    ),

                  ),

                ],

              ),

              const SizedBox(height: 18),

              Row(

                children: [

                  Expanded(

                    child: buildSummaryTile(

                      "Session No.",

                      "${session.sessionNumber}",

                      Icons.numbers,

                    ),

                  ),

                  const SizedBox(width: 14),

                  Expanded(

                    child: buildSummaryTile(

                      "",

                      session.sessionDate,

                      Icons.calendar_today_outlined,

                    ),

                  ),

                ],

              ),

              const SizedBox(height: 14),

              Row(

                children: [

                  Expanded(

                    child: buildSummaryTile(

                      "Amount",

                      session.paymentAmount.isEmpty
                          ? "-"

                          : "₹ ${session.paymentAmount}",

                      Icons.currency_rupee,

                    ),

                  ),

                  const SizedBox(width: 14),



                ],

              ),

            ],

          ),

        ),

        const SizedBox(height: 24),

        //////////////////////////////////////////////////////
        // History
        //////////////////////////////////////////////////////

//--------------------------------------------------
// History
//--------------------------------------------------

          buildSectionCard(
            icon: Icons.history,

            title: "History",

            children: [

              buildInfoTile(
                "Chief Complaint",
                session.chiefComplaint,
              ),

              buildInfoTile(
                "Duration",
                session.duration,
              ),

            ],

          ),

          const SizedBox(height: 20),
//--------------------------------------------------
// OPQRST
//--------------------------------------------------

          buildSectionCard(
            icon: Icons.health_and_safety_outlined,

            title: "OPQRST",

            children: [

              buildInfoTile(
                "Onset",
                session.onset,
              ),

              buildInfoTile(
                "Provocation",
                session.provocation,
              ),

              buildInfoTile(
                "Quality",
                session.quality,
              ),

              buildInfoTile(
                "Region",
                session.region,
              ),

              buildInfoTile(
                "Severity",
                session.severity,
              ),

              buildInfoTile(
                "Timing",
                session.timing,
              ),

            ],

          ),

          const SizedBox(height: 20),

//--------------------------------------------------
// SINSS
//--------------------------------------------------

          buildSectionCard(
            icon: Icons.monitor_heart_outlined,

            title: "SINSS",

            children: [

              buildInfoTile(
                "Severity",
                session.sinssSeverity,
              ),

              buildInfoTile(
                "Irritability",
                session.irritability,
              ),

              buildInfoTile(
                "Nature",
                session.nature,
              ),

              buildInfoTile(
                "Stage",
                session.stage,
              ),

              buildInfoTile(
                "Stability",
                session.stability,
              ),

            ],

          ),

          const SizedBox(height: 20),

//--------------------------------------------------
// Origin
//--------------------------------------------------

          buildSectionCard(
            icon: Icons.location_searching_outlined,

            title: "Origin",

            children: [

              Wrap(

                spacing: 8,

                runSpacing: 8,

                children: session.origins.map(

                      (origin) {
                    return Chip(

                      avatar: const Icon(
                        Icons.check_circle,
                        size: 18,
                        color: Colors.green,
                      ),

                      label: Text(origin),

                    );
                  },

                ).toList(),

              ),

            ],

          ),

          const SizedBox(height: 20),

//--------------------------------------------------
// Assessment
//--------------------------------------------------

          buildSectionCard(
            icon: Icons.medical_information_outlined,

            title: "Assessment",

            children: [

              buildInfoTile(

                "Biomechanical",

                session.biomechanicalFindings,

              ),

              buildInfoTile(

                "Osteopathic",

                session.osteopathicFindings,

              ),

              buildInfoTile(

                "Other Findings",

                session.otherFindings,

              ),

            ],

          ),

          const SizedBox(height: 20),
//--------------------------------------------------
// Treatment
//--------------------------------------------------

          buildSectionCard(
           icon: Icons.healing_outlined,

            title: "Treatment",

            children: [

              buildInfoTile(
                "Goals",
                session.treatmentGoals,
              ),

              buildInfoTile(
                "Treatment Given",
                session.treatmentGiven,
              ),

              buildInfoTile(
                "Home Exercise",
                session.homeExerciseProgram,
              ),

              buildInfoTile(
                "Advice",
                session.advice,
              ),

            ],

          ),

          const SizedBox(height: 30),

          const SizedBox(height: 20),

        buildSectionCard(

          icon: Icons.payments_outlined,

          title: "Payment Details",

          children: [

            //----------------------------------------------------
            // Amount
            //----------------------------------------------------

            buildInfoTile(

              "Amount Paid",

              session.paymentAmount.isEmpty
                  ? "Not Added"
                  : "₹ ${session.paymentAmount}",

            ),

            const SizedBox(height: 4),

            //----------------------------------------------------
            // Status
            //----------------------------------------------------



          ],

        ),

        const SizedBox(height: 20),

//==========================================================
// Session Note
//==========================================================

        buildSectionCard(
          icon: Icons.sticky_note_2_outlined,

          title: "Session Note",

          children: [

            Container(
              width: double.infinity,

              padding: const EdgeInsets.all(16),

              decoration: BoxDecoration(
                color: Colors.grey.withValues(
                  alpha: .06,
                ),

                borderRadius:
                BorderRadius.circular(12),

                border: Border.all(
                  color: Colors.grey.withValues(
                    alpha: .20,
                  ),
                ),
              ),

              child: Text(
                session.sessionNote.trim().isEmpty
                    ? "No Session Note Added"
                    : session.sessionNote,

                style: TextStyle(
                  fontSize: 14,

                  height: 1.6,

                  color:
                  session.sessionNote.trim().isEmpty
                      ? AppColors.textSecondary
                      : AppColors.textPrimary,
                ),
              ),
            ),

          ],
        ),


//--------------------------------------------------
// Buttons
//--------------------------------------------------
        const SizedBox(height: 25),

        Align(
          alignment: Alignment.centerRight,

          child: SizedBox(

            width: 220,

            height: 52,

            child: FilledButton.icon(

              onPressed: () async {

                await PdfService.instance.generateSessionPdf(
                  session,
                );

              },

              style: FilledButton.styleFrom(

                backgroundColor: AppColors.primary,

                foregroundColor: Colors.white,

                shape: RoundedRectangleBorder(

                  borderRadius: BorderRadius.circular(6),

                ),

                elevation: 2,

              ),

              icon: const Icon(
                Icons.picture_as_pdf_outlined,
                size: 20,
              ),

              label: const Text(

                "Download PDF",

                style: TextStyle(

                  fontSize: 15,

                  fontWeight: FontWeight.w600,

                ),

              ),

            ),

          ),

        ),

          const SizedBox(height: 25),

        ],

      ),

    );
  }

//////////////////////////////////////////////////////////////
// Reusable Card
//////////////////////////////////////////////////////////////

  Widget buildSectionCard({
    required IconData icon,
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(18),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            children: [

              Icon(
                icon,
                size: 22,
                color: AppColors.primary,
              ),

              const SizedBox(width: 10),

              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

            ],
          ),

          const SizedBox(height: 16),

          ...children,

        ],
      ),
    );
  }

//////////////////////////////////////////////////////////////
// Reusable Row
//////////////////////////////////////////////////////////////

  Widget buildInfoTile(
      String title,
      String value,
      ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          SizedBox(
            width: 170,
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
          ),

          const Text(
            ":",
            style: TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: SelectableText(
              value.isEmpty ? "-" : value,
              style: const TextStyle(
                fontSize: 14,
                height: 1.4,
                fontWeight: FontWeight.w500,
              ),
            ),
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
      children: [

        Icon(
          icon,
          size: iconSize,
          color: Colors.black87,
        ),

        const SizedBox(width: 6),

        Text(
          text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: fontWeight,
            color: Colors.black87,
          ),
        ),

      ],
    );
  }

  Widget buildSummaryTile(
      String title,
      String value,
      IconData icon,
      ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [

          Icon(
            icon,
            size: 20,
            color: AppColors.primary,
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
          ),

          Text(
            value.isEmpty ? "-" : value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),

        ],
      ),
    );
  }
}
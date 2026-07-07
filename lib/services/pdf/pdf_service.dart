import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter/foundation.dart';
import 'package:file_selector/file_selector.dart';

import '../../models/doctor/session_model.dart';

class PdfService {
  PdfService._();

  static final PdfService instance = PdfService._();





  pw.Widget buildSectionTitle(
      String title,
      ) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(
        top: 15,
        bottom: 10,
      ),
      child: pw.Row(
        children: [

          pw.Container(
            width: 6,
            height: 24,
            color: PdfColors.blue900,
          ),

          pw.SizedBox(width: 10),

          pw.Text(
            title.toUpperCase(),
            style: pw.TextStyle(
              fontSize: 16,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.blue900,
            ),
          ),

          pw.SizedBox(width: 10),

          pw.Expanded(
            child: pw.Container(
              height: 1,
              color: PdfColors.blue200,
            ),
          ),

        ],
      ),
    );
  }

//==========================================================
// Information Row
//==========================================================

  pw.Widget buildInfoRow(
      String title,
      String value,
      ) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 8),
      padding: const pw.EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 10,
      ),
      decoration: pw.BoxDecoration(
        color: PdfColors.white,
        border: pw.Border.all(
          color: PdfColors.blue100,
          width: 0.8,
        ),
        borderRadius: pw.BorderRadius.circular(6),
      ),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [

          // Left Title
          pw.Container(
            width: 130,
            child: pw.Text(
              title,
              style: pw.TextStyle(
                fontSize: 11,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.blue900,
              ),
            ),
          ),

          // Divider
          pw.Container(
            width: 1,
            height: 14,
            color: PdfColors.blue100,
          ),

          pw.SizedBox(width: 10),

          // Value
          pw.Expanded(
            child: pw.Text(
              value.trim().isEmpty ? "-" : value,
              style: pw.TextStyle(
                fontSize: 11,
                color: PdfColors.grey800,
              ),
            ),
          ),
        ],
      ),
    );
  }


  Future<void> generateSessionPdf(

      SessionModel session,
      ) async {

    final pdf = pw.Document();


    final logoBytes =
    (await rootBundle.load("lib/assets/images/logo.jpeg"))
        .buffer
        .asUint8List();

    final logo = pw.MemoryImage(logoBytes);




    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(25),

        build: (context) {
          return [

            //--------------------------------------------------
// Clinic Header
//--------------------------------------------------


            pw.SizedBox(height: 18),

            pw.Container(
              width: double.infinity,
              padding: const pw.EdgeInsets.symmetric(
                vertical: 8,
              ),
              decoration: pw.BoxDecoration(
                color: PdfColors.blue900,
                borderRadius: pw.BorderRadius.circular(5),
              ),
              alignment: pw.Alignment.center,
              child: pw.Text(
                "PHYSIOTHERAPY SESSION REPORT",
                style: pw.TextStyle(
                  color: PdfColors.white,
                  fontSize: 15,
                  fontWeight: pw.FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ),

            pw.SizedBox(height: 5),

            pw.SizedBox(height: 5),

            //--------------------------------------------------
            // Patient Information
            //--------------------------------------------------



            buildInfoRow(
              "Patient Code",
              session.patientCode,
            ),

            buildInfoRow(
              "Patient Name",
              session.patientName,
            ),

            buildInfoRow(
              "Phone",
              session.phone,
            ),

            buildInfoRow(
              "Age",
              session.age.toString(),
            ),

            buildInfoRow(
              "Gender",
              session.gender,
            ),

            buildInfoRow(
              "Address",
              session.address,
            ),

            pw.SizedBox(height: 20),

            //--------------------------------------------------
            // Session Information
            //--------------------------------------------------

            buildSectionTitle("Session Information"),

            buildInfoRow(
              "Session Number",
              session.sessionNumber.toString(),
            ),

            buildInfoRow(
              "Session Date",
              session.sessionDate,
            ),

            pw.SizedBox(height: 20),
            //--------------------------------------------------
            // History
            //--------------------------------------------------

            buildSectionTitle("History"),

            buildInfoRow(
              "Chief Complaint",
              session.chiefComplaint,
            ),

            buildInfoRow(
              "Duration",
              session.duration,
            ),

            pw.SizedBox(height: 20),

            //--------------------------------------------------
            // OPQRST
            //--------------------------------------------------

            buildSectionTitle("OPQRST"),

            buildInfoRow(
              "Onset",
              session.onset,
            ),

            buildInfoRow(
              "Provocation",
              session.provocation,
            ),

            buildInfoRow(
              "Quality",
              session.quality,
            ),

            buildInfoRow(
              "Region",
              session.region,
            ),

            buildInfoRow(
              "Severity",
              session.severity,
            ),

            buildInfoRow(
              "Timing",
              session.timing,
            ),

            pw.SizedBox(height: 20),

            //--------------------------------------------------
            // SINSS
            //--------------------------------------------------

            buildSectionTitle("SINSS"),

            buildInfoRow(
              "Severity",
              session.sinssSeverity,
            ),

            buildInfoRow(
              "Irritability",
              session.irritability,
            ),

            buildInfoRow(
              "Nature",
              session.nature,
            ),

            buildInfoRow(
              "Stage",
              session.stage,
            ),

            buildInfoRow(
              "Stability",
              session.stability,
            ),

            pw.SizedBox(height: 20),


            //--------------------------------------------------
            // Origin
            //--------------------------------------------------

            buildSectionTitle("Origin"),

            pw.Wrap(

              spacing: 8,

              runSpacing: 8,

              children: session.origins.map(

                    (origin) {

                  return pw.Container(

                    padding: const pw.EdgeInsets.symmetric(

                      horizontal: 10,

                      vertical: 5,

                    ),

                    decoration: pw.BoxDecoration(

                      border: pw.Border.all(

                        color: PdfColors.blueGrey,

                      ),

                      borderRadius:
                      pw.BorderRadius.circular(12),

                    ),

                    child: pw.Text(origin),

                  );

                },

              ).toList(),

            ),

            pw.SizedBox(height: 20),


            //--------------------------------------------------
            // Assessment
            //--------------------------------------------------

            buildSectionTitle("Assessment"),

            buildInfoRow(

              "Biomechanical",

              session.biomechanicalFindings,

            ),

            buildInfoRow(

              "Osteopathic",

              session.osteopathicFindings,

            ),

            buildInfoRow(

              "Other Findings",

              session.otherFindings,

            ),

            pw.SizedBox(height: 20),
            //--------------------------------------------------
            // Treatment
            //--------------------------------------------------

            buildSectionTitle("Treatment"),

            buildInfoRow(
              "Goals",
              session.treatmentGoals,
            ),

            buildInfoRow(
              "Treatment Given",
              session.treatmentGiven,
            ),

            buildInfoRow(
              "Home Exercise",
              session.homeExerciseProgram,
            ),

            buildInfoRow(
              "Advice",
              session.advice,
            ),

            pw.SizedBox(height: 25),

            pw.SizedBox(height: 10),

            buildSectionTitle("Session Note"),

            pw.Container(
              width: double.infinity,

              padding: const pw.EdgeInsets.all(15),

              decoration: pw.BoxDecoration(
                color: PdfColors.white,

                border: pw.Border.all(
                  color: PdfColors.blue100,
                  width: 0.8,
                ),

                borderRadius: pw.BorderRadius.circular(6),
              ),

              child: pw.Text(
                session.sessionNote.trim().isEmpty
                    ? "No Session Note Added"
                    : session.sessionNote,

                style: const pw.TextStyle(
                  fontSize: 11,
                  lineSpacing: 4,
                  color: PdfColors.grey800,
                ),
              ),
            ),

            //--------------------------------------------------
// Payment Details
//--------------------------------------------------

            buildSectionTitle("Payment Details"),

            pw.Container(
              width: double.infinity,
              padding: const pw.EdgeInsets.all(15),
              decoration: pw.BoxDecoration(
                color: PdfColors.white,
                border: pw.Border.all(
                  color: PdfColors.blue100,
                ),
                borderRadius: pw.BorderRadius.circular(8),
              ),
              child: pw.Column(
                children: [

                  //------------------------------------------------
                  // Amount
                  //------------------------------------------------

                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [

                      pw.Text(
                        "Amount Paid",
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.blue900,
                          fontSize: 12,
                        ),
                      ),

                      pw.Text(
                        session.paymentAmount.isEmpty
                            ? "Not Entered"
                            : ":${session.paymentAmount}",
                        style: pw.TextStyle(
                          fontSize: 13,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),

                    ],
                  ),

                  pw.Divider(color: PdfColors.blue100),

                  //------------------------------------------------
                  // Status
                  //------------------------------------------------

                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [

                      pw.Text(
                        "Payment Status",
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.blue900,
                          fontSize: 12,
                        ),
                      ),

                      pw.Container(
                        padding: const pw.EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: pw.BoxDecoration(
                          color: session.paymentStatus.toLowerCase() == "paid"
                              ? PdfColors.green100
                              : PdfColors.orange100,
                          borderRadius: pw.BorderRadius.circular(15),
                        ),
                        child: pw.Text(
                          session.paymentStatus,
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            color: session.paymentStatus.toLowerCase() == "paid"
                                ? PdfColors.green800
                                : PdfColors.orange800,
                          ),
                        ),
                      ),

                    ],
                  ),

                ],
              ),
            ),

            //--------------------------------------------------
            // Doctor Signature
            //--------------------------------------------------

            pw.SizedBox(height: 50),
            //--------------------------------------------------
// Report Completion Section
//--------------------------------------------------

            pw.Container(
              margin: const pw.EdgeInsets.only(top: 20),
              padding: const pw.EdgeInsets.all(15),
              decoration: pw.BoxDecoration(
                color: PdfColors.white,

                borderRadius: pw.BorderRadius.circular(8),
              ),
              child: pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [

                  //------------------------------------------------
                  // Generated On
                  //------------------------------------------------

                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [

                      pw.Text(
                        "REPORT GENERATED",
                        style: pw.TextStyle(
                          fontSize: 11,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.blue900,
                        ),
                      ),

                      pw.SizedBox(height: 6),

                      pw.Text(
                        DateTime.now().toString(),
                        style: const pw.TextStyle(
                          fontSize: 10,
                        ),
                      ),

                    ],
                  ),

                  //------------------------------------------------
                  // Doctor Signature
                  //------------------------------------------------

                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [

                      pw.Container(
                        width: 170,
                        height: 1,
                        color: PdfColors.grey500,
                      ),

                      pw.SizedBox(height: 6),

                      pw.Text(
                        "Doctor Signature",
                        style: pw.TextStyle(
                          fontSize: 11,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.blue900,
                        ),
                      ),

                    ],
                  ),

                ],
              ),
            ),

            pw.SizedBox(height: 25),

//--------------------------------------------------
// Footer
//--------------------------------------------------

            pw.Center(
              child: pw.Text(
                "This report is computer generated and intended for clinical reference.",
                style: const pw.TextStyle(
                  fontSize: 9,
                  color: PdfColors.grey600,
                ),
              ),
            ),

            pw.SizedBox(height: 30),

            //--------------------------------------------------
            // Footer
            //--------------------------------------------------

            pw.Center(

              child: pw.Text(

                "***** End of Medical Report *****",

                style: const pw.TextStyle(

                  fontSize: 10,

                  color: PdfColors.grey,

                ),

              ),

            ),

          ];
        },
      ),
    );    // ==========================================================
    // GENERATE PDF BYTES
    // ==========================================================

    final pdfBytes = await pdf.save();

    final fileName =
        "${session.patientCode}_Session_${session.sessionNumber}.pdf";

    debugPrint("PDF GENERATED SUCCESSFULLY");

    // ==========================================================
    // WINDOWS - SHOW SAVE AS DIALOG
    // ==========================================================

    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.windows) {
      debugPrint("WINDOWS SAVE DIALOG OPENING");

      final FileSaveLocation? location = await getSaveLocation(
        suggestedName: fileName,
        acceptedTypeGroups: const [
          XTypeGroup(
            label: "PDF File",
            extensions: ["pdf"],
          ),
        ],
      );

      if (location == null) {
        debugPrint("PDF SAVE CANCELLED");
        return;
      }

      final XFile pdfFile = XFile.fromData(
        pdfBytes,
        mimeType: "application/pdf",
        name: fileName,
      );

      await pdfFile.saveTo(location.path);

      debugPrint("PDF SAVED SUCCESSFULLY");
      debugPrint("PDF PATH: ${location.path}");

      return;
    }

    // ==========================================================
    // ANDROID / WEB / OTHER PLATFORMS
    // ==========================================================

    await Printing.layoutPdf(
      name: fileName,
      onLayout: (PdfPageFormat format) async {
        return pdfBytes;
      },
    );
  }
}

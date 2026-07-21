import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:file_selector/file_selector.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../models/doctor/session_model.dart';

class PdfService {
  PdfService._();

  static final PdfService instance = PdfService._();

  static const PdfColor _primary = PdfColors.blue900;
  static const PdfColor _border = PdfColors.blue100;
  static const PdfColor _muted = PdfColors.grey700;
  static const PdfColor _surface = PdfColors.grey100;

  Future<pw.MemoryImage> _loadLogo() async {
    final bytes =
    (await rootBundle.load("lib/assets/images/logo.jpeg"))
        .buffer
        .asUint8List();
    return pw.MemoryImage(bytes);
  }

  pw.PageTheme _pageTheme() {
    return const pw.PageTheme(
      pageFormat: PdfPageFormat.a4,
      margin: pw.EdgeInsets.fromLTRB(34, 34, 34, 38),
    );
  }

  pw.Widget _pageHeader(
      pw.Context context,
      pw.MemoryImage logo,
      String reportTitle,
      ) {
    return pw.Container(
      padding: const pw.EdgeInsets.only(bottom: 12),
      margin: const pw.EdgeInsets.only(bottom: 16),
      decoration: const pw.BoxDecoration(
        border: pw.Border(
          bottom: pw.BorderSide(
            color: _primary,
            width: 1.2,
          ),
        ),
      ),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          pw.Container(
            width: 54,
            height: 54,
            alignment: pw.Alignment.center,
            child: pw.Image(
              logo,
              fit: pw.BoxFit.contain,
            ),
          ),
          pw.SizedBox(width: 14),
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  reportTitle,
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                    color: _primary,
                  ),
                ),
                pw.SizedBox(height: 4),
                pw.Text(
                  "Clinical Record",
                  style: const pw.TextStyle(
                    fontSize: 9,
                    color: _muted,
                  ),
                ),
              ],
            ),
          ),
          pw.Text(
            "Page ${context.pageNumber} of ${context.pagesCount}",
            style: const pw.TextStyle(
              fontSize: 9,
              color: _muted,
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _pageFooter() {
    return pw.Container(
      padding: const pw.EdgeInsets.only(top: 8),
      decoration: const pw.BoxDecoration(
        border: pw.Border(
          top: pw.BorderSide(
            color: _border,
            width: .8,
          ),
        ),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            "Confidential clinical document",
            style: const pw.TextStyle(
              fontSize: 8,
              color: PdfColors.grey600,
            ),
          ),
          pw.Text(
            "Generated ${DateTime.now().toString().substring(0, 16)}",
            style: const pw.TextStyle(
              fontSize: 8,
              color: PdfColors.grey600,
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _reportTitle(String title, String subtitle) {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 14,
      ),
      decoration: pw.BoxDecoration(
        color: _primary,
        borderRadius: pw.BorderRadius.circular(7),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            title,
            style: pw.TextStyle(
              color: PdfColors.white,
              fontSize: 15,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            subtitle,
            style: const pw.TextStyle(
              color: PdfColors.blue100,
              fontSize: 9,
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _sectionTitle(String title) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(
        top: 16,
        bottom: 8,
      ),
      padding: const pw.EdgeInsets.only(
        left: 9,
        bottom: 5,
      ),
      decoration: const pw.BoxDecoration(
        border: pw.Border(
          left: pw.BorderSide(
            color: _primary,
            width: 3,
          ),
          bottom: pw.BorderSide(
            color: _border,
            width: .7,
          ),
        ),
      ),
      child: pw.Text(
        title.toUpperCase(),
        style: pw.TextStyle(
          fontSize: 11,
          fontWeight: pw.FontWeight.bold,
          color: _primary,
          letterSpacing: .5,
        ),
      ),
    );
  }

  pw.Widget _field(
      String label,
      String value, {
        double labelWidth = 125,
      }) {
    final cleanValue =
    value.trim().isEmpty ? "-" : value.trim();

    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 7,
      ),
      decoration: const pw.BoxDecoration(
        border: pw.Border(
          bottom: pw.BorderSide(
            color: PdfColors.grey300,
            width: .5,
          ),
        ),
      ),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(
            width: labelWidth,
            child: pw.Text(
              label,
              style: pw.TextStyle(
                fontSize: 9.5,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.grey800,
              ),
            ),
          ),
          pw.SizedBox(width: 10),
          pw.Expanded(
            child: pw.Text(
              cleanValue,
              style: const pw.TextStyle(
                fontSize: 9.5,
                color: PdfColors.grey800,
                lineSpacing: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _infoCard(List<pw.Widget> children) {
    return pw.Container(
      width: double.infinity,
      decoration: pw.BoxDecoration(
        color: PdfColors.white,
        border: pw.Border.all(
          color: PdfColors.grey300,
          width: .7,
        ),
        borderRadius: pw.BorderRadius.circular(6),
      ),
      child: pw.Column(
        children: children,
      ),
    );
  }

  pw.Widget _patientSummary(SessionModel session) {
    return _infoCard([
      _field("Patient Code", session.patientCode),
      _field("Patient Name", session.patientName),
      _field("Phone", session.phone),
      _field("Age", session.age.toString()),
      _field("Gender", session.gender),
      _field("Address", session.address),
    ]);
  }

  pw.Widget _originChips(SessionModel session) {
    if (session.origins.isEmpty) {
      return _infoCard([
        _field("Origin", "-"),
      ]);
    }

    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(
          color: PdfColors.grey300,
          width: .7,
        ),
        borderRadius: pw.BorderRadius.circular(6),
      ),
      child: pw.Wrap(
        spacing: 6,
        runSpacing: 6,
        children: session.origins.map((origin) {
          return pw.Container(
            padding: const pw.EdgeInsets.symmetric(
              horizontal: 9,
              vertical: 4,
            ),
            decoration: pw.BoxDecoration(
              color: _surface,
              borderRadius: pw.BorderRadius.circular(10),
            ),
            child: pw.Text(
              origin,
              style: const pw.TextStyle(
                fontSize: 8.5,
                color: PdfColors.grey800,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  List<pw.Widget> _sessionContent(
      SessionModel session, {
        required bool showPatientInformation,
      }) {
    return [
      if (showPatientInformation) ...[
        _sectionTitle("Patient Information"),
        _patientSummary(session),
      ],

      _sectionTitle("Session Information"),
      _infoCard([
        _field(
          "Session Number",
          session.sessionNumber.toString(),
        ),
        _field(
          "Session Date",
          session.sessionDate,
        ),
      ]),

      _sectionTitle("History"),
      _infoCard([
        _field(
          "Chief Complaint",
          session.chiefComplaint,
        ),
        _field(
          "Duration",
          session.duration,
        ),
      ]),

      _sectionTitle("OPQRST"),
      _infoCard([
        _field("Onset", session.onset),
        _field(
          "Provocation / Palliation",
          session.provocation,
        ),
        _field("Quality", session.quality),
        _field("Region / Radiation", session.region),
        _field("Severity", session.severity),
        _field("Timing", session.timing),
      ]),

      _sectionTitle("SINSS"),
      _infoCard([
        _field(
          "Severity",
          session.sinssSeverity,
        ),
        _field(
          "Irritability",
          session.irritability,
        ),
        _field("Nature", session.nature),
        _field("Stage", session.stage),
        _field(
          "Stability",
          session.stability,
        ),
      ]),

      _sectionTitle("Origin"),
      _originChips(session),

      _sectionTitle("Assessment"),
      _infoCard([
        _field(
          "Biomechanical Findings",
          session.biomechanicalFindings,
        ),
        _field(
          "Osteopathic Findings",
          session.osteopathicFindings,
        ),
        _field(
          "Other Findings",
          session.otherFindings,
        ),
      ]),

      _sectionTitle("Treatment"),
      _infoCard([
        _field(
          "Treatment Goals",
          session.treatmentGoals,
        ),
        _field(
          "Treatment Given",
          session.treatmentGiven,
        ),
        _field(
          "Home Exercise Program",
          session.homeExerciseProgram,
        ),
        _field("Advice", session.advice),
      ]),

      _sectionTitle("Session Note"),
      _infoCard([
        _field(
          "Clinical Note",
          session.sessionNote.trim().isEmpty
              ? "No session note added"
              : session.sessionNote,
        ),
      ]),

      _sectionTitle("Payment"),
      _infoCard([
        _field(
          "Amount Paid",
          session.paymentAmount.isEmpty
              ? "Not entered"
              : session.paymentAmount,
        ),
      ]),

      pw.SizedBox(height: 20),

      pw.Container(
        width: double.infinity,
        padding: const pw.EdgeInsets.only(top: 24),
        child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.end,
          children: [
            pw.Column(
              children: [
                pw.Container(
                  width: 150,
                  height: 1,
                  color: PdfColors.grey500,
                ),
                pw.SizedBox(height: 5),
                pw.Text(
                  "Doctor Signature",
                  style: pw.TextStyle(
                    fontSize: 9,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.grey700,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ];
  }

  Future<void> generateSessionPdf(
      SessionModel session,
      ) async {
    final pdf = pw.Document();
    final logo = await _loadLogo();

    pdf.addPage(
      pw.MultiPage(
        pageTheme: _pageTheme(),
        header: (context) => _pageHeader(
          context,
          logo,
          "Physiotherapy Session Report",
        ),
        footer: (context) => _pageFooter(),
        build: (context) => [
          _reportTitle(
            "Session ${session.sessionNumber}",
            "${session.patientName} • ${session.patientCode}",
          ),
          pw.SizedBox(height: 8),
          ..._sessionContent(
            session,
            showPatientInformation: true,
          ),
        ],
      ),
    );

    final bytes = await pdf.save();

    await _savePdf(
      bytes,
      "${session.patientCode}_Session_${session.sessionNumber}.pdf",
    );
  }

  Future<void> generateAllSessionsPdf(
      List<SessionModel> sessions,
      ) async {
    if (sessions.isEmpty) {
      return;
    }

    final sortedSessions =
    List<SessionModel>.from(sessions)
      ..sort(
            (a, b) => a.sessionNumber.compareTo(
          b.sessionNumber,
        ),
      );

    final firstSession = sortedSessions.first;
    final logo = await _loadLogo();
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageTheme: _pageTheme(),
        header: (context) => _pageHeader(
          context,
          logo,
          "Complete Patient Clinical History",
        ),
        footer: (context) => _pageFooter(),
        build: (context) => [
          _reportTitle(
            firstSession.patientName,
            "${firstSession.patientCode} • ${sortedSessions.length} sessions",
          ),
          _sectionTitle("Patient Information"),
          _patientSummary(firstSession),
          pw.SizedBox(height: 12),
          _sectionTitle("Record Summary"),
          _infoCard([
            _field(
              "Total Sessions",
              sortedSessions.length.toString(),
            ),
            _field(
              "First Session",
              sortedSessions.first.sessionDate,
            ),
            _field(
              "Latest Session",
              sortedSessions.last.sessionDate,
            ),
          ]),
        ],
      ),
    );

    for (final session in sortedSessions) {
      pdf.addPage(
        pw.MultiPage(
          pageTheme: _pageTheme(),
          header: (context) => _pageHeader(
            context,
            logo,
            "Complete Patient Clinical History",
          ),
          footer: (context) => _pageFooter(),
          build: (context) => [
            _reportTitle(
              "Session ${session.sessionNumber}",
              session.sessionDate,
            ),
            pw.SizedBox(height: 8),
            ..._sessionContent(
              session,
              showPatientInformation: false,
            ),
          ],
        ),
      );
    }

    final bytes = await pdf.save();

    await _savePdf(
      bytes,
      "${firstSession.patientCode}_Complete_Clinical_History.pdf",
    );
  }

  Future<void> _savePdf(
      Uint8List bytes,
      String fileName,
      ) async {
    if (!kIsWeb &&
        defaultTargetPlatform ==
            TargetPlatform.windows) {
      final location = await getSaveLocation(
        suggestedName: fileName,
        acceptedTypeGroups: const [
          XTypeGroup(
            label: "PDF File",
            extensions: ["pdf"],
          ),
        ],
      );

      if (location == null) {
        return;
      }

      final file = XFile.fromData(
        bytes,
        mimeType: "application/pdf",
        name: fileName,
      );

      await file.saveTo(location.path);
      return;
    }

    await Printing.layoutPdf(
      name: fileName,
      onLayout: (format) async => bytes,
    );
  }
}

import 'package:flutter/material.dart';
import '../../models/doctor/session_model.dart';

class PreviousSessionCard extends StatelessWidget {
  final SessionModel session;
  final VoidCallback onEdit;
  final VoidCallback onView;
  final VoidCallback onPdf;
  final VoidCallback onDelete;
  final VoidCallback onTap;

  const PreviousSessionCard({
    super.key,
    required this.session,
    required this.onEdit,
    required this.onView,
    required this.onPdf,
    required this.onDelete,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final date = session.saveDate.isEmpty
        ? session.sessionDate
        : session.saveDate;

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(
          color: Colors.blue.shade100,
          width: 1.2,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Session ${session.sessionNumber}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.2,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today_outlined,
                              size: 13,
                              color: Colors.grey.shade500,
                            ),
                            const SizedBox(width: 5),
                            Expanded(
                              child: Text(
                                date,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  PopupMenuButton<String>(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 36,
                      minHeight: 36,
                    ),
                    icon: Icon(
                      Icons.more_horiz,
                      size: 20,
                      color: Colors.grey.shade600,
                    ),
                    onSelected: (value) {
                      switch (value) {
                        case "edit":
                          onEdit();
                          break;
                        case "view":
                          onView();
                          break;
                        case "pdf":
                          onPdf();
                          break;
                        case "delete":
                          onDelete();
                          break;
                      }
                    },
                    itemBuilder: (_) => const [
                      PopupMenuItem(
                        value: "edit",
                        child: Row(
                          children: [
                            Icon(Icons.edit_outlined, size: 19),
                            SizedBox(width: 9),
                            Text("Edit Session"),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: "view",
                        child: Row(
                          children: [
                            Icon(Icons.visibility_outlined, size: 19),
                            SizedBox(width: 9),
                            Text("View"),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: "pdf",
                        child: Row(
                          children: [
                            Icon(
                              Icons.picture_as_pdf_outlined,
                              size: 19,
                            ),
                            SizedBox(width: 9),
                            Text("Generate PDF"),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: "delete",
                        child: Row(
                          children: [
                            Icon(Icons.delete_outline, size: 19),
                            SizedBox(width: 9),
                            Text("Delete"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 15),

              Divider(
                height: 1,
                color: Colors.grey.shade200,
              ),

              const SizedBox(height: 15),

              SizedBox(
                width: double.infinity,
                height: 36,
                child: OutlinedButton(
                  onPressed: onView,
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    backgroundColor: Colors.blue.shade50,
                    side: BorderSide(
                      color: Colors.blue.shade200,
                      width: 1,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "View Session",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.blue.shade700,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Icon(
                        Icons.arrow_forward_rounded,
                        size: 15,
                        color: Colors.blue.shade700,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
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
    final completed =
        session.paymentStatus == "Completed";

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 15),
      clipBehavior: Clip.antiAlias,

      child: InkWell(
        borderRadius: BorderRadius.circular(12),

        onTap: onTap,

        child: Padding(
          padding: const EdgeInsets.all(15),

          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [

              //------------------------------------------------
              // Session Number
              //------------------------------------------------

              CircleAvatar(
                radius: 24,
                backgroundColor: Colors.blue.shade100,

                child: Text(
                  "${session.sessionNumber}",

                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(width: 15),

              //------------------------------------------------
              // Session Details
              //------------------------------------------------

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,

                  children: [

                    //------------------------------------------------
                    // Session Title
                    //------------------------------------------------

                    Text(
                      "Session ${session.sessionNumber}",

                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 7),

                    //------------------------------------------------
                    // Session Save Date
                    //
                    // Example:
                    // 8th July 2026
                    //------------------------------------------------

                    Row(
                      children: [

                        const Icon(
                          Icons.calendar_month_outlined,
                          size: 15,
                          color: Colors.grey,
                        ),

                        const SizedBox(width: 6),

                        Flexible(
                          child: Text(
                            session.saveDate.isEmpty
                                ? session.sessionDate
                                : session.saveDate,

                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),

                            overflow:
                            TextOverflow.ellipsis,
                          ),
                        ),

                      ],
                    ),

                    const SizedBox(height: 12),

                    //------------------------------------------------
                    // Payment Information
                    //------------------------------------------------

                    Wrap(
                      spacing: 10,
                      runSpacing: 8,

                      children: [

                        //------------------------------------------------
                        // Payment Amount
                        //------------------------------------------------

                        Container(
                          padding:
                          const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),

                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,

                            borderRadius:
                            BorderRadius.circular(20),
                          ),

                          child: Row(
                            mainAxisSize: MainAxisSize.min,

                            children: [

                              const Icon(
                                Icons.currency_rupee,
                                size: 15,
                                color: Colors.blue,
                              ),

                              Text(
                                session.paymentAmount.isEmpty
                                    ? "N/A"
                                    : session.paymentAmount,

                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),

                            ],
                          ),
                        ),

                        //------------------------------------------------
                        // Payment Status
                        //------------------------------------------------



                      ],
                    ),

                  ],
                ),
              ),

              //------------------------------------------------
              // Session Actions Menu
              //------------------------------------------------

              PopupMenuButton<String>(
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

                  //------------------------------------------------
                  // Edit Session
                  //------------------------------------------------

                  PopupMenuItem(
                    value: "edit",

                    child: Row(
                      children: [
                        Icon(Icons.edit),
                        SizedBox(width: 8),
                        Text("Edit Session"),
                      ],
                    ),
                  ),

                  //------------------------------------------------
                  // View Session
                  //------------------------------------------------

                  PopupMenuItem(
                    value: "view",

                    child: Row(
                      children: [
                        Icon(Icons.visibility),
                        SizedBox(width: 8),
                        Text("View"),
                      ],
                    ),
                  ),

                  //------------------------------------------------
                  // Generate PDF
                  //------------------------------------------------

                  PopupMenuItem(
                    value: "pdf",

                    child: Row(
                      children: [
                        Icon(Icons.picture_as_pdf),
                        SizedBox(width: 8),
                        Text("Generate PDF"),
                      ],
                    ),
                  ),

                  //------------------------------------------------
                  // Delete Session
                  //------------------------------------------------

                  PopupMenuItem(
                    value: "delete",

                    child: Row(
                      children: [
                        Icon(Icons.delete),
                        SizedBox(width: 8),
                        Text("Delete"),
                      ],
                    ),
                  ),

                ],
              ),

            ],
          ),
        ),
      ),
    );
  }
}
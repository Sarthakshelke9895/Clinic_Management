import 'package:flutter/material.dart';

import '../../models/doctor/session_model.dart';

class PreviousSessionCard extends StatelessWidget {
  final SessionModel session;

  final VoidCallback onEdit;

  final VoidCallback onView;

  final VoidCallback onPdf;

  final VoidCallback onDelete;

  const PreviousSessionCard({
    super.key,
    required this.session,
    required this.onEdit,
    required this.onView,
    required this.onPdf,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final completed =
        session.paymentStatus == "Completed";

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 15),

      child: Padding(
        padding: const EdgeInsets.all(15),

        child: Row(
          crossAxisAlignment:
          CrossAxisAlignment.start,

          children: [

            //------------------------------------------------
            // Session Number
            //------------------------------------------------

            CircleAvatar(
              radius: 24,

              backgroundColor:
              Colors.blue.shade100,

              child: Text(
                "${session.sessionNumber}",

                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(width: 15),

            //------------------------------------------------
            // Details
            //------------------------------------------------

            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,

                children: [

                  Text(
                    "Session ${session.sessionNumber}",

                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Row(
                    children: [

                      const Icon(
                        Icons.calendar_today,
                        size: 14,
                        color: Colors.grey,
                      ),

                      const SizedBox(width: 5),

                      Text(
                        session.sessionDate,

                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),

                    ],
                  ),

                  const SizedBox(height: 12),

                  Wrap(
                    spacing: 10,
                    runSpacing: 8,

                    children: [

                      Container(
                        padding:
                        const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),

                        decoration: BoxDecoration(
                          color:
                          Colors.blue.shade50,

                          borderRadius:
                          BorderRadius.circular(
                              20),
                        ),

                        child: Row(
                          mainAxisSize:
                          MainAxisSize.min,

                          children: [

                            const Icon(
                              Icons.currency_rupee,
                              size: 15,
                              color: Colors.blue,
                            ),

                            Text(
                              session.paymentAmount
                                  .isEmpty
                                  ? "N/A"
                                  : session
                                  .paymentAmount,

                              style:
                              const TextStyle(
                                fontWeight:
                                FontWeight.bold,

                                color: Colors.blue,
                              ),
                            ),

                          ],
                        ),
                      ),

                      Container(
                        padding:
                        const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),

                        decoration: BoxDecoration(
                          color: completed
                              ? Colors.green
                              .shade100
                              : Colors.orange
                              .shade100,

                          borderRadius:
                          BorderRadius.circular(
                              20),
                        ),

                        child: Row(
                          mainAxisSize:
                          MainAxisSize.min,

                          children: [

                            Icon(
                              completed
                                  ? Icons
                                  .check_circle
                                  : Icons.pending,

                              size: 15,

                              color: completed
                                  ? Colors.green
                                  : Colors.orange,
                            ),

                            const SizedBox(width: 5),

                            Text(
                              session.paymentStatus,

                              style: TextStyle(
                                fontWeight:
                                FontWeight.bold,

                                color: completed
                                    ? Colors.green
                                    : Colors.orange,
                              ),
                            ),

                          ],
                        ),
                      ),

                    ],
                  ),

                ],
              ),
            ),

            //------------------------------------------------
            // Menu
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

                PopupMenuItem(
                  value: "edit",
                  child: Row(
                    children: [
                      Icon(Icons.edit),
                      SizedBox(width: 8),
                      Text("Edit"),
                    ],
                  ),
                ),

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
    );
  }
}
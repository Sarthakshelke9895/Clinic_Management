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

    final payment =
    session.paymentAmount.isEmpty
        ? "N/A"
        : session.paymentAmount;

    final doctor =
    session.treatingDoctor.isEmpty
        ? "N/A"
        : session.treatingDoctor;

    final date =
    session.saveDate.isEmpty
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
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              // =========================================
              // HEADER
              // =========================================

              Row(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Session ${session.sessionNumber}",
                          maxLines: 1,
                          overflow:
                          TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight:
                            FontWeight.w700,
                            letterSpacing: -0.2,
                          ),
                        ),

                        const SizedBox(height: 5),

                        Row(
                          children: [
                            Icon(
                              Icons
                                  .calendar_today_outlined,
                              size: 13,
                              color:
                              Colors.grey.shade500,
                            ),
                            const SizedBox(width: 5),
                            Expanded(
                              child: Text(
                                date,
                                maxLines: 1,
                                overflow:
                                TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors
                                      .grey
                                      .shade600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // =====================================
                  // MENU
                  // =====================================

                  PopupMenuButton<String>(
                    padding: EdgeInsets.zero,
                    constraints:
                    const BoxConstraints(
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
                            Icon(
                              Icons.edit_outlined,
                              size: 19,
                            ),
                            SizedBox(width: 9),
                            Text("Edit Session"),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: "view",
                        child: Row(
                          children: [
                            Icon(
                              Icons.visibility_outlined,
                              size: 19,
                            ),
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
                              Icons
                                  .picture_as_pdf_outlined,
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
                            Icon(
                              Icons.delete_outline,
                              size: 19,
                            ),
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

              // =========================================
              // DIVIDER
              // =========================================

              Divider(
                height: 1,
                color: Colors.grey.shade200,
              ),

              const SizedBox(height: 15),

              // =========================================
              // SESSION INFORMATION
              // =========================================

              Row(
                children: [
                  Expanded(
                    child: _DetailItem(
                      icon: Icons.currency_rupee,
                      label: "Payment",
                      value: payment,
                    ),
                  ),

                  Container(
                    width: 1,
                    height: 38,
                    color: Colors.grey.shade200,
                  ),

                  Expanded(
                    child: Padding(
                      padding:
                      const EdgeInsets.only(
                        left: 12,
                      ),
                      child: _DetailItem(
                        icon:
                        Icons.medical_services_outlined,
                        label: "Doctor",
                        value: doctor,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 15),

              // =========================================
              // PAYMENT STATUS
              // =========================================

              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: completed
                          ? Colors.green
                          : Colors.orange,
                    ),
                  ),

                  const SizedBox(width: 7),

                  Expanded(
                    child: Text(
                      session.paymentStatus.isEmpty
                          ? "Payment Pending"
                          : session.paymentStatus,
                      maxLines: 1,
                      overflow:
                      TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight:
                        FontWeight.w600,
                        color: completed
                            ? Colors.green.shade700
                            : Colors.orange.shade700,
                      ),
                    ),
                  ),
                ],
              ),

              const Spacer(),

              const SizedBox(height: 14),

              // =========================================
              // VIEW SESSION BUTTON
              // =========================================

              SizedBox(
                width: double.infinity,
                height: 36,
                child: OutlinedButton(
                  onPressed: onView,
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    backgroundColor:
                    Colors.blue.shade50,
                    side: BorderSide(
                      color: Colors.blue.shade200,
                      width: 1,
                    ),
                    shape:
                    RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(9),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment:
                    MainAxisAlignment.center,
                    children: [
                      Text(
                        "View Session",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight:
                          FontWeight.w600,
                          color:
                          Colors.blue.shade700,
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

// =====================================================
// DETAIL ITEM
// =====================================================

class _DetailItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 17,
          color: Colors.grey.shade600,
        ),

        const SizedBox(width: 7),

        Expanded(
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey.shade500,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 2),

              Text(
                value,
                maxLines: 1,
                overflow:
                TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
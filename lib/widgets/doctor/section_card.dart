import 'package:flutter/material.dart';

class SectionCard extends StatefulWidget {
  final String id;
  final String title;
  final IconData icon;
  final Widget child;
  final bool initiallyExpanded;

  final String? expandedSectionId;
  final ValueChanged<String?>? onExpansionChanged;

  const SectionCard({
    super.key,
    required this.id,
    required this.title,
    required this.icon,
    required this.child,
    this.initiallyExpanded = true,
    this.expandedSectionId,
    this.onExpansionChanged,
  });

  @override
  State<SectionCard> createState() =>
      _SectionCardState();
}

class _SectionCardState extends State<SectionCard>
    with TickerProviderStateMixin {
  late bool isExpanded;

  @override
  void initState() {
    super.initState();

    isExpanded =
    widget.expandedSectionId != null
        ? widget.expandedSectionId == widget.id
        : widget.initiallyExpanded;
  }

  @override
  void didUpdateWidget(
      covariant SectionCard oldWidget,
      ) {
    super.didUpdateWidget(oldWidget);

    final newExpandedState =
        widget.expandedSectionId == widget.id;

    if (isExpanded != newExpandedState) {
      setState(() {
        isExpanded = newExpandedState;
      });
    }
  }

  void _handleTap() {
    if (widget.onExpansionChanged != null) {
      if (isExpanded) {
        widget.onExpansionChanged!(null);
      } else {
        widget.onExpansionChanged!(widget.id);
      }

      return;
    }

    setState(() {
      isExpanded = !isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    final primary =
        Theme.of(context).primaryColor;

    return Container(
      margin: const EdgeInsets.only(
        bottom: 12,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(12),
        border: Border.all(
          color: isExpanded
              ? primary.withOpacity(.18)
              : Colors.grey.shade200,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.035),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: AnimatedSize(
        duration:
        const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        child: Column(
          children: [
            //==================================================
            // HEADER
            //==================================================

            Material(
              color: isExpanded
                  ? primary.withOpacity(.025)
                  : Colors.white,
              child: InkWell(
                onTap: _handleTap,
                splashColor:
                primary.withOpacity(.06),
                highlightColor:
                primary.withOpacity(.025),
                child: Padding(
                  padding:
                  const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      //========================================
                      // ICON
                      //========================================

                      AnimatedContainer(
                        duration:
                        const Duration(
                          milliseconds: 200,
                        ),
                        height: 38,
                        width: 38,
                        decoration: BoxDecoration(
                          color: isExpanded
                              ? primary
                              .withOpacity(.12)
                              : primary
                              .withOpacity(.07),
                          borderRadius:
                          BorderRadius.circular(
                            9,
                          ),
                        ),
                        child: Icon(
                          widget.icon,
                          color: primary,
                          size: 20,
                        ),
                      ),

                      const SizedBox(width: 13),

                      //========================================
                      // TITLE
                      //========================================

                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.title,
                              maxLines: 1,
                              overflow:
                              TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight:
                                FontWeight.w600,
                                color:
                                Colors.grey.shade900,
                                letterSpacing:
                                -0.1,
                              ),
                            ),

                            if (isExpanded) ...[
                              const SizedBox(height: 3),

                              Text(
                                "Expanded",
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight:
                                  FontWeight.w500,
                                  color:
                                  primary.withOpacity(
                                    .75,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),

                      const SizedBox(width: 10),

                      //========================================
                      // ARROW
                      //========================================

                      AnimatedContainer(
                        duration:
                        const Duration(
                          milliseconds: 200,
                        ),
                        height: 32,
                        width: 32,
                        decoration: BoxDecoration(
                          color: isExpanded
                              ? primary
                              .withOpacity(.08)
                              : Colors.grey
                              .shade100,
                          shape: BoxShape.circle,
                        ),
                        child: AnimatedRotation(
                          turns:
                          isExpanded ? .5 : 0,
                          duration:
                          const Duration(
                            milliseconds: 250,
                          ),
                          curve: Curves.easeOut,
                          child: Icon(
                            Icons
                                .keyboard_arrow_down_rounded,
                            color: isExpanded
                                ? primary
                                : Colors.grey
                                .shade600,
                            size: 21,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            //==================================================
            // DIVIDER
            //==================================================

            if (isExpanded)
              Divider(
                height: 1,
                thickness: 1,
                color: primary.withOpacity(.08),
              ),

            //==================================================
            // BODY
            //==================================================

            if (isExpanded)
              Container(
                width: double.infinity,
                color: Colors.white,
                child: Padding(
                  padding:
                  const EdgeInsets.fromLTRB(
                    20,
                    18,
                    20,
                    20,
                  ),
                  child: widget.child,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
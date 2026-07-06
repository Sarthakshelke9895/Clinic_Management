import 'package:flutter/material.dart';

class SectionCard extends StatefulWidget {
  final String title;
  final IconData icon;
  final Widget child;
  final bool initiallyExpanded;

  const SectionCard({
    super.key,
    required this.title,
    required this.icon,
    required this.child,
    this.initiallyExpanded = true,
  });

  @override
  State<SectionCard> createState() => _SectionCardState();
}

class _SectionCardState extends State<SectionCard>
    with TickerProviderStateMixin {

  late bool isExpanded;

  @override
  void initState() {
    super.initState();
    isExpanded = widget.initiallyExpanded;
  }

  @override
  Widget build(BuildContext context) {

    final primary = Theme.of(context).primaryColor;

    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      clipBehavior: Clip.antiAlias,

      child: AnimatedSize(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,

        child: Column(

          children: [

            //--------------------------------------------------
            // Header
            //--------------------------------------------------

            InkWell(

              onTap: () {

                setState(() {

                  isExpanded = !isExpanded;

                });

              },

              child: Padding(

                padding: const EdgeInsets.fromLTRB(
                  16,
                  14,
                  16,
                  14,
                ),

                child: Row(

                  children: [

                    Container(

                      height: 35,
                      width: 35,

                      decoration: BoxDecoration(

                        color: primary.withOpacity(.08),

                        borderRadius:
                        BorderRadius.circular(8),

                      ),

                      child: Icon(
                        widget.icon,
                        color: primary,
                        size: 22,
                      ),

                    ),

                    const SizedBox(width: 16),

                    Expanded(

                      child: Text(

                        widget.title,

                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),

                      ),

                    ),

                    AnimatedRotation(

                      turns: isExpanded ? .5 : 0,

                      duration: const Duration(
                        milliseconds: 250,
                      ),

                      child: Icon(

                        Icons.keyboard_arrow_down_rounded,

                        color: Colors.grey.shade700,

                        size: 28,

                      ),

                    ),

                  ],

                ),

              ),

            ),

            //--------------------------------------------------
            // Divider
            //--------------------------------------------------

            if (isExpanded)
              Divider(
                height: 1,
                color: Colors.grey.shade200,
              ),

            //--------------------------------------------------
            // Body
            //--------------------------------------------------

            if (isExpanded)

              Padding(

                padding: const EdgeInsets.fromLTRB(
                  20,
                  20,
                  20,
                  20,
                ),

                child: widget.child,

              ),

          ],

        ),

      ),

    );

  }

}
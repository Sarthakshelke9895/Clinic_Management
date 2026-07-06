import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';

class DashboardTile extends StatelessWidget {

  final String title;

  final IconData icon;

  final VoidCallback onTap;

  final Color color;

  const DashboardTile({

    super.key,

    required this.title,

    required this.icon,

    required this.onTap,

    this.color = AppColors.primary,

  });

  @override
  Widget build(BuildContext context) {

    return Card(

      elevation: 2,

      margin: const EdgeInsets.symmetric(vertical: 8),

      shape: RoundedRectangleBorder(

        borderRadius: BorderRadius.circular(12),

      ),

      child: ListTile(

        contentPadding: const EdgeInsets.symmetric(

          horizontal: 20,

          vertical: 10,

        ),

        leading: CircleAvatar(

          backgroundColor: color.withOpacity(.15),

          child: Icon(

            icon,

            color: color,

          ),

        ),

        title: Text(

          title,

          style: const TextStyle(

            fontWeight: FontWeight.w600,

            fontSize: 17,

          ),

        ),

        trailing: const Icon(

          Icons.arrow_forward_ios,

          size: 18,

        ),

        onTap: onTap,

      ),

    );
  }
}
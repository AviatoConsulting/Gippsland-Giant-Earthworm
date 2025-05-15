import 'package:flutter/material.dart';
import 'package:giant_gipsland_earthworm_fe/core/theme/app_colors.dart';
import 'package:giant_gipsland_earthworm_fe/features/dashboard/controller/dashboard_controller.dart';

class HowMyDataUseWidget extends StatelessWidget {
  const HowMyDataUseWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
          color: AppColor.primaryColor,
          borderRadius: BorderRadius.circular(16)),
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Expanded(
            child: Text(
              "Do you have worm sites on your property? Add worm sites.",
              maxLines: 3,
              style: textTheme.titleLarge?.copyWith(
                  fontSize: 19,
                  fontWeight: FontWeight.w500,
                  color: Colors.white),
            ),
          ),
          const SizedBox(width: 8),
          InkWell(
            onTap: () =>
                DashboardController.instance.currentPageIndex.value = 1,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(18)),
              child: Text(
                "Add Worm",
                style: textTheme.titleLarge?.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: AppColor.primaryColor),
              ),
            ),
          )
        ],
      ),
    );
  }
}

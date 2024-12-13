import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:giant_gipsland_earthworm_fe/core/constants/app_constants.dart';
import 'package:giant_gipsland_earthworm_fe/core/constants/common_assets.dart';
import 'package:giant_gipsland_earthworm_fe/features/dashboard/home_screen/controller/home_controller.dart';
import 'package:giant_gipsland_earthworm_fe/features/dashboard/home_screen/widgets/screen_title_widget.dart';

class HowWillMyDataUseScreen extends StatelessWidget {
  const HowWillMyDataUseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme =
        Theme.of(context).textTheme; // Get the text theme for styling

    return Scaffold(
      body: Padding(
        padding: AppConstants.screenPadding(), // Custom padding from constants
        child: SingleChildScrollView(
          // Allows scrolling if content exceeds screen height
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title and back button
              const ScreenTitleWidget(title: "", isBack: true),

              // Main title for the screen
              Text(
                "How will my data be \nused?", // Title text for the data usage explanation
                style: textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w500), // Apply headline style
              ),
              const SizedBox(height: 15),

              // Displaying the content about how data will be used
              // Using Obx to reactively update content when the HomeController model changes
              Obx(() => Container(
                    decoration: CommonAssets.containerDecorationwithShadow(
                        context:
                            context), // Decoration with shadow for the container
                    padding:
                        const EdgeInsets.all(16), // Padding around the content
                    child: Text(
                      HomeController.instance.homeScreenModel.value
                          .howDataWillBeUsed, // Text coming from the controller
                      style: textTheme.bodyLarge?.copyWith(
                          letterSpacing:
                              0.6), // Apply body style with slight letter spacing
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

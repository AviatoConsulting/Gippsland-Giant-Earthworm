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

    // Show when user is offline and open app first time
    const String howDataUsed =
        "All personal data collected during this project will be confidential. The collected data will be used to inform future Giant Gippsland Earthworm conservation programs and policy development. Collected data records will also be added to relevant databases such as the Biodiversity Data Repository and other existing database systems. No personal details or property details of GGE habitat sites will be publicly disclosed in any form.";

    return Scaffold(
      body: Padding(
        padding: AppConstants.screenPadding(
            context: context), // Custom padding from constants
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
                              .howDataWillBeUsed.isNotEmpty
                          ? HomeController
                              .instance.homeScreenModel.value.howDataWillBeUsed
                          : howDataUsed, // Text coming from the controller
                      style: textTheme.bodyLarge?.copyWith(
                          // color: Colors.black,
                          fontWeight: FontWeight.w500,
                          letterSpacing:
                              0.8), // Apply body style with slight letter spacing
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

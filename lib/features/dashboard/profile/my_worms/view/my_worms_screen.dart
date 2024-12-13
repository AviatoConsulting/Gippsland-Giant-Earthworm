import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:giant_gipsland_earthworm_fe/core/common_widgets/alert_msg_dialog.dart';
import 'package:giant_gipsland_earthworm_fe/core/common_widgets/custom_loader.dart';
import 'package:giant_gipsland_earthworm_fe/core/constants/common_assets.dart';
import 'package:giant_gipsland_earthworm_fe/core/theme/app_colors.dart';
import 'package:giant_gipsland_earthworm_fe/features/dashboard/controller/dashboard_controller.dart';
import 'package:giant_gipsland_earthworm_fe/features/dashboard/home_screen/widgets/location_card.dart';
import 'package:giant_gipsland_earthworm_fe/features/dashboard/home_screen/widgets/screen_title_widget.dart';
import 'package:giant_gipsland_earthworm_fe/features/dashboard/profile/my_worms/controller/my_worm_controller.dart';
import 'package:giant_gipsland_earthworm_fe/features/dashboard/worm_details/view/worm_details_screen.dart';
import '../../../../../core/constants/app_constants.dart';

class MyWormsScreen extends GetView<MyWormsControllers> {
  const MyWormsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme =
        Theme.of(context).textTheme; // To access the app's text styles

    return Scaffold(
      body: Padding(
        padding: AppConstants.screenPadding(), // Padding for the screen content
        child: SingleChildScrollView(
          // Allows scrolling when content overflows
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start, // Aligns content to the start
            children: [
              const ScreenTitleWidget(
                  title: "My GGE Records",
                  isBack: true), // Title with back button
              // The controller reacts to the data state using `obx` (Observer)
              controller.obx(
                  (state) => controller.wormList.isEmpty
                      // If no worm records are available
                      ? Container(
                          margin: const EdgeInsets.only(
                              top: 12), // Top margin for the message box
                          padding: const EdgeInsets.all(
                              16), // Padding inside the box
                          decoration:
                              CommonAssets.containerDecorationwithShadow(
                                  context:
                                      context), // Custom decoration with shadow
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "Currently, no GGE records are available. Would you like to add one now?",
                                  style: textTheme.bodyLarge, // Text style
                                ),
                              ),
                              const SizedBox(width: 30),
                              // Add button to navigate to a different page
                              InkWell(
                                onTap: () => DashboardController
                                    .instance
                                    .currentPageIndex
                                    .value = 1, // Navigate to page 1
                                child: Container(
                                  padding: const EdgeInsets.all(
                                      8), // Padding for the button
                                  decoration: BoxDecoration(
                                      color: AppColor
                                          .primaryColor, // Primary color for the button
                                      borderRadius: BorderRadius.circular(8)),
                                  child: const Icon(
                                    Icons.add, // Add icon
                                    size: 20,
                                    color:
                                        AppColor.white, // White color for icon
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      // If there are worm records, display them in a list
                      : ListView.builder(
                          shrinkWrap:
                              true, // Ensures the ListView occupies minimal space
                          physics:
                              const NeverScrollableScrollPhysics(), // Disables scrolling within the ListView
                          itemCount: controller
                              .wormList.length, // Number of items in the list
                          itemBuilder: (context, index) {
                            final item = controller.wormList[
                                index]; // Get the worm item at current index
                            return InkWell(
                              onTap: () => Get.to(() => WormDetailsScreen(
                                  wormDetails:
                                      item)), // Navigate to worm details
                              child: Stack(
                                children: [
                                  LocationCard(
                                      coordinates: item.latLong,
                                      description: item.note,
                                      location:
                                          "${item.administrativeArea}, ${item.country}",
                                      icon: item
                                          .locationImg), // Display worm's location details
                                  // Positioned delete icon button
                                  Positioned(
                                    right: 10,
                                    bottom: 25,
                                    child: InkWell(
                                      onTap: () => Get.dialog(
                                          CommonAlertMessageDialog(
                                              buttonText:
                                                  "Delete Worm", // Dialog title and button text
                                              title: "Delete Worm?",
                                              description:
                                                  "Are you sure you want to delete this worm? This action cannot be undone, and all your data will be permanently removed.",
                                              action: () {
                                                Get.back(); // Close the dialog
                                                controller.deleteWorm(
                                                    worm: item,
                                                    context:
                                                        context); // Delete the worm
                                              })),
                                      child: const Icon(
                                        Icons.delete_outline, // Delete icon
                                        color: Colors
                                            .black, // Black color for icon
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                        ),
                  onLoading: const Center(
                      child:
                          CustomLoader())) // Loader displayed when data is being fetched
            ],
          ),
        ),
      ),
    );
  }
}

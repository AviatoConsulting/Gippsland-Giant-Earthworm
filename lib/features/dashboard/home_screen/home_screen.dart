import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:giant_gipsland_earthworm_fe/core/common_widgets/custom_loader.dart';
import 'package:giant_gipsland_earthworm_fe/core/constants/common_assets.dart';
import 'package:giant_gipsland_earthworm_fe/core/theme/app_colors.dart';
import 'package:giant_gipsland_earthworm_fe/features/dashboard/controller/dashboard_controller.dart';
import 'package:giant_gipsland_earthworm_fe/features/dashboard/home_screen/controller/home_controller.dart';
import 'package:giant_gipsland_earthworm_fe/features/dashboard/home_screen/widgets/how_my_data_use_widget.dart';
import 'package:giant_gipsland_earthworm_fe/features/dashboard/home_screen/widgets/location_card.dart';
import 'package:giant_gipsland_earthworm_fe/features/dashboard/home_screen/widgets/sample_video_carousel.dart';
import 'package:giant_gipsland_earthworm_fe/features/dashboard/home_screen/widgets/screen_title_widget.dart';
import 'package:giant_gipsland_earthworm_fe/features/dashboard/worm_details/view/worm_details_screen.dart';
import 'package:giant_gipsland_earthworm_fe/route/routes_constant.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme =
        Theme.of(context).textTheme; // Get the text theme for styling

    return SingleChildScrollView(
      child: Obx(() => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header section with screen title and right-side logo button
              const ScreenTitleWidget(
                title: "Home",
                rightLogoVisible: true,
              ),
              const SizedBox(height: 15),

              // About Us section
              InkWell(
                onTap: () => Get.toNamed(
                    RouteConstant.about), // Navigate to About Us screen
                child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.black26),
                    ),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("About us",
                              style: textTheme.titleLarge
                                  ?.copyWith(fontWeight: FontWeight.w500)),
                          const Icon(Icons.arrow_forward_ios),
                        ])),
              ),
              const SizedBox(height: 15),

              // How My Data is Used section
              const HowMyDataUseWidget(),
              const SizedBox(height: 10),

              // Video carousel for sample videos (only if there are videos available)
              controller.homeScreenModel.value.sampleVideos.isEmpty
                  ? const SizedBox()
                  : SampleVideoCarousel(
                      videoUrls: controller.homeScreenModel.value.sampleVideos
                          .map((e) => e.videoLink)
                          .toList(),
                      text: controller.homeScreenModel.value.sampleVideos
                          .map((e) => e.title)
                          .toList(),
                    ),

              // Space between the video carousel and the "Recently Added Worms" section
              SizedBox(height: controller.isExapand.value ? 24 : 10),

              // Title for "Recently Added Worms"
              Text(
                "Recently Added Worms",
                style: textTheme.titleMedium?.copyWith(fontSize: 20),
              ),

              // Display worms list or a message if no worms are found
              controller.obx((state) {
                final hasWorms = controller.isSearch.value
                    ? controller.filteredWormList.isEmpty
                    : controller.wormList.isEmpty;

                // Show a message if no worms are found
                return (hasWorms)
                    ? Container(
                        margin: const EdgeInsets.only(top: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: CommonAssets.containerDecorationwithShadow(
                            context: context),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                (controller.isSearch.value)
                                    ? "No results found. Would you like to add one now?"
                                    : "Currently, no GGE records are available. Would you like to add one now?",
                                style: textTheme.bodyLarge,
                              ),
                            ),
                            const SizedBox(width: 30),

                            // Add Worms button
                            InkWell(
                              onTap: () => DashboardController
                                      .instance.currentPageIndex.value =
                                  1, // Navigate to the Add Worms screen
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    color: AppColor.primaryColor,
                                    borderRadius: BorderRadius.circular(8)),
                                child: const Icon(
                                  Icons.add,
                                  size: 20,
                                  color: AppColor.white,
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.only(top: 10),
                        shrinkWrap:
                            true, // Prevents the list from taking more space than needed
                        physics:
                            const NeverScrollableScrollPhysics(), // Disables scrolling within the list
                        itemCount: controller.isSearch.value
                            ? controller.filteredWormList.length
                            : controller.wormList.length,
                        itemBuilder: (context, index) {
                          // Get the worm item (either from filtered list or all worms list)
                          final item = controller.isSearch.value
                              ? controller.filteredWormList[index]
                              : controller.wormList[index];

                          // When a worm is tapped, navigate to its details screen
                          return InkWell(
                            onTap: () => Get.to(
                                () => WormDetailsScreen(wormDetails: item)),
                            child: LocationCard(
                                coordinates: item.latLong,
                                description: item.note,
                                location:
                                    "${item.administrativeArea}, ${item.country}",
                                icon: item.locationImg),
                          );
                        },
                      );
              },
                  onLoading:
                      const CustomLoader()) // Show a loader while data is being fetched
            ],
          )),
    );
  }
}

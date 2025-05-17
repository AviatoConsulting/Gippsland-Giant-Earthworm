import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:giant_gipsland_earthworm_fe/core/common_widgets/custom_loader.dart';
import 'package:giant_gipsland_earthworm_fe/core/constants/common_assets.dart';
import 'package:giant_gipsland_earthworm_fe/core/theme/app_colors.dart';
import 'package:giant_gipsland_earthworm_fe/features/dashboard/home_screen/widgets/screen_title_widget.dart';
import 'package:giant_gipsland_earthworm_fe/features/dashboard/resources/controller/resources_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class ResourcesScreen extends GetView<ResourcesController> {
  const ResourcesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Retrieving the current text theme from the context
    final textTheme = Theme.of(context).textTheme;

    // Building the UI
    return SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      // Displaying the screen title
      const ScreenTitleWidget(title: "Resources"),
      const SizedBox(height: 15),

      // Using Obx to reactively rebuild UI when the data (resourcesList) changes
      controller.obx(
          // If resources list is empty, display a message
          (state) => controller.resourcesList.isEmpty
              ? Center(
                  child: Text(
                    "No Resources Available", // No resources found message
                    style: textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.w500),
                  ),
                )
              // If resources are available, display them
              : Column(
                  children: controller.resourcesList
                      // Looping through the resources and displaying each one
                      .map((e) => Container(
                            margin: const EdgeInsets.only(bottom: 24),
                            width: MediaQuery.of(context).size.width,
                            decoration:
                                CommonAssets.containerDecorationwithShadow(
                                    context: context),
                            padding: const EdgeInsets.all(18.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Displaying the resource name
                                Text(
                                  e.resourceName,
                                  style: textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18),
                                  maxLines:
                                      2, // Limiting the title to two lines
                                ),
                                const Divider(color: AppColor.dividerColor),
                                // Looping through each resource item and displaying a clickable link
                                ...e.resourceItem.map((e) => Padding(
                                      padding: const EdgeInsets.only(top: 12),
                                      child: InkWell(
                                        onTap: () => launchUrl(Uri.parse(
                                            e.link)), // Launching the link
                                        child: Text(
                                          e.title,
                                          style: textTheme.bodyLarge?.copyWith(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                              color: AppColor.primaryColor,
                                              decoration: TextDecoration
                                                  .underline, // Underlining the text
                                              decorationColor:
                                                  AppColor.primaryColor),
                                        ),
                                      ),
                                    ))
                              ],
                            ),
                          ))
                      .toList(),
                ),
          onLoading:
              const CustomLoader()) // Displaying loader while data is being fetched
    ]));
  }
}

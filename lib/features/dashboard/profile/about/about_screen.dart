import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart'; // For rendering markdown text
import 'package:get/get.dart';
import 'package:giant_gipsland_earthworm_fe/core/constants/app_constants.dart'; // For screen padding constants
import 'package:giant_gipsland_earthworm_fe/core/constants/app_image_constant.dart'; // For image constants
import 'package:giant_gipsland_earthworm_fe/core/constants/common_assets.dart'; // For common assets like partner logos
import 'package:giant_gipsland_earthworm_fe/features/dashboard/home_screen/widgets/screen_title_widget.dart'; // Custom widget for the screen title
import 'package:package_info_plus/package_info_plus.dart'; // For fetching app version information

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  // Rx<PackageInfo> holds the version info and makes it reactive with GetX
  Rx<PackageInfo> packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
  ).obs;

  // Method to fetch package info such as app name, version, etc.
  Future<void> initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    packageInfo(info); // Updating the packageInfo reactive variable
  }

  @override
  void initState() {
    super.initState();
    initPackageInfo(); // Fetching package info on screen initialization
  }

  @override
  Widget build(BuildContext context) {
    final textTheme =
        Theme.of(context).textTheme; // For applying text theme styles

    return Scaffold(
      body: Padding(
        padding: AppConstants.screenPadding(
            context: context), // Custom padding from constants
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ScreenTitleWidget to display the "About Us" title and a back button
            const ScreenTitleWidget(title: "About Us", isBack: true),
            const SizedBox(height: 15),
            // Expanded widget to allow the content to scroll
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Rendering the markdown content from the aboutUsText variable
                    MarkdownBody(
                      data: aboutUsText,
                      styleSheet: MarkdownStyleSheet(
                          h1: textTheme.headlineSmall?.copyWith(fontSize: 22),
                          h2: textTheme.headlineSmall?.copyWith(fontSize: 20),
                          h3: textTheme.titleLarge?.copyWith(fontSize: 22),
                          h4: textTheme.titleLarge,
                          h5: textTheme.titleMedium,
                          h6: textTheme.titleSmall,
                          p: textTheme.bodyLarge,
                          em: textTheme.bodyMedium
                              ?.copyWith(fontStyle: FontStyle.italic),
                          strong: textTheme.bodyLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                          code: textTheme.bodySmall?.copyWith(
                            backgroundColor: Colors.black54,
                          ),
                          listBullet: textTheme.bodyLarge,
                          tableBody: textTheme.bodyMedium,
                          tableHead: textTheme.bodyLarge),
                    ),
                    const SizedBox(height: 10),
                    // "Funded by" section title
                    Text(
                      "Funded by",
                      style: textTheme.headlineSmall?.copyWith(fontSize: 20),
                    ),
                    const SizedBox(height: 5),
                    // Description about the funding source
                    Text(
                      "The ‘Census of the Giant Gippsland Earthworm in South and West Gippsland’ is funded by the Australian Government under the Saving Native Species Program.",
                      style: textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(height: 10),
                    // Display partner logos in two rows using CommonAssets.partnerList
                    SizedBox(
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: CommonAssets.partnerList
                            .map((e) => Image.asset(
                                  e,
                                  fit: BoxFit.contain,
                                  height: 100,
                                  width: 100,
                                ))
                            .take(3) // Take the first 3 partner logos
                            .toList(),
                      ),
                    ),
                    const SizedBox(height: 5),
                    SizedBox(
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: CommonAssets.partnerList
                            .map((e) => Image.asset(
                                  e,
                                  height: 100,
                                  width: 100,
                                  fit: BoxFit.contain,
                                ))
                            .skip(
                                3) // Skip the first 3 logos and show the next 3
                            .take(3)
                            .toList(),
                      ),
                    ),
                    // Display a specific image at the bottom of the screen
                    Center(
                        child: Image.asset(
                      AppImagesConstant.gtsagPNG,
                      fit: BoxFit.contain,
                      height: 100,
                      width: 100,
                    )),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                children: [
                  // Display the GGE Census logo
                  Image.asset(
                    AppImagesConstant.ggeCensusPNG,
                    width: 50,
                    height: 50,
                  ),
                  const SizedBox(height: 5),
                  // Display app version information using the reactive packageInfo
                  Obx(() => Text(
                        'Version: ${packageInfo.value.version} (${packageInfo.value.buildNumber})',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Color(0XFF999693),
                        ),
                      )),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

// Markdown text for the "About Us" section
String aboutUsText = '''
# Welcome to the Giant Gippsland Earthworm Conservation App

Welcome to our community driven app for the conservation and study of the Giant Gippsland Earthworm (GGE). The app has been developed to gather data about GGE habitat locations and increase understanding and appreciation of this unique endangered species.

## Our Vision

Through technology and community engagement, we aim to develop a comprehensive database of GGE habitat locations to support future conservation initiatives.

## Key Features

- **Location-Based Logging:** Easily log Giant Gippsland Earthworm habitat locations with precise location data captured automatically or manually.  Data can be captured within connection or mobile range and also outside connection or mobile range, saved locally on device.

- **Image Upload:** Upload photos of GGE habitat locations.

- **Notes and Observations:** add notes and observations about each recording, contributing valuable context and insights to further GGE research.

- **Community Contribution:** Join a passionate community dedicated to the conservation of the Giant Gippsland earthworm.

## Why Contribute?

Recording each GGE habitat location matters. Your contributions help scientists to better understand the habitats, behaviour and ecological roles of the Giant Gippsland Earthworm.

## Get Involved

Join us in our mission to further understand and protect the Giant Gippsland Earthworm by downloading the GGE App and logging your known habitat locations.
''';

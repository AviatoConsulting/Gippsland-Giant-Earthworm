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
        padding: AppConstants.screenPadding(), // Custom padding from constants
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

Welcome to our community-driven app dedicated to the conservation and study of the Giant Gippsland Earthworm (GGE). Our mission is to empower users to contribute valuable data about GGE sightings while fostering a deeper understanding and appreciation of this unique and endangered species.

## Our Vision

We envision a world where every Giant Gippsland Earthworm sighting contributes to scientific knowledge and conservation efforts. By harnessing the power of community engagement and technology, we aim to create a comprehensive database of GGE sightings to support conservation initiatives.

## Key Features

- **Location-Based Logging:** Easily log Giant Gippsland Earthworm sightings with precise location data captured automatically or manually.

- **Image Upload:** Upload photos of GGEs and their habitats to enrich sighting data and aid in identification and study.

- **Notes and Observations:** Add detailed notes and observations about each sighting, contributing valuable context and insights to GGE research.

- **Community Contribution:** Join a passionate community dedicated to the conservation of the Giant Gippsland Earthworm, sharing sightings, insights, and conservation efforts.

## Why Contribute?

Every GGE sighting matters. Your contributions help scientists, conservationists, and fellow enthusiasts better understand the habitats, behaviour, and ecological roles of the Giant Gippsland Earthworm. Together, we can make a meaningful impact on the conservation of this endangered species.

## Get Involved

Join us in our mission to document, learn about, and protect the Giant Gippsland Earthworm. Download the app today and start logging your GGE sightings to contribute to our shared knowledge and conservation efforts.
''';

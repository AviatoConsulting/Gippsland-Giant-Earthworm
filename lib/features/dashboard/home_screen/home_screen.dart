import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:giant_gipsland_earthworm_fe/core/common_widgets/custom_button.dart';
import 'package:giant_gipsland_earthworm_fe/core/common_widgets/custom_loader.dart';
import 'package:giant_gipsland_earthworm_fe/core/constants/common_assets.dart';
import 'package:giant_gipsland_earthworm_fe/core/custom_route_utills/custom_navigation.dart';
import 'package:giant_gipsland_earthworm_fe/core/theme/app_colors.dart';
import 'package:giant_gipsland_earthworm_fe/features/dashboard/controller/dashboard_controller.dart';
import 'package:giant_gipsland_earthworm_fe/features/dashboard/home_screen/controller/home_controller.dart';
import 'package:giant_gipsland_earthworm_fe/features/dashboard/home_screen/widgets/how_my_data_use_widget.dart';
import 'package:giant_gipsland_earthworm_fe/features/dashboard/home_screen/widgets/location_card.dart';
import 'package:giant_gipsland_earthworm_fe/features/dashboard/home_screen/widgets/sample_video_carousel.dart';
import 'package:giant_gipsland_earthworm_fe/features/dashboard/home_screen/widgets/screen_title_widget.dart';
import 'package:giant_gipsland_earthworm_fe/features/dashboard/worm_details/view/worm_details_screen.dart';
import 'package:giant_gipsland_earthworm_fe/route/routes_constant.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ScrollController _scrollController;
  final controller = HomeController.instance;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    final isBottom = currentScroll >= (maxScroll * 0.9);

    if (isBottom &&
        !controller.isMoreDataLoading.value &&
        controller.hasMoreData.value) {
      controller.fetchNextPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme =
        Theme.of(context).textTheme; // Get the text theme for styling

    return SingleChildScrollView(
      controller: _scrollController,
      child: Obx(() => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header section with screen title and right-side logo button
              const ScreenTitleWidget(
                title: "Home",
              ),
              const SizedBox(height: 15),

              // About Us section
              _buildCustomTextButton(
                  text: "About us",
                  onTap: () => Get.toNamed(RouteConstant.about),
                  textTheme: textTheme),
              const SizedBox(height: 15),
              _buildCustomTextButton(
                  text: "How will my data be used?",
                  onTap: () => CustomNavigationHelper.navigateTo(
                      context: context,
                      routeName: RouteConstant.howMyDataWillUse),
                  textTheme: textTheme),
              const SizedBox(height: 15),
              if (controller.homeScreenModel.value.surveys.isNotEmpty) ...[
                _buildSurveyButton(textTheme),
                const SizedBox(height: 15),
              ],

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

              const SizedBox(height: 10),

              // Title for "Recently Added Worms"
              Text(
                "Recently Added Worms",
                style: textTheme.titleMedium?.copyWith(fontSize: 20),
              ),

              // Display worms list or a message if no worms are found
              controller.obx((state) {
                final hasWorms = controller.wormList.isEmpty;

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
                                "Currently, no GGE records are available. Would you like to add one now?",
                                style: textTheme.bodyLarge,
                              ),
                            ),
                            const SizedBox(width: 30),
                            InkWell(
                              onTap: () => DashboardController
                                  .instance.currentPageIndex.value = 1,
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
                            ),
                            const SizedBox(width: 20),
                            InkWell(
                              onTap: () =>
                                  HomeController.instance.fetchWormData(),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    color: AppColor.primaryColor,
                                    borderRadius: BorderRadius.circular(8)),
                                child: const Icon(
                                  Icons.refresh,
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
                        shrinkWrap: true,

                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: controller
                            .wormList.length, // Add 1 for the loading indicator
                        itemBuilder: (context, index) {
                          // Get the worm item
                          final item = controller.wormList[index];

                          return InkWell(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () => Get.to(
                                () => WormDetailsScreen(wormDetails: item)),
                            child: LocationCard(
                                key: ValueKey(item.id),
                                coordinates: item.latLong,
                                description: item.note,
                                location:
                                    "${item.administrativeArea}, ${item.country}",
                                icon: item.locationImg),
                          );
                        },
                      );
              }, onLoading: const CustomLoader()),
              if (controller.isMoreDataLoading.value)
                const Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
            ],
          )),
    );
  }

  Widget _buildSurveyButton(TextTheme textTheme) {
    return _buildCustomTextButton(
        text: "Have you completed the GGE questionnaire?",
        onTap: () {
          if (controller.homeScreenModel.value.surveys.length > 1) {
            Get.dialog(AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(
                  color: Get.isDarkMode ? Colors.white30 : Colors.transparent,
                ),
              ),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Survey List",
                      style: textTheme.titleLarge?.copyWith(fontSize: 22)),
                  const SizedBox(height: 20),
                  ...controller.homeScreenModel.value.surveys.map((f) => Text(
                        f.title,
                        style: textTheme.titleLarge?.copyWith(
                            decoration: TextDecoration.underline,
                            decorationColor: AppColor.primaryColor,
                            color: AppColor.primaryColor),
                      )),
                  const SizedBox(height: 30),
                  CommonButton(
                    label: "Close",
                    height: 45,
                    onTap: () => Get.back(),
                  )
                ],
              ),
            ));
          } else {
            launchUrl(
                Uri.parse(controller.homeScreenModel.value.surveys.first.link));
          }
        },
        textTheme: textTheme);
  }

  Widget _buildCustomTextButton(
      {required String text,
      required Function()? onTap,
      required TextTheme textTheme}) {
    return InkWell(
      onTap: onTap, // Navigate to About Us screen
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.black26),
          ),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Flexible(
              child: Text(text,
                  style: textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.w500)),
            ),
            const Icon(Icons.arrow_forward_ios),
          ])),
    );
  }
}

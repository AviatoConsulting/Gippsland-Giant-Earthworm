import 'dart:core';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:giant_gipsland_earthworm_fe/core/common_controller/internet_check_controller.dart';
import 'package:giant_gipsland_earthworm_fe/core/common_widgets/alert_msg_dialog.dart';
import 'package:giant_gipsland_earthworm_fe/core/common_widgets/common_toast.dart';
import 'package:giant_gipsland_earthworm_fe/core/common_widgets/custom_button.dart';
import 'package:giant_gipsland_earthworm_fe/core/common_widgets/custom_loader.dart';
import 'package:giant_gipsland_earthworm_fe/core/common_widgets/custom_searchfield.dart';
import 'package:giant_gipsland_earthworm_fe/core/common_widgets/custom_textformField.dart';
import 'package:giant_gipsland_earthworm_fe/core/constants/app_image_constant.dart';
import 'package:giant_gipsland_earthworm_fe/core/constants/common_assets.dart';
import 'package:giant_gipsland_earthworm_fe/core/theme/app_colors.dart';
import 'package:giant_gipsland_earthworm_fe/core/utils/hive_service.dart';
import 'package:giant_gipsland_earthworm_fe/features/dashboard/add_worms/controller/offline_worm_controller.dart';
import 'package:giant_gipsland_earthworm_fe/features/dashboard/add_worms/location_screen.dart';
import 'package:giant_gipsland_earthworm_fe/features/dashboard/add_worms/widgets/audio_record_widget.dart';
import 'package:giant_gipsland_earthworm_fe/features/dashboard/add_worms/controller/add_worms_controller.dart';
import 'package:giant_gipsland_earthworm_fe/features/dashboard/add_worms/controller/location_controller.dart';
import 'package:giant_gipsland_earthworm_fe/features/dashboard/add_worms/widgets/offline_worms.dart';
import 'package:giant_gipsland_earthworm_fe/features/dashboard/controller/dashboard_controller.dart';
import 'package:giant_gipsland_earthworm_fe/features/dashboard/home_screen/widgets/screen_title_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';

class AddWormsScreen extends StatefulWidget {
  const AddWormsScreen({super.key});

  @override
  State<AddWormsScreen> createState() => _AddWormsScreenState();
}

class _AddWormsScreenState extends State<AddWormsScreen> {
  final controller = AddWormsController.instance;

  @override
  void initState() {
    if (OfflineWormsController.instance.wormList.isEmpty) {
      OfflineWormsController.instance.getAllOfflineWorm(showDialog: true);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ScreenTitleWidget(
            title: "Add worm sites",
            leadingChild: InkWell(
              onTap: () => Get.dialog(
                CommonAlertMessageDialog(
                  title: "Clear Worm Sites",
                  description:
                      "Are you sure you want to clear all filled worm site data? This action cannot be undone.",
                  buttonText: "Clear Data",
                  action: () {
                    controller.clearData(); // Call function to clear data
                    Get.back(); // Close dialog
                  },
                ),
              ),
              child: const Center(
                  child: Text("Clear data",
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: AppColor.primaryColor))),
            ),
          ),
          Obx(() => InternetCheckController.instance.isConnected.value == false
              ? _noInternetAvalaible()
              : const SizedBox()),
          const SizedBox(height: 10),
          Obx(() => OfflineWormsController.instance.wormList.isNotEmpty
              ? Container(
                  margin: const EdgeInsets.only(bottom: 15),
                  child: _buildCustomTextButton(
                      text:
                          "Offline Worm Sites (${OfflineWormsController.instance.wormList.length})",
                      onTap: () => Get.dialog(const OfflineWorms(),
                          barrierDismissible: false),
                      textTheme: textTheme),
                )
              : const SizedBox()),

          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                    text: "Email address ",
                    style: textTheme.bodyLarge?.copyWith(fontSize: 18)),
                TextSpan(
                    text:
                        "(If you have filled out the GGE questionnaire also, please use the same email address)",
                    style: textTheme.bodyLarge?.copyWith(fontSize: 16)),
              ],
            ),
          ),
          const SizedBox(height: 5),
          CustomTextFormField(
            hintText: "Enter your email address...",
            textFieldType: TextFieldType.email,
            controller: controller.emailController.value,
            onTap: () => HiveService().getAllWorms(),
          ),
          const SizedBox(height: 10),

          Text("Add the GPS location",
              style: textTheme.bodyLarge?.copyWith(fontSize: 20)),
          const SizedBox(height: 10),

          LocationController.instance.obx(
              (state) => Obx(() => CustomSearchTextField(
                    // Show dialog to choose location method
                    ontap: () => Get.dialog(CommonAlertMessageDialog(
                      title: "Choose Location Option",
                      description:
                          "How would you like to set your location? You can either let us detect it automatically based on your current location, or you can select it manually from map.",
                      action: () {
                        Get.back();
                        LocationController.instance.getCurrentPosition();
                      },
                      buttonText: "Fetch Current",
                      cancelText: "Select Manually",
                      showCancel:
                          InternetCheckController.instance.isConnected.value,
                      cancelAction: () async {
                        if (InternetCheckController
                                .instance.isConnected.value ==
                            false) {
                          showCommonToast(
                            context: context,
                            title: "Internet Connection Required",
                            description:
                                "Please connect to the internet and try again.",
                          );
                        } else {
                          Get.back();
                          _selectManualLocation();
                        }
                      },
                    )),
                    controller:
                        TextEditingController(text: controller.latLong.value),
                    hintText: "Add GPS location",

                    isReadOnly: true,
                    widget: Image.asset(
                      AppImagesConstant.mapIconPNG,
                      height: 25,
                      width: 25,
                    ),
                  )),
              onLoading: const CustomLoader()),

          Obx(() {
            if (AddWormsController.instance.latLong.value.isNotEmpty) {
              return FutureBuilder<String>(
                future: LocationController.instance.getLocationNameFromLatLong(
                  double.parse(
                      AddWormsController.instance.latLong.split(",")[0]),
                  double.parse(
                      AddWormsController.instance.latLong.split(",")[1]),
                ),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text(
                        "Fetching location..."); // Show loading state
                  } else if (snapshot.hasError) {
                    return const Text(
                        "Error fetching location"); // Handle error
                  } else if (snapshot.hasData) {
                    controller.selectedLocation.value = snapshot.data ?? "";
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(height: 2),
                        Text(snapshot.data ?? "Unknown Location",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.bodyLarge?.copyWith(fontSize: 14)),
                        InkWell(
                          onTap: () {
                            if (InternetCheckController
                                    .instance.isConnected.value ==
                                false) {
                              showCommonToast(
                                context: context,
                                title: "Internet Connection Required",
                                description:
                                    "Please connect to the internet and try again.",
                              );
                            } else {
                              _selectManualLocation();
                            }
                          },
                          child: Text(
                            "Not this? Select Manually",
                            style: textTheme.bodyMedium?.copyWith(
                                color: AppColor.primaryColor,
                                fontWeight: FontWeight.w400),
                          ),
                        )
                      ],
                    ); // Show location name
                  } else {
                    return const Text(
                        "Unknown Location"); // Fallback if no data
                  }
                },
              );
            } else {
              return const SizedBox();
            }
          }),
          const SizedBox(height: 10),
          // Text field for habitat description

          Text("Describe habitat",
              style: textTheme.bodyLarge?.copyWith(fontSize: 20)),
          const SizedBox(height: 2),
          CustomTextFormField(
            hintText: "Provide details about the worm's habitat...",
            maxLines: 5,
            maxLength: 200,
            textFieldType: TextFieldType.text,
            controller: controller.noteController.value,
          ),
          const SizedBox(height: 5),

          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                    text: "Upload a close-up photo of the habitat zone ",
                    style: textTheme.bodyLarge?.copyWith(fontSize: 18)),
                TextSpan(
                    text: "(including buttercups and yabby mounds if present)",
                    style: textTheme.bodyLarge?.copyWith(fontSize: 16)),
              ],
            ),
          ),
          const SizedBox(height: 10),

          Obx(() => Container(
                height: 130,
                width: double.infinity,
                decoration: CommonAssets.containerGreyDecoration(),
                child: Center(
                  child: controller.locationSelectedImage.value.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Stack(
                            children: [
                              Image.file(
                                File(controller.locationSelectedImage.value),
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                              InkWell(
                                onTap: () =>
                                    controller.locationSelectedImage.value = "",
                                child: const Center(
                                  child: Icon(
                                    Icons.delete_outlined,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      : InkWell(
                          onTap: () => CommonAssets.pickImage(
                              context: context,
                              onGalleryTap: () {
                                controller
                                    .pickLocationImg(
                                        context: context,
                                        source: ImageSource.gallery)
                                    .then((value) => Get.back());
                              },
                              onCameraTap: () {
                                controller
                                    .pickLocationImg(
                                        context: context,
                                        source: ImageSource.camera)
                                    .then((value) => Get.back());
                              }),
                          child: Image.asset(AppImagesConstant.uploadIconPNG),
                        ),
                ),
              )),
          const SizedBox(height: 20),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                    text: "Upload photo of worm habitat ",
                    style: textTheme.bodyLarge?.copyWith(fontSize: 18)),
                TextSpan(
                    text:
                        "(photo should be taken from approximately 50 meters away)",
                    style: textTheme.bodyLarge?.copyWith(fontSize: 16)),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Obx(() => Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: CommonAssets.containerGreyDecoration(),
                // Display selected worm images
                child: Wrap(
                  runSpacing: 15,
                  spacing: 15,
                  alignment: controller.wormImages.isEmpty
                      ? WrapAlignment.center
                      : WrapAlignment.start,
                  children: [
                    ...List.generate(controller.wormImages.length, (index) {
                      final element = controller.wormImages[index];
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Stack(
                          children: [
                            Image.file(
                              File(element.path),
                              height: 60,
                              width: 60,
                              fit: BoxFit.cover,
                            ),
                            // Delete button for worm images
                            Positioned(
                              top: 20,
                              left: 18,
                              child: InkWell(
                                onTap: () => controller.removeImage(index),
                                child: const Icon(
                                  Icons.delete_outlined,
                                  color: Colors.white,
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    }),
                    // Allow user to select multiple worm images

                    InkWell(
                      onTap: () => CommonAssets.pickImage(
                          context: context,
                          onGalleryTap: () {
                            controller
                                .pickImages(
                                    context: context,
                                    source: ImageSource.gallery,
                                    allowMultiple: true)
                                .then((value) => Get.back());
                          },
                          onCameraTap: () {
                            controller
                                .pickImages(
                                    context: context,
                                    source: ImageSource.camera)
                                .then((value) => Get.back());
                          }),
                      child: Image.asset(
                        AppImagesConstant.uploadIconPNG,
                        height: 60,
                        width: 60,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              )),
          const SizedBox(height: 20),
          // Audio recording widget
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                    text: "Record audio ",
                    style: textTheme.bodyLarge?.copyWith(fontSize: 18)),
                TextSpan(
                    text: "(worm gurgles)",
                    style: textTheme.bodyLarge?.copyWith(fontSize: 16)),
              ],
            ),
          ),

          const SizedBox(height: 5),
          RecordingScreen(),

          const SizedBox(height: 15),
          CommonButton(
            label: "Save",
            onTap: () {
              if (!CommonAssets.validateEmail(
                  controller.emailController.value.text.trim())) {
                showCommonToast(
                    context: context,
                    title: "Email Required",
                    description: "Please enter valid email to continue");
                return;
              }

              if (controller.latLong.value.isEmpty) {
                showCommonToast(
                  context: context,
                  title: "Location Required",
                  description: "Please Select Location and try again.",
                );
              } else if (controller.noteController.value.text.isEmpty) {
                showCommonToast(
                  context: context,
                  title: "Note Required",
                  description: "Please Enter a valid note and try again.",
                );
              } else if (controller.locationSelectedImage.value.isEmpty &&
                  controller.wormImages.isEmpty) {
                // If both images are missing
                Get.dialog(CommonAlertMessageDialog(
                  title: "Add Worm Site without images?",
                  description:
                      "You have not added a location image or a worm image. Are you sure you want to proceed without any images?",
                  action: () {
                    if (InternetCheckController.instance.isConnected.value ==
                        false) {
                      Get.back();
                      controller.addNewWorm(context: context);
                    } else {
                      Get.back();
                      _showConfirmWormLocationDialog(textTheme, context);
                    }
                  },
                  cancelAction: () {
                    Get.back();
                  },
                  cancelText: "No, Add Images",
                  buttonText: "Yes, Proceed",
                ));
              } else if (controller.locationSelectedImage.value.isEmpty) {
                // If only location image is missing
                Get.dialog(CommonAlertMessageDialog(
                  title: "Add Worm Site without location image?",
                  description:
                      "You have not added a location image. Are you sure you want to proceed without it?",
                  action: () {
                    if (InternetCheckController.instance.isConnected.value ==
                        false) {
                      Get.back();
                      controller.addNewWorm(context: context);
                    } else {
                      Get.back();
                      _showConfirmWormLocationDialog(textTheme, context);
                    }
                  },
                  cancelAction: () {
                    Get.back();
                  },
                  cancelText: "No, Add Image",
                  buttonText: "Yes, Proceed",
                ));
              } else if (controller.wormImages.isEmpty) {
                // If only worm image is missing
                Get.dialog(CommonAlertMessageDialog(
                  title: "Add Worm Site without worm image?",
                  description:
                      "You have not added a worm image. Are you sure you want to proceed without it?",
                  action: () {
                    if (InternetCheckController.instance.isConnected.value ==
                        false) {
                      Get.back();
                      controller.addNewWorm(context: context);
                    } else {
                      Get.back();
                      _showConfirmWormLocationDialog(textTheme, context);
                    }
                  },
                  cancelAction: () {
                    Get.back();
                  },
                  cancelText: "No, Add Image",
                  buttonText: "Yes, Proceed",
                ));
              } else {
                if (InternetCheckController.instance.isConnected.value ==
                    false) {
                  controller.addNewWorm(context: context);
                } else {
                  _showConfirmWormLocationDialog(textTheme, context);
                }
              }
            },
          ),
        ],
      ),
    );
  }

  void _showConfirmWormLocationDialog(
      TextTheme textTheme, BuildContext context) {
    Get.dialog(CommonAlertMessageDialog(
      title: "Confirm Worm Site Location",
      subHeadingChild: Text(
        "Location: ${controller.selectedLocation.value}",
        textAlign: TextAlign.center,
        style: textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: AppColor.primaryColor,
            fontSize: 16),
      ),
      description:
          "Confirm your location for the GGE colony. If incorrect, zoom out and adjust it on the map by clicking \n'No, Let Me Adjust'",
      action: () {
        Get.back();
        controller.addNewWorm(context: context);
        if (InternetCheckController.instance.isConnected.value == true) {
          _loadingDialog(textTheme);
        }
      },
      cancelAction: () {
        if (InternetCheckController.instance.isConnected.value == false) {
          showCommonToast(
            context: context,
            title: "Internet Connection Required",
            description: "Please connect to the internet and try again.",
          );
        } else {
          Get.back();
          _selectManualLocation();
        }
      },
      cancelText: "No, Let Me Adjust",
      buttonText: "Yes, Add Worm",
    ));
  }

  void _selectManualLocation() async {
    if (AddWormsController.instance.latLong.isEmpty) {
      await LocationController.instance.getCurrentPosition();
    }

    await Get.to(() => LocationSearchScreen(
          lat: AddWormsController.instance.latLong.isNotEmpty
              ? double.parse(AddWormsController.instance.latLong.split(",")[0])
              : 0.0,
          long: AddWormsController.instance.latLong.isNotEmpty
              ? double.parse(AddWormsController.instance.latLong.split(",")[1])
              : 0.0,
        ));
  }

  Future<dynamic> _loadingDialog(TextTheme textTheme) {
    return Get.dialog(
        barrierDismissible: false,
        AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                color: Get.isDarkMode ? Colors.white30 : Colors.transparent,
              ),
            ),
            content: controller.obx(
                (s) => Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Lottie.asset("assets/json/done.json",
                            height: 200,
                            width: 200,
                            animate: true,
                            repeat: false,
                            fit: BoxFit.cover),
                        const SizedBox(height: 5),
                        Text(
                          "Your worm site has been added successfully!",
                          textAlign: TextAlign.center,
                          style: textTheme.headlineSmall?.copyWith(
                              fontSize: 20, color: AppColor.primaryColor),
                        ),
                        const SizedBox(height: 15),
                        CommonButton(
                          label: "Go to Home",
                          backgroundColor: Colors.white,
                          borderColor: AppColor.primaryColor,
                          onTap: () {
                            DashboardController
                                .instance.currentPageIndex.value = 0;
                            Get.back();
                          },
                        ),
                        const SizedBox(height: 10),
                        CommonButton(
                          label: "Add another Worm Site",
                          onTap: () => Get.back(),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                onLoading: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Lottie.asset("assets/json/uploading.json",
                        height: 200, width: 200),
                    const SizedBox(height: 10),
                    Text(
                      "Adding Worm Site… \nUpload in progress. This may take some time. We appreciate your patience.",
                      textAlign: TextAlign.center,
                      style: textTheme.titleLarge
                          ?.copyWith(color: AppColor.primaryColor),
                    )
                  ],
                ), onError: (s) {
              Get.back();
              return const SizedBox();
            })));
  }

  Widget _noInternetAvalaible() {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Colors.red.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: const Text(
            "As you are currently out of range or offline, your worm record will be saved locally. You will be able to upload your record once you are back online.",
            style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.w400, color: Colors.red)));
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

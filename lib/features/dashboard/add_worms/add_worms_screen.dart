import 'dart:core';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:giant_gipsland_earthworm_fe/core/common_widgets/alert_msg_dialog.dart';
import 'package:giant_gipsland_earthworm_fe/core/common_widgets/common_toast.dart';
import 'package:giant_gipsland_earthworm_fe/core/common_widgets/custom_button.dart';
import 'package:giant_gipsland_earthworm_fe/core/common_widgets/custom_loader.dart';
import 'package:giant_gipsland_earthworm_fe/core/common_widgets/custom_searchfield.dart';
import 'package:giant_gipsland_earthworm_fe/core/common_widgets/custom_textformField.dart';
import 'package:giant_gipsland_earthworm_fe/core/constants/app_image_constant.dart';
import 'package:giant_gipsland_earthworm_fe/core/constants/common_assets.dart';
import 'package:giant_gipsland_earthworm_fe/features/dashboard/add_worms/location_screen.dart';
import 'package:giant_gipsland_earthworm_fe/features/dashboard/add_worms/widgets/audio_record_widget.dart';
import 'package:giant_gipsland_earthworm_fe/features/dashboard/add_worms/controller/add_worms_controller.dart';
import 'package:giant_gipsland_earthworm_fe/features/dashboard/add_worms/controller/location_controller.dart';
import 'package:giant_gipsland_earthworm_fe/features/dashboard/home_screen/widgets/screen_title_widget.dart';
import 'package:image_picker/image_picker.dart';

class AddWormsScreen extends GetView<AddWormsController> {
  const AddWormsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ScreenTitleWidget(title: "Add Worms"),
          const SizedBox(height: 15),
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
                      cancelAction: () async {
                        Get.back();
                        if (AddWormsController.instance.latLong.isEmpty) {
                          await LocationController.instance
                              .getCurrentPosition();
                        }
                        await Get.to(() => LocationSearchScreen(
                              lat:
                                  AddWormsController.instance.latLong.isNotEmpty
                                      ? double.parse(AddWormsController
                                          .instance.latLong
                                          .split(",")[0])
                                      : 0.0,
                              long:
                                  AddWormsController.instance.latLong.isNotEmpty
                                      ? double.parse(AddWormsController
                                          .instance.latLong
                                          .split(",")[1])
                                      : 0.0,
                            ));
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
          const SizedBox(height: 20),
          Text("Upload location overview",
              style: textTheme.bodyLarge?.copyWith(fontSize: 20)),
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
          Text("Upload worm habitat photos",
              style: textTheme.bodyLarge?.copyWith(fontSize: 20)),
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

          Text("Record audio (Worm gurgles)",
              style: textTheme.bodyLarge?.copyWith(fontSize: 20)),
          const SizedBox(height: 5),
          const RecordingScreen(),
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
          const SizedBox(height: 10),
          // Save button logic with validation
          controller.obx(
              (state) => CommonButton(
                  label: "Save",
                  onTap: () {
                    if (controller.latLong.value.isEmpty) {
                      showCommonToast(
                          context: context,
                          title: "Location Required",
                          description: "Please Select Location and try again.");
                    } else if (controller.locationSelectedImage.value.isEmpty) {
                      showCommonToast(
                          context: context,
                          title: "Location Image Required",
                          description:
                              "Please Select Location Image and try again.");
                    } else if (controller.wormImages.isEmpty) {
                      showCommonToast(
                          context: context,
                          title: "Worm Image Required",
                          description:
                              "Please Select Worm Image and try again.");
                    } else if (controller.noteController.value.text.isEmpty) {
                      showCommonToast(
                          context: context,
                          title: "Note Required",
                          description:
                              "Please Enter valid note and try again.");
                    } else {
                      controller.addNewWorm(context: context);
                    }
                  }),
              onLoading: const CustomLoader())
        ],
      ),
    );
  }
}

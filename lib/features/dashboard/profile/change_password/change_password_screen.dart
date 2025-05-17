import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:giant_gipsland_earthworm_fe/core/common_controller/internet_check_controller.dart';
import 'package:giant_gipsland_earthworm_fe/core/common_widgets/alert_msg_dialog.dart';
import 'package:giant_gipsland_earthworm_fe/core/common_widgets/common_toast.dart';
import 'package:giant_gipsland_earthworm_fe/core/common_widgets/custom_button.dart';
import 'package:giant_gipsland_earthworm_fe/core/common_widgets/custom_loader.dart';
import 'package:giant_gipsland_earthworm_fe/core/common_widgets/custom_textformField.dart';
import 'package:giant_gipsland_earthworm_fe/core/constants/app_constants.dart';
import 'package:giant_gipsland_earthworm_fe/core/constants/app_image_constant.dart';
import 'package:giant_gipsland_earthworm_fe/features/dashboard/profile/change_password/controller/change_password_controller.dart';

class ChangePassword extends GetView<ChangePasswordController> {
  const ChangePassword({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      body: Padding(
        padding: AppConstants.screenPadding(context: context),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    InkWell(
                      onTap: () => Get.back(),
                      child: const Icon(
                        Icons.arrow_back_ios,
                        size: 25,
                        color: Colors.black,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      "Change Password",
                      style: textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w500),
                    ),
                    const Spacer()
                  ],
                ),
                const SizedBox(height: 30),
                Text("Password", style: textTheme.bodyLarge),
                CustomTextFormField(
                  hintText: "*******",
                  textFieldType: TextFieldType.password,
                  textInputAction: TextInputAction.next,
                  controller: controller.passwordController.value,
                ),
                const SizedBox(height: 10),
                Text("Confirm Password", style: textTheme.bodyLarge),
                CustomTextFormField(
                  hintText: "*******",
                  textFieldType: TextFieldType.password,
                  textInputAction: TextInputAction.done,
                  controller: controller.confirmPasswordController.value,
                ),
                const SizedBox(height: 20),
                controller.obx(
                    (state) => CommonButton(
                          label: "Change Password",
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
                            } else if (formKey.currentState!.validate()) {
                              if (controller.passwordController.value.text ==
                                  controller
                                      .confirmPasswordController.value.text) {
                                Get.dialog(CommonAlertMessageDialog(
                                  title:
                                      "Are you sure you want to change your password??",
                                  description:
                                      "This action cannot be undone. You will need to log in again to proceed.",
                                  icon: AppImagesConstant.warningIconPNG,
                                  buttonText: "Change Password",
                                  action: () {
                                    Get.back();
                                    controller.changePassword(
                                        newPassword: controller
                                            .confirmPasswordController
                                            .value
                                            .text
                                            .trim(),
                                        context: context);
                                  },
                                ));
                              } else {
                                showCommonToast(
                                    context: context,
                                    title: "Password Not Matched",
                                    description:
                                        "Password and Confirm Password are not match, check and try again.");
                              }
                            }
                          },
                        ),
                    onLoading: const CustomLoader())
              ],
            ),
          ),
        ),
      ),
    );
  }
}

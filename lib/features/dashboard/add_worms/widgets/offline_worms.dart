import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:giant_gipsland_earthworm_fe/core/common_controller/internet_check_controller.dart';
import 'package:giant_gipsland_earthworm_fe/core/common_widgets/common_toast.dart';
import 'package:giant_gipsland_earthworm_fe/core/theme/app_colors.dart';
import 'package:giant_gipsland_earthworm_fe/features/dashboard/add_worms/controller/offline_worm_controller.dart';

// Widget class using GetX for state management
class OfflineWorms extends GetView<OfflineWormsController> {
  const OfflineWorms({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize the controller
    final controller = Get.put(OfflineWormsController());
    final textTheme = Theme.of(context).textTheme;

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Get.isDarkMode ? Colors.white30 : Colors.transparent,
        ),
      ),
      insetPadding: const EdgeInsets.all(24),
      content: SizedBox(
        width: MediaQuery.of(context).size.width,
        // height: MediaQuery.of(context).size.height * 0.8,
        child: Obx(() => ListView(
              shrinkWrap: true,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Offline Worm Sites",
                            style: textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w500, fontSize: 20)),
                        InkWell(
                          onTap: () => Get.back(),
                          child: const Icon(
                            Icons.close,
                            color: Colors.black,
                            size: 22,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 15),
                    ...controller.wormList.map((worm) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: ListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          tileColor: const Color(0XFFF2F4F5),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 0),
                          title: Text(
                            worm.latLong,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
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
                              Get.back();
                              controller.onWormSelected(worm);
                            }
                          },
                          trailing: Text(
                            "Add Now",
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(color: AppColor.primaryColor),
                          ),
                        ),
                      );
                    }),
                    // InkWell(
                    //   onTap: () => Get.dialog(CommonAlertMessageDialog(
                    //     icon: "assets/icons/warning.png",
                    //     title: "Confirm Deletion",
                    //     description:
                    //         "Are you sure you want to delete all saved worm sites? This action cannot be undone.",
                    //     action: () async {
                    //       HiveService().deleteAllWorms(controller.wormList);
                    //       controller.wormList.clear();
                    //       Get.back();
                    //       Get.back();
                    //     },
                    //     buttonText: "Delete All",
                    //   )),
                    //   child: Text(
                    //     "To clear all offline saved worm sites, click here.",
                    //     style: textTheme.bodyLarge?.copyWith(
                    //         fontSize: 16,
                    //         fontWeight: FontWeight.w500,
                    //         color: AppColor.primaryColor,
                    //         decoration: TextDecoration.underline,
                    //         decorationColor: AppColor.primaryColor,
                    //         fontStyle: FontStyle.italic),
                    //   ),
                    // )
                  ],
                ),
              ],
            )),
      ),
    );
  }
}

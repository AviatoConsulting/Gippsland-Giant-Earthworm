import 'package:flutter/material.dart';
import 'package:giant_gipsland_earthworm_fe/core/constants/app_image_constant.dart';
import 'package:giant_gipsland_earthworm_fe/core/constants/common_assets.dart';
import 'package:giant_gipsland_earthworm_fe/core/theme/app_colors.dart';

class SampleVideoWidget extends StatelessWidget {
  final String img;
  final String text;
  final double? size;
  final double? height;
  final double? width;
  const SampleVideoWidget(
      {super.key,
      required this.img,
      required this.text,
      this.size,
      this.height = 180,
      this.width = 160});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: CommonAssets.containerDecorationwithShadow(context: context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16), topRight: Radius.circular(16)),
            child: Stack(
              alignment: Alignment.center,
              children: [
                CommonAssets.getGCSNetworkImage(
                  img,
                  defaultImage: AppImagesConstant.appLogo,
                  width: size ?? 160,
                  height: 120,
                  fit: BoxFit.cover,
                ),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                      color: Colors.grey.shade200, shape: BoxShape.circle),
                  child: const Icon(
                    Icons.play_arrow,
                    size: 20,
                    color: AppColor.primaryColor,
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              text,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context)
                  .textTheme
                  .labelMedium
                  ?.copyWith(fontSize: 14, fontWeight: FontWeight.w400),
            ),
          ),
        ],
      ),
    );
  }
}

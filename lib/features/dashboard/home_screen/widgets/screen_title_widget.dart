import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:giant_gipsland_earthworm_fe/core/constants/app_image_constant.dart';

class ScreenTitleWidget extends StatelessWidget {
  final String title;
  final bool isBack;
  final Widget? leadingChild;
  const ScreenTitleWidget(
      {super.key, required this.title, this.isBack = false, this.leadingChild});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SizedBox(
      height: 55,
      child: Stack(
        children: [
          Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: isBack
                  ? InkWell(
                      onTap: () => Get.back(),
                      child: const Center(
                        child: Icon(
                          Icons.arrow_back_ios,
                          size: 25,
                        ),
                      ),
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(80),
                      child: Image.asset(
                        AppImagesConstant.ggeCensusPNG,
                        height: 50,
                        width: 50,
                        fit: BoxFit.cover,
                      ))),
          Positioned(
            top: 0,
            bottom: 0,
            right: 0,
            left: 0,
            child: Center(
              child: Text(
                title,
                style: textTheme.headlineSmall
                    ?.copyWith(fontWeight: FontWeight.w500),
              ),
            ),
          ),
          if (leadingChild != null)
            Positioned(
              top: 0,
              bottom: 0,
              right: 0,
              child: leadingChild!,
            ),
        ],
      ),
    );
  }
}

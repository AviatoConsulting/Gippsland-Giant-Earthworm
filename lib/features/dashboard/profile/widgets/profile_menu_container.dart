import 'package:flutter/material.dart';
import 'package:giant_gipsland_earthworm_fe/core/constants/common_assets.dart';

class ProfileMenuContainer extends StatelessWidget {
  final String text;
  final Function()? ontap;
  const ProfileMenuContainer({super.key, required this.text, this.ontap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ontap,
      child: Container(
        decoration: CommonAssets.containerGreyDecoration(),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 20,
            )
          ],
        ),
      ),
    );
  }
}

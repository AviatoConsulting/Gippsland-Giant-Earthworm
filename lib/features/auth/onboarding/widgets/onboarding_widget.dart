import 'package:flutter/material.dart';
import 'package:giant_gipsland_earthworm_fe/features/auth/onboarding/model/onboarding_model.dart';

class OnboardingWidget extends StatelessWidget {
  final OnboardingModel onboardingModel;
  const OnboardingWidget({super.key, required this.onboardingModel});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate screen size based on constraints
        final screenHeight = constraints.maxHeight;
        final screenWidth = constraints.maxWidth;

        // Adjust sizes based on screen height and width for responsiveness
        final img1Size = screenHeight * 0.26;
        final img2Size = screenHeight * 0.2;
        final img3Size = screenHeight * 0.2;
        final double titleFontSize =
            screenHeight < 600 ? 20 : 24; // Adjust for small screens
        final double descFontSize =
            screenHeight < 600 ? 14 : 16; // Smaller font for small screens

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Positioned(
                    top: screenHeight *
                        0.1, // Adjust position based on screen height
                    left: screenWidth * 0.06, // Adjust based on screen width
                    child: Image.asset(
                      onboardingModel.img1,
                      height: img1Size,
                      width: img1Size,
                    ),
                  ),
                  Positioned(
                    top: screenHeight * 0.2,
                    right: screenWidth * 0.04,
                    child: Image.asset(
                      onboardingModel.img2,
                      height: img2Size,
                      width: img2Size,
                    ),
                  ),
                  Positioned(
                    top: screenHeight * 0.36,
                    right: screenWidth * 0.32,
                    child: Image.asset(
                      onboardingModel.img3,
                      height: img3Size,
                      width: img3Size,
                    ),
                  ),
                  Positioned(
                    bottom: screenHeight * 0.05,
                    left: 20,
                    right: 20,
                    child: Column(
                      children: [
                        Text(
                          onboardingModel.title,
                          textAlign: TextAlign.center,
                          style: textTheme.headlineLarge?.copyWith(
                            fontSize: titleFontSize,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          onboardingModel.description,
                          textAlign: TextAlign.center,
                          style: textTheme.bodyLarge?.copyWith(
                              fontSize: descFontSize,
                              fontWeight: FontWeight.w300,
                              wordSpacing: 1,
                              height: 1.4,
                              letterSpacing: 0.2),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

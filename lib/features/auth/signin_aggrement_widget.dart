import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:giant_gipsland_earthworm_fe/core/constants/common_assets.dart';
import 'package:giant_gipsland_earthworm_fe/core/theme/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';

class SignInAgreementText extends StatelessWidget {
  final bool isSignup;
  const SignInAgreementText({
    super.key,
    this.isSignup = false,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: textTheme.bodySmall,
        children: [
          TextSpan(
              text: isSignup
                  ? "By creating an account, you agree to our "
                  : 'By signing in, you agree to our '),
          TextSpan(
            text: 'Terms and Conditions',
            style: textTheme.bodySmall?.copyWith(color: AppColor.primaryColor),
            recognizer: TapGestureRecognizer()
              ..onTap =
                  () => launchUrl(Uri.parse(CommonAssets.termsAndConditionUrl)),
          ),
          const TextSpan(text: ' and '),
          TextSpan(
            text: 'Privacy Policy',
            style: textTheme.bodySmall?.copyWith(color: AppColor.primaryColor),
            recognizer: TapGestureRecognizer()
              ..onTap =
                  () => launchUrl(Uri.parse(CommonAssets.privacyPolicyUrl)),
          ),
        ],
      ),
    );
  }
}

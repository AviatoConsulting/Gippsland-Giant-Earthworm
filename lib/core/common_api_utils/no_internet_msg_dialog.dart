import 'package:flutter/material.dart';

import 'spacing_widgets.dart';

class NoInternetMsgDialog extends StatelessWidget {
  const NoInternetMsgDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0.0,
      insetPadding: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const VSpace(8),
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.signal_wifi_connected_no_internet_4_outlined,
                  size: 70,
                ),
                const VSpace(16),
                Text("Internet Not Found",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineLarge),
                const VSpace(16),
                Text("Please check your Internet Connection",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge),
              ],
            ),
            /*const VSpace(25),
            AppTextButton(text: "Retry",onTap: (){
            },),*/
            const VSpace(8),
          ],
        ),
      ),
    );
  }
}

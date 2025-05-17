import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:giant_gipsland_earthworm_fe/core/constants/common_assets.dart';
import 'package:giant_gipsland_earthworm_fe/core/theme/app_colors.dart';
import 'package:giant_gipsland_earthworm_fe/features/dashboard/add_worms/controller/audio_recording_controller.dart';
import 'package:giant_gipsland_earthworm_fe/features/dashboard/add_worms/widgets/recording_waves.dart';

class RecordingScreen extends StatelessWidget {
  final RecordingController controller = Get.put(RecordingController());

  RecordingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Align(
          alignment: Alignment.topRight,
          child: InkWell(
            onTap: () => controller.selectAudioFromFile(context: context),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.add, color: AppColor.primaryColor, size: 22),
                const SizedBox(width: 4),
                Text(
                  "Upload Recording",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          decoration: CommonAssets.containerGreyDecoration(),
          padding: const EdgeInsets.all(12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Recording button
              Obx(() {
                return InkWell(
                  onTap: () {
                    if ((controller.audioPath.value != null &&
                        !controller.isRecording.value)) {
                      controller.deleteRecording();
                    } else {
                      controller.toggleRecording(context);
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColor.primaryColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: controller.audioPath.value != null &&
                            !controller.isRecording.value
                        ? const Icon(Icons.delete, color: Colors.black54)
                        : controller.isRecording.value
                            ? const Icon(Icons.stop_circle,
                                color: Colors.black54)
                            : const Icon(Icons.mic, color: Colors.black54),
                  ),
                );
              }),
              const SizedBox(width: 20),
              Obx(() {
                return controller.isRecording.value ||
                        controller.isPlaying.value
                    ? const CustomRecordingWaveWidget()
                    : const CustomStaticWaves();
              }),
              const Spacer(),
              Obx(() {
                return controller.audioPath.value != null
                    ? InkWell(
                        onTap: () {
                          if (controller.isPlaying.value) {
                            controller.stopPlaying();
                          } else {
                            controller.playRecording(context);
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColor.primaryColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.all(8),
                          child: Icon(
                            controller.isPlaying.value
                                ? Icons.pause
                                : Icons.play_arrow,
                            color: Colors.black54,
                          ),
                        ),
                      )
                    : const SizedBox();
              }),
            ],
          ),
        ),
      ],
    );
  }
}

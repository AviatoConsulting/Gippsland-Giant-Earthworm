import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:giant_gipsland_earthworm_fe/core/common_controller/internet_check_controller.dart';
import 'package:giant_gipsland_earthworm_fe/features/dashboard/home_screen/widgets/video_player_online_widget.dart';

class SampleVideoCarousel extends StatefulWidget {
  final List<String> videoUrls; // List of video URLs
  final List<String> text; // List of video captions

  const SampleVideoCarousel({
    super.key,
    required this.videoUrls,
    required this.text,
  });

  @override
  State<SampleVideoCarousel> createState() => _SampleVideoCarouselState();
}

class _SampleVideoCarouselState extends State<SampleVideoCarousel> {
  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
          children: [
            if (InternetCheckController.instance.isConnected.value == false)
              _buildCustomTextButton(
                text: "Video can be viewed when you are online.",
                textTheme: Theme.of(context).textTheme,
              )
            else
              ListView.builder(
                padding: EdgeInsets.zero, // Remove all padding around the list
                physics:
                    const NeverScrollableScrollPhysics(), // Prevent internal scrolling
                itemCount: widget.videoUrls.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 0), // Only vertical padding for spacing
                    child: Container(
                      key: ValueKey(widget.videoUrls[index]),
                      height: 240, // Fixed height for each video container
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.black26),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                            ),
                            child: SizedBox(
                              width:
                                  double.infinity, // Full width for the video
                              height: 190,
                              child: VideoPlayerOnlineWidget(
                                videoUrl: widget.videoUrls[index],
                              ),
                            ),
                          ),
                          const Spacer(),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              widget.text[index],
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium
                                  ?.copyWith(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                  ),
                            ),
                          ),
                          const Spacer(),
                        ],
                      ),
                    ),
                  );
                },
              ),
          ],
        ));
  }

  Widget _buildCustomTextButton(
      {required String text, required TextTheme textTheme}) {
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black26),
        ),
        child: Text(text,
            style:
                textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500)));
  }
}

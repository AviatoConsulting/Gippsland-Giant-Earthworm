import 'package:flutter/material.dart';
import 'package:giant_gipsland_earthworm_fe/features/dashboard/home_screen/widgets/video_player_online_widget.dart';

class SampleVideoCarousel extends StatefulWidget {
  final List<String> videoUrls; // List of video URLs
  final List<String> text; // List of video URLs

  const SampleVideoCarousel({
    super.key,
    required this.videoUrls,
    required this.text,
  });

  @override
  State<SampleVideoCarousel> createState() => _SampleVideoCarouselState();
}

class _SampleVideoCarouselState extends State<SampleVideoCarousel> {
  PageController pageController = PageController();

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListView.builder(
          padding: EdgeInsets.zero,
          physics:
              const NeverScrollableScrollPhysics(), // Disable scroll if not needed, or remove this for vertical scroll
          itemCount: widget.videoUrls.length, shrinkWrap: true,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: 8.0), // Add some spacing between the items
              child: Container(
                height: 240, // Fixed height for each video container
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.black26)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                      child: SizedBox(
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
                                fontSize: 16, fontWeight: FontWeight.w400),
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            );
          },
        )
      ],
    );
  }
}

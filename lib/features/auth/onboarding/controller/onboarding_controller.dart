import 'package:get/get.dart';
import 'package:giant_gipsland_earthworm_fe/core/constants/app_image_constant.dart';
import 'package:giant_gipsland_earthworm_fe/features/auth/onboarding/model/onboarding_model.dart';

class OnboardingController extends GetxController with StateMixin {
  static OnboardingController get instance => Get.find();

  RxInt currentPage = 0.obs;

  //====================== Onboarding List Content =======================
  RxList<OnboardingModel> listOfScreenContent = <OnboardingModel>[
    OnboardingModel(
      img1: AppImagesConstant.onboarding1PNG,
      img2: AppImagesConstant.onboarding2PNG,
      img3: AppImagesConstant.onboarding3PNG,
      title: "About the Giant Gippsland Earthworm (GGE)",
      description:
          "The GGE is one of the world’s largest earthworms, they can grow up to 2 metres long! They are only found in South and West Gippsland and spend their entire lives underground. They are often heard making gurgling sounds as they travel in their burrows, which are usually near a creek or on south or west facing slopes, or near the base of landslips.",
    ),
    OnboardingModel(
      img1: AppImagesConstant.onboarding4PNG,
      img2: AppImagesConstant.onboarding5PNG,
      img3: AppImagesConstant.onboarding6PNG,
      title: "Why report GGE’s on your property via this app? ",
      description:
          "The Giant Gippsland Earthworm is a threatened species, and its survival is dependent on the protection and appropriate management of their habitat. As most GGE’s occur on private property, we need everyone’s help to find out where they live.",
    ),
    OnboardingModel(
        img1: AppImagesConstant.onboarding7PNG,
        img2: AppImagesConstant.onboarding8PNG,
        img3: AppImagesConstant.onboarding9PNG,
        title:
            "Help us work out where the Giant Gippsland Earthworms are found!",
        description:
            "Landcare, scientists and conservationists are doing a census of the GGE to find out where they occur. This information will be used to develop programs to protect GGE’s to ensure their long-term survival. By using this app you can join in!"),
  ].obs;
}

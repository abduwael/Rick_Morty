import 'package:get/get.dart';

import '../../../data/models/character_model.dart';

class CharacterDetailsController extends GetxController {
  Rx<Results?> charDetails = Rx<Results?>(null);
  @override
  void onInit() {
    super.onInit();
    initArguments();
  }

  void initArguments() {
    if (Get.arguments['character'] == null) return;
    charDetails.value = Get.arguments['character'] as Results?;
  }
}

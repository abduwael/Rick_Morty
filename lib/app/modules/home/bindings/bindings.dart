import 'package:get/get.dart';

import '../../../data/proviedr/character_provider.dart';
import '../controller/controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(CharacterProvider());
    Get.put(HomeController());
  }
}

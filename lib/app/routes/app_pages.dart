import 'package:get/get_navigation/src/routes/get_route.dart';

import '../modules/character_details/bindings/character_details_binding.dart';
import '../modules/character_details/views/character_details_view.dart';
import '../modules/home/bindings/bindings.dart';
import '../modules/home/view/home_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;
  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.CHARACTER_DETAILS,
      page: () => const CharacterDetailsView(),
      binding: CharacterDetailsBinding(),
    ),
  ];
}

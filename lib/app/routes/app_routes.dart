part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const HOME = _Paths.HOME;
  static const CHARACTER_DETAILS = _Paths.CHARACTER_DETAILS;
}

abstract class _Paths {
  _Paths._();

  static const HOME = '/home';
  static const CHARACTER_DETAILS = '/character-details';
}

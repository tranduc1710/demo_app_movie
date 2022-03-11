import 'package:demo_app_movie/base/base.dart';

class Constant {
  static const vi = Locale("vi");
  static const en = Locale("en");
  static Locale _locale = vi;
  static Locale get locale => _locale;
  static set locale(Locale locale) {
    _locale = locale;
    Get.forceAppUpdate();
    BSharedPreferences.setString(ConfigSP.keyLanguage, locale.languageCode);
  }

  static const timeAnimationShort = Duration(milliseconds: 300);
  static const timeAnimationLong = Duration(milliseconds: 700);
  static const timeRequest = Duration(seconds: 20);
  static const brButtonAndTF = 22.5;

  static const sTitle = TextStyle(
    fontSize: 20,
    color: Colors.black54,
    fontWeight: FontWeight.bold,
  );
}

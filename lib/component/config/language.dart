import '../constant.dart';

class Language {
  //dòng này để copy mới cho nhanh
  get _ => _language(
        vi: "",
        en: "",
      );
}

String _language({required String vi, required String en}) {
  switch (Constant.locale.languageCode) {
    case "vi":
      return vi;
    case "en":
      return en;
    default:
      return "";
  }
}

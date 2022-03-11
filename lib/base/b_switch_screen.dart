import 'base.dart';

class BSwitchScreen {
  static Future<O> push<O>(dynamic page) async => await Get.to(
        page,
        duration: Constant.timeAnimationShort,
        curve: Curves.easeInOut,
        transition: Transition.rightToLeftWithFade,
      );

  static Future<O> pushName<O>(
    String page, {
    dynamic arguments,
    int? id,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
  }) async =>
      await Get.toNamed(
        page,
        arguments: arguments,
        id: id,
        parameters: parameters,
        preventDuplicates: preventDuplicates,
      );

  static Future<O> pushAndRemove<O>(dynamic page) async => await Get.off(
        page,
        duration: Constant.timeAnimationShort,
        curve: Curves.easeInOut,
        transition: Transition.rightToLeftWithFade,
      );

  static Future<O> pushNameAndRemove<O>(
    String page, {
    dynamic arguments,
    int? id,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
  }) async =>
      await Get.offNamed(
        page,
        arguments: arguments,
        id: id,
        parameters: parameters,
        preventDuplicates: preventDuplicates,
      );

  static Future<O> pushAndRemoveAll<O>(dynamic page) async => await Get.offAll(
        page,
        duration: Constant.timeAnimationShort,
        curve: Curves.easeInOut,
        transition: Transition.rightToLeftWithFade,
      );

  static Future<O> pushNameAndRemoveAll<O>(
    String page, {
    bool Function(Route<dynamic>)? predicate,
    dynamic arguments,
    int? id,
    Map<String, String>? parameters,
  }) async =>
      await Get.offAllNamed(
        page,
        arguments: arguments,
        id: id,
        parameters: parameters,
        predicate: predicate,
      );

  static void backMultiScreen<T>(String page, {T? result, bool closeOverlays = true, bool canPop = true, int? id}) {
    while (Get.currentRoute != page && Get.currentRoute.isNotEmpty) {
      Get.back(canPop: canPop, closeOverlays: closeOverlays, result: result, id: id);
    }
  }
}

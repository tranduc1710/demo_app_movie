import '../base.dart';

abstract class BBloc<S extends BScreen, R extends BRequestApi> extends GetxController {
  late BuildContext context;
  R? request;
  late S screen;
  bool isCloseScreen = true;
  @protected
  dynamic arguments = "";

  @override
  void onInit() {
    super.onInit();
    context = Get.context!;
    if (ModalRoute.of(context) != null) arguments = ModalRoute.of(context)!.settings.arguments;
    isCloseScreen = false;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void onClose() {
    if (request != null) request!.close();
    isCloseScreen = true;
    super.onClose();
  }

  void back({
    bool closeOverlays: false,
    var result,
  }) =>
      isCloseScreen
          ? null
          : Get.back(
              closeOverlays: closeOverlays,
              result: result,
            );

  void sendError(dynamic error, [StackTrace? stackTrace, FlutterErrorDetails? errorDetails]) {
    printError(info: error.toString());
  }
}

import 'dart:async';

import 'package:widget_loading/widget_loading.dart';

import 'base.dart';

class BDialog {
  final Future Function()? action;
  static final Lock _lock = Lock();

  BDialog([this.action]);

  Future loading([String? content, bool tapCancel = false]) async {
    return _lock.synchronized(() async => await _loading(content, tapCancel));
  }

  Future _loading(String? content, bool tapCancel) async {
    var value;
    Get.dialog(
      WillPopScope(
        onWillPop: () async => tapCancel,
        child: Center(
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularWidgetLoading(
                  dotColor: Colors.orangeAccent,
                  dotCount: 8,
                  rollingFactor: 0.8,
                  loading: true,
                  dotBuilder: (_) => Container(
                    width: 15,
                    height: 15,
                    decoration: BoxDecoration(
                      color: themeData.primaryColor,
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  loadingDuration: Duration(seconds: 3),
                  appearingDuration: Duration(milliseconds: 100),
                  sizeDuration: Duration(milliseconds: 100),
                  child: SizedBox(
                    height: 100,
                    width: 150,
                  ),
                ),
                AutoSizeText(
                  content ?? "Đang lấy dữ liệu",
                  minFontSize: 14,
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );

    try {
      if (this.action != null) value = await this.action!();
    } catch (e, s) {
      printError(info: e.toString());
      printError(info: s.toString());
    }

    Get.back();

    return value;
  }

  void alert(String? title, String? content) async {
    return _lock.synchronized(() async => await _alert(title, content));
  }

  Future<void> _alert(String? title, String? content) async {
    await Get.dialog(
      Center(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 100,
            vertical: 100,
          ),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 30,
                vertical: 30,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AutoSizeText(
                    title ?? "Thông báo",
                    minFontSize: 16,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 40),
                  AutoSizeText(
                    content ?? "",
                    minFontSize: 14,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 40),
                  BButtonAnimation(
                    width: 100,
                    height: 40,
                    onTap: () => Get.back(),
                    child: AutoSizeText(
                      "Đóng",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      minFontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> ask(String? title, {String? agree, String? disagree}) async {
    return _lock.synchronized(() async => await _ask(title, agree: agree, disagree: disagree));
  }

  Future<bool> _ask(String? title, {String? agree, String? disagree}) async {
    var value = await Get.dialog(
      Center(
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: sWValue(.08),
              vertical: sWValue(.04),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AutoSizeText(
                  title ?? "Thông báo",
                  minFontSize: 16,
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: sWValue(.05)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    BButtonAnimation(
                      onTap: () => Get.back(result: false),
                      backgroundColor: themeData.disabledColor,
                      width: 100,
                      child: AutoSizeText(
                        disagree ?? "Từ chối",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        minFontSize: 14,
                      ),
                    ),
                    SizedBox(width: sWValue(.02)),
                    BButtonAnimation(
                      onTap: () => Get.back(result: true),
                      width: 100,
                      child: AutoSizeText(
                        agree ?? "Đồng ý",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        minFontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );

    if (value == null) return false;

    return value;
  }

  Future comboBox({
    String? title,
  }) async {
    return await _lock.synchronized(() async => await _comboBox(title));
  }

  Future _comboBox(String? title) async {
    GlobalKey keyTF = GlobalKey();
    GlobalKey keyLayout = GlobalKey();
    StreamController stream = StreamController.broadcast();
    bool onDialog = true;

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      do {
        await .1.delay();
        if (keyTF.currentContext != null && keyTF.currentContext!.findRenderObject() != null) {
          if (!stream.isClosed) stream.sink.add(true);
        }
      } while (Get.context!.mediaQueryViewInsets.bottom != 0 && onDialog);
    });

    await Get.dialog(Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () => Get.back(),
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Center(
                  child: Container(
                    key: keyLayout,
                    padding: EdgeInsets.symmetric(
                      vertical: sWValue(.03),
                      horizontal: sWValue(.04),
                    ),
                    margin: EdgeInsets.symmetric(
                      horizontal: sWValue(.12),
                      vertical: sWValue(.2),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AutoSizeText(
                          title ?? "",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                          minFontSize: 14,
                          textAlign: TextAlign.center,
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: sWValue(.03),
                            bottom: sWValue(.015),
                          ),
                          child: AutoSizeText(
                            "Chọn",
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        Container(
                          key: keyTF,
                          height: sWValue(.12),
                          width: double.infinity,
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: sWValue(.06)),
                          child: BButton(
                            "Chọn",
                            backgroundColor: themeData.primaryColor,
                            colorText: Colors.white,
                            width: sWValue(.2),
                            height: sHValue(.1),
                            onTap: () async {},
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                StreamBuilder(
                    stream: stream.stream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        RenderBox renderBox = (keyTF.currentContext!.findRenderObject() as RenderBox);
                        Offset offset = renderBox.localToGlobal(Offset.zero);
                        Offset offsetLayout = (keyLayout.currentContext!.findRenderObject() as RenderBox).localToGlobal(Offset.zero);
                        Size size = renderBox.size;
                        return Positioned(
                          top: offset.dy - offsetLayout.dy,
                          child: Container(
                            color: Colors.transparent,
                            constraints: BoxConstraints(
                              maxHeight: sWValue(.5),
                              maxWidth: size.width,
                            ),
                            child: AutoSizeText("nnnnnn"),
                          ),
                        );
                      } else
                        return SizedBox();
                    }),
              ],
            ),
          ),
        ],
      ),
    ));
    onDialog = false;
    stream.close();
  }
}

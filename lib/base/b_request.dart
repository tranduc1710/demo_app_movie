import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:dio/dio.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/foundation.dart';

import 'base.dart';

int _countToast401 = 0;

class BRequest {
  final Dio _dio = Dio();
  final CancelToken _cancelToken = CancelToken();
  late RxInt _progress;

  String e001 = "Lỗi mạng";
  String e002 = "Hết thời gian kết nối";
  String e003 = "Lỗi lấy dữ liệu";
  String e004 = "Lỗi hệ thống";
  String e005 = "Tải lên thất bại";

  void closeRequest() {
    if (kDebugMode) print("CANCEL REQUEST");
    if (!_cancelToken.isCancelled) _cancelToken.cancel();
    _dio.clear();
    _dio.close();
  }

  Future<void> get(
    String url, {
    Map<String, String>? headers,
    Duration? timeout,
    bool toast: true,
    CancelToken? cancelToken,
    Future<void> success(var res)?,
    Function(String error)? error,
  }) async {
    try {
      if (headers == null) headers = {};
      if (success == null) success = (_) async => null;
      if (error == null) error = (_) => null;

      if (!headers.containsKey('Content-Type')) headers.addAll({"Content-Type": "application/json;charset=utf-8"});

      _dio.options.headers = headers;

      if (kDebugMode)
        print("REQUEST GET:"
            "\n- Url: $url"
            "\n- Header: ${_dio.options.headers}");

      var res = await _dio
          .get(
        url,
        cancelToken: cancelToken ?? _cancelToken,
      )
          .timeout(
        timeout ?? Constant.timeRequest,
        onTimeout: () {
          closeRequest();
          _onTimeout(toast, error!);
          printError(info: "Time out");
          return dio.Response(requestOptions: RequestOptions(path: ''));
        },
      );

      if (kDebugMode) print("RESPONSE ${res.statusCode}: ${res.data}");

      Map<String, dynamic> json = {};

      if (res.data is String)
        json = jsonDecode(res.data);
      else
        json = res.data;

      if (res.statusCode! >= 200 && res.statusCode! < 300) {
        try {
          await success(json);
        } catch (e, s) {
          printError(info: e.toString());
          printError(info: s.toString());
          BDialog().alert(null, json['data']);
        }
      } else if (res.statusCode == 401)
        _onLoginExpires(toast, error);
      else
        BDialog().alert("Lỗi", json['data']);
    } catch (e, s) {
      closeRequest();
      _catchError(e, s, toast, error!);
    }
  }

  Future post(
    String url, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    Duration? timeout,
    bool toast: true,
    CancelToken? cancelToken,
    Future<void> success(dynamic res)?,
    Function(String error)? error,
  }) async {
    if (headers == null) headers = {};
    if (success == null) success = (_) async => null;
    if (error == null) error = (_) => null;

    if (!headers.containsKey('Content-Type')) headers.addAll({"Content-Type": "application/json;charset=utf-8"});

    _dio.options.headers = headers;

    if (kDebugMode)
      print("REQUEST POST:"
          "\n- Url: $url"
          "\n- Header: $headers"
          "\n- Body: $body");

    try {
      var res = await _dio
          .post(
        url,
        data: body,
        cancelToken: cancelToken ?? _cancelToken,
      )
          .timeout(
        timeout ?? Constant.timeRequest,
        onTimeout: () {
          _onTimeout(toast, error!);
          printError(info: "Time out");
          return dio.Response(requestOptions: RequestOptions(path: ''));
        },
      );

      if (kDebugMode) print("RESPONSE ${res.statusCode}: ${res.data}");

      Map<String, dynamic> json = {};

      if (res.data is String)
        json = jsonDecode(res.data);
      else
        json = res.data;

      if (res.statusCode! >= 200 && res.statusCode! < 300) {
        try {
          await success(json);
        } catch (e) {
          BDialog().alert(null, json['data']);
        }
      } else if (res.statusCode == 401)
        _onLoginExpires(toast, error);
      else
        BDialog().alert("Lỗi", json['data']);
    } catch (e, s) {
      closeRequest();
      _catchError(e, s, toast, error);
    }
  }

  Future<void> multipart(
    String url, {
    Map<String, String>? headers,
    @required Map<String, dynamic>? formData,
    TypeShowUpload? typeShowUpload,
    void Function(int progress)? onSendProgress,
    void Function(dynamic res)? success,
    void Function(String error)? error,
    int timeOut: 60,
  }) async {
    final form = dio.FormData.fromMap(formData!);
    bool isTimeOut = false;
    bool isCancel = false;

    if (headers != null) _dio.options.headers = headers;

    if (success == null) success = (_) => null;
    if (error == null) error = (_) => null;

    if (kDebugMode)
      print("request Multipart:"
          "\n - Url: $url"
          "\n - Header: ${_dio.options.headers}"
          "\n - FormData: $formData");

    switch (typeShowUpload) {
      case TypeShowUpload.dialog:
        _progress = 0.obs;

        Get.dialog(_layoutDialog()).then(
          (value) {
            if (_progress.value < 100) {
              closeRequest();
              BToast.show("Huỷ tải lên");
            }
          },
        );
        break;
      default:
        break;
    }

    dio.Response res = await _dio.post(
      url,
      data: form,
      cancelToken: _cancelToken,
      onSendProgress: (count, total) {
        int progress = ((count / total) * 100).toInt();
        int lastProgress = progress > 100
            ? 100
            : progress < 0
                ? 0
                : progress;
        if (onSendProgress != null) onSendProgress(lastProgress);
      },
    ).timeout(
      Duration(seconds: timeOut),
      onTimeout: () {
        isTimeOut = true;
        printError(info: "Time out");
        return dio.Response(requestOptions: RequestOptions(path: ''));
      },
    ).catchError((e, s) {
      if (e is DioError && e.type == DioErrorType.cancel) {
        isCancel = true;
        printError(info: e.toString());
        printError(info: s.toString());
      }

      printError(info: e.toString());
      printError(info: s.toString());

      closeRequest();

      error!(e.toString());
    });

    if (isCancel) {
      if (kDebugMode) print("CANCEL REQUEST");
      return;
    }

    closeRequest();

    if (kDebugMode) print("RESPONSE: ${res.data}");

    if (isTimeOut) return error(e002);

    if (res.statusCode! >= 200 && res.statusCode! < 300)
      return success(res.data.toString().isEmpty ? "" : res.data);
    else
      return error(res.data.isEmpty ? "" : res.data);
  }

  Widget _layoutDialog() => Dialog(
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Container(
          height: sWValue(.3),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.5),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircularProgressIndicator(),
              SizedBox(height: sWValue(.02)),
              Obx(
                () => AutoSizeText(
                  "${_progress.value}%",
                  minFontSize: 14,
                ),
              ),
            ],
          ),
        ),
      );

  Future<void> _catchError(
    var e,
    StackTrace s,
    bool toast,
    Function(String error) error,
  ) async {
    if (e.runtimeType is SocketException) {
      if (toast) BToast.show("Lỗi mạng");
      error("Lỗi mạng");
    } else {
      if (toast) BToast.show("Lỗi hệ thống");
      error("Lỗi hệ thống");
    }

    printError(info: e.toString());
    printError(info: s.toString());
  }

  void _onTimeout(
    bool toast,
    Function(String error) error,
  ) {
    if (toast) BToast.show("Hết thời gian kết nối");

    error("Hết thời gian kết nối");
  }

  void _onLoginExpires(
    bool toast,
    Function(String error) error,
  ) async {
    if (_countToast401 != 0) return;
    _countToast401 += _countToast401;
    BSharedPreferences.clear();
    if (toast) BToast.show("Hết hạn đăng nhập");
    error("Hết hạn đăng nhập");
    // BSwitchScreen.pushAndRemoveAll(() => LoginScreen());
    _countToast401 -= _countToast401;
  }
}

enum TypeShowUpload {
  none,
  dialog,
}

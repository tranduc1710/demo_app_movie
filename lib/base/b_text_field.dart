import 'package:flutter/rendering.dart';

import 'base.dart';

// ignore: must_be_immutable
class BTextField extends StatefulWidget {
  final bool autoFocus;
  final bool hasShadow;
  final bool hasClear;
  final bool enable;
  final ConfigTFPassword? configPassword;
  final FocusNode? focusNode;
  final TextEditingController? controller;
  final Function()? onTap;
  final Function()? onEditingComplete;
  final Function()? onDelete;
  final Function(String s)? onChanged;
  final Function(String s)? onSubmitted;
  final Widget Function(BuildContext, {int currentLength, bool isFocused, int maxLength})? buildCounter;
  final TextInputType keyboardType;
  final String? hintText;
  final TextStyle? hintStyle;
  final TextStyle? style;
  final double? height;
  final double? width;
  final BoxConstraints? constraints;
  final double? radius;
  final EdgeInsets? padding;
  final EdgeInsets? paddingTF;
  final EdgeInsets? margin;
  final Widget? leading;
  final Widget? ending;
  final Color? colorBackground;
  final Border? border;
  final int? maxLines;

  BTextField({
    Key? key,
    this.autoFocus: false,
    this.hasShadow: true,
    this.hasClear: true,
    this.focusNode,
    this.controller,
    this.onTap,
    this.onChanged,
    this.configPassword,
    this.buildCounter,
    this.keyboardType: TextInputType.text,
    this.hintText,
    this.hintStyle,
    this.style,
    this.onEditingComplete,
    this.onSubmitted,
    this.height,
    this.width,
    this.padding,
    this.margin,
    this.enable: true,
    this.radius,
    this.leading,
    this.paddingTF,
    this.colorBackground,
    this.border,
    this.onDelete,
    this.ending,
    this.maxLines,
    this.constraints,
  }) : super(key: key);

  @override
  _BTextFieldState createState() => _BTextFieldState();
}

class _BTextFieldState extends State<BTextField> {
  late TextEditingController controller;
  late FocusNode focusNode;
  late Function(String s) onChanged;
  late Function(String s) onSubmitted;
  late Function() onDelete;
  late ConfigTFPassword configPassword;

  double _sizeIcon = 20;
  double _paddingIcon = 10;
  double _paddingInput = 20;
  int maxLines = 0;
  var hasShadow = false.obs;
  var showPass = false.obs;
  var showClear = false.obs;

  @override
  void initState() {
    focusNode = widget.focusNode ?? FocusNode();
    controller = widget.controller ?? TextEditingController();
    configPassword = widget.configPassword ?? ConfigTFPassword();
    onChanged = widget.onChanged ?? (_) {};
    onSubmitted = widget.onSubmitted ?? (_) {};
    onDelete = widget.onDelete ?? () {};
    maxLines = widget.maxLines ?? 1;

    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        maxLines = widget.maxLines ?? 1;
        hasShadow.value = true;
      } else {
        maxLines = 1;
        hasShadow.value = false;
      }

      if (!showClear.value && controller.text.isNotEmpty)
        showClear.value = true;
      else if (showClear.value && controller.text.isEmpty) showClear.value = false;
    });

    controller.addListener(() {
      if (!showClear.value && controller.text.isNotEmpty)
        showClear.value = true;
      else if (showClear.value && controller.text.isEmpty) showClear.value = false;
    });

    showPass.value = configPassword.defaultShowPass;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => AnimatedContainer(
        duration: Constant.timeAnimationShort,
        height: widget.height,
        width: widget.width,
        constraints: widget.constraints,
        margin: widget.margin ?? EdgeInsets.zero,
        decoration: BoxDecoration(
          color: widget.colorBackground ?? themeData.backgroundColor,
          border: widget.border ?? Border.all(color: Colors.black.withOpacity(.3)),
          borderRadius: BorderRadius.circular(widget.radius ?? Constant.brButtonAndTF),
          boxShadow: hasShadow.value && widget.hasShadow
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(.1),
                    blurRadius: 10,
                    spreadRadius: 0,
                    offset: Offset(1.5, 1),
                  ),
                ]
              : [],
        ),
        child: Row(
          children: [
            widget.leading ?? SizedBox(),
            Expanded(
              child: Padding(
                padding: widget.padding ??
                    EdgeInsets.only(
                      left: _paddingInput,
                      right: !configPassword.isPassword && !widget.hasClear ? _paddingInput : 0,
                    ),
                child: Center(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: controller,
                          style: widget.style,
                          autofocus: widget.autoFocus,
                          focusNode: focusNode,
                          // buildCounter: widget.buildCounter,
                          keyboardType: widget.keyboardType,
                          onTap: widget.onTap,
                          onEditingComplete: widget.onEditingComplete,
                          onSubmitted: onSubmitted,
                          onChanged: onChanged,
                          obscureText: !showPass.value && configPassword.isPassword,
                          minLines: 1,
                          maxLines: maxLines,
                          decoration: InputDecoration(
                            enabled: widget.enable,
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            focusedErrorBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            fillColor: Colors.transparent,
                            contentPadding: widget.paddingTF,
                            hintText: widget.hintText,
                            hintStyle: widget.hintStyle,
                          ),
                        ),
                      ),
                      !configPassword.isPassword && !widget.hasClear || !showClear.value
                          ? SizedBox()
                          : Container(
                              padding: EdgeInsets.only(left: _paddingIcon),
                              constraints: BoxConstraints(maxWidth: _sizeIcon * 5 + _paddingIcon * 10),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  !configPassword.isPassword
                                      ? SizedBox()
                                      : InkWell(
                                          splashColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onTap: () => showPass.toggle(),
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(horizontal: sWValue(.01)),
                                            child: AnimatedSwitcher(
                                              duration: Constant.timeAnimationShort,
                                              child: Image.asset(
                                                showPass.value ? "assets/base/icons/open_eye.png" : "assets/base/icons/close_eye.png",
                                                width: _sizeIcon,
                                              ),
                                            ),
                                          ),
                                        ),
                                  !widget.hasClear || !showClear.value
                                      ? SizedBox()
                                      : InkWell(
                                          splashColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onTap: () {
                                            controller.text = "";
                                            showClear.value = false;
                                            onDelete();
                                          },
                                          child: Container(
                                            width: _sizeIcon,
                                            height: _sizeIcon,
                                            margin: EdgeInsets.symmetric(horizontal: _paddingIcon),
                                            decoration: BoxDecoration(
                                              color: Colors.grey.withAlpha(100),
                                              borderRadius: BorderRadius.circular(50),
                                            ),
                                            child: Center(
                                              child: Icon(
                                                Icons.close,
                                                color: Colors.white,
                                                size: _sizeIcon * .8,
                                              ),
                                            ),
                                          ),
                                        ),
                                ],
                              ),
                            ),
                      widget.ending ?? SizedBox(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ConfigTFPassword {
  final bool isPassword, defaultShowPass;

  ConfigTFPassword({
    this.isPassword: false,
    this.defaultShowPass: false,
  });
}

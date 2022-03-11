import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'base.dart';

// ignore: must_be_immutable
class BButton extends StatelessWidget {
  final String title;
  final Function()? onTap;
  Color? backgroundColor;
  final Color? colorText;
  final Color? colorLoading;
  final TextStyle? textStyle;
  final Widget? child;
  double? width;
  double? height;
  double? radius;
  final EdgeInsets? margin;
  List<BoxShadow>? boxShadow;
  final bool? hasLoading;
  final Gradient? gradient;
  final DecorationImage? imageBackground;
  final BoxBorder? border;

  BButton(
    this.title, {
    this.onTap,
    this.backgroundColor,
    this.colorText,
    this.colorLoading: Colors.white,
    this.textStyle,
    this.child,
    this.width,
    this.height,
    this.margin,
    this.radius,
    this.boxShadow,
    this.hasLoading: true,
    this.gradient,
    this.imageBackground,
    this.border,
  }) : assert(colorLoading != null);

  // EdgeInsets? margin;
  // Color? backgroundColor;
  double? _sizeLoading;
  // List<BoxShadow>? boxShadow;

  var _isLoad = false.obs;

  @override
  Widget build(BuildContext context) {
    height = height ?? 50;
    width = width ?? sWidth;
    _sizeLoading = height! * .5;
    backgroundColor = backgroundColor ?? themeData.primaryColor;
    radius = radius ?? Constant.brButtonAndTF;
    boxShadow = boxShadow ??
        [
          BoxShadow(
            color: Colors.black38,
            blurRadius: 3,
            spreadRadius: 0,
            offset: Offset.zero,
          ),
        ];

    return Container(
      height: height,
      width: width,
      margin: margin,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.all(Radius.circular(radius!)),
        shape: BoxShape.rectangle,
        boxShadow: boxShadow,
        gradient: gradient,
        image: imageBackground,
        border: border,
      ),
      child: InkWell(
        onTap: () async {
          FocusScope.of(context).requestFocus(FocusNode());
          if (_isLoad.value) return;
          if (hasLoading! && _isLoad.canUpdate) _isLoad.toggle();
          try {
            if (onTap != null) await onTap!();
          } catch (e, s) {
            _isLoad.value = false;
            if (kDebugMode) print(e);
            throw s;
          }
          // await Future.delayed(Constant.timeAnimation);
          if (hasLoading! && _isLoad.canUpdate) _isLoad.toggle();
        },
        child: Center(
          child: Obx(
            () => _isLoad.value && hasLoading!
                ? SizedBox(
                    width: _sizeLoading,
                    height: _sizeLoading,
                    child: CircularProgressIndicator(
                      backgroundColor: colorLoading,
                      strokeWidth: height! * .08,
                    ),
                  )
                : child ??
                    AutoSizeText(
                      title,
                      style: textStyle ??
                          TextStyle(
                            color: colorText ?? Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            shadows: [
                              BoxShadow(
                                color: Colors.black.withOpacity(.4),
                                blurRadius: margin == null ? 0 : (margin!.bottom * .5),
                                spreadRadius: 0,
                                offset: margin == null ? Offset.zero : Offset(margin!.bottom * .1, margin!.bottom * .1),
                              ),
                            ],
                          ),
                      minFontSize: 14,
                    ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter_bounce/flutter_bounce.dart';

import 'base.dart';

class BButtonAnimation extends StatelessWidget {
  final Function()? onTap;
  final Color? backgroundColor;
  final Widget? child;
  final double? height, width;

  const BButtonAnimation({
    Key? key,
    this.onTap,
    this.backgroundColor,
    @required this.child,
    this.height,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Bounce(
      onPressed: () {
        FocusScope.of(context).requestFocus(FocusNode());
        if (onTap != null) onTap!();
      },
      duration: Constant.timeAnimationShort,
      child: Container(
        width: width,
        height: height ?? sWValue(.1),
        decoration: BoxDecoration(
          color: backgroundColor ?? Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(Constant.brButtonAndTF),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 10,
          ),
          child: Center(child: child ?? SizedBox()),
        ),
      ),
    );
  }
}

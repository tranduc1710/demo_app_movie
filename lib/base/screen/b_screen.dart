import 'package:flutter/gestures.dart';

import '../base.dart';

/// Nếu là màn hình thì bọc với Scaffold còn lại không bọc
abstract class BScreen<B> extends StatefulWidget {
  B get bloc;

  Widget build(BuildContext context);

  BuildContext get context => Get.context!;

  bool? backgroundTop;
  bool? backgroundBottom;
  Color? colorBackgroundTop;

  AppBar appBar(String title, {Widget? leading, List<Widget>? actions}) => AppBar(
        title: AutoSizeText(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: leading,
        actions: actions,
      );

  void onTapBackground() => null;

  void didChangeAppLifecycleState() => null;

  @override
  @deprecated
  _BScreenState createState() => _BScreenState();
}

class _BScreenState extends State<BScreen> with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  @override
  void initState() {
    WidgetsBinding.instance!.addObserver(this);
    widget.bloc;
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) widget.didChangeAppLifecycleState();
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
        widget.onTapBackground();
      },
      child: ScrollConfiguration(
        behavior: _MyBehavior(),
        child: (widget.build(context) is Scaffold)
            ? Scaffold(
                appBar: (widget.build(context) is Scaffold) && (widget.build(context) as Scaffold).appBar != null ? (widget.build(context) as Scaffold).appBar : null,
                body: InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                    widget.onTapBackground();
                  },
                  child: Column(
                    children: [
                      widget.backgroundTop ?? true
                          ? Container(
                              height: context.mediaQueryPadding.top,
                              width: sWidth,
                              color: widget.colorBackgroundTop ?? Colors.grey[300],
                            )
                          : SizedBox(),
                      Expanded(
                        child: (widget.build(context) as Scaffold).body ?? SizedBox(),
                      ),
                      widget.backgroundBottom ?? true
                          ? Container(
                              height: context.mediaQueryPadding.bottom,
                              width: sWidth,
                              color: Colors.white,
                            )
                          : SizedBox(),
                    ],
                  ),
                ),
                backgroundColor: themeData.backgroundColor,
                primary: (widget.build(context) is Scaffold) ? (widget.build(context) as Scaffold).primary : true,
                bottomNavigationBar: (widget.build(context) is Scaffold) ? (widget.build(context) as Scaffold).bottomNavigationBar : null,
                bottomSheet: (widget.build(context) is Scaffold) ? (widget.build(context) as Scaffold).bottomSheet : null,
                drawer: (widget.build(context) is Scaffold) ? (widget.build(context) as Scaffold).drawer : null,
                endDrawer: (widget.build(context) is Scaffold) ? (widget.build(context) as Scaffold).endDrawer : null,
                drawerDragStartBehavior: (widget.build(context) is Scaffold) ? (widget.build(context) as Scaffold).drawerDragStartBehavior : DragStartBehavior.start,
                key: (widget.build(context) is Scaffold) ? (widget.build(context) as Scaffold).key : null,
                drawerEdgeDragWidth: (widget.build(context) is Scaffold) ? (widget.build(context) as Scaffold).drawerEdgeDragWidth : null,
                drawerEnableOpenDragGesture: (widget.build(context) is Scaffold) ? (widget.build(context) as Scaffold).drawerEnableOpenDragGesture : true,
                drawerScrimColor: (widget.build(context) is Scaffold) ? (widget.build(context) as Scaffold).drawerScrimColor : null,
                endDrawerEnableOpenDragGesture: (widget.build(context) is Scaffold) ? (widget.build(context) as Scaffold).endDrawerEnableOpenDragGesture : true,
                extendBody: (widget.build(context) is Scaffold) ? (widget.build(context) as Scaffold).extendBody : false,
                extendBodyBehindAppBar: (widget.build(context) is Scaffold) ? (widget.build(context) as Scaffold).extendBodyBehindAppBar : false,
                floatingActionButton: (widget.build(context) is Scaffold) ? (widget.build(context) as Scaffold).floatingActionButton : null,
                floatingActionButtonAnimator: (widget.build(context) is Scaffold) ? (widget.build(context) as Scaffold).floatingActionButtonAnimator : null,
                floatingActionButtonLocation: (widget.build(context) is Scaffold) ? (widget.build(context) as Scaffold).floatingActionButtonLocation : null,
                persistentFooterButtons: (widget.build(context) is Scaffold) ? (widget.build(context) as Scaffold).persistentFooterButtons : [],
                resizeToAvoidBottomInset: (widget.build(context) is Scaffold) ? (widget.build(context) as Scaffold).resizeToAvoidBottomInset : true,
                // ignore: deprecated_member_use
              )
            : widget.build(context),
      ),
    );
  }
}

class _MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}

import 'dart:math';

import 'base.dart';

class Captcha extends StatefulWidget {
  final TypeCaptcha typeCaptcha;
  final Function(String value)? onChange;
  final Function(String value)? onReload;
  final int numChar;
  final String captcha;
  static late Function() reloadCaptcha;

  Captcha({
    this.typeCaptcha: TypeCaptcha.Number,
    this.onReload,
    this.onChange,
    this.numChar: 4,
    this.captcha: "",
  });

  @override
  _CaptchaState createState() => _CaptchaState();
}

class _CaptchaState extends State<Captcha> {
  Random _rnd = Random();

  String _charsNumber = '1234567890';
  String _charsNumberAndText = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  late String captcha = "";

  @override
  void initState() {
    super.initState();
    captcha = widget.captcha;
    getRandomCaptchaNUmber(onInit: true);
    Captcha.reloadCaptcha = () => getRandomCaptchaNUmber();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          constraints: BoxConstraints(
            minWidth: 150,
            minHeight: 50,
          ),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: sWValue(.03)),
              child: AutoSizeText(
                captcha,
                style: TextStyle(
                  letterSpacing: 5,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
        InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () => getRandomCaptchaNUmber(),
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Icon(Icons.refresh),
          ),
        ),
      ],
    );
  }

  void getRandomCaptchaNUmber({bool onInit: false}) {
    if (!this.mounted) return;

    setState(() {
      captcha = String.fromCharCodes(
        Iterable.generate(
          widget.numChar,
          (_) => (widget.typeCaptcha == TypeCaptcha.Number ? _charsNumber : _charsNumberAndText).codeUnitAt(
            _rnd.nextInt((widget.typeCaptcha == TypeCaptcha.Number ? _charsNumber : _charsNumberAndText).length),
          ),
        ),
      );
      if (widget.onChange != null) widget.onChange!(captcha);
      if (widget.onReload != null && !onInit) widget.onReload!(captcha);
    });
  }
}

enum TypeCaptcha { Number, NumberAndText }

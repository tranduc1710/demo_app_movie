import 'package:fluttertoast/fluttertoast.dart';

import 'base.dart';

class BToast {
  static void show(String content, [Toast? toast]) => Fluttertoast.showToast(
        msg: content,
        toastLength: toast ?? Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.grey.withOpacity(0.7),
        textColor: Colors.white,
      );
}

import 'package:demo_app_movie/base/base.dart';
import 'package:demo_app_movie/model/movie_model.dart';

import 'home_request.dart';
import 'home_screen.dart';

class HomeBloc extends BBloc<HomeScreen, HomeRequest> {
  @override
  HomeRequest? get request => HomeRequest();

  var lMovie = <Result>[].obs;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      _callApi();
    });
  }

  void _callApi() async {
    List<Result> list = await BDialog(
      () async => await request!.getListMovie(),
    ).loading();

    lMovie.addAll(list);
  }
}

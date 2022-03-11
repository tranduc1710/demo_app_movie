import 'package:demo_app_movie/base/base.dart';
import 'package:demo_app_movie/model/movie_model.dart';

class HomeRequest extends BRequestApi {
  Future<List<Result>> getListMovie() async {
    var list = <Result>[];

    await request.get(
      'https://api.themoviedb.org/3/discover/movie?api_key=26763d7bf2e94098192e629eb975dab0&page=1',
      success: (res) async {
        var movie = MovieModel.fromJson(res);
        list = movie.results!;
      },
    );

    return list;
  }
}

import 'package:auto_size_text/auto_size_text.dart';
import 'package:demo_app_movie/base/base.dart';
import 'package:demo_app_movie/model/movie_model.dart';
import 'package:flutter/cupertino.dart';

import 'home_bloc.dart';

class HomeScreen extends BScreen<HomeBloc> {
  @override
  HomeBloc get bloc => Get.put(HomeBloc());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(sWValue(.04)),
              child: AutoSizeText(
                "Popular list",
                style: Constant.sTitle,
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: sWValue(.02)),
                child: Obx(
                  () => GridView.builder(
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: sWValue(.5),
                      childAspectRatio: 2 / 3,
                      crossAxisSpacing: sWValue(.02),
                    ),
                    itemCount: bloc.lMovie.length,
                    itemBuilder: (context, index) => itemList(bloc.lMovie[index]),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget itemList(Result item) {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.symmetric(
            horizontal: sWValue(.04),
            vertical: sWValue(.02),
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                offset: const Offset(0, 1),
                blurRadius: 8,
                spreadRadius: 0,
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(
            horizontal: sWValue(.02),
            vertical: sWValue(.01),
          ),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  'https://image.tmdb.org/t/p/w440_and_h660_face' + item.backdropPath!,
                  fit: BoxFit.fill,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: sWValue(.02)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    AutoSizeText(
                      item.releaseDate!.year.toString(),
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 5),
                    AutoSizeText(
                      item.title!.toUpperCase().toString(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      minFontSize: 14,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: sWValue(.07)),
                  ],
                ),
              ),
              Align(
                alignment: Alignment(.86, -.92),
                child: Container(
                  width: sWValue(.08),
                  height: sWValue(.08),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    gradient: LinearGradient(
                      begin: Alignment(-1, -1),
                      end: Alignment(1, 1),
                      colors: [
                        Colors.orange,
                        Colors.red,
                      ],
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: AutoSizeText(
                            item.voteAverage!.toString().substring(0, item.voteAverage!.toString().indexOf('.')),
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        AutoSizeText(
                          item.voteAverage!.toString().substring(item.voteAverage!.toString().indexOf('.')),
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

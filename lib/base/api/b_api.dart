import 'package:shimmer/shimmer.dart';

import '../base.dart';

class BApi<T> extends StatelessWidget {
  final Widget? buildLoad;
  final Widget? buildError;
  final Widget Function(T t) builder;
  final Stream init;
  final TypeBApi type;

  const BApi({
    Key? key,
    this.buildLoad,
    this.buildError,
    required this.builder,
    required this.init,
    this.type: TypeBApi.LIST,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: init,
      builder: (context, snapshot) {
        if (snapshot.hasError) return _loadError();

        if (snapshot.hasData) {
          if (snapshot.data != null)
            return builder(snapshot.data as T);
          else
            return _loadError();
        }

        switch (type) {
          case TypeBApi.DATA:
            return _loadData();
          case TypeBApi.LIST:
            return _loadList();
          default:
            return _loadCustom();
        }
      },
    );
  }

  Widget _loadCustom() => buildLoad == null
      ? SizedBox()
      : Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          enabled: true,
          child: buildLoad!,
        );

  Widget _loadList() => Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        enabled: true,
        child: ListView.builder(
          itemBuilder: (_, __) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 48.0,
                  height: 48.0,
                  color: Colors.white,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                        height: 8.0,
                        color: Colors.white,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 2.0),
                      ),
                      Container(
                        width: double.infinity,
                        height: 8.0,
                        color: Colors.white,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 2.0),
                      ),
                      Container(
                        width: 40.0,
                        height: 8.0,
                        color: Colors.white,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          itemCount: 4,
        ),
      );

  Widget _loadData() => Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: sWValue(.08),
              height: sWValue(.08),
              child: CircularProgressIndicator(
                color: themeData.primaryColor,
              ),
            ),
            SizedBox(height: sWValue(.03)),
            AutoSizeText(
              "Đang tải dữ liệu",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );

  Widget _loadError() => buildError == null
      ? Column(
          children: [
            Image.asset(
              "assets/base/icons/error.png",
              width: sWValue(.2),
            ),
            AutoSizeText(
              "Lỗi lấy dữ liệu",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        )
      : buildError!;
}

enum TypeBApi { LIST, DATA, CUSTOM }

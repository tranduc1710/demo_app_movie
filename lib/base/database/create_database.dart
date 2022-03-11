import 'sqf_lite/database_helper.dart';

class CreateDatabase {
  ///nếu tạo bảng mới cần thêm vào cả 2 list
  ///nếu thêm lệnh xoá bảng trong migrations thì cần xoá lệnh tạo bảng trong initialScript
  static BaseDatabaseHelper db = BaseDatabaseHelper(
    initialScript: [],
    migrations: [],
  );
}

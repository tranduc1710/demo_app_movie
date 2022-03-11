import 'sqf_lite/database_column_model.dart';
import 'sqf_lite/database_info.dart';

class ConstantDatabase {
  static var notificationLocal = DataBaseInfo(
    table: "local_notification",
    column: [
      DBColumnModel("id", TypeColumn.integer, hasNull: TypeColumnNull.none, isPrimaryKey: true, isAutoincrement: true),
      DBColumnModel("idNoti", TypeColumn.integer, hasNull: TypeColumnNull.not_null),
      DBColumnModel("function", TypeColumn.text, hasNull: TypeColumnNull.not_null),
      DBColumnModel("data", TypeColumn.text, hasNull: TypeColumnNull.none),
    ],
  );
}

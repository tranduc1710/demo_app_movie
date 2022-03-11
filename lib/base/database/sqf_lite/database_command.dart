import 'database_column_model.dart';
import 'database_info.dart';
import 'query_create_table.dart';

class DataBaseCommand {
  final DataBaseInfo dataBaseInfo;

  DataBaseCommand(this.dataBaseInfo);

  ///tạo bảng mới
  String createTable({
    int version: -1,
  }) =>
      "CREATE TABLE IF NOT EXISTS ${dataBaseInfo.table} (${QueryCreateTable(version == -1 ? dataBaseInfo.columnUpgrade!.last : dataBaseInfo.columnUpgrade![version]).getQueryCreateColumn()});";

  ///xoá bảng
  String deleteTable() => "DROP TABLE IF EXISTS ${dataBaseInfo.table};";

  ///thêm cột trong bảng
  String addColumn({
    required String nameColumn,
    required TypeColumn typeColumn,
  }) =>
      "ALTER TABLE ${dataBaseInfo.table} ADD COLUMN $nameColumn ${_getTypeColumn(typeColumn)};";

  ///update bảng
  List<String> updateColumn(int version) {
    List<String> lQuery = [];
    lQuery.add("ALTER TABLE ${dataBaseInfo.table} RENAME TO ${dataBaseInfo.table}_clone;");
    lQuery.add(createTable(version: version));
    String column = _getNameColumn(version);
    lQuery.add("INSERT INTO ${dataBaseInfo.table}($column) SELECT $column FROM ${dataBaseInfo.table}_clone;");
    lQuery.add("DROP TABLE ${dataBaseInfo.table}_clone;");
    return lQuery;
  }

  String _getNameColumn(int version) {
    String value = "";

    for (int i = 0; i < dataBaseInfo.columnUpgrade![version].length; i++) {
      value += dataBaseInfo.columnUpgrade![version][i].nameColumn;
      if (i < dataBaseInfo.columnUpgrade![version].length - 1) value += ",";
    }

    return value;
  }

  String _getTypeColumn(TypeColumn typeColumn) {
    String query = "";

    switch (typeColumn) {
      case TypeColumn.text:
        query = "TEXT";
        break;
      case TypeColumn.integer:
        query = "INTEGER";
        break;
    }

    return query;
  }
}

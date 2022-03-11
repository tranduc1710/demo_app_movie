import 'database_column_model.dart';

class QueryCreateTable {
  List<DBColumnModel> lColumn = [];

  QueryCreateTable(this.lColumn);

  String _getTypeColumn(TypeColumn typeColumn) {
    String query = "";

    switch (typeColumn) {
      case TypeColumn.text:
        query = " TEXT";
        break;
      case TypeColumn.integer:
        query = " INTEGER";
        break;
    }

    return query;
  }

  String _getTypeColumnNull(TypeColumnNull typeColumnNull) {
    String query = "";

    switch (typeColumnNull) {
      case TypeColumnNull.not_null:
        query = " NOT NULL";
        break;
      case TypeColumnNull.none:
        query = "";
        break;
    }

    return query;
  }

  String _getEndQuery(String nameColumn) {
    String query = "";

    if (nameColumn != lColumn[lColumn.length - 1].nameColumn) query = ",";

    return query;
  }

  String _getPrimaryKey(bool isPrimaryKey) {
    String query = "";
    if (isPrimaryKey) query = " PRIMARY KEY";
    return query;
  }

  String _getAutoincrement(bool isAutoincrement) {
    String query = "";
    if (isAutoincrement) query = " AUTOINCREMENT";
    return query;
  }

  String getQueryCreateColumn() {
    String query = "";

    for (DBColumnModel item in lColumn)
      query = query +
          item.nameColumn +
          _getTypeColumn(item.typeColumn) +
          _getPrimaryKey(item.isPrimaryKey) +
          _getAutoincrement(item.isAutoincrement) +
          _getTypeColumnNull(item.hasNull) +
          _getEndQuery(item.nameColumn);

    return query;
  }
}

import 'database_column_model.dart';

class DataBaseInfo {
  final String table;
  final List<DBColumnModel> column;
  List<List<DBColumnModel>>? columnUpgrade;

  DataBaseInfo(
      {required this.table, required this.column, this.columnUpgrade}) {
    if (this.columnUpgrade == null) {
      this.columnUpgrade = [this.column];
    } else {
      this.columnUpgrade!.insert(0, this.column);
    }
  }
}

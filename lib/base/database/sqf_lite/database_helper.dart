import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../../base.dart';

bool _onOpen = false;

class BaseDatabaseHelper {
  List<String> initialScript;
  List<String> migrations;
  late Database db;
  var _lock = Lock();

  BaseDatabaseHelper({required this.initialScript, required this.migrations});

  ///check xem có giá trị chưa
  bool _checkInputDatabase({required String content1, required String content2}) {
    if (content1.trim().isEmpty || content2.trim().isEmpty) return false;
    return true;
  }

  ///mở database
  Future<Database?> _openDatabaseHelper() async {
    await _lock.synchronized(_openDb);
    return db;
  }

  Future<Database?> _openDb() async {
    if (_onOpen) return db;

    var databasesPath = await getDatabasesPath();

    String path = join(databasesPath, 'vnpost_hcc.db');

    if (kDebugMode) print("Db vesion: ${migrations.length + 1}");

    db = await openDatabase(
      path,
      version: migrations.length + 1,
      onCreate: (Database db, int version) async {
        if (kDebugMode) print('onCreate');
        initialScript.forEach((value) async => await db.execute(value));
      },
      onConfigure: (Database db) {
        if (kDebugMode) print("onConfigure");
      },
      onOpen: (Database db) {
        if (kDebugMode) print("_onOpen");
      },
      onUpgrade: (Database db, int oldVersion, int newVersion) async {
        if (kDebugMode) print("onUpgrade");
        for (var i = (oldVersion - 1); i < newVersion - 1; i++) await db.execute(migrations[i]);
      },
      onDowngrade: (Database db, int oldVersion, int newVersion) {
        if (kDebugMode) print("onDowngrade");
      },
    ).catchError(
      (err, s) {
        _onOpen = false;
        if (kDebugMode) print(s);
        if (kDebugMode) print(err);
      },
    );

    _onOpen = true;

    return db;
  }

  ///đóng database
  Future<void> closeDatabase() async => await _lock.synchronized((_closeDatabase));

  Future<void> _closeDatabase() async {
    if (!_onOpen) {
      if (kDebugMode) print("Database is close");
      return;
    }

    await db.close().catchError(
      (err, s) {
        _onOpen = true;
        if (kDebugMode) print(s);
        if (kDebugMode) print(err);
      },
    );

    _onOpen = false;
    if (kDebugMode) print("Close database");
  }

  ///insert vào database
  Future<int?> insertDatabase({
    required String table,
    required Map<String, dynamic> raw,
  }) async =>
      await _lock.synchronized(() async => await _insertDatabase(table, raw));

  Future<int?> _insertDatabase(
    String table,
    Map<String, dynamic> raw,
  ) async {
    if (!_onOpen) await _openDatabaseHelper();
    if (!_onOpen) {
      return -1;
    }
    var req = await db.rawQuery("PRAGMA table_info ($table)");
    if (req.isEmpty) {
      if (kDebugMode) print("No table: " + table);
      return -1;
    }

    int recordId = await db.insert('$table', raw).catchError(
      (err, s) {
        if (kDebugMode) print(s);
        if (kDebugMode) print(err);
      },
    );
    if (kDebugMode) print("Id insert: $recordId");
    return recordId;
  }

  ///lấy tất cả data trong bảng
  Future<List<Map<String, dynamic>>?> queryAllDatabase({
    required String table,
    required List<String> listColumn,
    String? columnOrderBy,
    TypeOrderBy? typeOrderBy,
  }) async =>
      await _lock.synchronized(() async => await _queryAllDatabase(table, listColumn, columnOrderBy!, typeOrderBy!));

  Future<List<Map<String, dynamic>>?> _queryAllDatabase(String table, List<String> listColumn, String? columnOrderBy, TypeOrderBy typeOrderBy) async {
    if (!_onOpen) await _openDatabaseHelper();
    if (!_onOpen) {
      return null;
    }
    var req = await db.rawQuery("PRAGMA table_info ($table)");
    if (req.isEmpty) {
      if (kDebugMode) print("No table: " + table);
      return null;
    }

    List<Map<String, dynamic>> list = await db
        .query(
      '$table',
      columns: listColumn,
      orderBy: columnOrderBy == null
          ? null
          : _getOrderBy(
              columnOrderBy: columnOrderBy,
              typeOrderBy: typeOrderBy,
            ),
    )
        .catchError(
      (err, s) {
        if (kDebugMode) print(s);
        if (kDebugMode) print(err);
      },
    );
    if (kDebugMode) print("Query all: $list");
    return list;
  }

  //get lenh orderBY
  String _getOrderBy({required String columnOrderBy, required TypeOrderBy typeOrderBy}) {
    return columnOrderBy + ' ' + (typeOrderBy == TypeOrderBy.ASC ? 'ASC' : 'DESC');
  }

  ///lấy data có điều kiện
  Future<List<Map<String, dynamic>>?> querySearchDatabase({
    required String table,
    required List<String> listColumn,
    required var where,
    required List<dynamic> whereArgs,
  }) async =>
      await _lock.synchronized(() async => await _querySearchDatabase(table, listColumn, where, whereArgs));

  Future<List<Map<String, dynamic>>?> _querySearchDatabase(
    String table,
    List<String> listColumn,
    var where,
    List<dynamic> whereArgs,
  ) async {
    if (!_onOpen) await _openDatabaseHelper();
    if (!_onOpen) {
      return null;
    }
    var req = await db.rawQuery("PRAGMA table_info ($table)");
    if (req.isEmpty) {
      if (kDebugMode) print("No table: " + table);
      return null;
    }

    List<Map<String, dynamic>> list = await db
        .query(
      '$table',
      columns: listColumn,
      where: "${where ?? ''} = ?",
      whereArgs: whereArgs,
    )
        .catchError(
      (err, s) {
        if (kDebugMode) print(s);
        if (kDebugMode) print(err);
      },
    );
    if (kDebugMode) print("Query search: $list");
    return list;
  }

  ///lấy data có điều kiện và sắp xếp
  Future<List<Map<String, dynamic>>?> querySearchOderByDatabase({
    required String table,
    required List<String> listColumn,
    required var where,
    required List<dynamic> whereArgs,
    required String orderBy,
  }) async =>
      await _lock.synchronized(() async => await _querySearchOderByDatabase(table, listColumn, where, whereArgs, orderBy));

  Future<List<Map<String, dynamic>>?> _querySearchOderByDatabase(
    String table,
    List<String> listColumn,
    var where,
    List<dynamic> whereArgs,
    String orderBy,
  ) async {
    if (!_onOpen) await _openDatabaseHelper();
    if (!_onOpen) {
      return null;
    }
    var req = await db.rawQuery("PRAGMA table_info ($table)");
    if (req.isEmpty) {
      if (kDebugMode) print("No table: " + table);
      return null;
    }

    List<Map<String, dynamic>> list = await db
        .query(
      '$table',
      columns: listColumn,
      where: "${where ?? ''} = ?",
      whereArgs: whereArgs,
      orderBy: orderBy,
    )
        .catchError(
      (err, s) {
        if (kDebugMode) print(s);
        if (kDebugMode) print(err);
      },
    );
    if (kDebugMode) print("Query search order by: $list");
    return list;
  }

  ///xoá một data trong bảng
  Future<void> deleteItemInTable({
    required String table,
    required String column,
    required String whereArgs,
  }) async =>
      await _lock.synchronized(() async => await _deleteItemInTable(table, column, whereArgs));

  Future<void> _deleteItemInTable(
    String table,
    String column,
    String whereArgs,
  ) async {
    bool check = _checkInputDatabase(content1: column, content2: whereArgs);
    if (!check) {
      return;
    }
    if (!_onOpen) await _openDatabaseHelper();
    var req = await db.rawQuery("PRAGMA table_info ($table)");
    if (req.isEmpty) {
      if (kDebugMode) print("No table: " + table);
      return;
    }

    var count = await db.delete('$table', where: '$column = ?', whereArgs: ['$whereArgs']).catchError(
      (err, s) {
        if (kDebugMode) print(s);
        if (kDebugMode) print(err);
      },
    );
    if (kDebugMode) print("Delete item: $count");
  }

  ///xoá data trong bảng
  Future<void> deleteDatabaseTable({
    required String table,
  }) async =>
      await _lock.synchronized(() async => await _deleteDatabaseTable(table));

  Future<void> _deleteDatabaseTable(String table) async {
    if (!_onOpen) await _openDatabaseHelper();
    if (!_onOpen) {
      return;
    }
    var req = await db.rawQuery("PRAGMA table_info ($table)");
    if (req.isEmpty) {
      if (kDebugMode) print("No table: " + table);
      return;
    }

    var count = await db.delete('$table').catchError(
      (err, s) {
        if (kDebugMode) print(s);
        if (kDebugMode) print(err);
      },
    );
    if (kDebugMode) print("Delete table: $count");
  }

  ///update một data trong bảng
  Future<void> updateItemInTable({
    required String table,
    required String columnUpdate,
    required String where,
    required List<dynamic> whereArgs,
    required var valueUpdate,
  }) async =>
      await _lock.synchronized(() async => _updateItemInTable(table, columnUpdate, where, whereArgs, valueUpdate));

  Future<void> _updateItemInTable(
    String table,
    String columnUpdate,
    String where,
    List<dynamic> whereArgs,
    var valueUpdate,
  ) async {
    if (!_onOpen) await _openDatabaseHelper();
    if (!_onOpen) {
      return;
    }
    var req = await db.rawQuery("PRAGMA table_info ($table)");
    if (req.isEmpty) {
      if (kDebugMode) print("No table: " + table);
      return;
    }

    var count = await db
        .update(
      '$table',
      {'$columnUpdate': "${valueUpdate ?? ''}"},
      where: '$where = ?',
      whereArgs: whereArgs,
    )
        .catchError(
      (err, s) {
        if (kDebugMode) print(s);
        if (kDebugMode) print(err);
      },
    );
    if (kDebugMode) print("Update: $count");
  }

  ///update nhiều cột trong bảng
  Future<void> updateMoreColumnInTable({
    required String table,
    required Map<String, dynamic> rawColumnUpdate,
    required String where,
    required List<dynamic> whereArgs,
  }) async =>
      await _lock.synchronized(() async => await _updateMoreColumnInTable(table, rawColumnUpdate, where, whereArgs));

  Future<void> _updateMoreColumnInTable(
    String table,
    Map<String, dynamic> rawColumnUpdate,
    String where,
    List<dynamic> whereArgs,
  ) async {
    if (!_onOpen) await _openDatabaseHelper();
    if (!_onOpen) {
      return;
    }
    var req = await db.rawQuery("PRAGMA table_info ($table)");
    if (req.isEmpty) {
      if (kDebugMode) print("No table: " + table);
      return;
    }

    var count = await db
        .update(
      '$table',
      rawColumnUpdate,
      where: '$where = ?',
      whereArgs: whereArgs,
    )
        .catchError(
      (err, s) {
        if (kDebugMode) print(s);
        if (kDebugMode) print(err);
      },
    );
    if (kDebugMode) print("Update more column: $count");
  }

  ///xoá tất cả database
  Future<void> deleteAllDatabase() async => await _lock.synchronized(_deleteAllDatabase);

  Future<void> _deleteAllDatabase() async {
    if (!_onOpen) await _openDatabaseHelper();

    for (String element in initialScript) {
      String nameTable = element.substring("CREATE TABLE IF NOT EXISTS ".length, element.indexOf(' ', 'CREATE TABLE IF NOT EXISTS '.length));
      var req = await db.rawQuery("PRAGMA table_info ($nameTable)");
      if (req.isNotEmpty)
        await db.delete(nameTable.trim()).catchError(
          (err, s) {
            if (kDebugMode) print(s);
            if (kDebugMode) print(err);
          },
        );
      else if (kDebugMode) print("No table: " + nameTable);
    }

    if (kDebugMode) print("delete all database");
  }
}

enum TypeOrderBy {
//tăng dần
  ASC,
// giảm dần
  DESC
}

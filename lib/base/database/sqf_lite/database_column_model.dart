import 'dart:core';

class DBColumnModel {
  String nameColumn;
  bool isPrimaryKey;
  bool isAutoincrement;
  TypeColumn typeColumn;
  TypeColumnNull hasNull;

  DBColumnModel(
    this.nameColumn,
    this.typeColumn, {
    this.isPrimaryKey: false,
    this.isAutoincrement: false,
    required this.hasNull,
  });
}

enum TypeColumn {
  integer,
  text,
}

enum TypeColumnNull {
  not_null,
  none,
}

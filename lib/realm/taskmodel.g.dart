// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'taskmodel.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

class TaskItem extends _TaskItem
    with RealmEntity, RealmObjectBase, RealmObject {
  TaskItem(
    ObjectId id,
    String title,
    String description,
    bool isDone,
  ) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'title', title);
    RealmObjectBase.set(this, 'description', description);
    RealmObjectBase.set(this, 'isDone', isDone);
  }

  TaskItem._();

  @override
  ObjectId get id => RealmObjectBase.get<ObjectId>(this, 'id') as ObjectId;
  @override
  set id(ObjectId value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get title => RealmObjectBase.get<String>(this, 'title') as String;
  @override
  set title(String value) => RealmObjectBase.set(this, 'title', value);

  @override
  String get description =>
      RealmObjectBase.get<String>(this, 'description') as String;
  @override
  set description(String value) =>
      RealmObjectBase.set(this, 'description', value);

  @override
  bool get isDone => RealmObjectBase.get<bool>(this, 'isDone') as bool;
  @override
  set isDone(bool value) => RealmObjectBase.set(this, 'isDone', value);

  @override
  Stream<RealmObjectChanges<TaskItem>> get changes =>
      RealmObjectBase.getChanges<TaskItem>(this);

  @override
  TaskItem freeze() => RealmObjectBase.freezeObject<TaskItem>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(TaskItem._);
    return const SchemaObject(ObjectType.realmObject, TaskItem, 'TaskItem', [
      SchemaProperty('id', RealmPropertyType.objectid, primaryKey: true),
      SchemaProperty('title', RealmPropertyType.string),
      SchemaProperty('description', RealmPropertyType.string),
      SchemaProperty('isDone', RealmPropertyType.bool),
    ]);
  }
}

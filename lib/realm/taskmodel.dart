import 'package:realm/realm.dart';
part 'taskmodel.g.dart';

@RealmModel()
class _TaskItem {
  @PrimaryKey()
  late ObjectId id;
  late String title;
  late String description;
}
import 'package:flutter/material.dart';
import 'package:task_app/realm/taskmodel.dart';
import 'package:logger/logger.dart';
import 'package:task_app/widgets/card_shadow.dart';
import 'package:task_app/widgets/confirm_dialog.dart';
import 'package:realm/realm.dart';
import 'package:path_provider/path_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Logger logger = Logger();

  final initialTasks = [
    TaskItem(ObjectId(), 'Apple', 'red one'),
    TaskItem(ObjectId(), 'Milk', 'Birch or Bear Brand'),
    TaskItem(ObjectId(), 'Yogurt', 'Blueberry or Vanilla Pascal'),
  ];

  dynamic taskLists;
  // -------------------- LOADING --------------------
  // bool _isLoading = true;

  // void _refreshData() async {
  //   setState(() {
  //     _isLoading = false;
  //   });
  // }
  // -------------------- REALM DATABASE --------------------

  late Realm realm;

  _HomeScreenState() {
    final config = Configuration.local([TaskItem.schema]);
    realm = Realm(config);
    taskLists = realm.all<TaskItem>();
  }

  // -------------------- INITSTATE --------------------

  @override
  void initState() {
    logger.i('There are ${taskLists.length} in the Realm.');

    var indexedItem = taskLists[0];
    logger.i('First task listed is : ${indexedItem.title}');

    getApplicationDocumentsDirectory().then((appDocumentsDir) {
      final pathstr = '${appDocumentsDir.path}/TaskItem.realm';

      logger.i(pathstr);
    });

    for (var x in taskLists) {
      logger.i('${x.id}. ${x.title} - ${x.description}');
    }

    super.initState();
  }

  @override
  void dispose() {
    realm.close();
    super.dispose();
  }

  Future<void> _updateData(int? id) async {
    final editingData = taskLists[id];

    realm.write(() {
      editingData.title = _titleController.text;
      editingData.description = _descController.text;
    });
  }

  Future<void> _addData() async {
    String title = _titleController.text;
    String desc = _descController.text;
    final newData = TaskItem(ObjectId(), title, desc);

    realm.write(() {
      realm.add(newData);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Task list'),
      ),
      body: ListView.builder(
        itemCount: taskLists.length,

        // -------------------- DISPLAY --------------------

        itemBuilder: (context, index) {
          final task = taskLists[index];

          return ShadowedCard(
            title: task.title,
            description: task.description,
            onEditPressed: () {
              logger.i('pressed edit');
              logger.i('index : $index');
              showBottomSheet(index);
            },
            onDeletePressed: () {
              logger.i('pressed delete');

              showDialog(
                  context: context,
                  builder: (context) {
                    return ConfirmationDialog(
                      title: 'Delete Item',
                      message: 'Are you sure you want to delete this item?',
                      confirmText: 'Delete',
                      cancelText: 'Cancel',
                      onConfirm: () {
                        logger.i('Deleted the item ${task.title}');
                        setState(() {
                          realm.write(() {
                            realm.delete<TaskItem>(task);
                          });
                        });
                        Navigator.pop(context);
                      },
                      onCancel: () {
                        logger.i('Cancelled');
                        Navigator.pop(context);
                      },
                    );
                  });
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {
          logger.i("clicked"),
          showBottomSheet(null),
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  void showBottomSheet(int? id) async {
    if (id != null) {
      final existingData = taskLists[id];

      _titleController.text = existingData.title;
      _descController.text = existingData.description;
    }

    showModalBottomSheet(
        elevation: 5,
        isScrollControlled: true,
        context: context,
        builder: (_) => Container(
              padding: EdgeInsets.only(
                top: 30,
                left: 15,
                right: 15,
                bottom: MediaQuery.of(context).viewInsets.bottom + 50,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Title",
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _descController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Description",
                    ),
                  ),
                  const SizedBox(height: 20),

                  // -------------------- ADD BUTTON --------------------
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        final navigator = Navigator.of(context);

                        // -------------------- ADD OR UPDATE --------------------

                        setState(() {
                          if (id != null) {
                            _updateData(id);
                          } else {
                            _addData();
                          }
                        });

                        _titleController.clear();
                        _descController.clear();
                        navigator.pop();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(18),
                        child: Text(
                          id == null ? "Add Data" : "Update",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ));
  }
}

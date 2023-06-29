import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:task_app/realm/taskmodel.dart';
import 'package:logger/logger.dart';
import 'package:task_app/widgets/card_shadow.dart';
import 'package:task_app/widgets/confirm_dialog.dart';
import 'package:realm/realm.dart';
import 'package:path_provider/path_provider.dart';
import 'package:task_app/widgets/list_tile.dart';
import 'dart:math' as math;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Logger logger = Logger();
  dynamic taskLists;
  List<TaskItem> sortedTaskList = [];
  int completedTasksCount = 0;
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

    if (taskLists.length > 0) {
      var indexedItem = taskLists[0];
      logger.i('First task listed is : ${indexedItem.title}');

      for (var x in taskLists) {
        logger.i('${x.id}. ${x.title} - ${x.description}');
      }
    }

    getApplicationDocumentsDirectory().then((appDocumentsDir) {
      final pathstr = '${appDocumentsDir.path}/TaskItem.realm';

      logger.i(pathstr);
    });

    super.initState();
    _fetchCount();
  }

  @override
  void dispose() {
    realm.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Task list'),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const ListTile(
              title: Text(
                'Summary',
                style: TextStyle(fontSize: 18),
              ),
            ),
            SummaryTile(
              title: 'Total tasks listed.',
              description: taskLists != null ? '${taskLists.length}' : '0',
              titleSize: 15,
              descSize: 12,
            ),
            SummaryTile(
              title: 'Total tasks completed.',
              description: taskLists != null ? completedTasksCount.toString() : '0',
              titleSize: 15,
              descSize: 12
            ),
          ],
        ),
      ),
      body: taskLists.isEmpty
          ? const Center(
              child: Text(
                'No entries.',
                style: TextStyle(fontSize: 18),
              ),
            )
          : Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.rotationY(math.pi),
                        child: const Icon(Icons.sort),
                      ),
                      onPressed: () {
                        setState(() {
                          _sortByTitle().then((_) {
                            logger.i('trying to sort');
                            for(var t in sortedTaskList) {
                              logger.i('inside pressed : ${t.title}');
                            }
                          });
                        });
                      }, 
                    ),
                  ],
                ),
              ),
              // -------------------- DISPLAY --------------------
              Expanded(
                child: ListView.builder(
                    itemCount: taskLists.length,
              
                    itemBuilder: (context, index) {
                      final task = taskLists[index];
                      bool isChecked = task.isDone;
              
                      return ShadowedCard(
                        title: task.title,
                        description: task.description,
                        cbState: isChecked,
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
                                  message:
                                      'Are you sure you want to delete this item?',
                                  confirmText: 'Delete',
                                  cancelText: 'Cancel',
                                  onConfirm: () {
                                    logger.i('Deleted the item ${task.title}');
                                    setState(() {
                                      realm.write(() {
                                        realm.delete<TaskItem>(task);
                                      });
                                      _fetchCount();
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
                        onCBPressed: (value) => {
                          setState(() {
                            isChecked = value!;
                            logger.i('checkbox clicked : $value');
                            realm.write(() => task.isDone = isChecked);
                            _fetchCount();
                          }),
                        },
                      );
                    },
                  ),
              ),
            ],
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

    await showModalBottomSheet(
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
            )).then((value) {
              setState(() {
                _titleController.clear();
                _descController.clear();
              });
            });
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
    final newData = TaskItem(ObjectId(), title, desc, false);

    realm.write(() {
      realm.add(newData);
    });
  }

  Future<int> _completedTasks() async {
    int total = 0;

    for (var task in taskLists) {
      if (task.isDone) total++;
    }

    return total;
  }

  Future<void> _fetchCount() async {
    int count = await _completedTasks();
    setState(() {
      completedTasksCount = count;
    });
  }

  Future<List<TaskItem>> _sortByTitle() async {
    final List<TaskItem> tempList = taskLists.toList();
    tempList.sort((a, b) => a.title.compareTo(b.title));

    // final rever = tempList.reversed;
    final sortee = tempList.sortedBy((element) => element.description);

    sortedTaskList = tempList;

    for(var t in sortee) {
      logger.i('rever : ${t.title}');
    }
    return sortedTaskList;
  }
}
part of 'task_bloc.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object> get props => [];
}

class LoadTasks extends TaskEvent {
  final List<TaskItem> tasks;

  const LoadTasks({this.tasks = const <TaskItem>[]});

  @override
  List<Object> get props => [tasks];
}

class AddTask extends TaskEvent {
  final TaskItem task;

  const AddTask({required this.task});

  @override
  List<Object> get props => [task];
}

class UpdateTask extends TaskEvent {
  final TaskItem task;

  const UpdateTask({required this.task});

  @override
  List<Object> get props => [task];
}

class DeleteTask extends TaskEvent {
  final TaskItem task;

  const DeleteTask({required this.task});

  @override
  List<Object> get props => [task];
}
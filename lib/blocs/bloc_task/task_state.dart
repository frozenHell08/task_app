part of 'task_bloc.dart';

abstract class TaskState extends Equatable {
  const TaskState();
  
  @override
  List<Object> get props => [];
}

class TaskInitial extends TaskState {}

class TaskLoaded extends TaskState {
  final List<TaskItem> tasks;

  const TaskLoaded({this.tasks = const <TaskItem>[]});

  @override
  List<Object> get props => [tasks];
}
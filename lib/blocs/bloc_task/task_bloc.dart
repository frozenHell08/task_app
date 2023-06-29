import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:task_app/realm/taskmodel.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  TaskBloc() : super(TaskInitial()) {
    on<LoadTasks>(_onLoadTasks);
    on<AddTask>(_onAddTask);
    on<UpdateTask>(_onUpdateTask);
    on<DeleteTask>(_onDeleteTask);
  }

  void _onLoadTasks(LoadTasks event, Emitter<TaskState> emit) {
    emit(
      TaskLoaded(tasks: event.tasks),
    );
  }

  void _onAddTask(AddTask event, Emitter<TaskState> emit) {
    
  }

  void _onUpdateTask(UpdateTask event, Emitter<TaskState> emit) {
    
  }

  void _onDeleteTask(DeleteTask event, Emitter<TaskState> emit) {
    
  }
}

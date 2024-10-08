import 'package:task_manager/common/api/api_endpoints.dart';
import 'package:task_manager/common/utils/api_service.dart';
import 'package:task_manager/common/utils/cache_helper.dart';
import 'package:task_manager/common/utils/functions.dart';

import 'package:task_manager/features/home/data/models/todo_model.dart';
import 'package:task_manager/features/home/data/models/todos.dart';

abstract class HomeRemoteDataSource {
  Future<TodoModel> getTasksData(int page);
  Future<Todos> addTask(Todos task);
}

class HomeRemoteDataSourceImpl extends HomeRemoteDataSource {
  final ApiService apiService;

  HomeRemoteDataSourceImpl(this.apiService);
  @override
  Future<TodoModel> getTasksData(int page) async {
    int limit = 10;

    var response = await apiService.get(
        endPoint: "${Endpoints.getTasks}?limit=$limit &skip=$page");
    TodoModel todoModel = TodoModel.fromJson(response);

    saveLocalTasksData(todoModel.todos!);
    CacheHelper.saveData(key: 'total', value: todoModel.total);

    return todoModel;
  }

  @override
  Future<Todos> addTask(Todos task) async {
    var response =
        await apiService.post(endPoint: Endpoints.addTask, data: task.toJson());
    Todos todos = Todos.fromJson(response);
    return Todos.fromJson(response);
  }

  List<Todos> getTodosList(TodoModel todoModel) {
    List<Todos> todos = [];
    for (var todo in todoModel.todos!) {
      todos.add(todo);
    }
    return todos;
  }
}

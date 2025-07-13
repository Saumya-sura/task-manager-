import 'package:http/http.dart' as http;
import 'package:task_manager/constants/constant.dart';

class TaskRemoteRepo {
  Future<void> createTask({
    required String title,
    required String description,
    required DateTime dueAt,
  }) async {
    try{
      final res = await http.post(Uri.parse("${Constants.backendUri}/tasks"),
        headers: {
          "Content-Type": "application/json",
        },
        body: {
          "title": title,
          "description": description,
          "dueAt": dueAt.toIso8601String(),
        },
      );
    }catch(e){
      rethrow;
    }
  }
}

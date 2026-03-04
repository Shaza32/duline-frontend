import 'package:flutter/foundation.dart';

import '../models/family_task.dart';
import '../localization/app_strings.dart';
import '../services/api_client.dart';
import '../services/task_api.dart';

class GroupState extends ChangeNotifier {
  ApiClient apiClient;
  late TaskApi _taskApi;

  GroupState({required this.apiClient}) {
    _taskApi = TaskApi(client: apiClient);
  }

  void updateApi(ApiClient api) {
    apiClient = api;
    _taskApi = TaskApi(client: apiClient); // ✅ مهم
  }

  List<FamilyTask> tasks = [];

  // يتعبى من AuthState.userId
  String? currentUserId;

  AppLang currentLang = AppLang.en;

  bool _loadingTasks = false;
  String? _error;

  bool get loadingTasks => _loadingTasks;
  String? get error => _error;

  AppStrings get strings => kStrings[currentLang] ?? kStrings[AppLang.en]!;

  void switchLang(AppLang lang) {
    currentLang = lang;
    notifyListeners();
  }

  Future<void> loadTasks(int groupId) async {
    _loadingTasks = true;
    _error = null;
    notifyListeners();

    try {
      tasks = await _taskApi.getTasks(groupId);
    } catch (e) {
      _error = e.toString();
    } finally {
      _loadingTasks = false;
      notifyListeners();
    }
  }

  Future<void> addTask(
      String title, {
        DateTime? dueDate,
        required int groupId,
      }) async {
    final trimmed = title.trim();
    if (trimmed.isEmpty) return;

    try {
      final newTask = await _taskApi.createTask(
        groupId: groupId,
        title: trimmed,
        dueDate: dueDate,
      );

      tasks.add(newTask);
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> toggleTake({
    required int groupId,
    required int taskId,
  }) async {
    final index = tasks.indexWhere((t) => t.id == taskId.toString());
    if (index == -1) return;

    final task = tasks[index];
    final bool isFree = task.takenById == null;
    final bool isMine = (currentUserId != null && task.takenById == currentUserId);

    try {
      FamilyTask updated;

      if (isFree) {
        updated = await _taskApi.takeTask(groupId: groupId, taskId: taskId);
      } else if (isMine) {
        updated = await _taskApi.releaseTask(groupId: groupId, taskId: taskId);
      } else {
        return; // محجوز لحدا تاني
      }

      tasks[index] = updated;
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> deleteTask({
    required int groupId,
    required int taskId,
  }) async {
    final index = tasks.indexWhere((t) => t.id == taskId.toString());
    if (index == -1) return;

    try {
      await _taskApi.deleteTask(groupId: groupId, taskId: taskId);
      tasks.removeAt(index);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> toggleDone({
    required int groupId,
    required int taskId,
  }) async {
    final index = tasks.indexWhere((t) => t.id == taskId.toString());
    if (index == -1) return;

    try {
      final task = tasks[index];

      final FamilyTask updated = task.completed
          ? await _taskApi.undoDone(groupId: groupId, taskId: taskId)
          : await _taskApi.markDone(groupId: groupId, taskId: taskId);

      tasks[index] = updated;
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
}

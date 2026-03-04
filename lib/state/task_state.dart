import 'package:flutter/foundation.dart';

import '../localization/app_strings.dart';
import '../models/family_task.dart';
import '../services/api_client.dart';
import '../services/task_api.dart';

class TaskState extends ChangeNotifier {
  ApiClient apiClient;
  late TaskApi _taskApi;

  TaskState({required this.apiClient}) {
    _taskApi = TaskApi(client: apiClient);
  }

  void updateApi(ApiClient api) {
    apiClient = api;
    _taskApi = TaskApi(client: apiClient);
  }

  // ========= Language (SINGLE SOURCE OF TRUTH) =========
  AppLang _currentLang = AppLang.en;
  AppLang get currentLang => _currentLang;

  AppStrings get strings => kStrings[_currentLang] ?? kStrings[AppLang.en]!;

  void switchLang(AppLang lang) {
    if (_currentLang == lang) return;
    _currentLang = lang;
    notifyListeners();
  }

  // ========= Data =========
  // شاشة الغروب تعتمد عليها
  List<FamilyTask> tasks = [];

  // ✅ جديد: كل التاسكس مجمعة من كل الغروبات (لشاشة Tasks)
  final Map<int, List<FamilyTask>> tasksByGroup = {};

  bool loadingTasks = false;
  String? error;

  // ========= Helpers =========
  String displayName(String? userId) => userId ?? '-';

  List<FamilyTask> get allTasks => tasksByGroup.values.expand((e) => e).toList();

  List<FamilyTask> myTasks(String currentUserId, {bool hideCompleted = true}) {
    return allTasks.where((t) {
      if (t.takenById != currentUserId) return false;
      if (hideCompleted && t.completed) return false;
      return true;
    }).toList();
  }

  int? groupIdForTask(int taskId) {
    for (final entry in tasksByGroup.entries) {
      final gid = entry.key;
      final list = entry.value;
      if (list.any((t) => int.tryParse(t.id) == taskId)) return gid;
    }
    return null;
  }

  // ========= API Calls =========

  Future<void> loadTasks(int groupId) async {
    loadingTasks = true;
    error = null;
    notifyListeners();

    try {
      tasks = await _taskApi.getTasks(groupId);

      // ✅ نخزن نسخة ضمن tasksByGroup لتفيد شاشة MyTasks
      tasksByGroup[groupId] = tasks;
    } catch (e) {
      error = e.toString();
    } finally {
      loadingTasks = false;
      notifyListeners();
    }
  }

  // ✅ جديد: تحميل كل التاسكس من كل الغروبات
  Future<void> loadAllTasksFromGroups(List<int> groupIds) async {
    loadingTasks = true;
    error = null;
    notifyListeners();

    try {
      tasksByGroup.clear();
      for (final gid in groupIds) {
        final list = await _taskApi.getTasks(gid);
        tasksByGroup[gid] = list;
      }
    } catch (e) {
      error = e.toString();
    } finally {
      loadingTasks = false;
      notifyListeners();
    }
  }

  Future<void> addTask({
    required int groupId,
    required String title,
    DateTime? dueDate,
  }) async {
    error = null;
    notifyListeners();

    try {
      await _taskApi.createTask(
        groupId: groupId,
        title: title,
        dueDate: dueDate,
      );
      await loadTasks(groupId);
    } catch (e) {
      error = e.toString();
      notifyListeners();
    }
  }

  Future<void> toggleTake(
      int taskId, {
        required int groupId,
        required String currentUserId,
      }) async {
    error = null;
    notifyListeners();

    try {
      // ⚠️ يعتمد على tasks الحالية (شاشة الغروب)
      final t = tasks.firstWhere((x) => int.parse(x.id) == taskId);

      if (t.takenById == null) {
        await _taskApi.takeTask(groupId: groupId, taskId: taskId);
      } else if (t.takenById == currentUserId) {
        await _taskApi.releaseTask(groupId: groupId, taskId: taskId);
      }

      await loadTasks(groupId);
    } catch (e) {
      error = e.toString();
      notifyListeners();
    }
  }

  // ✅ جديد: ToggleTake من شاشة MyTasks (بدون groupId)
  Future<void> toggleTakeGlobal(
      int taskId, {
        required String currentUserId,
      }) async {
    final gid = groupIdForTask(taskId);
    if (gid == null) {
      error = 'Group not found for task $taskId';
      notifyListeners();
      return;
    }

    // لازم نحمّل tasks تبع هالغروب لأن toggleTake يعتمد على tasks
    await loadTasks(gid);
    await toggleTake(taskId, groupId: gid, currentUserId: currentUserId);
  }

  Future<void> toggleDone(
      int taskId, {
        required int groupId,
      }) async {
    error = null;
    notifyListeners();

    try {
      // ⚠️ يعتمد على tasks الحالية (شاشة الغروب)
      final t = tasks.firstWhere((x) => int.parse(x.id) == taskId);

      if (t.completed) {
        await _taskApi.undoDone(groupId: groupId, taskId: taskId);
      } else {
        await _taskApi.markDone(groupId: groupId, taskId: taskId);
      }

      await loadTasks(groupId);
    } catch (e) {
      error = e.toString();
      notifyListeners();
    }
  }

  // ✅ جديد: ToggleDone من شاشة MyTasks
  Future<void> toggleDoneGlobal(int taskId) async {
    final gid = groupIdForTask(taskId);
    if (gid == null) {
      error = 'Group not found for task $taskId';
      notifyListeners();
      return;
    }

    await loadTasks(gid);
    await toggleDone(taskId, groupId: gid);
  }

  Future<void> deleteTask(
      int taskId, {
        required int groupId,
      }) async {
    error = null;
    notifyListeners();

    try {
      await _taskApi.deleteTask(groupId: groupId, taskId: taskId);
      await loadTasks(groupId);
    } catch (e) {
      error = e.toString();
      notifyListeners();
    }
  }

  // ✅ جديد: Delete من شاشة MyTasks
  Future<void> deleteTaskGlobal(int taskId) async {
    final gid = groupIdForTask(taskId);
    if (gid == null) {
      error = 'Group not found for task $taskId';
      notifyListeners();
      return;
    }
    await deleteTask(taskId, groupId: gid);
  }
}

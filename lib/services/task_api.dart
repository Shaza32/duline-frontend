// lib/services/task_api.dart
import 'dart:convert';

import 'package:flutter/cupertino.dart';

import '../models/family_task.dart';
import 'api_client.dart';

class TaskApi {
  final ApiClient client;
  TaskApi({required this.client});

  /// GET /api/tasks?groupId=...
  Future<List<FamilyTask>> getTasks(int groupId) async {
    final res = await client.get('/api/tasks?groupId=$groupId');
    debugPrint('TASKS BODY = ${res.body}');

    if (res.statusCode == 200) {
      final list = jsonDecode(res.body) as List<dynamic>;
      return list
          .map((e) => FamilyTask.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    throw Exception('Failed to load tasks: ${res.statusCode} ${res.body}');
  }

  /// POST /api/tasks?groupId=...
  Future<FamilyTask> createTask({
    required int groupId,
    required String title,
    DateTime? dueDate,
  }) async {
    final res = await client.post(
      '/api/tasks?groupId=$groupId',
      body: {
        'title': title,
        'dueDate': dueDate?.toIso8601String(),
      },
    );

    if (res.statusCode == 200 || res.statusCode == 201) {
      return FamilyTask.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
    }
    throw Exception('Create task failed: ${res.statusCode} ${res.body}');
  }

  /// PUT /api/tasks/{id}/take?groupId=...
  Future<FamilyTask> takeTask({
    required int groupId,
    required int taskId,
  }) async {
    final res = await client.put('/api/tasks/$taskId/take?groupId=$groupId');

    if (res.statusCode == 200) {
      return FamilyTask.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
    }
    throw Exception('Take task failed: ${res.statusCode} ${res.body}');
  }

  /// PUT /api/tasks/{id}/release?groupId=...
  Future<FamilyTask> releaseTask({
    required int groupId,
    required int taskId,
  }) async {
    final res = await client.put('/api/tasks/$taskId/release?groupId=$groupId');

    if (res.statusCode == 200) {
      return FamilyTask.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
    }
    throw Exception('Release task failed: ${res.statusCode} ${res.body}');
  }

  /// PUT /api/tasks/{id}/done?groupId=...
  Future<FamilyTask> markDone({
    required int groupId,
    required int taskId,
  }) async {
    final res = await client.put('/api/tasks/$taskId/done?groupId=$groupId');

    if (res.statusCode == 200) {
      return FamilyTask.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
    }
    throw Exception('Done failed: ${res.statusCode} ${res.body}');
  }

  /// PUT /api/tasks/{id}/undo?groupId=...
  Future<FamilyTask> undoDone({
    required int groupId,
    required int taskId,
  }) async {
    final res = await client.put('/api/tasks/$taskId/undo?groupId=$groupId');

    if (res.statusCode == 200) {
      return FamilyTask.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
    }
    throw Exception('Undo failed: ${res.statusCode} ${res.body}');
  }

  /// DELETE /api/tasks/{id}?groupId=...
  Future<void> deleteTask({
    required int groupId,
    required int taskId,
  }) async {
    final res = await client.delete('/api/tasks/$taskId?groupId=$groupId');

    if (res.statusCode != 200 && res.statusCode != 204) {
      throw Exception('Delete task failed: ${res.statusCode} ${res.body}');
    }
  }
}

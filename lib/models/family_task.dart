// lib/models/family_task.dart

class FamilyTask {
  String id;
  String title;

  // IDs
  String createdById;
  String? takenById;

  // ✅ Names (NEW)
  String? createdByName;
  String? takenByName;

  DateTime createdAt;
  DateTime? dueDate;

  bool completed;

  FamilyTask({
    required this.id,
    required this.title,
    required this.createdById,
    required this.createdAt,
    this.dueDate,
    this.takenById,
    this.createdByName,
    this.takenByName,
    this.completed = false,
  });

  factory FamilyTask.fromJson(Map<String, dynamic> json) {
    return FamilyTask(
      id: json['id'].toString(),
      title: (json['title'] ?? '') as String,

      createdById: json['createdById']?.toString() ?? '',
      createdByName: json['createdByName'] as String?, // ✅

      takenById: json['takenById']?.toString(),
      takenByName: json['takenByName'] as String?, // ✅

      createdAt: DateTime.parse(json['createdAt'] as String),
      dueDate: json['dueDate'] != null
          ? DateTime.parse(json['dueDate'] as String)
          : null,

      completed: (json['completed'] ?? false) as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': int.tryParse(id),
      'title': title,
      'createdById': createdById,
      'createdByName': createdByName, // ✅ optional

      'createdAt': createdAt.toIso8601String(),
      'dueDate': dueDate?.toIso8601String(),

      'takenById': takenById,
      'takenByName': takenByName, // ✅ optional

      'completed': completed,
    };
  }
}

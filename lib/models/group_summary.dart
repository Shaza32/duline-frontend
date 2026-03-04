class GroupSummary {
  final int id;
  final String name;
  final String code;
  final String role;

  GroupSummary({
    required this.id,
    required this.name,
    required this.code,
    required this.role,
  });

  factory GroupSummary.fromJson(Map<String, dynamic> json) {
    return GroupSummary(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      code: json['code'] as String,
      role: json['role'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'code': code,
    'role': role,
  };
}

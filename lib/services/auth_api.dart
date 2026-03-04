// lib/services/auth_api.dart
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../models/group_summary.dart';

import 'config.dart'; // ✅ هون apiBaseUrl


class AuthResult {
  final int userId;
  final String email;
  final String name;

  final String accessToken;
  final String refreshToken;

  final List<GroupSummary> groups;

  AuthResult({
    required this.userId,
    required this.email,
    required this.name,
    required this.accessToken,
    required this.refreshToken,
    required this.groups,
  });

  factory AuthResult.fromJson(Map<String, dynamic> json) {
    final groupsJson = (json['groups'] as List?) ?? [];
    return AuthResult(
      userId: (json['id'] as num).toInt(),
      email: (json['email'] ?? '') as String,
      name: (json['name'] ?? '') as String,
      accessToken: (json['accessToken'] ?? '') as String,
      refreshToken: (json['refreshToken'] ?? '') as String,
      groups: groupsJson
          .map((g) => GroupSummary.fromJson(g as Map<String, dynamic>))
          .toList(),
    );
  }
}

class AuthApi {
  // ✅ حطي هاد هون (قبل register)
  static String _extractMsg(String body) {
    try {
      final j = jsonDecode(body);
      if (j is Map && j['message'] != null) return j['message'].toString();
    } catch (_) {}
    return body;
  }

  static Future<AuthResult> register({
    required String email,
    required String password,
    required String name,
    String? inviteCode,
    String? familyName,
  }) async {
    final url = Uri.parse('$apiBaseUrl/api/auth/register');

    final res = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
        'name': name,
        'inviteCode': inviteCode,
        'familyName': familyName,
      }),
    );

    if (res.statusCode == 200 || res.statusCode == 201) {
      return AuthResult.fromJson(jsonDecode(res.body));
    }
    throw Exception(_extractMsg(res.body));
  }


  static Future<AuthResult> login({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('$apiBaseUrl/api/auth/login');

    final res = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (res.statusCode == 200) {
      return AuthResult.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
    }
    throw Exception(_extractMsg(res.body));
  }

  // ✅ نفس الاسم اللي ApiClient عم يناديه
  static Future<String> refresh({required String refreshToken}) async {
    final url = Uri.parse('$apiBaseUrl/api/auth/refresh');

    final res = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({'refreshToken': refreshToken}),
    );

    debugPrint('REFRESH status=${res.statusCode} body=${res.body}');

    if (res.statusCode != 200) {
      throw Exception('Refresh failed: ${res.statusCode} ${res.body}');
    }

    final data = jsonDecode(res.body) as Map<String, dynamic>;
    final token = (data['accessToken'] ?? '') as String;

    if (token.isEmpty) {
      throw Exception('Refresh returned empty accessToken. Body=${res.body}');
    }

    return token;
  }

  static Future<void> forgotPassword(String email) async {
    final res = await http.post(
      Uri.parse('$apiBaseUrl/api/auth/forgot-password'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );

    // الـ backend بيرجع 200 حتى لو الإيميل مو موجود
    if (res.statusCode != 200) {
      throw Exception('forgot-password failed: ${res.statusCode} ${res.body}');
    }
  }

  static Future<String> verifyResetCode(String email, String code) async {
    final res = await http.post(
      Uri.parse('$apiBaseUrl/api/auth/verify-reset-code'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'code': code}),
    );

    if (res.statusCode >= 400) {
      throw Exception('Invalid code');
    }

    final data = jsonDecode(res.body) as Map<String, dynamic>;
    return (data['resetSessionToken'] ?? '') as String;
  }

  static Future<void> resetPassword(String resetSessionToken, String newPassword) async {
    final res = await http.post(
      Uri.parse('$apiBaseUrl/api/auth/reset-password'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'resetSessionToken': resetSessionToken,
        'newPassword': newPassword,
      }),
    );

    if (res.statusCode >= 400) {
      throw Exception('Reset failed');
    }
  }


}

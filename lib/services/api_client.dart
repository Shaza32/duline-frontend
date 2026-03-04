import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../state/auth_state.dart';
import 'auth_api.dart';
import 'config.dart';
import 'dart:io';

class ApiClient {
  final AuthState auth;

  ApiClient({required this.auth});

  Future<http.Response> get(String path) async {
    debugPrint('GET  $path');
    return _sendWithRefresh(() => http.get(
      Uri.parse('$apiBaseUrl$path'),
      headers: _headers(),
    ));
  }

  Future<http.Response> post(String path, {Object? body}) async {
    debugPrint('POST $path');
    return _sendWithRefresh(() => http.post(
      Uri.parse('$apiBaseUrl$path'),
      headers: _headers(),
      body: body == null ? null : jsonEncode(body),
    ));
  }


  Future<http.Response> patch(String path, {Object? body}) async {
    return _sendWithRefresh(() => http.patch(
      Uri.parse('$apiBaseUrl$path'),
      headers: _headers(),
      body: body == null ? null : jsonEncode(body),
    ));
  }

  Future<http.Response> delete(String path) async {
    return _sendWithRefresh(() => http.delete(
      Uri.parse('$apiBaseUrl$path'),
      headers: _headers(),
    ));
  }

  Future<http.Response> put(String path, {Map<String, dynamic>? body}) async {
    return _sendWithRefresh(() => http.put(
      Uri.parse('$apiBaseUrl$path'),
      headers: _headers(),
      body: jsonEncode(body ?? {}),
    ));
  }




  Map<String, String> _headers() {
    final h = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    var token = auth.accessToken;
    if (token != null) {
      token = token.trim();
      if (token.toLowerCase().startsWith('bearer ')) {
        token = token.substring(7).trim();
      }
    }

    debugPrint('ApiClient accessToken len = ${token?.length ?? 0}');
    debugPrint('ApiClient refreshToken len = ${auth.refreshToken?.length ?? 0}');

    if (token != null && token.isNotEmpty) {
      h['Authorization'] = 'Bearer $token';
    }
    return h;
  }


  Future<http.Response> uploadImage(String path, File file) async {
    return _sendWithRefresh(() async {
      final uri = Uri.parse('$apiBaseUrl$path');

      final req = http.MultipartRequest('POST', uri);

      // ✅ خذ التوكن الحالي كل مرة (مهم للـ retry بعد refresh)
      var token = auth.accessToken;
      if (token != null) {
        token = token.trim();
        if (token.toLowerCase().startsWith('bearer ')) {
          token = token.substring(7).trim();
        }
        if (token.isNotEmpty) {
          req.headers['Authorization'] = 'Bearer $token';
        }
      }

      req.headers['Accept'] = 'application/json';

      // ✅ مهم: حطّي contentType للملف (اختياري بس مفيد)
      req.files.add(await http.MultipartFile.fromPath('file', file.path));

      final streamed = await req.send();
      return http.Response.fromStream(streamed);
    });
  }

  Future<http.Response> _sendWithRefresh(Future<http.Response> Function() request) async {
    debugPrint('---- SENDING REQUEST ----');
    // اطبعي الهيدر اللي رح يطلع من _headers()
    final hh = _headers();
    debugPrint('Auth header = ${hh['Authorization']}');
    debugPrint('-------------------------');

    final res = await request();

    if (res.statusCode != 401) return res;

    debugPrint('401 body: ${res.body}');

    final ok = await _tryRefresh();
    if (!ok) return res;

    debugPrint('After refresh -> trying again...');
    final hh2 = _headers();
    debugPrint('Auth header (retry) = ${hh2['Authorization']}');

    final retry = await request();
    debugPrint('Retry status: ${retry.statusCode}');
    debugPrint('Retry body: ${retry.body}');
    return retry;
  }


  Future<bool> _tryRefresh() async {
    final rt = auth.refreshToken;
    if (rt == null || rt.isEmpty) return false;

    try {
      final newAccess = await AuthApi.refresh(refreshToken: rt); // ✅ استدعاء
      await auth.setAccessToken(newAccess);                      // ✅ تحديث
      return true;
    } catch (_) {
      await auth.logout(); // refresh فشل => logout
      return false;
    }
  }

}

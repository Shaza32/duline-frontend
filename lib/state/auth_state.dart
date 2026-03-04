import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/group_summary.dart';

class AuthState extends ChangeNotifier {
  // ========= User =========
  String? userId;
  String? email;
  String? name;

  // ========= Tokens (JWT) =========
  String? accessToken;
  String? refreshToken;

  // ========= Groups =========
  List<GroupSummary> groups = [];

  // ========= Profile image (local path) =========
  // (اختياري: إذا بدك تعرضي الصورة فوراً بعد اختيارها قبل ما يخلص الرفع)
  String? profileImagePath;

  // ========= Avatar from backend (URL or relative path) =========
  // هذا هو اللي رح نعتمد عليه للعرض النهائي بعد الرفع
  String? avatarUrl;

  // ========= SharedPreferences keys =========
  static const _kUserId = 'userId';
  static const _kEmail = 'email';
  static const _kName = 'name';
  static const _kAccessToken = 'accessToken';
  static const _kRefreshToken = 'refreshToken';
  static const _kProfileImagePath = 'profileImagePath';

  // ✅ groups
  static const _kGroupsJson = 'groupsJson';

  // ✅ avatarUrl
  static const _kAvatarUrl = 'avatarUrl';

  // ❗ مفاتيح قديمة (Family) — نخليها بس للمسح والتنظيف
  static const _kFamilyId = 'familyId';
  static const _kFamilyName = 'familyName';
  static const _kFamilyCode = 'familyCode';

  bool get isLoggedIn => accessToken != null && refreshToken != null;

  // ========= Boot / Auto login =========
  Future<void> autoLogin() async {
    final prefs = await SharedPreferences.getInstance();

    userId = prefs.getString(_kUserId);
    email = prefs.getString(_kEmail);
    name = prefs.getString(_kName);

    accessToken = prefs.getString(_kAccessToken);
    refreshToken = prefs.getString(_kRefreshToken);

    profileImagePath = prefs.getString(_kProfileImagePath);

    // ✅ اقرأ avatarUrl
    avatarUrl = prefs.getString(_kAvatarUrl);

    // ✅ اقرأ groups
    final groupsStr = prefs.getString(_kGroupsJson);
    if (groupsStr != null && groupsStr.isNotEmpty) {
      try {
        final list = jsonDecode(groupsStr) as List<dynamic>;
        groups = list
            .map((e) => GroupSummary.fromJson(e as Map<String, dynamic>))
            .toList();
      } catch (_) {
        groups = [];
      }
    } else {
      groups = [];
    }

    // تنظيف بيانات قديمة من النسخة السابقة (Family)
    await prefs.remove(_kFamilyId);
    await prefs.remove(_kFamilyName);
    await prefs.remove(_kFamilyCode);

    notifyListeners();
  }

  // ========= Name =========
  Future<void> setName(String newName) async {
    name = newName;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kName, newName);
    notifyListeners();
  }

  // ✅ Alias للـ UI اللي كتبتيه
  Future<void> setNameLocal(String newName) => setName(newName);

  // ========= AvatarUrl (from backend) =========
  Future<void> setAvatarUrl(String newUrl) async {
    avatarUrl = newUrl;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kAvatarUrl, newUrl);
    notifyListeners();
  }

  // ========= Profile Image (local path) =========
  Future<void> loadProfileImage() async {
    final prefs = await SharedPreferences.getInstance();
    profileImagePath = prefs.getString(_kProfileImagePath);
    notifyListeners();
  }

  Future<void> setProfileImage(String path) async {
    profileImagePath = path;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kProfileImagePath, path);
    notifyListeners();
  }

  Future<void> clearProfileImage() async {
    profileImagePath = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kProfileImagePath);
    notifyListeners();
  }

  // ========= Auth =========
  Future<void> setUser({
    required String id,
    required String email,
    required String name,
    required String accessToken,
    required String refreshToken,
    required List<GroupSummary> groups,
    String? avatarUrl, // ✅ جديد (إذا الباك اند رجعه)
  }) async {
    userId = id;
    this.email = email;
    this.name = name;
    this.accessToken = accessToken;
    this.refreshToken = refreshToken;
    this.groups = groups;

    // ✅ خزني avatarUrl لو موجود
    this.avatarUrl = avatarUrl;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kUserId, id);
    await prefs.setString(_kEmail, email);
    await prefs.setString(_kName, name);
    await prefs.setString(_kAccessToken, accessToken);
    await prefs.setString(_kRefreshToken, refreshToken);

    // ✅ خزّن groups
    final groupsJson = jsonEncode(groups
        .map((g) => {
      'id': g.id,
      'name': g.name,
      'code': g.code,
      'role': g.role,
    })
        .toList());
    await prefs.setString(_kGroupsJson, groupsJson);

    // ✅ خزّن avatarUrl أو امسحه
    if (avatarUrl != null && avatarUrl.isNotEmpty) {
      await prefs.setString(_kAvatarUrl, avatarUrl);
    } else {
      await prefs.remove(_kAvatarUrl);
    }

    // تنظيف family keys لو كانوا موجودين
    await prefs.remove(_kFamilyId);
    await prefs.remove(_kFamilyName);
    await prefs.remove(_kFamilyCode);

    notifyListeners();
  }

  Future<void> setAccessToken(String newAccessToken) async {
    accessToken = newAccessToken;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kAccessToken, newAccessToken);
    notifyListeners();
  }

  Future<void> setGroupsFromJson(String body) async {
    final decoded = jsonDecode(body) as List<dynamic>;
    final newGroups = decoded
        .map((e) => GroupSummary.fromJson(e as Map<String, dynamic>))
        .toList();
    await setGroups(newGroups);
  }

  // ✅ إذا رجعلك AuthResponse جديد (login/register) وبدك تحدثي groups لحالها
  Future<void> setGroups(List<GroupSummary> newGroups) async {
    groups = newGroups;
    final prefs = await SharedPreferences.getInstance();
    final groupsJson = jsonEncode(newGroups
        .map((g) => {
      'id': g.id,
      'name': g.name,
      'code': g.code,
      'role': g.role,
    })
        .toList());
    await prefs.setString(_kGroupsJson, groupsJson);
    notifyListeners();
  }

  Future<void> logout({bool clearAvatar = false}) async {
    await clear();
    if (clearAvatar) {
      await clearProfileImage(); // local path
      await clearAvatarUrl();    // ✅ new
    }
  }
  Future<void> clearAvatarUrl() async {
    avatarUrl = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kAvatarUrl);
    notifyListeners();
  }

  Future<void> clear() async {
    userId = null;
    email = null;
    name = null;
    accessToken = null;
    refreshToken = null;
    groups = [];
    avatarUrl = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kUserId);
    await prefs.remove(_kEmail);
    await prefs.remove(_kName);
    await prefs.remove(_kAccessToken);
    await prefs.remove(_kRefreshToken);
    await prefs.remove(_kGroupsJson);
    await prefs.remove(_kAvatarUrl);

    // تنظيف family keys لو كانوا موجودين
    await prefs.remove(_kFamilyId);
    await prefs.remove(_kFamilyName);
    await prefs.remove(_kFamilyCode);

    notifyListeners();
  }
}

// lib/screens/main_shell.dart
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/auth_state.dart';
import '../services/api_client.dart';

import 'tasks/my_tasks_screen.dart';
import 'groups/group_list_screen.dart';
import 'groups/group_tasks_screen.dart';
import 'profile_screen.dart';

import '../localization/strings_ext.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  int? _selectedGroupId;
  String? _selectedGroupName;

  static const Color _brandGold = Color(0xFFD4AF37);
  static const Color _darkBg = Color(0xFF2F2F2F);
  static const Color _cardBg = Color(0xFF3A3A3A);

  void openGroup(int groupId, String groupName) {
    setState(() {
      _index = 0;
      _selectedGroupId = groupId;
      _selectedGroupName = groupName;
    });
  }

  void closeGroup() {
    setState(() {
      _selectedGroupId = null;
      _selectedGroupName = null;
    });
  }

  void _onTabSelected(int i) {
    setState(() => _index = i);
  }

  String _title(BuildContext context) {
    final s = context.strings;
    if (_index == 0) return _selectedGroupName ?? s.titleMyGroups;
    if (_index == 1) return s.titleTasks;
    return s.titleProfile;
    // (بس مانو رح ينعرض لما _index==2 لأن AppBar رح يكون null)
  }

  void _toast(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: _cardBg,
        content: Text(msg, style: const TextStyle(color: Colors.white)),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _openJoinCreateDialog(BuildContext context) async {
    final sRoot = context.stringsRead;

    final joinCtrl = TextEditingController();
    final createCtrl = TextEditingController();

    String? err;
    bool loading = false;

    await showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setState) {
            final s = ctx.stringsRead;

            Future<void> join() async {
              final code = joinCtrl.text.trim();
              if (code.isEmpty) {
                setState(() => err = s.enterInviteCode);
                return;
              }

              setState(() {
                err = null;
                loading = true;
              });

              try {
                final api = ctx.read<ApiClient>();
                final res = await api.post('/api/groups/join', body: {'code': code});
                if (res.statusCode != 200 && res.statusCode != 201) {
                  throw Exception('${res.statusCode} ${res.body}');
                }

                final res2 = await api.get('/api/groups/my');
                if (res2.statusCode != 200) {
                  throw Exception('${res2.statusCode} ${res2.body}');
                }

                final auth = ctx.read<AuthState>();
                await auth.setGroupsFromJson(res2.body);

                if (ctx.mounted) Navigator.pop(ctx);
                if (context.mounted) _toast(context, sRoot.joinedSuccessfully);
              } catch (e) {
                setState(() => err = '${s.joinFailedPrefix} $e');
              } finally {
                setState(() => loading = false);
              }
            }

            Future<void> create() async {
              final name = createCtrl.text.trim();
              if (name.isEmpty) {
                setState(() => err = s.enterGroupName);
                return;
              }

              setState(() {
                err = null;
                loading = true;
              });

              try {
                final api = ctx.read<ApiClient>();
                final res = await api.post('/api/groups', body: {'name': name});
                if (res.statusCode != 200 && res.statusCode != 201) {
                  throw Exception('${res.statusCode} ${res.body}');
                }

                final res2 = await api.get('/api/groups/my');
                if (res2.statusCode != 200) {
                  throw Exception('${res2.statusCode} ${res2.body}');
                }

                final auth = ctx.read<AuthState>();
                await auth.setGroupsFromJson(res2.body);

                if (ctx.mounted) Navigator.pop(ctx);
                if (context.mounted) _toast(context, sRoot.createdSuccessfully);
              } catch (e) {
                setState(() => err = '${s.createFailedPrefix} $e');
              } finally {
                setState(() => loading = false);
              }
            }

            InputDecoration dec(String hint) => InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.35)),
              filled: true,
              fillColor: Colors.white.withOpacity(0.06),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: Colors.white.withOpacity(0.10)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: _brandGold),
              ),
            );

            return AlertDialog(
              backgroundColor: _darkBg,
              title: Text(s.addGroupTitle, style: const TextStyle(color: Colors.white)),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (err != null)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.red.withOpacity(0.25)),
                        ),
                        child: Text(err!, style: const TextStyle(color: Colors.redAccent)),
                      ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        s.joinByCodeTitle,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.85),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: joinCtrl,
                      style: const TextStyle(color: Colors.white),
                      decoration: dec(s.inviteCodeHint),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: loading ? null : join,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _brandGold,
                          foregroundColor: _darkBg,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          elevation: 0,
                        ),
                        child: loading
                            ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                            : Text(
                          s.joinBtn,
                          style: const TextStyle(letterSpacing: 1.2, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Divider(color: Colors.white.withOpacity(0.12)),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        s.createNewGroupTitle,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.85),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: createCtrl,
                      style: const TextStyle(color: Colors.white),
                      decoration: dec(s.groupNameHint),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: loading ? null : create,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _brandGold,
                          foregroundColor: _darkBg,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          elevation: 0,
                        ),
                        child: loading
                            ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                            : Text(
                          s.createBtn,
                          style: const TextStyle(letterSpacing: 1.2, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: loading ? null : () => Navigator.pop(ctx),
                  child: Text(s.closeBtn, style: TextStyle(color: Colors.white.withOpacity(0.75))),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthState>();
    final s = context.strings;

    final groupsPage = (_selectedGroupId == null)
        ? GroupListScreen(onOpenGroup: openGroup)
        : GroupTasksScreen(
      groupId: _selectedGroupId!,
      groupName: _selectedGroupName,
    );

    final pages = <Widget>[
      groupsPage,
      const MyTasksScreen(),
      const ProfileScreen(),
    ];

    final showBack = _index == 0 && _selectedGroupId != null;

    final avatarUrl = auth.avatarUrl;
    final localPath = auth.profileImagePath;

    ImageProvider? avatarProvider;
    if (avatarUrl != null && avatarUrl.isNotEmpty) {
      avatarProvider = NetworkImage(avatarUrl);
    } else if (localPath != null && localPath.isNotEmpty && File(localPath).existsSync()) {
      avatarProvider = FileImage(File(localPath));
    }

    return Theme(
      data: Theme.of(context).copyWith(
        scaffoldBackgroundColor: _darkBg,
        appBarTheme: const AppBarTheme(
          backgroundColor: _darkBg,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
        ),
      ),
      child: Scaffold(
        backgroundColor: _darkBg,

        // ✅ اهم تعديل: لما نكون على Profile (index=2) نخلي AppBar تبع MainShell = null
        appBar: (_index == 2)
            ? null
            : AppBar(
          leading: showBack
              ? IconButton(
            icon: const Icon(Icons.arrow_back, color: _brandGold),
            onPressed: closeGroup,
          )
              : null,
          title: Text(
            _title(context),
            style: const TextStyle(color: _brandGold, letterSpacing: 1.2),
          ),
          actions: [
            IconButton(
              onPressed: () => setState(() => _index = 2),
              icon: CircleAvatar(
                radius: 16,
                backgroundColor: Colors.white.withOpacity(0.08),
                backgroundImage: avatarProvider,
                child: avatarProvider == null
                    ? Text(
                  (auth.name?.isNotEmpty ?? false)
                      ? auth.name!.trim().characters.first.toUpperCase()
                      : s.unknownUserInitial,
                  style: const TextStyle(
                    color: _brandGold,
                    fontWeight: FontWeight.w700,
                  ),
                )
                    : null,
              ),
            ),
            const SizedBox(width: 8),
          ],
        ),

        body: SafeArea(
          child: Material(
            color: _darkBg,
            child: IndexedStack(
              index: _index,
              children: pages,
            ),
          ),
        ),
        floatingActionButton: (_index == 0 && _selectedGroupId == null)
            ? FloatingActionButton(
          backgroundColor: _brandGold,
          foregroundColor: _darkBg,
          onPressed: () => _openJoinCreateDialog(context),
          child: const Icon(Icons.add),
        )
            : null,
        bottomNavigationBar: NavigationBarTheme(
          data: NavigationBarThemeData(
            backgroundColor: _darkBg,
            indicatorColor: Colors.white.withOpacity(0.08),
            labelTextStyle: WidgetStateProperty.resolveWith((states) {
              final selected = states.contains(WidgetState.selected);
              return TextStyle(
                color: selected ? _brandGold : Colors.white.withOpacity(0.55),
                fontSize: 12,
                letterSpacing: 0.5,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              );
            }),
            iconTheme: WidgetStateProperty.resolveWith((states) {
              final selected = states.contains(WidgetState.selected);
              return IconThemeData(
                color: selected ? _brandGold : Colors.white.withOpacity(0.55),
              );
            }),
          ),
          child: NavigationBar(
            selectedIndex: _index,
            onDestinationSelected: _onTabSelected,
            destinations: [
              NavigationDestination(
                icon: const Icon(Icons.groups_outlined),
                selectedIcon: const Icon(Icons.groups),
                label: s.navGroups,
              ),
              NavigationDestination(
                icon: const Icon(Icons.checklist_outlined),
                selectedIcon: const Icon(Icons.checklist),
                label: s.navTasks,
              ),
              NavigationDestination(
                icon: const Icon(Icons.person_outline),
                selectedIcon: const Icon(Icons.person),
                label: s.navProfile,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../state/auth_state.dart';
import '../../state/task_state.dart';
import '../../localization/strings_ext.dart';

class MyTasksScreen extends StatefulWidget {
  const MyTasksScreen({super.key});

  @override
  State<MyTasksScreen> createState() => _MyTasksScreenState();
}

class _MyTasksScreenState extends State<MyTasksScreen> {
  static const Color _brandGold = Color(0xFFD4AF37);
  static const Color _darkBg = Color(0xFF2F2F2F);
  static const Color _cardBg = Color(0xFF3A3A3A);

  bool _loaded = false;

  Future<void> _reload() async {
    final auth = context.read<AuthState>();
    final tasks = context.read<TaskState>();

    if (auth.userId == null) return;

    // الغروبات من AuthState
    final groupIds = auth.groups.map((g) => g.id).toList();
    if (groupIds.isEmpty) return;

    await tasks.loadAllTasksFromGroups(groupIds);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_loaded) return;
    _loaded = true;

    Future.microtask(() async => _reload());
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthState>();
    final tasks = context.watch<TaskState>();
    final s = context.strings;

    if (auth.userId == null) {
      return Center(
        child: Text(
          s.pleaseLoginAgain,
          style: TextStyle(color: Colors.white.withOpacity(0.7)),
        ),
      );
    }

    final my = tasks.myTasks(auth.userId!);

    return Container(
      color: _darkBg,
      child: Column(
        children: [
          // Header نفس ستايل group_tasks_screen
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    s.titleTasks,
                    style: const TextStyle(
                      color: _brandGold,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  auth.name ?? auth.email ?? auth.userId!,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 12,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(width: 6),
                IconButton(
                  icon: const Icon(Icons.refresh, color: _brandGold, size: 20),
                  onPressed: _reload,
                  tooltip: 'Refresh',
                ),
              ],
            ),
          ),

          Expanded(
            child: tasks.loadingTasks
                ? const Center(child: CircularProgressIndicator(color: _brandGold))
                : my.isEmpty
                ? Center(
              child: Text(
                s.noTasksYet,
                style: TextStyle(color: Colors.white.withOpacity(0.55)),
              ),
            )
                : ListView(
              padding: const EdgeInsets.fromLTRB(12, 6, 12, 12),
              children: my.map((task) {
                final due = task.dueDate;

                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: _cardBg,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.white.withOpacity(0.08)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          [
                            if (due != null)
                              '${s.duePrefix}: ${due.toString().substring(0, 16)}',
                          ].join('\n'),
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 12,
                            height: 1.35,
                          ),
                        ),
                        const SizedBox(height: 12),

                        Row(
                          children: [
                            TextButton.icon(
                              onPressed: () async {
                                await context
                                    .read<TaskState>()
                                    .toggleDoneGlobal(int.parse(task.id));
                                await _reload();
                              },
                              style: TextButton.styleFrom(
                                foregroundColor: _brandGold,
                              ),
                              icon: Icon(
                                task.completed
                                    ? Icons.check_circle
                                    : Icons.check_circle_outline,
                                size: 18,
                                color: _brandGold,
                              ),
                              label: Text(s.doneBtn),
                            ),

                            const SizedBox(width: 6),

                            TextButton(
                              onPressed: () async {
                                await context.read<TaskState>().toggleTakeGlobal(
                                  int.parse(task.id),
                                  currentUserId: auth.userId!,
                                );
                                await _reload();
                              },
                              style: TextButton.styleFrom(
                                foregroundColor: _brandGold,
                              ),
                              child: Text(s.releaseTask),
                            ),

                            const Spacer(),

                            IconButton(
                              onPressed: () async {
                                await context
                                    .read<TaskState>()
                                    .deleteTaskGlobal(int.parse(task.id));
                                await _reload();
                              },
                              icon: Icon(
                                Icons.delete_outline,
                                color: Colors.red.withOpacity(0.9),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

// lib/screens/groups/group_tasks_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../state/auth_state.dart';
import '../../state/task_state.dart';
import '../../localization/strings_ext.dart';

class GroupTasksScreen extends StatefulWidget {
  final int groupId;
  final String? groupName;

  const GroupTasksScreen({
    super.key,
    required this.groupId,
    this.groupName,
  });

  @override
  State<GroupTasksScreen> createState() => _GroupTasksScreenState();
}

class _GroupTasksScreenState extends State<GroupTasksScreen> {
  final taskCtrl = TextEditingController();
  DateTime? _selectedDueAt;

  static const Color _brandGold = Color(0xFFD4AF37);
  static const Color _darkBg = Color(0xFF2F2F2F);
  static const Color _fieldBg = Color(0xFF3A3A3A);

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      if (!mounted) return;
      await context.read<TaskState>().loadTasks(widget.groupId);
    });
  }

  @override
  void dispose() {
    taskCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDueAt(BuildContext context) async {
    final now = DateTime.now();

    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDueAt ?? now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: _brandGold,
              surface: _darkBg,
              onSurface: Colors.white,
            ), dialogTheme: DialogThemeData(backgroundColor: _darkBg),
          ),
          child: child!,
        );
      },
    );
    if (date == null || !mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: _selectedDueAt != null
          ? TimeOfDay.fromDateTime(_selectedDueAt!)
          : TimeOfDay.fromDateTime(now.add(const Duration(hours: 1))),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: _brandGold,
              surface: _darkBg,
              onSurface: Colors.white,
            ), dialogTheme: DialogThemeData(backgroundColor: _darkBg),
          ),
          child: child!,
        );
      },
    );
    if (time == null || !mounted) return;

    final combined = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );

    setState(() => _selectedDueAt = combined);
  }


  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthState>();
    final tasksState = context.watch<TaskState>();
    final s = context.strings;

    final groupTitle = widget.groupName ?? s.groupDefaultTitle;

    return Scaffold(
      backgroundColor: _darkBg,
      body: SafeArea(
        child: auth.userId == null
            ? Center(
          child: Text(
            s.pleaseLoginAgain,
            style: TextStyle(color: Colors.white.withOpacity(0.7)),
          ),
        )
            : CustomScrollView(
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        groupTitle,
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
                    Flexible(
                      child: Text(
                        auth.name ?? auth.email ?? auth.userId!,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 12,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Add task bar
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: taskCtrl,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: s.newTaskPlaceholder,
                          hintStyle: TextStyle(
                            color: Colors.white.withOpacity(0.35),
                          ),
                          prefixIcon: const Icon(
                            Icons.edit_outlined,
                            color: _brandGold,
                            size: 18,
                          ),
                          filled: true,
                          fillColor: _fieldBg,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),

                    _squareIconButton(
                      icon: Icons.calendar_today_outlined,
                      onTap: () => _pickDueAt(context),
                    ),
                    const SizedBox(width: 10),

                    _goldButton(
                      text: s.addBtn,
                      onPressed: () async {
                        final title = taskCtrl.text.trim();
                        if (title.isEmpty) return;

                        await tasksState.addTask(
                          groupId: widget.groupId,
                          title: title,
                          dueDate: _selectedDueAt,
                        );

                        if (!mounted) return;

                        if (tasksState.error != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: _fieldBg,
                              behavior: SnackBarBehavior.floating,
                              content: Text(
                                '${s.errorPrefix}: ${tasksState.error}',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          );
                          return;
                        }

                        taskCtrl.clear();
                        setState(() => _selectedDueAt = null);
                        await tasksState.loadTasks(widget.groupId);
                      },
                    ),
                  ],
                ),
              ),
            ),

            if (_selectedDueAt != null)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '${s.duePrefix}: ${_selectedDueAt!.toString().substring(0, 10)}',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.55),
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ),

            const SliverToBoxAdapter(child: SizedBox(height: 10)),

            if (tasksState.loadingTasks)
              const SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: CircularProgressIndicator(color: _brandGold),
                ),
              )
            else if (tasksState.tasks.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Text(
                    // ✅ مترجم
                    // لازم يكون موجود عندك بالـ strings
                    // إذا اسم المفتاح عندك مختلف قوليلي بغيره فوراً
                    // ignore: unnecessary_string_interpolations
                    '',
                    style: const TextStyle(color: Colors.white54),
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(12, 6, 12, 12),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      final task = tasksState.tasks[index];

                      final now = DateTime.now();
                      final due = task.dueDate;

                      // تجاهلي التنبيه إذا التاسك مكتمل
                      final showDue = due != null && !task.completed;

                      final isOverdue = showDue && due.isBefore(now);

                      // "قريب" خلال 24 ساعة
                      final isSoon = showDue &&
                          !isOverdue &&
                          due.difference(now).inHours <= 24;

                      final borderColor = isOverdue
                          ? Colors.redAccent
                          : isSoon
                          ? Colors.orangeAccent
                          : Colors.white.withOpacity(0.08);

                      final creator =
                      tasksState.displayName(task.createdByName );
                      final takenBy = task.takenByName  == null
                          ? null
                          : tasksState.displayName(task.takenByName );

                      final isMine = task.takenByName  == auth.userId;

                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: _fieldBg,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: borderColor,
                            width: (isOverdue || isSoon) ? 1.4 : 1,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                task.title,
                                style: TextStyle(
                                  color: task.completed
                                      ? Colors.white.withOpacity(0.45)
                                      : Colors.white,
                                  fontWeight: FontWeight.w700,
                                  decoration: task.completed
                                      ? TextDecoration.lineThrough
                                      : null,
                                ),
                              ),

                              if (isOverdue) ...[
                                const SizedBox(height: 6),
                                Text(
                                  s.taskOverdue,
                                  style: const TextStyle(
                                    color: Colors.redAccent,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ] else if (isSoon) ...[
                                const SizedBox(height: 6),
                                Text(
                                  s.taskDueSoon,
                                  style: const TextStyle(
                                    color: Colors.orangeAccent,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],

                              const SizedBox(height: 8),
                              Text(
                                [
                                  '${s.addedBy}: $creator',
                                  '${s.createdAt}: ${task.createdAt.toString().substring(0, 16)}',
                                  if (due != null)
                                    '${s.duePrefix}: ${due.toString().substring(0, 16)}',
                                  takenBy == null
                                      ? s.taskFree
                                      : '${s.taskTakenBy}: $takenBy',
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
                                  TextButton(
                                    onPressed: () async {
                                      await tasksState.toggleTake(
                                        int.parse(task.id),
                                        groupId: widget.groupId,
                                        currentUserId: auth.userId!,
                                      );
                                    },
                                    style: TextButton.styleFrom(
                                      foregroundColor: _brandGold,
                                    ),
                                    child: Text(
                                      task.takenById == null
                                          ? s.takeTask
                                          : isMine
                                          ? s.releaseTask
                                          : s.reservedTask,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  TextButton.icon(
                                    onPressed: () async {
                                      await tasksState.toggleDone(
                                        int.parse(task.id),
                                        groupId: widget.groupId,
                                      );
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
                                  const Spacer(),
                                  IconButton(
                                    onPressed: () async {
                                      await tasksState.deleteTask(
                                        int.parse(task.id),
                                        groupId: widget.groupId,
                                      );
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
                    },
                    childCount: tasksState.tasks.length,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _squareIconButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: _fieldBg,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: SizedBox(
          height: 56,
          width: 56,
          child: Center(
            child: Icon(icon, color: _brandGold, size: 18),
          ),
        ),
      ),
    );
  }

  Widget _goldButton({required String text, required VoidCallback onPressed}) {
    return SizedBox(
      height: 56,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: _brandGold,
          foregroundColor: _darkBg,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        child: Text(
          '$text →',
          style: const TextStyle(letterSpacing: 1.2, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}

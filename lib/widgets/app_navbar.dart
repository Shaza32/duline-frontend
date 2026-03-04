import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/auth_state.dart';
import '../state/task_state.dart'; // مهم: state فيه strings

class AppNavbar extends StatelessWidget implements PreferredSizeWidget {
  const AppNavbar({
    super.key,
    required this.title,
    this.showBack = true,
  });

  final String title;
  final bool showBack;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthState>();
    final t = context.watch<TaskState>().strings; // ✅ الترجمات
    final canPop = Navigator.of(context).canPop();

    return AppBar(
      elevation: 0.5,
      leading: (showBack && canPop)
          ? IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.of(context).pop(),
      )
          : null,

      title: Text(
        title, // ملاحظة تحت عن العنوان
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),

      actions: [
        PopupMenuButton<String>(
          offset: const Offset(0, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          onSelected: (value) {
            switch (value) {
              case 'home':
                Navigator.pushNamedAndRemoveUntil(context, '/home', (r) => false);
                break;
              case 'setup':
                Navigator.pushNamed(context, '/setup');
                break;
              case 'profile':
                Navigator.pushNamed(context, '/profile');
                break;
              case 'logout':
                auth.logout();
                Navigator.pushNamedAndRemoveUntil(context, '/login', (r) => false);
                break;
            }
          },

          // ❌ لا const هون
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'home',
              child: Row(
                children: [
                  const Icon(Icons.home_outlined),
                  const SizedBox(width: 10),
                  Text(t.home),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'setup',
              child: Row(
                children: [
                  const Icon(Icons.group_outlined),
                  const SizedBox(width: 10),
                  Text(t.addFamilyMembers),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'profile',
              child: Row(
                children: [
                  const Icon(Icons.person_outline),
                  const SizedBox(width: 10),
                  Text(t.profile),
                ],
              ),
            ),
            const PopupMenuDivider(),
            PopupMenuItem(
              value: 'logout',
              child: Row(
                children: [
                  const Icon(Icons.logout),
                  const SizedBox(width: 10),
                  Text(t.logout),
                ],
              ),
            ),
          ],

          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: Colors.blueGrey.shade100,
              child: Text(
                (auth.name ?? auth.email ?? 'U')[0].toUpperCase(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
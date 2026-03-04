// lib/screens/groups/group_list_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../state/auth_state.dart';
import '../../models/group_summary.dart';
import '../../localization/strings_ext.dart';

class GroupListScreen extends StatelessWidget {
  final void Function(int groupId, String groupName) onOpenGroup;

  const GroupListScreen({
    super.key,
    required this.onOpenGroup,
  });

  // نفس ألوان اللوج إن
  static const Color _brandGold = Color(0xFFD4AF37);
  static const Color _darkBg = Color(0xFF2F2F2F);
  static const Color _cardBg = Color(0xFF3A3A3A);

  void _toast(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: _cardBg,
        content: Text(msg, style: const TextStyle(color: Colors.white)),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showGroupActions(BuildContext context, GroupSummary group) {
    final s = context.stringsRead;

    showModalBottomSheet(
      context: context,
      backgroundColor: _cardBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 42,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 14),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.visibility, color: _brandGold),
                  title: Text(
                    s.showInviteCode,
                    style: const TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _showInviteCodeDialog(context, group);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.copy, color: _brandGold),
                  title: Text(
                    s.copyCode,
                    style: const TextStyle(color: Colors.white),
                  ),
                  onTap: () async {
                    await Clipboard.setData(ClipboardData(text: group.code));
                    Navigator.pop(context);
                    _toast(context, s.codeCopied);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.share, color: _brandGold),
                  title: Text(
                    s.shareCode,
                    style: const TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    final msg = s.shareInviteTemplate.replaceAll('{code}', group.code);
                    Share.share(msg);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showInviteCodeDialog(BuildContext context, GroupSummary group) {
    final s = context.stringsRead;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: _darkBg,
        title: Text(
          s.inviteCodeTitle,
          style: const TextStyle(color: Colors.white),
        ),
        content: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.06),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withOpacity(0.08)),
          ),
          child: SelectableText(
            group.code,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: _brandGold,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              letterSpacing: 3,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await Clipboard.setData(ClipboardData(text: group.code));
              Navigator.pop(context);
              _toast(context, s.codeCopied);
            },
            child: Text(s.copyBtn, style: const TextStyle(color: _brandGold)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              s.closeBtn,
              style: TextStyle(color: Colors.white.withOpacity(0.7)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthState>();
    final s = context.strings;

    return Container(
      color: _darkBg,
      child: auth.groups.isEmpty
          ? Center(
        child: Text(
          s.groupsEmptyHint,
          style: TextStyle(color: Colors.white.withOpacity(0.6)),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
        itemCount: auth.groups.length,
        itemBuilder: (_, i) {
          final g = auth.groups[i];

          return InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () => onOpenGroup(g.id, g.name),
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                color: _cardBg,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.white.withOpacity(0.08)),
              ),
              child: Row(
                children: [
                  // أيقونة بسيطة ذهبية
                  Container(
                    height: 38,
                    width: 38,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.06),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white.withOpacity(0.08)),
                    ),
                    child: const Icon(Icons.group_outlined, color: _brandGold, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          g.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${s.codeLabel}: ${g.code} • ${s.roleLabel}: ${g.role}',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.55),
                            fontSize: 12,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.more_vert, color: Colors.white.withOpacity(0.75)),
                    onPressed: () => _showGroupActions(context, g),
                  ),
                  Icon(Icons.chevron_right, color: Colors.white.withOpacity(0.55)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../auth/presentation/providers/auth_state_provider.dart';
import '../providers/profile_providers.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).user;
    final role = user?.role ?? 'user';
    final profileAsync = user == null ? null : ref.watch(getProfileProvider(user.id));
    final profileName = profileAsync?.maybeWhen(
          data: (profile) => profile.fullName,
          orElse: () => user?.name ?? 'User',
        ) ??
        (user?.name ?? 'User');
    final profilePhone = profileAsync?.maybeWhen(
          data: (profile) => profile.phone,
          orElse: () => user?.phone,
        ) ??
        user?.phone;

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppTheme.heroTop, AppTheme.heroBottom],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(28),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 34,
                    backgroundColor: Colors.white24,
                    child: Icon(Icons.person, size: 34, color: Colors.white),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          profileName,
                          style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user?.email ?? 'No email',
                          style: TextStyle(color: Colors.white.withValues(alpha: 0.78), fontSize: 13),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.14),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            role.toUpperCase(),
                            style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w800),
                          ),
                        ),
                        if (profilePhone != null && profilePhone.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text(
                            profilePhone,
                            style: TextStyle(color: Colors.white.withValues(alpha: 0.78), fontSize: 13),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            _SectionCard(
              children: [
                _item(context, Icons.person_outline, 'Edit Profile', () => Navigator.pushNamed(context, AppRoutes.editProfile)),
                if (role == 'worker')
                  _item(
                    context,
                    Icons.work_outline,
                    'Worker Dashboard',
                    () => Navigator.pushNamedAndRemoveUntil(context, AppRoutes.workerShell, (_) => false),
                  ),
                _item(context, Icons.notifications_outlined, 'Notifications', () => Navigator.pushNamed(context, AppRoutes.notifications)),
                _item(context, Icons.favorite_outline, 'Saved Workers', () => Navigator.pushNamed(context, AppRoutes.favorites)),
                _item(context, Icons.lock_outline, 'Privacy & Security', () => _comingSoon(context)),
                _item(context, Icons.help_outline, 'Help & Support', () => _comingSoon(context), isLast: true),
              ],
            ),
            const SizedBox(height: 16),
            _SectionCard(
              children: [
                InkWell(
                  onTap: () => _logout(context, ref),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    child: Row(
                      children: [
                        Icon(Icons.logout, size: 20, color: AppTheme.iconRed),
                        SizedBox(width: 12),
                        Text('Logout', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppTheme.iconRed)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _item(BuildContext context, IconData icon, String label, VoidCallback onTap, {bool isLast = false}) {
    return Material(
      color: AppTheme.cardBg,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            border: isLast ? null : const Border(bottom: BorderSide(color: AppTheme.borderColor)),
          ),
          child: Row(
            children: [
              Icon(icon, size: 20, color: AppTheme.textSecondary),
              const SizedBox(width: 12),
              Expanded(child: Text(label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: AppTheme.textPrimary))),
              const Icon(Icons.chevron_right, size: 20, color: Color(0xFFBDBDBD)),
            ],
          ),
        ),
      ),
    );
  }

  void _comingSoon(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Coming Soon'),
        content: const Text('This feature is coming soon.'),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))],
      ),
    );
  }

  Future<void> _logout(BuildContext context, WidgetRef ref) async {
    final ok = await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Logout'),
            content: const Text('Are you sure you want to logout?'),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
              ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Logout')),
            ],
          ),
        ) ??
        false;

    if (!ok) {
      return;
    }

    await ref.read(authStateProvider.notifier).logout();
    if (!context.mounted) {
      return;
    }
    Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (_) => false);
  }
}

class _SectionCard extends StatelessWidget {
  final List<Widget> children;

  const _SectionCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.cardBg,
        border: Border.all(color: AppTheme.borderColor),
        borderRadius: BorderRadius.circular(24),
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(children: children),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_theme.dart';
import '../../features/auth/presentation/providers/auth_state_provider.dart';
import '../../features/workers/presentation/providers/worker_mode_provider.dart';

class ModeSwitchBanner extends ConsumerWidget {
  const ModeSwitchBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).user;
    if (user == null || user.role != 'worker') {
      return const SizedBox.shrink();
    }

    final mode = ref.watch(workerModeProvider);
    final isSeeking = mode == WorkerMode.seeking;
    final subtitle = isSeeking
        ? 'Switch to browse as a customer'
        : 'Switch to manage your jobs and earnings';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.primaryLight, Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: AppTheme.primary,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.sync_rounded, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Mode switch',
                      style: TextStyle(fontSize: 13, color: AppTheme.textSecondary),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      isSeeking ? 'Browsing customers' : 'Managing your jobs',
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppTheme.textPrimary),
                    ),
                  ],
                ),
              ),
              InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () => _showModeBottomSheet(context, ref, mode),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSeeking ? AppTheme.cardBg : AppTheme.primary,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: AppTheme.primary),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isSeeking ? Icons.search_rounded : Icons.handyman_rounded,
                        size: 16,
                        color: isSeeking ? AppTheme.primary : Colors.white,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        isSeeking ? 'Seeking' : 'Providing',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: isSeeking ? AppTheme.primary : Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 12.5, color: AppTheme.textSecondary),
          ),
        ],
      ),
    );
  }

  Future<void> _showModeBottomSheet(
    BuildContext context,
    WidgetRef ref,
    WorkerMode currentMode,
  ) {
    return showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (sheetContext) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 42,
                height: 5,
                decoration: BoxDecoration(
                  color: AppTheme.borderColor,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Switch your mode',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              LayoutBuilder(
                builder: (context, constraints) {
                  final stacked = constraints.maxWidth < 520;
                  final seeking = _ModeOption(
                    mode: WorkerMode.seeking,
                    title: 'Seeking',
                    subtitle: 'Browse & book services',
                    icon: Icons.search_rounded,
                    isActive: currentMode == WorkerMode.seeking,
                    onTap: () => _onModeSelect(
                      outerContext: context,
                      sheetContext: sheetContext,
                      ref: ref,
                      mode: WorkerMode.seeking,
                    ),
                  );
                  final providing = _ModeOption(
                    mode: WorkerMode.providing,
                    title: 'Providing',
                    subtitle: 'Manage your jobs & earnings',
                    icon: Icons.handyman_rounded,
                    isActive: currentMode == WorkerMode.providing,
                    onTap: () => _onModeSelect(
                      outerContext: context,
                      sheetContext: sheetContext,
                      ref: ref,
                      mode: WorkerMode.providing,
                    ),
                  );

                  if (stacked) {
                    return Column(
                      children: [
                        seeking,
                        const SizedBox(height: 12),
                        providing,
                      ],
                    );
                  }

                  return Row(
                    children: [
                      Expanded(child: seeking),
                      const SizedBox(width: 12),
                      Expanded(child: providing),
                    ],
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _onModeSelect({
    required BuildContext outerContext,
    required BuildContext sheetContext,
    required WidgetRef ref,
    required WorkerMode mode,
  }) {
    ref.read(workerModeProvider.notifier).state = mode;
    Navigator.of(sheetContext).pop();
    final route = mode == WorkerMode.seeking ? AppRoutes.shell : AppRoutes.workerShell;
    Navigator.pushNamedAndRemoveUntil(outerContext, route, (routeItem) => false);
  }
}

class _ModeOption extends StatelessWidget {
  final WorkerMode mode;
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  const _ModeOption({
    required this.mode,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isActive ? AppTheme.primaryLight : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isActive ? AppTheme.primary : AppTheme.borderColor,
            width: isActive ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: isActive ? AppTheme.primary : AppTheme.primaryLight,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: isActive ? Colors.white : AppTheme.primary, size: 22),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

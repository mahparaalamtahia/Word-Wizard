import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/presentation/providers/auth_state_provider.dart';
import '../../features/bookings/presentation/screens/bookings_screen.dart';
import '../../features/dashboard/presentation/screens/worker_dashboard_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/notifications/presentation/screens/notifications_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import 'bottom_nav_bar.dart';

class MainShell extends ConsumerStatefulWidget {
  final int initialIndex;

  const MainShell({super.key, this.initialIndex = 0});

  @override
  ConsumerState<MainShell> createState() => _MainShellState();
}

class _MainShellState extends ConsumerState<MainShell> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    final role = ref.watch(authStateProvider).user?.role ?? 'user';
    final worker = role == 'worker';

    final screens = worker
        ? const [
            HomeScreen(),
            BookingsScreen(),
            NotificationsScreen(),
            WorkerDashboardScreen(),
            ProfileScreen(),
          ]
        : const [
            HomeScreen(),
            BookingsScreen(),
            NotificationsScreen(),
            ProfileScreen(),
          ];

    if (_currentIndex >= screens.length) {
      _currentIndex = 0;
    }

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: screens),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        isWorker: worker,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}

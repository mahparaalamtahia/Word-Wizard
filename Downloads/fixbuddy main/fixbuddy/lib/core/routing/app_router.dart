import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/providers/auth_state_provider.dart';
import '../../features/dashboard/presentation/screens/worker_dashboard_screen.dart';
import '../../features/workers/presentation/screens/worker_list_screen.dart';
import '../../features/workers/presentation/screens/worker_profile_screen.dart';
import '../../features/bookings/presentation/screens/booking_screen.dart';
import '../../features/bookings/presentation/screens/booking_detail_screen.dart';
import '../../features/bookings/presentation/screens/bookings_screen.dart';
import '../../features/notifications/presentation/screens/notifications_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/profile/presentation/screens/edit_profile_screen.dart';
import '../../features/chat/presentation/screens/chat_screen.dart';
import '../../features/reviews/presentation/screens/rating_screen.dart';
import '../../features/workers/presentation/providers/worker_mode_provider.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (context, state) => const LoginScreen()),
      GoRoute(path: '/register', builder: (context, state) => const RegisterScreen()),
      GoRoute(
        path: '/workers',
        builder: (context, state) => WorkerListScreen(
          initialCategory: state.uri.queryParameters['category'],
          initialArea: state.uri.queryParameters['area'],
        ),
      ),
      GoRoute(path: '/dashboard', builder: (context, state) => const WorkerDashboardScreen()),
      GoRoute(
        path: '/worker-profile',
        builder: (context, state) => WorkerProfileScreen(workerId: state.uri.queryParameters['workerId'] ?? ''),
      ),
      GoRoute(
        path: '/booking',
        builder: (context, state) => BookingScreen(workerId: state.uri.queryParameters['workerId'] ?? ''),
      ),
      GoRoute(
        path: '/booking-detail',
        builder: (context, state) => BookingDetailScreen(bookingId: state.uri.queryParameters['bookingId'] ?? ''),
      ),
      GoRoute(path: '/bookings', builder: (context, state) => const BookingsScreen()),
      GoRoute(path: '/notifications', builder: (context, state) => const NotificationsScreen()),
      GoRoute(path: '/profile', builder: (context, state) => const ProfileScreen()),
      GoRoute(path: '/edit-profile', builder: (context, state) => const EditProfileScreen()),
      GoRoute(
        path: '/chat',
        builder: (context, state) => ChatScreen(
          workerId: state.uri.queryParameters['workerId'] ?? '',
          workerName: state.uri.queryParameters['workerName'] ?? '',
          workerCategory: state.uri.queryParameters['workerCategory'] ?? '',
          bookingId: state.uri.queryParameters['bookingId'] ?? '',
        ),
      ),
      GoRoute(
        path: '/rating',
        builder: (context, state) => RatingScreen(bookingId: state.uri.queryParameters['bookingId'] ?? ''),
      ),
      GoRoute(path: '/admin', builder: (context, state) => const _AdminPlaceholderScreen()),
    ],
    redirect: (context, state) {
      final authState = ref.read(authStateProvider);
      final user = authState.user;
      final location = state.uri.path;
      final onAuthPage = location == '/' || location == '/register';

      if (!authState.isAuthenticated) {
        return onAuthPage ? null : '/';
      }

      if (user == null) {
        return '/';
      }

      final roleTarget = resolvePostLoginRoute(user, workerMode: ref.read(workerModeProvider));

      // keep requested location unless redirecting from auth pages

      if (onAuthPage) {
        return roleTarget;
      }

      return null;
    },
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Center(child: Text(state.error.toString())),
    ),
  );
});

class _AdminPlaceholderScreen extends StatelessWidget {
  const _AdminPlaceholderScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin')),
      body: const Center(child: Text('Admin panel is ready for integration.')),
    );
  }
}

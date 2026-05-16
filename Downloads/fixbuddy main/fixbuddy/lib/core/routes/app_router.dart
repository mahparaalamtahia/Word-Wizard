import 'package:flutter/material.dart';

import '../../features/admin/presentation/screens/admin_shell.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/screens/verify_email_screen.dart';
import '../../features/bookings/presentation/screens/booking_confirmation_screen.dart';
import '../../features/bookings/presentation/screens/booking_detail_screen.dart';
import '../../features/bookings/presentation/screens/booking_screen.dart';
import '../../features/bookings/presentation/screens/my_jobs_screen.dart';
import '../../features/chat/presentation/screens/chat_screen.dart';
import '../../features/dashboard/presentation/screens/worker_dashboard_shell.dart';
import '../../features/favorites/presentation/screens/favorites_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/profile/presentation/screens/edit_profile_screen.dart';
import '../../features/reviews/presentation/screens/rating_screen.dart';
import '../../features/reviews/presentation/screens/reviews_list_screen.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';
import '../../features/workers/presentation/screens/worker_list_screen.dart';
import '../../features/workers/presentation/screens/worker_profile_screen.dart';
import '../services/supabase_service.dart';
import '../services/user_role_service.dart';
import '../../shared/widgets/main_shell.dart';
import 'app_routes.dart';

class AppRouter {
  AppRouter._();

  static const String login = AppRoutes.login;
  static const String register = AppRoutes.register;
  static const String home = AppRoutes.shell;
  static const String workerList = AppRoutes.workers;
  static const String dashboard = AppRoutes.workerShell;
  static const String admin = AppRoutes.adminShell;
  static const String booking = AppRoutes.booking;

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final uri = Uri.tryParse(settings.name ?? '') ?? Uri(path: settings.name ?? '');
    final args = settings.arguments is Map<String, dynamic>
        ? settings.arguments! as Map<String, dynamic>
        : <String, dynamic>{};
    final mergedArgs = <String, dynamic>{...uri.queryParameters, ...args};

    switch (uri.path) {
      case AppRoutes.splash:
        return _page(const SplashScreen(), settings);
      case AppRoutes.onboarding:
        return _page(const OnboardingScreen(), settings);
      case AppRoutes.login:
        return _page(const LoginScreen(), settings);
      case AppRoutes.register:
        return _page(const RegisterScreen(), settings);
      case AppRoutes.verifyEmail:
        return _page(const VerifyEmailScreen(), settings);
      case AppRoutes.shell:
        return _page(MainShell(initialIndex: (mergedArgs['initialIndex'] as int?) ?? 0), settings);
      case AppRoutes.workerShell:
        return _page(const WorkerDashboardShell(), settings);
      case AppRoutes.bookings:
        return _page(const MainShell(initialIndex: 1), settings);
      case AppRoutes.notifications:
        return _page(const MainShell(initialIndex: 2), settings);
      case AppRoutes.profile:
        return _page(const MainShell(initialIndex: 3), settings);
      case AppRoutes.myJobs:
        return _page(const MyJobsScreen(), settings);
      case AppRoutes.workers:
        return _page(
          WorkerListScreen(
            initialCategory: (mergedArgs['category'] ?? mergedArgs['selectedCategory'])?.toString(),
            initialArea: (mergedArgs['area'] ?? mergedArgs['selectedArea'])?.toString(),
          ),
          settings,
        );
      case AppRoutes.workerProfile:
        return _page(
          WorkerProfileScreen(workerId: (mergedArgs['workerId'] ?? '').toString()),
          settings,
        );
      case AppRoutes.booking:
        return _page(
          BookingScreen(workerId: (mergedArgs['workerId'] ?? '').toString()),
          settings,
        );
      case AppRoutes.bookingDetail:
        return _page(
          BookingDetailScreen(bookingId: (mergedArgs['bookingId'] ?? '').toString()),
          settings,
        );
      case AppRoutes.bookingConfirm:
        return _page(BookingConfirmationScreen(bookingData: mergedArgs), settings);
      case AppRoutes.reviews:
        return _page(const ReviewsListScreen(), settings);
      case AppRoutes.chat:
        return _page(
          ChatScreen(
            workerId: (mergedArgs['workerId'] ?? '').toString(),
            workerName: (mergedArgs['workerName'] ?? 'Worker').toString(),
            workerCategory: (mergedArgs['workerCategory'] ?? 'Service').toString(),
            bookingId: (mergedArgs['bookingId'] ?? '').toString(),
          ),
          settings,
        );
      case AppRoutes.rating:
        return _page(
          RatingScreen(bookingId: (mergedArgs['bookingId'] ?? '').toString()),
          settings,
        );
      case AppRoutes.favorites:
        return _page(const FavoritesScreen(), settings);
      case AppRoutes.editProfile:
        return _page(const EditProfileScreen(), settings);
      case AppRoutes.adminShell:
        return _page(const _AdminRoleGate(child: AdminShell()), settings);
      default:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const LoginScreen(),
        );
    }
  }

  static Route<dynamic> onUnknownRoute(RouteSettings settings) {
    return MaterialPageRoute<void>(
      settings: settings,
      builder: (_) => const LoginScreen(),
    );
  }

  static MaterialPageRoute<void> _page(Widget child, RouteSettings settings) {
    return MaterialPageRoute<void>(settings: settings, builder: (_) => child);
  }
}

class _AdminRoleGate extends StatefulWidget {
  final Widget child;
  const _AdminRoleGate({required this.child});

  @override
  State<_AdminRoleGate> createState() => _AdminRoleGateState();
}

class _AdminRoleGateState extends State<_AdminRoleGate> {
  late final Future<String> _roleFuture;

  @override
  void initState() {
    super.initState();
    _roleFuture = UserRoleService(SupabaseService.client).getCurrentUserRole();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _roleFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        final role = snapshot.data ?? 'user';
        if (role != 'admin') {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;
            Navigator.pushNamedAndRemoveUntil(context, AppRoutes.shell, (_) => false);
          });
          return const Scaffold(body: SizedBox.shrink());
        }

        return widget.child;
      },
    );
  }
}

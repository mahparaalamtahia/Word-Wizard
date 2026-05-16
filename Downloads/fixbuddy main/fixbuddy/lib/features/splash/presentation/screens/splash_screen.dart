import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../auth/presentation/providers/auth_state_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _go();
  }

  Future<void> _go() async {
    await Future<void>.delayed(const Duration(milliseconds: 800));
    await ref.read(authStateProvider.notifier).getCurrentUser();
    final auth = ref.read(authStateProvider);
    if (!mounted) return;
    if (!auth.isAuthenticated || auth.user == null) {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
      return;
    }
    final role = auth.user!.role;
    Navigator.pushReplacementNamed(context, role == 'admin' ? AppRoutes.admin : AppRoutes.shell);
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}

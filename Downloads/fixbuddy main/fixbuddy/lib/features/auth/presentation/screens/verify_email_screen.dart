import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import 'package:flutter/foundation.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/services/supabase_service.dart';
import '../providers/auth_state_provider.dart';
import '../widgets/auth_widgets.dart';

class VerifyEmailScreen extends ConsumerStatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  ConsumerState<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends ConsumerState<VerifyEmailScreen> {
  bool _isResending = false;
  String? _message;

  Future<void> _resendVerificationEmail(String email) async {
    setState(() {
      _isResending = true;
      _message = null;
    });

    try {
      final emailRedirectTo = kIsWeb ? '${Uri.base.origin}/#${AppRoutes.login}' : null;

      await SupabaseService.client.auth.resend(
        type: supabase.OtpType.signup,
        email: email,
        emailRedirectTo: emailRedirectTo,
      );

      if (!mounted) return;
      setState(() {
        _message = 'Verification email sent again. Check your inbox and spam folder.';
      });
    } on supabase.AuthException catch (e) {
      if (!mounted) return;
      setState(() {
        _message = e.message;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _message = 'Failed to resend verification email: $e';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isResending = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);
    final email = authState.pendingVerificationEmail ?? '';

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(
                    Icons.mark_email_unread_outlined,
                    size: 72,
                    color: Color(0xFF2563EB),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Check your email',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    email.isEmpty
                        ? 'We sent a verification link to your email. Please confirm it, then sign in.'
                        : 'We sent a verification link to $email. Please confirm it, then sign in.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Color(0xFF555555),
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (_message != null) ...[
                    ErrorMessage(message: _message!),
                    const SizedBox(height: 16),
                  ],
                  AuthButton(
                    label: _isResending ? 'Sending...' : 'Resend verification email',
                    isLoading: _isResending,
                    onPressed: email.isEmpty ? () {} : () => _resendVerificationEmail(email),
                    isEnabled: email.isNotEmpty,
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () {
                      ref.read(authStateProvider.notifier).clearVerificationState();
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        AppRoutes.login,
                        (_) => false,
                      );
                    },
                    child: const Text('Back to login'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
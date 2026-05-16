import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/extensions/string_extensions.dart';
import '../providers/auth_state_provider.dart';
import '../../../workers/presentation/providers/worker_mode_provider.dart';
import '../widgets/auth_widgets.dart';

/// Register screen for new users with role-based signup
class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _passwordController;
  late TextEditingController _bioController;
  late TextEditingController _serviceAreaController;
  late TextEditingController _experienceController;
  late TextEditingController _rateController;

  String _selectedRole = AppConstants.roleUser;
  String? _selectedCategoryId;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Seeded categories aligned with migration IDs.
  final List<Map<String, String>> _categories = const [
    {'id': '11111111-1111-1111-1111-111111111111', 'name': 'Plumbing'},
    {'id': '22222222-2222-2222-2222-222222222222', 'name': 'Electrical'},
    {'id': '33333333-3333-3333-3333-333333333333', 'name': 'Carpentry'},
    {'id': '44444444-4444-4444-4444-444444444444', 'name': 'Cleaning'},
    {'id': '55555555-5555-5555-5555-555555555555', 'name': 'Painting'},
    {'id': '66666666-6666-6666-6666-666666666666', 'name': 'HVAC'},
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _passwordController = TextEditingController();
    _bioController = TextEditingController();
    _serviceAreaController = TextEditingController();
    _experienceController = TextEditingController();
    _rateController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    _serviceAreaController.dispose();
    _experienceController.dispose();
    _rateController.dispose();
    super.dispose();
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    if (value.length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!value.isValidEmail()) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (!value.isStrongPassword()) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    if (value.length < 8) {
      return 'Enter a valid phone number';
    }
    return null;
  }

  String? _validateExperience(String? value) {
    if (_selectedRole == AppConstants.roleWorker) {
      if (value == null || value.isEmpty) {
        return 'Experience is required';
      }
      if (int.tryParse(value) == null || int.parse(value) < 0) {
        return 'Enter a valid number';
      }
    }
    return null;
  }

  String? _validateRate(String? value) {
    if (_selectedRole == AppConstants.roleWorker) {
      if (value == null || value.isEmpty) {
        return 'Hourly rate is required';
      }
      if (double.tryParse(value) == null || double.parse(value) <= 0) {
        return 'Enter a valid amount';
      }
    }
    return null;
  }

  void _handleRegister() {
    if (_formKey.currentState!.validate()) {
      ref.read(authStateProvider.notifier).clearError();

      int? experience;
      double? rate;

      if (_selectedRole == AppConstants.roleWorker) {
        experience = int.tryParse(_experienceController.text.trim()) ?? 0;
        rate = double.tryParse(_rateController.text.trim()) ?? 0;
      }

      ref.read(authStateProvider.notifier).register(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        name: _nameController.text.trim(),
        role: _selectedRole,
        phone: _phoneController.text.trim(),
        categoryId: _selectedCategoryId,
        experienceYears: experience,
        hourlyRate: rate,
        serviceArea: _serviceAreaController.text.trim().isEmpty
            ? null
            : _serviceAreaController.text.trim(),
        bio: _bioController.text.trim().isEmpty ? null : _bioController.text.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AuthState>(authStateProvider, (previous, next) {
      if (next.requiresEmailVerification) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.verifyEmail,
          (route) => false,
          arguments: {'email': next.pendingVerificationEmail},
        );
        return;
      }

      if (next.isAuthenticated && !next.isLoading) {
        final user = next.user;
        if (user == null) {
          return;
        }
        if (user.role == 'worker') {
          ref.read(workerModeProvider.notifier).state = WorkerMode.providing;
        }
        final targetRoute = resolvePostLoginRoute(
          user,
          workerMode: ref.read(workerModeProvider),
        );
        Navigator.pushNamedAndRemoveUntil(
          context,
          targetRoute,
          (route) => false,
        );
      }
    });

    final authState = ref.watch(authStateProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: const BoxDecoration(
                              color: Color(0xFF2563EB),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.handyman_rounded,
                              color: Colors.white,
                              size: 44,
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Create Account',
                            style: TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Sign up to get started',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF555555),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),

                    if (authState.error != null) ...[
                      ErrorMessage(message: authState.error!),
                      const SizedBox(height: 24),
                    ],

                    // Role Selection
                    const Text(
                      'I want to',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedRole = AppConstants.roleUser;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: _selectedRole == AppConstants.roleUser
                                      ? const Color(0xFF2563EB)
                                      : const Color(0xFFE5E7EB),
                                  width: _selectedRole == AppConstants.roleUser ? 2 : 1,
                                ),
                                borderRadius: BorderRadius.circular(8),
                                color: _selectedRole == AppConstants.roleUser
                                    ? const Color(0xFF2563EB).withValues(alpha: 0.05)
                                    : Colors.white,
                              ),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.shopping_bag_outlined,
                                    color: _selectedRole == AppConstants.roleUser
                                        ? const Color(0xFF2563EB)
                                        : const Color(0xFF9CA3AF),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Book Services',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: _selectedRole == AppConstants.roleUser
                                          ? const Color(0xFF2563EB)
                                          : const Color(0xFF6B7280),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedRole = AppConstants.roleWorker;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: _selectedRole == AppConstants.roleWorker
                                      ? const Color(0xFF2563EB)
                                      : const Color(0xFFE5E7EB),
                                  width: _selectedRole == AppConstants.roleWorker ? 2 : 1,
                                ),
                                borderRadius: BorderRadius.circular(8),
                                color: _selectedRole == AppConstants.roleWorker
                                    ? const Color(0xFF2563EB).withValues(alpha: 0.05)
                                    : Colors.white,
                              ),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.build_outlined,
                                    color: _selectedRole == AppConstants.roleWorker
                                        ? const Color(0xFF2563EB)
                                        : const Color(0xFF9CA3AF),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Offer Services',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: _selectedRole == AppConstants.roleWorker
                                          ? const Color(0xFF2563EB)
                                          : const Color(0xFF6B7280),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Common Fields
                    AuthTextField(
                      controller: _nameController,
                      label: 'Full Name',
                      hint: 'Enter your full name',
                      validator: _validateName,
                    ),
                    const SizedBox(height: 16),

                    AuthTextField(
                      controller: _emailController,
                      label: 'Email',
                      hint: 'Enter your email',
                      keyboardType: TextInputType.emailAddress,
                      validator: _validateEmail,
                    ),
                    const SizedBox(height: 16),

                    AuthTextField(
                      controller: _phoneController,
                      label: 'Phone Number',
                      hint: 'Enter your phone number',
                      keyboardType: TextInputType.phone,
                      validator: _validatePhone,
                    ),
                    const SizedBox(height: 16),

                    AuthTextField(
                      controller: _passwordController,
                      label: 'Password',
                      hint: 'Create a password',
                      isPassword: true,
                      validator: _validatePassword,
                    ),
                    const SizedBox(height: 24),

                    // Worker-specific fields
                    if (_selectedRole == AppConstants.roleWorker) ...[
                      const Text(
                        'Professional Details',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Category Dropdown
                      DropdownButtonFormField<String>(
                        initialValue: _selectedCategoryId,
                        decoration: InputDecoration(
                          labelText: 'Service Category',
                          hintText: 'Select your specialty',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Color(0xFFE5E7EB),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Color(0xFF2563EB),
                              width: 2,
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        items: _categories
                            .map((category) => DropdownMenuItem(
                                  value: category['id'],
                                  child: Text(category['name'] ?? ''),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedCategoryId = value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a category';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Experience
                      AuthTextField(
                        controller: _experienceController,
                        label: 'Years of Experience',
                        hint: 'Enter your years of experience',
                        keyboardType: TextInputType.number,
                        validator: _validateExperience,
                      ),
                      const SizedBox(height: 16),

                      // Hourly Rate
                      AuthTextField(
                        controller: _rateController,
                        label: 'Hourly Rate (\$)',
                        hint: 'Enter your hourly rate',
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        validator: _validateRate,
                      ),
                      const SizedBox(height: 16),

                      // Service Area
                      AuthTextField(
                        controller: _serviceAreaController,
                        label: 'Service Area',
                        hint: 'Enter service area (e.g., Downtown, Suburbs)',
                        maxLines: 1,
                      ),
                      const SizedBox(height: 16),

                      // Bio
                      AuthTextField(
                        controller: _bioController,
                        label: 'Bio',
                        hint: 'Tell customers about yourself',
                        maxLines: 3,
                      ),
                      const SizedBox(height: 24),
                    ],

                    AuthButton(
                      label: 'Sign Up',
                      isLoading: authState.isLoading,
                      onPressed: _handleRegister,
                    ),
                    const SizedBox(height: 20),

                    Center(
                      child: AuthTextButton(
                        text: 'Already have an account? ',
                        highlightedText: 'Login',
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, AppRoutes.login);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../auth/presentation/providers/auth_state_provider.dart';
import '../providers/profile_providers.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  bool _isSaving = false;
  bool _seededInitialValues = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    final user = ref.read(authStateProvider).user;
    if (user == null || _isSaving) {
      return;
    }

    final fullName = _nameController.text.trim();
    final phone = _phoneController.text.trim();
    final bio = _bioController.text.trim();

    setState(() => _isSaving = true);

    try {
      final savedProfile = await ref.read(profileUpdateProvider.notifier).updateProfile(user.id, {
        'full_name': fullName,
        'phone': phone.isEmpty ? null : phone,
        'bio': bio.isEmpty ? null : bio,
      });

      if (savedProfile == null) {
        throw Exception('Profile update failed');
      }

      await ref.read(updateUserProfileUsecaseProvider).call(
            userId: user.id,
            name: fullName,
            phone: phone.isEmpty ? null : phone,
          );

      ref.invalidate(getProfileProvider(user.id));
      await ref.read(authStateProvider.notifier).getCurrentUser();

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );
      Navigator.pop(context);
    } catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile: $error')),
      );
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authStateProvider).user;
    final profileAsync = user == null ? null : ref.watch(getProfileProvider(user.id));

    if (!_seededInitialValues && profileAsync?.hasValue == true) {
      final profile = profileAsync!.value!;
      _nameController.text = profile.fullName;
      _phoneController.text = profile.phone ?? '';
      _bioController.text = profile.bio ?? '';
      _seededInitialValues = true;
    }

    if (!_seededInitialValues && user != null && profileAsync == null) {
      _nameController.text = user.name ?? '';
      _phoneController.text = user.phone ?? '';
      _bioController.text = '';
      _seededInitialValues = true;
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const CircleAvatar(
            radius: 40,
            backgroundColor: AppTheme.primaryLight,
            child: Icon(Icons.person, color: AppTheme.primary, size: 36),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Full Name'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _phoneController,
            decoration: const InputDecoration(labelText: 'Phone Number'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _bioController,
            maxLines: 4,
            decoration: const InputDecoration(labelText: 'Bio'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _isSaving ? null : _saveProfile,
            child: _isSaving
                ? const SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Save Changes'),
          ),
        ],
      ),
    );
  }
}

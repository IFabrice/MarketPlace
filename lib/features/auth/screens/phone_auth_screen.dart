import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_config.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/loading_overlay.dart';

class PhoneAuthScreen extends ConsumerStatefulWidget {
  const PhoneAuthScreen({super.key});

  @override
  ConsumerState<PhoneAuthScreen> createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends ConsumerState<PhoneAuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController(text: kProductionMode ? '+250 ' : '+1 ');

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  String get _cleanPhone {
    return _phoneController.text.replaceAll(RegExp(r'\s+'), '');
  }

  bool _isValidPhone(String phone) {
    // Rwanda: +250 followed by 9 digits
    if (RegExp(r'^\+250[0-9]{9}$').hasMatch(phone)) return true;
    // US (dev/testing only): +1 followed by 10 digits
    if (!kProductionMode && RegExp(r'^\+1[0-9]{10}$').hasMatch(phone)) return true;
    return false;
  }

  Future<void> _sendOtp() async {
    if (!_formKey.currentState!.validate()) return;
    final notifier = ref.read(otpProvider.notifier);
    await notifier.sendOtp(_cleanPhone);

    if (!mounted) return;
    final state = ref.read(otpProvider);
    if (state.codeSent) {
      context.push(AppRoutes.otpVerification, extra: _cleanPhone);
    }
  }

  @override
  Widget build(BuildContext context) {
    final otpState = ref.watch(otpProvider);

    return LoadingOverlay(
      isLoading: otpState.isLoading,
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.storefront_rounded,
                      color: AppColors.primary,
                      size: 32,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Welcome to\n${AppStrings.appName}',
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    kProductionMode
                        ? 'Enter your Rwandan phone number to get started.'
                        : 'Enter your phone number to get started.',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                  const SizedBox(height: 40),
                  Text(
                    AppStrings.phoneNumber,
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9+ ]')),
                    ],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1,
                    ),
                    decoration: InputDecoration(
                      prefixIcon: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              kProductionMode ? '🇷🇼' : '🌍',
                              style: const TextStyle(fontSize: 20),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              width: 1,
                              height: 24,
                              color: AppColors.divider,
                            ),
                          ],
                        ),
                      ),
                      hintText: kProductionMode
                          ? AppStrings.phoneHint
                          : '+1 650 555 0100',
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return AppStrings.fieldRequired;
                      }
                      if (!_isValidPhone(_cleanPhone)) {
                        return kProductionMode
                            ? AppStrings.invalidPhone
                            : 'Enter a valid phone number (+250 or +1).';
                      }
                      return null;
                    },
                  ),
                  if (otpState.error != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      otpState.error!,
                      style: const TextStyle(
                        color: AppColors.error,
                        fontSize: 13,
                      ),
                    ),
                  ],
                  const Spacer(),
                  CustomButton(
                    label: AppStrings.sendOtp,
                    onPressed: _sendOtp,
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: Text(
                      'By continuing you agree to our Terms of Service.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 12,
                          ),
                      textAlign: TextAlign.center,
                    ),
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

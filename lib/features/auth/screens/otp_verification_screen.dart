import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/services/firestore_service.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/loading_overlay.dart';

class OtpVerificationScreen extends ConsumerStatefulWidget {
  final String phoneNumber;
  const OtpVerificationScreen({super.key, required this.phoneNumber});

  @override
  ConsumerState<OtpVerificationScreen> createState() =>
      _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends ConsumerState<OtpVerificationScreen> {
  final _otpController = TextEditingController();
  final _focusNode = FocusNode();
  int _secondsRemaining = 60;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_secondsRemaining == 0) {
        t.cancel();
      } else {
        setState(() => _secondsRemaining--);
      }
    });
  }

  @override
  void dispose() {
    _otpController.dispose();
    _focusNode.dispose();
    _timer.cancel();
    super.dispose();
  }

  Future<void> _verify() async {
    final code = _otpController.text.trim();
    if (code.length != 6) return;

    final success =
        await ref.read(otpProvider.notifier).verifyOtp(code);
    if (!mounted) return;

    if (!success) return;

    // Check if user already has a Firestore profile
    final firebaseUser = ref.read(firebaseAuthUserProvider).valueOrNull;
    if (firebaseUser == null) return;

    final exists = await ref
        .read(firestoreServiceProvider)
        .userExists(firebaseUser.uid);

    if (!mounted) return;
    if (exists) {
      final user = await ref.read(currentUserProvider.future);
      if (!mounted) return;
      if (user?.role.name == 'vendor') {
        context.go(AppRoutes.vendorDashboard);
      } else {
        context.go(AppRoutes.clientHome);
      }
    } else {
      context.go(AppRoutes.roleSelection);
    }
  }

  Future<void> _resend() async {
    setState(() => _secondsRemaining = 60);
    _startTimer();
    await ref.read(otpProvider.notifier).sendOtp(widget.phoneNumber);
  }

  @override
  Widget build(BuildContext context) {
    final otpState = ref.watch(otpProvider);

    final defaultPinTheme = PinTheme(
      width: 52,
      height: 60,
      textStyle: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary, width: 2),
      ),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary, width: 1.5),
      ),
    );

    return LoadingOverlay(
      isLoading: otpState.isLoading,
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(onPressed: () => context.pop()),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Text(
                  AppStrings.enterOtp,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Text.rich(
                  TextSpan(
                    text: '${AppStrings.otpSentTo} ',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                    children: [
                      TextSpan(
                        text: widget.phoneNumber,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                Center(
                  child: Pinput(
                    length: 6,
                    controller: _otpController,
                    focusNode: _focusNode,
                    autofocus: true,
                    defaultPinTheme: defaultPinTheme,
                    focusedPinTheme: focusedPinTheme,
                    submittedPinTheme: submittedPinTheme,
                    onCompleted: (_) => _verify(),
                  ),
                ),
                if (otpState.error != null) ...[
                  const SizedBox(height: 16),
                  Center(
                    child: Text(
                      otpState.error!,
                      style: const TextStyle(
                        color: AppColors.error,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                Center(
                  child: _secondsRemaining > 0
                      ? Text(
                          '${AppStrings.resendIn} $_secondsRemaining s',
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 14,
                          ),
                        )
                      : TextButton(
                          onPressed: _resend,
                          child: const Text(AppStrings.resendCode),
                        ),
                ),
                const Spacer(),
                CustomButton(
                  label: AppStrings.verifyOtp,
                  onPressed: () {
                    if (_otpController.text.length == 6) _verify();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

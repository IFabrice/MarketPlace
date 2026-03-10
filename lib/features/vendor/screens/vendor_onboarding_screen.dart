import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/models/market_model.dart';
import '../../../core/models/product_model.dart';
import '../../../core/models/vendor_model.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/providers/vendor_provider.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/custom_text_field.dart';
import '../../../shared/widgets/loading_overlay.dart';

class VendorOnboardingScreen extends ConsumerStatefulWidget {
  const VendorOnboardingScreen({super.key});

  @override
  ConsumerState<VendorOnboardingScreen> createState() =>
      _VendorOnboardingScreenState();
}

class _VendorOnboardingScreenState
    extends ConsumerState<VendorOnboardingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _businessNameController = TextEditingController();
  final _stallCodeController = TextEditingController();
  final _neighborhoodController = TextEditingController();

  @override
  void dispose() {
    _businessNameController.dispose();
    _stallCodeController.dispose();
    _neighborhoodController.dispose();
    super.dispose();
  }

  bool _isValidStallCode(String code) {
    // Format: XXX-A0-00 (e.g., NYA-A2-04)
    return RegExp(r'^[A-Z]{2,4}-[A-Z]\d+-\d{2,3}$').hasMatch(code);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final notifier = ref.read(vendorOnboardingProvider.notifier);
    notifier.setBusinessName(_businessNameController.text.trim());
    if (_stallCodeController.text.isNotEmpty) {
      notifier.setStallCode(_stallCodeController.text.trim().toUpperCase());
    }
    if (_neighborhoodController.text.isNotEmpty) {
      notifier.setNeighborhood(_neighborhoodController.text.trim());
    }

    final firebaseUser = ref.read(firebaseAuthUserProvider).valueOrNull;
    if (firebaseUser == null) return;

    await notifier.submit(firebaseUser.uid);

    if (!mounted) return;
    final state = ref.read(vendorOnboardingProvider);
    if (state.isComplete) {
      context.go(AppRoutes.vendorDashboard);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(vendorOnboardingProvider);
    final marketsAsync = ref.watch(marketsProvider);
    final isMarketVendor = state.vendorType == VendorType.market;

    return LoadingOverlay(
      isLoading: state.isLoading,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(AppStrings.vendorProfile),
          leading: BackButton(onPressed: () => context.pop()),
        ),
        body: SafeArea(
          child: Form(
            key: _formKey,
            child: ListView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              children: [
                // Progress indicator
                _StepIndicator(currentStep: 2, totalSteps: 2),
                const SizedBox(height: 24),

                // Business name
                CustomTextField(
                  label: AppStrings.businessName,
                  hint: isMarketVendor
                      ? 'e.g., Mama Amina\'s Vegetables'
                      : 'e.g., Jean\'s Electronics',
                  controller: _businessNameController,
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? AppStrings.fieldRequired : null,
                ),
                const SizedBox(height: 20),

                if (isMarketVendor) ...[
                  // Market selection
                  Text(
                    AppStrings.selectMarket,
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  const SizedBox(height: 8),
                  marketsAsync.when(
                    data: (markets) => _MarketDropdown(
                      markets: markets,
                      selectedId: state.marketId,
                      onChanged: (id) => ref
                          .read(vendorOnboardingProvider.notifier)
                          .setMarket(id),
                    ),
                    loading: () => const LinearProgressIndicator(),
                    error: (_, __) => Text(
                      AppStrings.somethingWentWrong,
                      style: const TextStyle(color: AppColors.error),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Stall code
                  CustomTextField(
                    label: AppStrings.stallCode,
                    hint: AppStrings.stallCodeHint,
                    helperText: AppStrings.stallCodeHelper,
                    controller: _stallCodeController,
                    textCapitalization: TextCapitalization.characters,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return AppStrings.fieldRequired;
                      }
                      if (!_isValidStallCode(v.trim().toUpperCase())) {
                        return AppStrings.invalidStallCode;
                      }
                      return null;
                    },
                  ),

                  // Grid directions preview
                  ValueListenableBuilder<TextEditingValue>(
                    valueListenable: _stallCodeController,
                    builder: (_, value, __) {
                      final code = value.text.trim().toUpperCase();
                      if (!_isValidStallCode(code)) return const SizedBox.shrink();
                      final tempVendor = VendorModel(
                        vendorId: '',
                        userId: '',
                        businessName: '',
                        type: VendorType.market,
                        stallCode: code,
                        mainCategory: '',
                        createdAt: DateTime.now(),
                      );
                      final directions = tempVendor.gridDirections;
                      if (directions == null) return const SizedBox.shrink();
                      return Container(
                        margin: const EdgeInsets.only(top: 12),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.06),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.primary.withOpacity(0.25),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.location_on_rounded,
                              color: AppColors.primary,
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                directions,
                                style: const TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ] else ...[
                  // Individual vendor: neighborhood
                  CustomTextField(
                    label: AppStrings.neighborhood,
                    hint: AppStrings.neighborhoodHint,
                    controller: _neighborhoodController,
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? AppStrings.fieldRequired : null,
                  ),
                ],

                const SizedBox(height: 20),

                // Product category
                Text(
                  AppStrings.productCategory,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const SizedBox(height: 8),
                _CategoryDropdown(
                  selected: state.mainCategory.isEmpty ? null : state.mainCategory,
                  onChanged: (cat) => ref
                      .read(vendorOnboardingProvider.notifier)
                      .setCategory(cat),
                ),

                if (state.error != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    state.error!,
                    style: const TextStyle(color: AppColors.error, fontSize: 13),
                  ),
                ],
                const SizedBox(height: 32),
                CustomButton(
                  label: AppStrings.completeSetup,
                  onPressed: _submit,
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Step Indicator ──────────────────────────────────────────────────────────

class _StepIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const _StepIndicator({required this.currentStep, required this.totalSteps});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(totalSteps, (i) {
        final isActive = i < currentStep;
        return Expanded(
          child: Container(
            height: 4,
            margin: EdgeInsets.only(right: i < totalSteps - 1 ? 6 : 0),
            decoration: BoxDecoration(
              color: isActive ? AppColors.primary : AppColors.divider,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        );
      }),
    );
  }
}

// ─── Market Dropdown ─────────────────────────────────────────────────────────

class _MarketDropdown extends StatelessWidget {
  final List<MarketModel> markets;
  final String? selectedId;
  final void Function(String) onChanged;

  const _MarketDropdown({
    required this.markets,
    required this.selectedId,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: selectedId,
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.surfaceVariant,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      hint: Text(
        AppStrings.selectMarket,
        style: const TextStyle(color: AppColors.textHint, fontSize: 14),
      ),
      items: markets
          .map((m) => DropdownMenuItem(value: m.marketId, child: Text(m.name)))
          .toList(),
      onChanged: (v) {
        if (v != null) onChanged(v);
      },
      validator: (v) =>
          (v == null || v.isEmpty) ? AppStrings.fieldRequired : null,
    );
  }
}

// ─── Category Dropdown ───────────────────────────────────────────────────────

class _CategoryDropdown extends StatelessWidget {
  final String? selected;
  final void Function(String) onChanged;

  const _CategoryDropdown({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: selected,
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.surfaceVariant,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      hint: const Text(
        'Select a category',
        style: TextStyle(color: AppColors.textHint, fontSize: 14),
      ),
      items: ProductModel.categories
          .map((c) => DropdownMenuItem(value: c, child: Text(c)))
          .toList(),
      onChanged: (v) {
        if (v != null) onChanged(v);
      },
      validator: (v) =>
          (v == null || v.isEmpty) ? AppStrings.fieldRequired : null,
    );
  }
}

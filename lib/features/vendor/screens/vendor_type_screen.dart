import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/models/vendor_model.dart';
import '../../../core/providers/vendor_provider.dart';
import '../../../shared/widgets/custom_button.dart';

class VendorTypeScreen extends ConsumerWidget {
  const VendorTypeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(vendorOnboardingProvider);

    return Scaffold(
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
                AppStrings.vendorType,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'Where do you sell your products?',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
              const SizedBox(height: 32),
              _VendorTypeCard(
                type: VendorType.market,
                title: AppStrings.marketVendor,
                description: AppStrings.marketVendorDescription,
                icon: Icons.store_mall_directory_rounded,
                isSelected: state.vendorType == VendorType.market,
                onTap: () => ref
                    .read(vendorOnboardingProvider.notifier)
                    .setVendorType(VendorType.market),
              ),
              const SizedBox(height: 16),
              _VendorTypeCard(
                type: VendorType.individual,
                title: AppStrings.individualVendor,
                description: AppStrings.individualVendorDescription,
                icon: Icons.home_work_rounded,
                isSelected: state.vendorType == VendorType.individual,
                onTap: () => ref
                    .read(vendorOnboardingProvider.notifier)
                    .setVendorType(VendorType.individual),
              ),
              const Spacer(),
              CustomButton(
                label: AppStrings.next,
                onPressed: state.vendorType != null
                    ? () => context.go(AppRoutes.vendorOnboarding)
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _VendorTypeCard extends StatelessWidget {
  final VendorType type;
  final String title;
  final String description;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _VendorTypeCard({
    required this.type,
    required this.title,
    required this.description,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withOpacity(0.07)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.divider,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary.withOpacity(0.12)
                    : AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                icon,
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.textPrimary,
                        ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

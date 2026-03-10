import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/providers/vendor_provider.dart';

/// Placeholder vendor dashboard — will be expanded with product management,
/// promotions, reviews, and in-app chat in future iterations.
class VendorDashboardScreen extends ConsumerWidget {
  const VendorDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vendorAsync = ref.watch(currentVendorProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.appName),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            onPressed: () => ref.read(authServiceProvider).signOut(),
          ),
        ],
      ),
      body: vendorAsync.when(
        data: (vendor) {
          if (vendor == null) {
            return const Center(child: Text('Vendor profile not found.'));
          }
          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              _WelcomeBanner(businessName: vendor.businessName),
              const SizedBox(height: 24),
              if (vendor.gridDirections != null)
                _GridLocatorCard(directions: vendor.gridDirections!),
              const SizedBox(height: 24),
              _DashboardShortcut(
                icon: Icons.inventory_2_rounded,
                label: 'My Products',
                description: 'Add, edit, and manage stock',
                color: AppColors.primary,
                onTap: () =>
                    context.push(AppRoutes.vendorProducts, extra: vendor),
              ),
              const SizedBox(height: 12),
              _DashboardShortcut(
                icon: Icons.campaign_rounded,
                label: 'Promotions',
                description: 'Post daily deals and offers',
                color: AppColors.accent,
                onTap: () {}, // TODO: navigate to promotions screen
              ),
              const SizedBox(height: 12),
              _DashboardShortcut(
                icon: Icons.chat_bubble_rounded,
                label: 'Messages',
                description: 'Chat with your customers',
                color: AppColors.info,
                onTap: () {}, // TODO: navigate to chats screen
              ),
              const SizedBox(height: 12),
              _DashboardShortcut(
                icon: Icons.star_rounded,
                label: 'Reviews',
                description: 'See what customers are saying',
                color: AppColors.star,
                onTap: () {}, // TODO: navigate to reviews screen
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => Center(
          child: Text(
            AppStrings.somethingWentWrong,
            style: const TextStyle(color: AppColors.error),
          ),
        ),
      ),
    );
  }
}

class _WelcomeBanner extends StatelessWidget {
  final String businessName;
  const _WelcomeBanner({required this.businessName});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.storefront_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Welcome back,',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    fontFamily: 'Inter',
                  ),
                ),
                Text(
                  businessName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GridLocatorCard extends StatelessWidget {
  final String directions;
  const _GridLocatorCard({required this.directions});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.location_on_rounded,
            color: AppColors.primary,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Your Stall Location',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  directions,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DashboardShortcut extends StatelessWidget {
  final IconData icon;
  final String label;
  final String description;
  final Color color;
  final VoidCallback onTap;

  const _DashboardShortcut({
    required this.icon,
    required this.label,
    required this.description,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: const Border.fromBorderSide(
              BorderSide(color: AppColors.divider),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textHint,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

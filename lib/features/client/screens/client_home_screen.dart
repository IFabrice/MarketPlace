import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/models/market_model.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/providers/vendor_provider.dart';

class ClientHomeScreen extends ConsumerWidget {
  const ClientHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final marketsAsync = ref.watch(marketsProvider);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Image.asset(
          'assets/images/ndangira_logo.png',
          height: 44,
          errorBuilder: (_, __, ___) => Text(
            AppStrings.appName,
            style: Theme.of(context).appBarTheme.titleTextStyle,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            onPressed: () => ref.read(authServiceProvider).signOut(),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          // Search bar (placeholder)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              children: [
                Icon(Icons.search_rounded, color: AppColors.textHint),
                SizedBox(width: 10),
                Text(
                  'Search products, vendors...',
                  style: TextStyle(
                    color: AppColors.textHint,
                    fontSize: 14,
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          Text(
            'Browse Markets',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 4),
          Text(
            'Find vendors in major Rwandan markets',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),

          marketsAsync.when(
            data: (markets) => Column(
              children: markets
                  .map((m) => _MarketCard(
                        market: m,
                        onTap: () =>
                            context.push(AppRoutes.marketDetail, extra: m),
                      ))
                  .toList(),
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, __) => Text(
              AppStrings.somethingWentWrong,
              style: const TextStyle(color: AppColors.error),
            ),
          ),

          const SizedBox(height: 28),
          Text(
            'Coming Soon',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          _ComingSoonChip(label: 'Promotions & Daily Deals'),
          const SizedBox(height: 8),
          _ComingSoonChip(label: 'In-App Chat with Vendors'),
          const SizedBox(height: 8),
          _ComingSoonChip(label: 'Reviews & Ratings'),
          const SizedBox(height: 8),
          _ComingSoonChip(label: 'MoMo / Airtel Money Payments'),
        ],
      ),
    );
  }
}

class _MarketCard extends StatelessWidget {
  final MarketModel market;
  final VoidCallback onTap;
  const _MarketCard({required this.market, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
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
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.store_mall_directory_rounded,
                    color: AppColors.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        market.name,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        '${market.city} · ${market.totalStalls} stalls',
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
      ),
    );
  }
}

class _ComingSoonChip extends StatelessWidget {
  final String label;
  const _ComingSoonChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const Icon(Icons.access_time_rounded,
              color: AppColors.textHint, size: 16),
          const SizedBox(width: 10),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
              fontFamily: 'Inter',
            ),
          ),
        ],
      ),
    );
  }
}

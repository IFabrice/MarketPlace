import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/models/product_model.dart';
import '../../../core/models/vendor_model.dart';

class ProductDetailScreen extends StatelessWidget {
  final ProductModel product;
  final VendorModel vendor;
  const ProductDetailScreen(
      {super.key, required this.product, required this.vendor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Product image placeholder
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _categoryIcon(product.category),
                  size: 64,
                  color: AppColors.textHint,
                ),
                const SizedBox(height: 8),
                Text(
                  product.category,
                  style: const TextStyle(
                    color: AppColors.textHint,
                    fontSize: 13,
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Price + stock status row
          Row(
            children: [
              Text(
                product.formattedPrice,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                  fontFamily: 'Inter',
                ),
              ),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: product.inStock
                      ? AppColors.primary.withOpacity(0.1)
                      : AppColors.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      product.inStock
                          ? Icons.check_circle_rounded
                          : Icons.cancel_rounded,
                      size: 14,
                      color: product.inStock
                          ? AppColors.primary
                          : AppColors.error,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      product.inStock ? 'In stock' : 'Out of stock',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: product.inStock
                            ? AppColors.primary
                            : AppColors.error,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            product.name,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),

          // Description
          Text(
            'Description',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 6),
          Text(
            product.description,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 24),

          // Sold by
          const Divider(color: AppColors.divider),
          const SizedBox(height: 16),
          Text(
            'Sold by',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: const Border.fromBorderSide(
                  BorderSide(color: AppColors.divider)),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primary, AppColors.accent],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.storefront_rounded,
                      color: Colors.white, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(vendor.businessName,
                          style: Theme.of(context).textTheme.titleMedium),
                      Text(vendor.mainCategory,
                          style: Theme.of(context).textTheme.bodyMedium),
                    ],
                  ),
                ),
                Row(
                  children: [
                    const Icon(Icons.star_rounded,
                        color: AppColors.star, size: 14),
                    const SizedBox(width: 3),
                    Text(
                      vendor.rating.toStringAsFixed(1),
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // CTA buttons
          ElevatedButton.icon(
            onPressed: product.inStock
                ? () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content:
                              Text('MoMo / Airtel Money payments — coming soon!')),
                    );
                  }
                : null,
            icon: const Icon(Icons.shopping_cart_rounded),
            label: const Text('Buy Now'),
          ),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('In-App Chat — coming soon!')),
              );
            },
            icon: const Icon(Icons.chat_bubble_outline_rounded),
            label: const Text('Contact Vendor'),
          ),
        ],
      ),
    );
  }

  IconData _categoryIcon(String category) {
    switch (category) {
      case 'Vegetables & Fruits':
        return Icons.eco_rounded;
      case 'Clothing & Textiles':
        return Icons.checkroom_rounded;
      case 'Electronics':
        return Icons.devices_rounded;
      case 'Beauty & Health':
        return Icons.spa_rounded;
      case 'Food & Groceries':
        return Icons.shopping_basket_rounded;
      case 'Household Items':
        return Icons.home_rounded;
      case 'Crafts & Handmade':
        return Icons.palette_rounded;
      case 'Mobile & Accessories':
        return Icons.phone_android_rounded;
      default:
        return Icons.inventory_2_rounded;
    }
  }
}

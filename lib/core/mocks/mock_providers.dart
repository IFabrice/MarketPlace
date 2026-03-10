import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/market_model.dart';
import '../models/product_model.dart';
import '../models/user_model.dart';
import '../models/vendor_model.dart';
import '../providers/auth_provider.dart';
import '../providers/vendor_provider.dart';
import 'mock_data.dart';

// ─── Current session mocks ───────────────────────────────────────────────────

final _mockUser = UserModel(
  uid: 'mock-user-001',
  phone: '+250788123456',
  role: UserRole.vendor,
  name: 'Amina Uwase',
  createdAt: DateTime(2025, 1, 1),
);

final _mockVendor = mockVendors.firstWhere((v) => v.vendorId == 'mock-user-001');

// ─── In-memory query providers ───────────────────────────────────────────────
// These read from in-memory mock lists — no Firestore required.

/// All vendors for a given market ID.
final vendorsByMarketProvider =
    FutureProvider.family<List<VendorModel>, String>((ref, marketId) async {
  return mockVendors.where((v) => v.marketId == marketId).toList();
});

/// All products for a given vendor ID.
final productsByVendorProvider =
    FutureProvider.family<List<ProductModel>, String>((ref, vendorId) async {
  return mockProducts.where((p) => p.vendorId == vendorId).toList();
});

/// Look up a single vendor by ID.
final vendorByIdProvider =
    FutureProvider.family<VendorModel?, String>((ref, vendorId) async {
  try {
    return mockVendors.firstWhere((v) => v.vendorId == vendorId);
  } catch (_) {
    return null;
  }
});

// ─── Provider overrides ──────────────────────────────────────────────────────

final List<Override> mockOverrides = [
  currentUserProvider.overrideWith((_) async => _mockUser),
  currentVendorProvider.overrideWith((_) async => _mockVendor),
  marketsProvider.overrideWith((_) async => mockMarkets),
];

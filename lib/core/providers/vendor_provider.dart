import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/vendor_model.dart';
import '../models/market_model.dart';
import '../services/firestore_service.dart';
import 'auth_provider.dart';

final marketsProvider = FutureProvider<List<MarketModel>>((ref) async {
  return ref.read(firestoreServiceProvider).getMarkets();
});

final currentVendorProvider = FutureProvider<VendorModel?>((ref) async {
  final user = await ref.watch(currentUserProvider.future);
  if (user == null) return null;
  return ref.read(firestoreServiceProvider).getVendorByUserId(user.uid);
});

// ─── Vendor onboarding state ─────────────────────────────────────────────────

class VendorOnboardingState {
  final VendorType? vendorType;
  final String businessName;
  final String? marketId;
  final String? stallCode;
  final String? neighborhood;
  final String mainCategory;
  final bool isLoading;
  final String? error;
  final bool isComplete;

  const VendorOnboardingState({
    this.vendorType,
    this.businessName = '',
    this.marketId,
    this.stallCode,
    this.neighborhood,
    this.mainCategory = '',
    this.isLoading = false,
    this.error,
    this.isComplete = false,
  });

  VendorOnboardingState copyWith({
    VendorType? vendorType,
    String? businessName,
    String? marketId,
    String? stallCode,
    String? neighborhood,
    String? mainCategory,
    bool? isLoading,
    String? error,
    bool? isComplete,
  }) =>
      VendorOnboardingState(
        vendorType: vendorType ?? this.vendorType,
        businessName: businessName ?? this.businessName,
        marketId: marketId ?? this.marketId,
        stallCode: stallCode ?? this.stallCode,
        neighborhood: neighborhood ?? this.neighborhood,
        mainCategory: mainCategory ?? this.mainCategory,
        isLoading: isLoading ?? this.isLoading,
        error: error,
        isComplete: isComplete ?? this.isComplete,
      );
}

class VendorOnboardingNotifier extends Notifier<VendorOnboardingState> {
  @override
  VendorOnboardingState build() => const VendorOnboardingState();

  void setVendorType(VendorType type) =>
      state = state.copyWith(vendorType: type);

  void setBusinessName(String name) =>
      state = state.copyWith(businessName: name);

  void setMarket(String marketId) => state = state.copyWith(marketId: marketId);

  void setStallCode(String code) => state = state.copyWith(stallCode: code);

  void setNeighborhood(String neighborhood) =>
      state = state.copyWith(neighborhood: neighborhood);

  void setCategory(String category) =>
      state = state.copyWith(mainCategory: category);

  Future<void> submit(String userId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final firestoreService = ref.read(firestoreServiceProvider);
      final vendor = VendorModel(
        vendorId: userId, // one-to-one with user for now
        userId: userId,
        businessName: state.businessName,
        type: state.vendorType!,
        marketId: state.marketId,
        stallCode: state.stallCode,
        neighborhood: state.neighborhood,
        mainCategory: state.mainCategory,
        createdAt: DateTime.now(),
      );
      await firestoreService.createVendor(vendor);
      state = state.copyWith(isLoading: false, isComplete: true);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

final vendorOnboardingProvider =
    NotifierProvider<VendorOnboardingNotifier, VendorOnboardingState>(
  VendorOnboardingNotifier.new,
);

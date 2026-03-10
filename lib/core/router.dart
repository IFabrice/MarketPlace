import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'constants/app_config.dart';
import 'constants/app_routes.dart';
import 'models/market_model.dart';
import 'models/product_model.dart';
import 'models/vendor_model.dart';
import 'providers/auth_provider.dart';
import '../features/auth/screens/splash_screen.dart';
import '../features/auth/screens/phone_auth_screen.dart';
import '../features/auth/screens/otp_verification_screen.dart';
import '../features/auth/screens/role_selection_screen.dart';
import '../features/vendor/screens/vendor_type_screen.dart';
import '../features/vendor/screens/vendor_onboarding_screen.dart';
import '../features/vendor/screens/vendor_dashboard_screen.dart';
import '../features/vendor/screens/vendor_products_screen.dart';
import '../features/client/screens/client_home_screen.dart';
import '../features/client/screens/market_detail_screen.dart';
import '../features/client/screens/vendor_profile_screen.dart';
import '../features/client/screens/product_detail_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: kUseMocks ? kMockStartRoute : AppRoutes.splash,
    redirect: (context, state) {
      // Skip auth guard entirely in mock mode
      if (kUseMocks) return null;

      final firebaseUser = ref.read(firebaseAuthUserProvider).valueOrNull;
      final isAuthRoute = state.matchedLocation == AppRoutes.phoneAuth ||
          state.matchedLocation == AppRoutes.otpVerification ||
          state.matchedLocation == AppRoutes.splash;

      if (firebaseUser == null && !isAuthRoute) {
        return AppRoutes.phoneAuth;
      }
      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (_, __) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.phoneAuth,
        builder: (_, __) => const PhoneAuthScreen(),
      ),
      GoRoute(
        path: AppRoutes.otpVerification,
        builder: (context, state) {
          final phone = state.extra as String? ?? '';
          return OtpVerificationScreen(phoneNumber: phone);
        },
      ),
      GoRoute(
        path: AppRoutes.roleSelection,
        builder: (_, __) => const RoleSelectionScreen(),
      ),
      GoRoute(
        path: AppRoutes.vendorType,
        builder: (_, __) => const VendorTypeScreen(),
      ),
      GoRoute(
        path: AppRoutes.vendorOnboarding,
        builder: (_, __) => const VendorOnboardingScreen(),
      ),
      GoRoute(
        path: AppRoutes.vendorDashboard,
        builder: (_, __) => const VendorDashboardScreen(),
      ),
      GoRoute(
        path: AppRoutes.vendorProducts,
        builder: (_, state) {
          final vendor = state.extra as VendorModel;
          return VendorProductsScreen(vendor: vendor);
        },
      ),
      GoRoute(
        path: AppRoutes.clientHome,
        builder: (_, __) => const ClientHomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.marketDetail,
        builder: (_, state) {
          final market = state.extra as MarketModel;
          return MarketDetailScreen(market: market);
        },
      ),
      GoRoute(
        path: AppRoutes.vendorProfile,
        builder: (_, state) {
          final vendor = state.extra as VendorModel;
          return VendorProfileScreen(vendor: vendor);
        },
      ),
      GoRoute(
        path: AppRoutes.productDetail,
        builder: (_, state) {
          final extra = state.extra as Map<String, dynamic>;
          return ProductDetailScreen(
            product: extra['product'] as ProductModel,
            vendor: extra['vendor'] as VendorModel,
          );
        },
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text(
          'Page not found: ${state.error}',
          style: const TextStyle(color: Colors.red),
        ),
      ),
    ),
  );
});

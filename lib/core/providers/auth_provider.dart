import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import '../models/user_model.dart';

final authServiceProvider = Provider<AuthService>((ref) => AuthService());
final firestoreServiceProvider =
    Provider<FirestoreService>((ref) => FirestoreService());

/// Streams the raw Firebase Auth user (null = logged out).
final firebaseAuthUserProvider = StreamProvider<User?>((ref) {
  return ref.watch(authServiceProvider).authStateChanges;
});

/// The fully-loaded Ndangira [UserModel], once the user is signed in.
final currentUserProvider = FutureProvider<UserModel?>((ref) async {
  final firebaseUser = ref.watch(firebaseAuthUserProvider).valueOrNull;
  if (firebaseUser == null) return null;

  final firestoreService = ref.read(firestoreServiceProvider);
  return firestoreService.getUser(firebaseUser.uid);
});

// ─── OTP flow state ─────────────────────────────────────────────────────────

class OtpState {
  final bool isLoading;
  final String? verificationId;
  final String? error;
  final bool codeSent;

  const OtpState({
    this.isLoading = false,
    this.verificationId,
    this.error,
    this.codeSent = false,
  });

  OtpState copyWith({
    bool? isLoading,
    String? verificationId,
    String? error,
    bool? codeSent,
  }) =>
      OtpState(
        isLoading: isLoading ?? this.isLoading,
        verificationId: verificationId ?? this.verificationId,
        error: error,
        codeSent: codeSent ?? this.codeSent,
      );
}

class OtpNotifier extends Notifier<OtpState> {
  @override
  OtpState build() => const OtpState();

  Future<void> sendOtp(String phoneNumber) async {
    state = state.copyWith(isLoading: true, error: null);

    await ref.read(authServiceProvider).sendOtp(
      phoneNumber: phoneNumber,
      onCodeSent: (verificationId) {
        state = state.copyWith(
          isLoading: false,
          verificationId: verificationId,
          codeSent: true,
        );
      },
      onError: (error) {
        state = state.copyWith(isLoading: false, error: error);
      },
    );
  }

  Future<bool> verifyOtp(String smsCode) async {
    if (state.verificationId == null) return false;
    state = state.copyWith(isLoading: true, error: null);

    try {
      final credential = await ref.read(authServiceProvider).verifyOtp(
            verificationId: state.verificationId!,
            smsCode: smsCode,
          );
      state = state.copyWith(isLoading: false);
      return credential != null;
    } on FirebaseAuthException catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.message ?? 'Invalid code.',
      );
      return false;
    }
  }

  void reset() => state = const OtpState();
}

final otpProvider = NotifierProvider<OtpNotifier, OtpState>(OtpNotifier.new);

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Sends an OTP to [phoneNumber] (must include country code, e.g., +250788000000).
  /// Calls [onCodeSent] with the verificationId when SMS is delivered.
  Future<void> sendOtp({
    required String phoneNumber,
    required void Function(String verificationId) onCodeSent,
    required void Function(String error) onError,
  }) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Android auto-retrieval
          await _auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          final msg = switch (e.code) {
            'invalid-phone-number' => 'The phone number is not valid.',
            'too-many-requests' => 'Too many attempts. Please try again later.',
            'quota-exceeded' => 'SMS quota exceeded. Please try again later.',
            _ => e.message ?? 'Verification failed.',
          };
          onError(msg);
        },
        codeSent: (String verificationId, int? resendToken) {
          onCodeSent(verificationId);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          debugPrint('Auto-retrieval timeout: $verificationId');
        },
      );
    } catch (e) {
      onError(e.toString());
    }
  }

  /// Verifies [smsCode] against [verificationId] and signs the user in.
  Future<UserCredential?> verifyOtp({
    required String verificationId,
    required String smsCode,
  }) async {
    final credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );
    return _auth.signInWithCredential(credential);
  }

  Future<void> signOut() => _auth.signOut();
}

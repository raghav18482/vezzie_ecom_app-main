import 'package:ecom_app/src/Data/local%20data/prefrence.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class FirebaseOTPVerification {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> verifyPhoneNumber(
    String phoneNumber,
    Function(String verificationId) onCodeSent,
    Function(String errorMessage) onVerificationFailed,
    Function(String message) onAutoRetrievalTimeout,
  ) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) {
          // This callback will be triggered if auto-verification occurs.
          // For example, if the user receives the OTP code without manual input.
        },
        verificationFailed: (FirebaseAuthException e) {
          onVerificationFailed(e.message ?? 'Verification Failed');
        },
        codeSent: (String verificationId, int? resendToken) {
          onCodeSent(verificationId);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          onAutoRetrievalTimeout('OTP code auto-retrieval timeout');
        },
        timeout: const Duration(
            seconds: 60), // Timeout duration for OTP verification.
      );
    } catch (e) {
      onVerificationFailed('Error: ${e.toString()}');
    }
  }

  Future<void> handleLogout() async {
    try {
      await _auth.signOut();
      Pref.clearAllData();

      // Perform any additional actions after successful logout, if needed
    } catch (e) {
      // Handle any errors that occur during logout, if needed
      if (kDebugMode) {
        print("Error during logout: ${e.toString()}");
      }
    }
  }

  Future<void> signInWithOTP(
    String otp,
    String verificationId,
    Function() onVerificationCompleted,
    Function(String errorMessage) onVerificationFailed,
  ) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp,
      );
      await _auth.signInWithCredential(credential);
      onVerificationCompleted();
    } catch (e) {
      onVerificationFailed('Error: ${e.toString()}');
    }
  }
}

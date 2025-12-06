import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();
  User? get currentUser => _firebaseAuth.currentUser;
  /// ------------------------ OTP ------------------------
  Future<void> sendOTP({
    required String phone,
    required Function(String verificationId) onCodeSent,
    required Function(String error) onError,
  }) async {
    await _firebaseAuth.verifyPhoneNumber(
      phoneNumber: phone,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _firebaseAuth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        onError(e.message ?? "Verification failed");
      },
      codeSent: (String verificationId, int? resendToken) {
        onCodeSent(verificationId);
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }
  Future<UserCredential> verifyOTP({
    required String verificationId,
    required String smsCode,
  }) async {
    final credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );
    return await _firebaseAuth.signInWithCredential(credential);
  }
   // --- Email & Password Methods ---

  Future<User?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      print('AuthService Error in signIn: ${e.code}');
      rethrow;
    }
  }

  Future<User?> signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user != null) {
        await user.updateDisplayName(fullName);
        return user;
      }
      return null;
    } on FirebaseAuthException catch (e) {
      print('AuthService Error in signUp: ${e.code}');
      rethrow;
    }
  }

  // --- Google Sign-In Method ---

  Future<User?> signInWithGoogle() async {
    try {

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        print('Google sign in cancelled by user.');
        return null;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      print('AuthService Error in signInWithGoogle: ${e.code}');
      rethrow;
    } catch (e) {
      print('An unexpected error occurred in signInWithGoogle: $e');
      rethrow;
    }
  }

  // --- Password Update Method ---

  Future<void> updatePassword({required String newPassword}) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user != null) {
        await user.updatePassword(newPassword);
      } else {
        throw FirebaseAuthException(
          code: "no-current-user",
          message: "No user is currently signed in to update the password.",
        );
      }
    } on FirebaseAuthException catch (e) {
      print('AuthService Error in updatePassword: ${e.code}');
      rethrow;
    }
  }

  // --- Sign Out Method ---

  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _firebaseAuth.signOut();
    } catch (e) {
      print('Error during sign out: $e');
      await _firebaseAuth.signOut();
    }
  }
}

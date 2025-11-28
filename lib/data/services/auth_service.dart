import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  /// Stream of auth changes (login/logout)
  Stream<User?> get user => _firebaseAuth.authStateChanges();

  /// Current signed-in user (nullable)
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

  /// ------------------------ Email ------------------------
  Future<User?> signIn({
    required String email,
    required String password,
  }) async {
    final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential.user;
  }

  Future<User?> signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    if (userCredential.user != null) {
      // Update display name after signup
      await userCredential.user!.updateDisplayName(fullName);
      await userCredential.user!.reload();
      return _firebaseAuth.currentUser; // Always return latest user
    }
    return null;
  }

  /// ------------------------ Google ------------------------
  Future<User?> signInWithGoogle() async {
    // Ensure clean sign-in
    await _googleSignIn.signOut();
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) return null;

    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCredential = await _firebaseAuth.signInWithCredential(credential);
    return userCredential.user;
  }

  /// ------------------------ Password ------------------------
  Future<void> updatePassword({required String newPassword}) async {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      await user.updatePassword(newPassword);
      await user.reload();
    } else {
      throw FirebaseAuthException(
        code: "no-current-user",
        message: "No user is currently signed in.",
      );
    }
  }

  /// ------------------------ Sign Out ------------------------
  Future<void> signOut() async {
    // Sign out from Firebase & Google
    await _firebaseAuth.signOut();
    await _googleSignIn.signOut();
    // ⚡ AuthWrapper listens to authStateChanges → Home/Login will update automatically
  }
}

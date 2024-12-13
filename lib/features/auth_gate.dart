import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:giant_gipsland_earthworm_fe/core/bindings/dashboard_bindings.dart';
import 'package:giant_gipsland_earthworm_fe/features/auth/onboarding/onboarding_screen.dart';
import 'package:giant_gipsland_earthworm_fe/features/dashboard/dashboard_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthGate extends StatelessWidget {
  static const String routeName = "/";

  const AuthGate({super.key});

  Future<void> _checkUserExistence() async {
    User? user = FirebaseAuth.instance.currentUser;

    try {
      await user?.reload(); // Reload user to check if still exists
    } catch (e) {
      if (e is FirebaseAuthException && e.code == 'user-not-found') {
        // If the user no longer exists, sign out
        await FirebaseAuth.instance.signOut();
        await GoogleSignIn().signOut();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          User? user = snapshot.data;
          if (user == null) {
            return const OnboardingScreen();
          }

          // Check for manual deletion or session expiration
          _checkUserExistence();

          DashboardBinding().dependencies();
          return const DashboardScreen();
        } else {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }
}

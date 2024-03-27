import 'package:flutter/material.dart';
import 'package:shrine/app.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../presentation/screens/register_screen.dart';
import '../presentation/screens/sign_in_screen.dart';

class AuthChanges extends StatefulWidget {
  final SupabaseClient supabase;
  const AuthChanges({super.key, required this.supabase});

  @override
  State<AuthChanges> createState() => _LoginOrSignUpState();
}

class _LoginOrSignUpState extends State<AuthChanges> {
  //initially show login page
  bool showLoginPage = true;
  //function to switch between the pages
  void switchScreens() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Session? session = widget.supabase.auth.currentSession;
    if (session == null) {
      if (showLoginPage) {
        return SignInScreen(
          onTap: switchScreens,
          supabase: widget.supabase,
        );
      } else {
        return RegisterScreen(
          supabase: widget.supabase,
          onTap: switchScreens,
        );
      }
    } else {
      return HomeScreen(
        supabase: widget.supabase,
      );
    }
  }
}

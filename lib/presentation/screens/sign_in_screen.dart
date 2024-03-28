// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shrine/app.dart';
import 'package:shrine/presentation/widgets/cta_button.dart';
import 'package:shrine/presentation/widgets/text_field.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../themes/theme.dart';

class SignInScreen extends StatefulWidget {
  final SupabaseClient supabase;
  final Function()? onTap;
  const SignInScreen({super.key, required this.onTap, required this.supabase});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    //user controller
    TextEditingController emailController = TextEditingController();
    //group controller
    TextEditingController groupController = TextEditingController();
    //password controller
    TextEditingController passwordController = TextEditingController();
    void showErrorDialog(BuildContext context, String message) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Oops, something went wrong"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("OK"),
            ),
          ],
        ),
      );
    }

    Future<void> signInUser() async {
      if (emailController.text.isEmpty ||
          passwordController.text.isEmpty ||
          groupController.text.length < 5) {
        showErrorDialog(context,
            "Please fill in all fields and use a password with at least 7 characters.");
        return;
      }

      try {
        showDialog(
          context: context,
          builder: (context) => Container(
            color: whiteBG,
            child: Center(
                child: Lottie.asset('assets/lottie/ani1.json', height: 500)),
          ),
        );
        final session = await widget.supabase.auth.signInWithPassword(
          email: emailController.text,
          password: passwordController.text,
        );

        // ignore: unnecessary_null_comparison
        if (session == null) {
          Navigator.of(context).pop();
          showErrorDialog(context, "Invalid email or password.");
        } else {
          
          //to store team name in shared preference
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('team_name', groupController.text);

          Navigator.of(context).pop();
          // Successful sign-in, navigate to home screen
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => HomeScreen(supabase: widget.supabase),
          ));
        }
      } catch (error) {
        showErrorDialog(context, "An unexpected error occurred. \n $error");
      }
    }

    return Scaffold(
      backgroundColor: whiteBG,
      body: Stack(
        // mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
              height: 400,
              child: Lottie.asset(
                'assets/lottie/ani2.json',
                fit: BoxFit.cover,
              )),
          Align(
            alignment: const Alignment(0, 1),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(left: 8, right: 8),
                child: Container(
                  decoration: const BoxDecoration(
                      color: whiteContainer,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20))),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Shrine',
                        style: GoogleFonts.dmSerifDisplay(fontSize: 35),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      const Center(
                        child: Text(
                          '"A one stop solution for project management"',
                          style: TextStyle(
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      InputTextField(
                        hintText: 'Group Email',
                        controller: emailController,
                        left: 8,
                        right: 8,
                        bottom: 20,
                      ),
                      InputTextField(
                        hintText: 'Group Name',
                        controller: groupController,
                        left: 8,
                        right: 8,
                        bottom: 20,
                      ),
                      InputTextField(
                        obscureText: true,
                        hintText: 'Password',
                        controller: passwordController,
                        left: 8,
                        right: 8,
                        bottom: 20,
                      ),
                      CTAButton(
                        text: 'Sign in',
                        onTap: signInUser,
                        right: 8,
                        left: 8,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Don't have an account? ",
                            style: TextStyle(fontSize: 10),
                          ),
                          GestureDetector(
                            onTap: widget.onTap,
                            child: const Text(
                              "Register Now",
                              style: TextStyle(
                                  fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

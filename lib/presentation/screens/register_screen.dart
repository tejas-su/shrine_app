// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:shrine/presentation/widgets/cta_button.dart';
import 'package:shrine/presentation/widgets/text_field.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../app.dart';
import '../themes/theme.dart';

class RegisterScreen extends StatefulWidget {
  final Function()? onTap;
  final SupabaseClient supabase;
  const RegisterScreen(
      {super.key, required this.onTap, required this.supabase});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    //user controller
    TextEditingController groupEmailController = TextEditingController();
    //group controller
    TextEditingController groupPasswordController = TextEditingController();
    //password controller
    TextEditingController groupNameController = TextEditingController();

    //Show success dialog to the user if everything goes properly
    void _showDialog(BuildContext context, String message) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Success 🥳"),
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

    //show error message to the user if something goes wrong
    void _showErrorDialog(BuildContext context, String message) {
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

    //create a new team in the database
    Future<void> insertUserData() async {
      try {
        await widget.supabase.from('team').upsert([
          {
            'team_name': groupNameController.text,
            'team_email': groupEmailController.text,
            'team_password': groupPasswordController.text,
          }
        ]);
      } catch (error) {
        _showErrorDialog(context,
            'Oops, Something went wrong while creating your team./n This was the error message: $error');
      }
    }

    //register the user
    Future<void> registerUser() async {
      if (groupEmailController.text.isEmpty ||
          groupPasswordController.text.length < 7 ||
          groupNameController.text.length < 5) {
        _showErrorDialog(context,
            "Please fill in all fields and use a password with at least 7 characters and a group name with at least 5 characters.");
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
        final session = await widget.supabase.auth.signUp(
          email: groupEmailController.text,
          password: groupPasswordController.text,
        );

        // ignore: unnecessary_null_comparison
        if (session == null) {
          Navigator.of(context).pop();
          _showErrorDialog(context, "An error occurred during registration.");
        } else {
          //upsert data to the table
          insertUserData();

          // Successful registration, show success message and switch to sign-in
          Navigator.of(context).pop();
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => HomeScreen(supabase: widget.supabase),
          ));
          _showDialog(context, "Registration successful 🥳");
          widget.onTap?.call();
        }
      } catch (error) {
        _showErrorDialog(context, "An unexpected error occurred.");
      }
    }

    return Scaffold(
      backgroundColor: whiteBG,
      body: Stack(
        children: [
          SizedBox(
              height: 400,
              child:
                  Lottie.asset('assets/lottie/ani2.json', fit: BoxFit.cover)),
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
                        controller: groupEmailController,
                        left: 8,
                        right: 8,
                        bottom: 20,
                      ),
                      InputTextField(
                        hintText: 'Group Name',
                        left: 8,
                        controller: groupNameController,
                        right: 8,
                        bottom: 20,
                      ),
                      InputTextField(
                        obscureText: true,
                        controller: groupPasswordController,
                        hintText: 'Password',
                        left: 8,
                        right: 8,
                        bottom: 20,
                      ),
                      CTAButton(
                        text: 'Register',
                        onTap: registerUser,
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
                            "Already have an account? ",
                            style: TextStyle(fontSize: 10),
                          ),
                          GestureDetector(
                            onTap: widget.onTap,
                            child: const Text(
                              "SignIn Now",
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

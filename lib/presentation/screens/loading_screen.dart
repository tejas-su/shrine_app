import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoadingScreen extends StatefulWidget {
  final String text;
  final SupabaseClient supabase;

  ///Pass in the screen which you want to diplay after the loding screen
  final Widget screen;
  const LoadingScreen(
      {super.key, required this.supabase, required this.screen, this.text=''});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => widget.screen),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Lottie.asset('assets/lottie/ani1.json', height: 500),//500
            const SizedBox(
              height: 50,
            ),
            Text(widget.text,
              style: GoogleFonts.dmSerifDisplay(
                  fontWeight: FontWeight.w500, fontSize: 25),
            )
          ],
        ),
      ),
    );
  }
}

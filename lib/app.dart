// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:lottie/lottie.dart';
import 'package:shrine/presentation/screens/chat_screen.dart';
import 'package:shrine/services/auth_changes.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'presentation/screens/add_screen.dart';
import 'presentation/screens/bugs_screen.dart';
import 'presentation/screens/home_content.dart';
import 'presentation/screens/search_screen.dart';
import 'presentation/screens/users_screen.dart';
import 'presentation/themes/theme.dart';

class HomeScreen extends StatefulWidget {
  final SupabaseClient supabase;
  const HomeScreen({super.key, required this.supabase});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List screens = [
    HomeContent(
      supabase: Supabase.instance.client,
    ),
    UsersScreen(
      supabase: Supabase.instance.client,
    ),
    AddScreen(supabase: Supabase.instance.client),
    BugsScreen(),
    SearchScreen(),
  ];
  int selectedIndex = 0;

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

  void onTabChange(int value) {
    setState(() {
      selectedIndex = value;
    });
  }

  void signOutUser() async {
    try {
      showDialog(
        context: context,
        builder: (context) => Container(
          color: whiteBG,
          child: Center(
              child: Lottie.asset('assets/lottie/ani1.json', height: 500)),
        ),
      );
      await widget.supabase.auth.signOut();
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => AuthChanges(supabase: widget.supabase),
      ));
    } catch (e) {
      _showErrorDialog(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: whiteBG,
        appBar: AppBar(
          leading: const SizedBox(),
          leadingWidth: 0,
          backgroundColor: whiteContainer,
          title: Text(
            'Shrine',
            style: GoogleFonts.dmSerifDisplay(fontSize: 30),
          ),
          actions: [
            Builder(builder: (context) {
              return IconButton(
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                  icon: const Icon(
                    Icons.group_rounded,
                    size: 25,
                    color: black,
                  ));
            }),
            //Sign out button
            Padding(
              padding: const EdgeInsets.only(right: 5),
              child: IconButton(
                  onPressed: signOutUser,
                  icon: const Icon(
                    Icons.exit_to_app_rounded,
                    color: black,
                  )),
            )
          ],
        ),
        drawer: ChatScreen(supabase:widget.supabase),
        body: screens[selectedIndex],
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
              color: whiteContainer,
              border: Border(top: BorderSide(width: 0.01))),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: GNav(
              onTabChange: (value) {
                onTabChange(value);
              },
              selectedIndex: selectedIndex,
              activeColor: black,
              gap: 8,
              tabBackgroundColor: whiteBG,
              tabBorderRadius: 10,
              backgroundColor: whiteContainer,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              tabs: const [
                GButton(
                  padding: EdgeInsets.all(20),
                  icon: Icons.newspaper_rounded,
                ),
                GButton(
                  padding: EdgeInsets.all(20),
                  icon: Icons.person_rounded,
                ),
                GButton(
                  padding: EdgeInsets.all(20),
                  icon: Icons.add_rounded,
                ),
                GButton(
                  padding: EdgeInsets.all(20),
                  icon: Icons.bug_report_rounded,
                ),
                GButton(
                  padding: EdgeInsets.all(20),
                  icon: Icons.search_rounded,
                )
              ],
            ),
          ),
        ));
  }
}

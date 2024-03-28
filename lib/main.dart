import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shrine/services/auth_changes.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'constants/api_keys.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: url,
    anonKey: anonKey,
  );
  final supabase = Supabase.instance.client;
  const SystemUiOverlayStyle(
      statusBarBrightness: Brightness.light,
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark);
  runApp(MyApp(
    supabase: supabase,
  ));
}

class MyApp extends StatelessWidget {
  final SupabaseClient supabase;
  const MyApp({super.key, required this.supabase});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(useMaterial3: true),
      debugShowCheckedModeBanner: false,
      home: AuthChanges(
        supabase: supabase,
      ),
    );
  }
}

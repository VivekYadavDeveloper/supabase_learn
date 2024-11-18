import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'auth/auth_gate.dart';

void main() async {
  /*Supabase Setup*/

  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
      url: "https://vzcairpodngztbzfpzuq.supabase.co",
      anonKey:
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZ6Y2FpcnBvZG5nenRiemZwenVxIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzE4NzE1NDMsImV4cCI6MjA0NzQ0NzU0M30.i_z-Mfx_1i1w0-MR1s1vz-EmQsrp1QZjL0UKuwVvsMY");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Supa base',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const AuthGate(),
    );
  }
}

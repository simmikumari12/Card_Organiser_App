import 'package:flutter/material.dart';
// Replace 'card_organizer_app' with your actual project name if different
import 'package:card_organizer_app/screens/folders_screen.dart';

void main() {
  // Required to ensure internal Flutter plugins (like sqflite) 
  // are initialized before the app starts
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(const CardOrganizerApp());
}

class CardOrganizerApp extends StatelessWidget {
  const CardOrganizerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Card Organizer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      // This points the app to your initial screen
      home: FoldersScreen(),
    );
  }
}
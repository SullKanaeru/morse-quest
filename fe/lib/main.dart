import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:morsequest/features/main_page/screens/main_screen.dart';
import 'package:morsequest/shared/providers/sound_provider.dart';
import 'package:morsequest/shared/providers/user_provider.dart';
import 'package:morsequest/shared/widgets/network_overlay.dart';
void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SoundProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: const MyApp(),
    ),
  );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return NetworkOverlay(
      child: MaterialApp(
        title: "Morse Quest",
        theme: ThemeData(fontFamily: "QuickSand", primaryColor: Colors.blue),
        home: const MainScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

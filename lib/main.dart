import 'package:flutter/material.dart';

import 'config/app_config.dart';
import 'providers/app_provider.dart';
import 'screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppConfig.load();
  runApp(const MyApp());
}

/// Root aplikasi dengan tema terpusat.
class MyApp extends StatelessWidget {
  /// Membuat [MyApp].
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => AppProviderWrapper(
    child: MaterialApp(
      title: 'Profil Mahasiswa',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
        cardTheme: const CardThemeData(elevation: 2),
        appBarTheme: const AppBarTheme(centerTitle: true),
      ),
      home: const HomeScreen(),
    ),
  );
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/scan_provider.dart';
import 'providers/cards_provider.dart';
import 'services/database_service.dart';
import 'screens/home_screen.dart';

class App extends StatelessWidget {
  final DatabaseService databaseService;

  const App({super.key, required this.databaseService});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ScanProvider()),
        ChangeNotifierProvider(create: (_) => CardsProvider(databaseService)),
      ],
      child: MaterialApp(
        title: 'Visitenkarten',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            brightness: Brightness.light,
          ),
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            centerTitle: true,
          ),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'provider/app_data.dart';
import 'pages/home.dart';
import 'services/database_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper().initializeDatabase();
  runApp(
    ChangeNotifierProvider(create: (_) => AppData(), child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'Silkscreen',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
      ),
      home: const MyHomePage(title: 'Aplicación'),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Provider/app_data.dart'; // Asegúrate de que la ruta sea correcta
import 'Pages/home.dart';

void main() {
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
      home: const MyHomePage(title: 'Aplicacion'),
    );
  }
}

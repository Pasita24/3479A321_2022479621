import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferenciaScreen extends StatefulWidget {
  const PreferenciaScreen({super.key});

  @override
  State<PreferenciaScreen> createState() => _PreferenciaScreenState();
}

class _PreferenciaScreenState extends State<PreferenciaScreen> {
  bool _isResetEnabled = false;

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isResetEnabled = prefs.getBool('isResetEnabled') ?? false;
    });
  }

  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isResetEnabled', _isResetEnabled);
  }

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  @override
  void dispose() {
    _savePreferences();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Preferencias')),
      body: Center(
        child: SwitchListTile(
          title: const Text('¿Habilitar reset del contador?'),
          value: _isResetEnabled,
          onChanged: (value) {
            setState(() {
              _isResetEnabled = value;
            });
          },
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:vivo_front/main.dart';

class AccessibilityPage extends StatelessWidget {
  const AccessibilityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Accessibility'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ValueListenableBuilder<ThemeMode>(
            valueListenable: themeModeNotifier,
            builder: (context, themeMode, _) {
              final bool isDark = themeMode == ThemeMode.dark;
              return SwitchListTile(
                title: const Text('Dark Mode'),
                subtitle: const Text('Toggle light/dark theme'),
                value: isDark,
                onChanged: (value) {
                  themeModeNotifier.value =
                      value ? ThemeMode.dark : ThemeMode.light;
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

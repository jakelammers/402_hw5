import 'package:flutter/material.dart';
import '../models/settings.dart';

/**
 * @author jakelammers & claude 3.5
 * @date 10-24-24
 *
 * settings screen for the windowpane app
 */
class SettingsScreen extends StatefulWidget {
  final AppSettings settings;

  const SettingsScreen({Key? key, required this.settings}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Theme'),
            subtitle: Text(widget.settings.isDarkMode ? 'Dark Theme' : 'Light Theme'),
            trailing: Switch(
              value: widget.settings.isDarkMode,
              onChanged: (value) {
                setState(() {
                  widget.settings.toggleTheme();
                });
              },
            ),
          ),
          ListTile(
            title: const Text('Temperature in Celsius'),
            trailing: Switch(
              value: widget.settings.useCelsius,
              onChanged: (value) {
                setState(() {
                  widget.settings.toggleTemperatureUnit();
                });
              },
            ),
          ),
          ListTile(
            title: const Text('24 hour time'),
            trailing: Switch(
              value: widget.settings.use24HourTime,
              onChanged: (value) {
                setState(() {
                  widget.settings.toggleTimeFormat();
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';

void main() => runApp(Week17App());

class Week17App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Week 17',
      home: Week17HomePage(),
    );
  }
}

class Week17HomePage extends StatefulWidget {
  String title = 'Setting';

  @override
  _Week17HomePageState createState() => _Week17HomePageState();
}

class SwitchConfig {
  String title;
  bool state;
  IconData iconData;
  SwitchConfig({
    this.title,
    this.iconData,
    this.state = false,
  });
}

class _Week17HomePageState extends State<Week17HomePage> {
  static const String AP_MODE = 'AP_MODE';
  static const String WIFI = 'WIFI';
  static const String BLUETOOTH = 'BLUETOOTH';

  Map<String, SwitchConfig> settingMap = {
    AP_MODE: SwitchConfig(
      title: 'Airplane Mode',
      iconData: Icons.airplanemode_active,
    ),
    WIFI: SwitchConfig(
      title: 'Wi-Fi',
      iconData: Icons.wifi,
    ),
    BLUETOOTH: SwitchConfig(
      title: 'Bluetooth',
      iconData: Icons.bluetooth,
    ),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            buildSwitchListTile(AP_MODE),
            buildDivider(),
            buildSwitchListTile(WIFI),
            buildDivider(),
            buildSwitchListTile(BLUETOOTH),
          ],
        ),
      ),
    );
  }

  SwitchListTile buildSwitchListTile(String mode) {
    return SwitchListTile(
      title: Text(settingMap[mode].title),
      secondary: Icon(settingMap[mode].iconData),
      onChanged: (value) {
        setState(() {
          settingMap[mode].state = value;
        });
      },
      value: settingMap[mode].state,
    );
  }

  Divider buildDivider() => Divider(thickness: 1.2);
}

import 'dart:html';

import 'package:flutter/material.dart';
import 'package:giffy_dialog/giffy_dialog.dart';

void main() => runApp(Week14App());

const List<Key> keys = [
  Key('Network'),
  Key('NetworkDialog'),
  Key('Flare'),
  Key('FlareDialog'),
  Key('Asset'),
  Key('AssetDialog'),
];

class Week14App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Week 14',
      home: Week14HomePage(),
      theme: ThemeData(
        primarySwatch: Colors.teal,
        fontFamily: 'Nunito',
      ),
    );
  }
}

class Week14HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Giffy Dialog Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            buildDialogButton(
              context: context,
              key: keys[0],
              btLabel: 'Network Giffy',
              buildDialog: buildNetworkGiffyDialog,
            ),
            buildDivider(),
            buildDialogButton(
              context: context,
              key: keys[2],
              btLabel: 'Flare Giffy',
              buildDialog: buildFlareGiffyDialog,
            ),
            buildDivider(),
            buildDialogButton(
              context: context,
              key: keys[4],
              btLabel: 'Asset Giffy',
              buildDialog: buildAssetGiffyDialog,
            ),
          ],
        ),
      ),
    );
  }

  RaisedButton buildDialogButton({
    BuildContext context,
    Key key,
    String btLabel,
    Function buildDialog,
  }) {
    return RaisedButton(
      key: key,
      color: Colors.teal,
      child: Text(
        btLabel,
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () {
        showDialog(
          context: context,
          builder: (_) => buildDialog(),
        );
      },
    );
  }

  Widget buildNetworkGiffyDialog() {
    return NetworkGiffyDialog(
      key: keys[1],
      image: Image.network(
        "https://raw.githubusercontent.com/Shashank02051997/FancyGifDialog-Android/master/GIF's/gif14.gif",
        fit: BoxFit.cover,
      ),
      entryAnimation: EntryAnimation.TOP_LEFT,
      title: Text(
        'Granny Eating Chocolate',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      ),
      description: Text(
        'This is a granny eating chocolate dialog box',
        textAlign: TextAlign.center,
      ),
      onOkButtonPressed: () {},
    );
  }

  Widget buildAssetGiffyDialog() {
    return AssetGiffyDialog(
      key: keys[5],
      image: Image.asset(
        'assets/men_wearing_jacket.gif',
        fit: BoxFit.cover,
      ),
      title: Text(
        'Men Wearing Jackets',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),
      ),
      entryAnimation: EntryAnimation.BOTTOM_RIGHT,
      description: Text(
        'This is a men wearing jackets dialog box. This library helps you easily create fancy giffy dialog.',
        textAlign: TextAlign.center,
        style: TextStyle(),
      ),
      onOkButtonPressed: () {},
    );
  }

  Widget buildFlareGiffyDialog() {
    return FlareGiffyDialog(
      key: keys[3],
      flarePath: 'assets/space_demo.flr',
      flareAnimation: 'loading',
      title: Text(
        'Space Reloading',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),
      ),
      entryAnimation: EntryAnimation.DEFAULT,
      description: Text(
        'This is a space reloading dialog box. This library helps you easily create fancy flare dialog.',
        textAlign: TextAlign.center,
        style: TextStyle(),
      ),
      onOkButtonPressed: () {},
    );
  }

  Divider buildDivider() => Divider(thickness: 1.2);
}

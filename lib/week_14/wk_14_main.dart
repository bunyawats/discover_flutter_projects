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
            RaisedButton(
              key: keys[0],
              color: Colors.teal,
              child: Text(
                'Network Giffy',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => NetworkGiffyDialog(
                    key: keys[1],
                    image: Image.network(
                      "https://raw.githubusercontent.com/Shashank02051997/FancyGifDialog-Android/master/GIF's/gif14.gif",
                      fit: BoxFit.cover,
                    ),
                    entryAnimation: EntryAnimation.TOP_LEFT,
                    title: Text(
                      'Granny Eating Chocolate',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    description: Text(
                      'This is a granny eating chocolate dialog box',
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

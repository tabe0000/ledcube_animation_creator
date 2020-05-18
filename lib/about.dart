import 'package:flutter/material.dart';
import 'dart:js' as js;
import 'nav_drawer.dart';

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        title: Text("Led Pattern Code Generator"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Text('このアプリはLEDCubeを作る時、'
            'ピンのHigh/Lowをソースに直書きするのがめんどくさかったので'
            '作りました'),
            Divider(),
            Text('開発者/ たべ'),
            RaisedButton(
              child: Text('Twitter'),
              onPressed: () async {
                print('hoge');
                const url = 'https://twitter.com/tabe_unity';
                js.context.callMethod("open", [url]);
              },
            )
          ]
        )
      ),
    );
  }
}
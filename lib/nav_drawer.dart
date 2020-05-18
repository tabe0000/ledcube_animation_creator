import 'package:cube_animation_creator/main.dart';
import 'package:flutter/material.dart';
import 'about.dart';

class NavDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text(
              'Led Code Generator',
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
            decoration: BoxDecoration(
                color: Colors.green,
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage('assets/led.png'))),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () => {
              Navigator.of(context).popAndPushNamed('/')
            },
          ),
          ListTile(
            leading: Icon(Icons.verified_user),
            title: Text('About'),
            onTap: () => {
              Navigator.of(context).pushNamed('/about')
            },
          ),
          ListTile(
            leading: Icon(Icons.local_convenience_store),
            title: Text('License'),
            onTap: () => showLicensePage(context: context),
          ),
        ],
      ),
    );
  }
}
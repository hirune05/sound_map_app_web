import 'package:flutter/material.dart';
import 'package:sound_map_app/thems/styles.dart';
import 'package:sound_map_app/view/top/top_page.dart';

class SoundFit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) => Top(),
        '/top': (BuildContext context) => Top(),
      },
      debugShowCheckedModeBanner: false,
      title: 'Title',
    );
  }
}

Future<void> errorPage(String err, BuildContext context) async {
  await Navigator.of(context).pushNamed('/error', arguments: err);
}

class Top extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TopPage(),
    );
  }
}

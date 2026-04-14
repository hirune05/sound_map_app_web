import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sound_map_app/thems/styles.dart';
import 'package:sound_map_app/top_page_route.dart';
import 'package:sound_map_app/view/login.dart';

class SoundFit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) => Top(),
        '/login': (BuildContext context) => Top(),
        '/top': (BuildContext context) => Top(),
      },
      debugShowCheckedModeBanner: false,
      title: 'Title',
      theme: ThemeData(
        primarySwatch: Styles.primarySwatch,
        primaryColor: Styles.primaryColor,
        brightness: Brightness.light,
        colorScheme: const ColorScheme.light(
          primary: Styles.primaryColor,
          background: Styles.pageBackground,
        ),
        appBarTheme: Styles.appBarTheme,
        scaffoldBackgroundColor: Styles.pageBackground,
        textTheme: GoogleFonts.mPlusRounded1cTextTheme(
          Styles.textTheme,
        ),
      ),
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
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData) {
            return TopPageRoute();
          }
          return LoginPage();
        },
      ),
    );
  }
}

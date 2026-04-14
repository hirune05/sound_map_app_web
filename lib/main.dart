import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sound_map_app/firebase_options.dart';
import 'package:sound_map_app/service/google_maps_loader.dart';
import 'package:sound_map_app/sound_fit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ensureGoogleMapsInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAuth.instance.setPersistence(Persistence.LOCAL);
  runApp(
    ProviderScope(
      child: SoundFit(),
    ),
  );
}

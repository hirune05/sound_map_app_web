import 'dart:async';
import 'dart:html' as html;

import 'package:sound_map_app/env/env.dart';

Future<void> ensureGoogleMapsInitialized() async {
  final apiKey = _loadMapsApiKey();

  final existing =
      html.document.querySelector('script[data-google-maps="true"]');
  if (existing != null) {
    return;
  }

  final script = html.ScriptElement()
    ..src = 'https://maps.googleapis.com/maps/api/js?key=$apiKey'
    ..async = true
    ..defer = true
    ..setAttribute('data-google-maps', 'true');

  final completer = Completer<void>();
  script.onError.listen((_) {
    completer.completeError('Failed to load Google Maps JavaScript API.');
  });
  script.onLoad.listen((_) {
    completer.complete();
  });

  html.document.head?.append(script);
  await completer.future;
}

String _loadMapsApiKey() {
  final apiKey = Env.mapsApiKey.trim();
  if (apiKey.isEmpty) {
    throw 'YOURAPIKEY is not set. Pass it with --dart-define=YOURAPIKEY=...';
  }
  return apiKey;
}

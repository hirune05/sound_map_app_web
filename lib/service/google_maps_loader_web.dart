import 'dart:async';
import 'dart:html' as html;

import 'package:flutter/services.dart' show rootBundle;

Future<void> ensureGoogleMapsInitialized() async {
  final apiKey = await _loadMapsApiKey();

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

Future<String> _loadMapsApiKey() async {
  final content = await rootBundle.loadString('.env');
  final lines = content.split(RegExp(r'\r?\n'));
  for (final rawLine in lines) {
    final line = rawLine.trim();
    if (line.isEmpty || line.startsWith('#')) {
      continue;
    }
    if (!line.startsWith('YOURAPIKEY=')) {
      continue;
    }
    final parts = line.split('=');
    var value = parts.length > 1 ? parts.sublist(1).join('=').trim() : '';
    if (value.startsWith('"') && value.endsWith('"') && value.length >= 2) {
      value = value.substring(1, value.length - 1);
    }
    if (value.isEmpty) {
      break;
    }
    return value;
  }
  throw 'YOURAPIKEY is not set. Add it to .env.';
}

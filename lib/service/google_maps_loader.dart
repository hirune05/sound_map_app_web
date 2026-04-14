import 'google_maps_loader_stub.dart'
    if (dart.library.html) 'google_maps_loader_web.dart' as impl;

Future<void> ensureGoogleMapsInitialized() => impl.ensureGoogleMapsInitialized();

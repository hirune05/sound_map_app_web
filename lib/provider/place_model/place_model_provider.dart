import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sound_map_app/models/place/place_model.dart';
/*final placeModelProvider =
    FutureProvider.autoDispose<List<Marker>>((ref) async {
  final querySnapshot =
      await FirebaseFirestore.instance.collection('places').get();

  final places = querySnapshot.docs.map((doc) {
    final data = doc.data();
    return PlaceModel(
      lat: data['lat'],
      long: data['long'],
    );
  }).toList();

  final newMarkers = places.map((place) {
    return Marker(
      markerId: MarkerId('${place.lat}-${place.long}'),
      position: LatLng(place.lat, place.long),
    );
  }).toList();

  return newMarkers;
});*/

final placeModelProvider =
    StateNotifierProvider<PlaceModelNotifier, AsyncValue<List<PlaceModel>>>(
        (ref) {
  return PlaceModelNotifier()..getPlaces();
});

class PlaceModelNotifier extends StateNotifier<AsyncValue<List<PlaceModel>>> {
  PlaceModelNotifier() : super(const AsyncValue.loading());

  Future<void> getPlaces() async {
    try {
      final querySnapshot =
          await FirebaseFirestore.instance.collection('places').get();
      final places = querySnapshot.docs.map((doc) {
        final data = doc.data();
        return PlaceModel(
          lat: (data['lat'] as num?)?.toDouble(),
          long: (data['long'] as num?)?.toDouble(),
        );
      }).toList();

      state = AsyncValue.data(places);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

/*final placeModelProvider =
    FutureProvider.autoDispose<List<PlaceModel>>((ref) async {
  final querySnapshot =
      await FirebaseFirestore.instance.collection('places').get();

  final places = querySnapshot.docs.map((doc) {
    final data = doc.data();
    return PlaceModel(
      lat: data['lat'],
      long: data['long'],
    );
  }).toList();

  return places;
});*/

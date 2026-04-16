import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sound_map_app/models/place/place_model.dart';
import 'package:sound_map_app/provider/markers/markers_provider.dart';
import 'package:sound_map_app/provider/place_model/place_model_provider.dart';

import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sound_map_app/view/top/add/place_list_page/place_list_page.dart';

class TopPage extends ConsumerStatefulWidget {
  @override
  ConsumerState<TopPage> createState() => _TopPageState();
}

class _TopPageState extends ConsumerState<TopPage> {
  final Completer<GoogleMapController> _controller = Completer();
  static const LatLng _fallbackPosition = LatLng(35.681236, 139.767125);
  ProviderSubscription<AsyncValue<List<PlaceModel>>>? _placesSubscription;
  LatLng? _currentPosition;
  String? _locationError;

  @override
  void initState() {
    super.initState();
    _loadCurrentPosition();
    _placesSubscription = ref.listenManual<AsyncValue<List<PlaceModel>>>(
      placeModelProvider,
      (previous, next) {
        next.whenData((places) {
          ref.read(markersProvider.notifier).addMarkers(context, places);
        });
      },
    );
  }

  @override
  void dispose() {
    _placesSubscription?.close();
    super.dispose();
  }

  Future<void> _loadCurrentPosition() async {
    try {
      final position = await _getCurrentPosition();
      final currentPosition = LatLng(position.latitude, position.longitude);
      if (!mounted) {
        return;
      }
      setState(() {
        _currentPosition = currentPosition;
        _locationError = null;
      });
      await _moveCamera(currentPosition);
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _locationError = error.toString();
      });
    }
  }

  Future<Position> _getCurrentPosition() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw 'Location services are disabled.';
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      throw 'Location permissions are denied.';
    }

    if (permission == LocationPermission.deniedForever) {
      throw 'Location permissions are permanently denied.';
    }

    return Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  Future<void> _moveCamera(LatLng target) async {
    if (!_controller.isCompleted) {
      return;
    }
    final controller = await _controller.future;
    await controller.animateCamera(
      CameraUpdate.newLatLng(target),
    );
  }

  @override
  Widget build(BuildContext context) {
    final placesAsync = ref.watch(placeModelProvider);
    final initialPosition = _currentPosition ?? _fallbackPosition;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Search',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: initialPosition,
                zoom: 14.4746,
              ),
              onMapCreated: (GoogleMapController controller) async {
                if (!_controller.isCompleted) {
                  _controller.complete(controller);
                }
                if (_currentPosition != null) {
                  await controller.animateCamera(
                    CameraUpdate.newLatLng(_currentPosition!),
                  );
                }
              },
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              mapToolbarEnabled: false,
              buildingsEnabled: true,
              onTap: (LatLng latLng) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ShopListPage(
                      lat: latLng.latitude,
                      long: latLng.longitude,
                      shoptitle: 'どこか',
                    ),
                  ),
                );
              },
              markers: Set.from(ref.watch(markersProvider)),
            ),
            if (placesAsync.isLoading || _currentPosition == null || _locationError != null)
              Positioned(
                left: 16,
                right: 16,
                top: 16,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.92),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.12),
                        blurRadius: 12,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      _locationError ??
                          (placesAsync.isLoading
                              ? '地図を準備中...'
                              : '位置情報を取得中...'),
                      style: TextStyle(color: Colors.black87),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}


/*class TopPage extends StatefulWidget {
  @override
  _TopPageState createState() => _TopPageState();
}

class _TopPageState extends State<TopPage> {
  Completer<GoogleMapController> _controller = Completer();

  late LatLng _initialPosition;
  late bool _loading;

  void initState() {
    super.initState();
    _loading = true;
    _getUserLocation();
  }

  void _getUserLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _initialPosition = LatLng(position.latitude, position.longitude);
      _loading = false;
      print(position);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      //前のページに戻らせたくない時に使う
      onWillPop: willPopCallback,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Search',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: _loading
            ? Center(child: CircularProgressIndicator())
            : SafeArea(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Consumer(
                      builder: (context, watch, child) {
                        final markers = watch(markersProvider);
                        return GoogleMap(
                          initialCameraPosition: CameraPosition(
                            target: _initialPosition,
                            zoom: 14.4746,
                          ),
                          onMapCreated: (GoogleMapController controller) async {
                            _controller.complete(controller);
                            final places = await getPlaces();
                            context.read(markersProvider).addMarkers(places);
                          },
                          myLocationEnabled: true,
                          myLocationButtonEnabled: true,
                          mapToolbarEnabled: false,
                          buildingsEnabled: true,
                          onTap: (LatLng latLng) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ShopListPage(
                                        lat: latLng.latitude,
                                        long: latLng.longitude,
                                        shoptitle: 'どこか',
                                      )),
                            );
                            print(latLng);
                          },
                          markers: Set.from(markers),
                        );
                      },
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}*/


/*class _TopPageState extends State<TopPage> {
  Completer<GoogleMapController> _controller = Completer();

  late LatLng _initialPosition;
  late bool _loading;

  void initState() {
    super.initState();
    _loading = true;
    _getUserLocation();
  }

  void _getUserLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _initialPosition = LatLng(position.latitude, position.longitude);
      _loading = false;
      print(position);
    });
  }

  void _addMarkers(List<PlaceModel> places, GoogleMapController controller) {
    places.forEach((place) {
      final marker = Marker(
        markerId: MarkerId('${place.lat}-${place.long}'),
        position: LatLng(place.lat, place.long),
        infoWindow: InfoWindow(title: 'Place'),
      );
      controller.addMarker(marker);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      //前のページに戻らせたくない時に使う
      onWillPop: willPopCallback,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Search',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: _loading
            ? Center(child: CircularProgressIndicator())
            : SafeArea(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: _initialPosition,
                        zoom: 14.4746,
                      ),
                      onMapCreated: (GoogleMapController controller) async {
                        _controller.complete(controller);
                        final places = await getPlaces();
                        _addMarkers(places, controller);
                      },
                      myLocationEnabled: true,
                      myLocationButtonEnabled: true,
                      mapToolbarEnabled: false,
                      buildingsEnabled: true,
                      onTap: (LatLng latLng) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ShopListPage(
                                    lat: latLng.latitude,
                                    long: latLng.longitude,
                                    shoptitle: 'どこか',
                                  )),
                        );
                        print(latLng);
                      },
                    ),
                    //buildFloatingSearchBar(),
                  ],
                ),
              ),
      ),
    );
  }
}*/

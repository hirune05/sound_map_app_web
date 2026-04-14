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
  late final Future<Position> _positionFuture;
  ProviderSubscription<AsyncValue<List<PlaceModel>>>? _placesSubscription;

  @override
  void initState() {
    super.initState();
    _positionFuture = _getCurrentPosition();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Search',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: FutureBuilder<Position>(
        future: _positionFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final position = snapshot.data!;
            final initialPosition =
                LatLng(position.latitude, position.longitude);
            final placesAsync = ref.watch(placeModelProvider);
            return SafeArea(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: initialPosition,
                      zoom: 14.4746,
                    ),
                    onMapCreated: (GoogleMapController controller) async {
                      _controller.complete(controller);
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
                      print(latLng);
                    },
                    markers: Set.from(ref.watch(markersProvider)),
                  ),
                  placesAsync.when(
                    loading: () => Center(
                      child: CircularProgressIndicator(),
                    ),
                    error: (error, stackTrace) => Center(
                      child: Text(
                        error.toString(),
                      ),
                    ),
                    data: (_) => SizedBox.shrink(),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString(),
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
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

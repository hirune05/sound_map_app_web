import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sound_map_app/models/place/place_list.dart';

class ShopListModel extends ChangeNotifier {
  List<Shop>? shops;

  void fetchShopList() async {
    final QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('shops').get();

    final List<Shop> shops = snapshot.docs.map((DocumentSnapshot document) {
      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
      final String id = document.id;
      final String title = data['title'] ?? '';
      final String? imgURL = data['imgURL'];
      final double lat = (data['lat'] as num?)?.toDouble() ?? 0;
      final double long = (data['long'] as num?)?.toDouble() ?? 0;
      final int electronic = (data['electronic'] as num?)?.toInt() ?? 0;
      final int ventilationFan =
          (data['ventilationFan'] as num?)?.toInt() ?? 0;
      final int masticatory = (data['masticatory'] as num?)?.toInt() ?? 0;
      final String situation = data['situation'] ?? '';
      final String timezone = data['timezone'] ?? '';
      final String seatforme = data['seatforme'] ?? '';
      return Shop(id, title, imgURL, lat, long, electronic, ventilationFan,
          masticatory, situation, timezone, seatforme);
    }).toList();

    this.shops = shops;
    notifyListeners();
  }

  void filterByTitle(String title) {
    if (shops == null) return;
    shops = shops!.where((shop) => shop.title == title).toList();
    notifyListeners();
  }
}

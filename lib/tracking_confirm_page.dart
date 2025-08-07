import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'tracking_spot.dart'; // 修正: 正しいパスに変更してください

class TrackingConfirmPage extends StatelessWidget {
  final List<LatLng> trackingPoints;
  final List<TrackingSpot> trackingSpots;

  const TrackingConfirmPage({
    Key? key,
    required this.trackingPoints,
    required this.trackingSpots,
  }) : super(key: key);

  Future<void> _submitTracking(BuildContext context) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final postRef = FirebaseFirestore.instance.collection('posts').doc();

      await postRef.set({
        'userId': user.uid,
        'createdAt': FieldValue.serverTimestamp(),
        'route': trackingPoints.map((e) => {'lat': e.latitude, 'lng': e.longitude}).toList(),
      });

      final spotsCollection = postRef.collection('spots');
      for (final spot in trackingSpots) {
        await spotsCollection.add({
          'text': spot.text,
          'imagePath': spot.imagePath,
          'location': {'lat': spot.location.latitude, 'lng': spot.location.longitude},
          'timestamp': spot.timestamp,
        });
      }

      Navigator.popUntil(context, (route) => route.isFirst);
    } catch (e) {
      print('投稿保存エラー: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('投稿の保存に失敗しました')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('トラッキング確認')),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: FlutterMap(
              options: MapOptions(
                initialCenter: trackingPoints.first,
                initialZoom: 15,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                ),
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: trackingPoints,
                      strokeWidth: 4.0,
                      color: Colors.blue,
                    ),
                  ],
                ),
                MarkerLayer(
                  markers: trackingSpots.map((spot) {
                    return Marker(
                      width: 40,
                      height: 40,
                      point: spot.location,
                      child: Icon(Icons.location_on, color: Colors.red, size: 30),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: ListView.builder(
              itemCount: trackingSpots.length,
              itemBuilder: (context, index) {
                final spot = trackingSpots[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: spot.imagePath != null
                        ? Image.file(
                            spot.imagePath!,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          )
                        : Icon(Icons.text_snippet),
                    title: Text(spot.text ?? 'テキストなし'),
                    subtitle: Text(DateFormat('yyyy/MM/dd HH:mm').format(spot.timestamp)),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('キャンセル'),
                ),
                ElevatedButton(
                  onPressed: () => _submitTracking(context),
                  child: Text('投稿する'),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
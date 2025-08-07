import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'tracking_spot.dart';
import 'tracking_confirm_page.dart';

class TrackingPage extends StatefulWidget {
  const TrackingPage({super.key});

  @override
  State<TrackingPage> createState() => _TrackingPageState();
}

class _TrackingPageState extends State<TrackingPage> {
  List<LatLng> _trackingPoints = [];
  List<TrackingSpot> _trackingSpots = [];
  Timer? _timer;
  bool _isTracking = false;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTracking() {
    _isTracking = true;
    _timer = Timer.periodic(Duration(seconds: 5), (_) async {
      final position = await Geolocator.getCurrentPosition();
      setState(() {
        _trackingPoints.add(LatLng(position.latitude, position.longitude));
      });
    });
  }

  void _stopTracking() {
    _isTracking = false;
    _timer?.cancel();
  }

  Future<void> _showAddSpotDialog() async {
    String? text;
    File? imageFile;

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF3D1A6F), // 紫背景に変更
          title: const Text(
            '記録の追加',
            style: TextStyle(color: Colors.white), // タイトル白文字
          ),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  style: const TextStyle(color: Colors.white), // 入力文字を白に
                  decoration: const InputDecoration(
                    labelText: 'テキスト（任意）',
                    labelStyle: TextStyle(color: Colors.white70), // ラベル文字も白
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white70),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  onChanged: (value) => text = value,
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, // 白背景
                    foregroundColor: const Color(0xFF3D1A6F), // 紫文字
                  ),
                  onPressed: () async {
                    final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
                    if (pickedImage != null) {
                      setState(() {
                        imageFile = File(pickedImage.path);
                      });
                    }
                  },
                  child: const Text('ギャラリーから画像を選択'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'キャンセル',
                style: TextStyle(color: Colors.white),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white, // 白背景
                foregroundColor: const Color(0xFF3D1A6F), // 紫文字
              ),
              onPressed: () async {
                final position = await Geolocator.getCurrentPosition();
                final location = LatLng(position.latitude, position.longitude);
                DateTime timestamp = DateTime.now();

                setState(() {
                  _trackingSpots.add(
                    TrackingSpot(
                      location: location,
                      text: text,
                      imagePath: imageFile,
                      timestamp: timestamp,
                    ),
                  );
                });
                Navigator.pop(context);
              },
              child: const Text('記録'),
            ),
          ],
        );
      },
    );
  }

  void _onFinishTracking() {
    _stopTracking();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TrackingConfirmPage(
          trackingPoints: _trackingPoints,
          trackingSpots: _trackingSpots,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF3D1A6F),
        title: Text(
          _isTracking ? 'トラッキング中' : '経路記録',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          if (_isTracking)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('計測中...', style: TextStyle(color: Colors.green)),
            ),
          Expanded(
            child: FlutterMap(
              options: MapOptions(
                initialCenter: _trackingPoints.isNotEmpty
                    ? _trackingPoints.last
                    : LatLng(35.6812, 139.7671),
                initialZoom: 16,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                ),
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: _trackingPoints,
                      strokeWidth: 4.0,
                      color: Colors.blue,
                    ),
                  ],
                ),
                MarkerLayer(
                  markers: _trackingSpots.map((spot) {
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
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _startTracking, // 押せるようにする
                  child: Text('開始'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_isTracking) {
                      _onFinishTracking();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('計測を開始してください')),
                      );
                    }
                  },
                  child: Text('終了'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_isTracking) {
                      _showAddSpotDialog();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('計測を開始してください')),
                      );
                    }
                  },
                  child: Text('記録'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

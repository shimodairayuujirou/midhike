import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<LatLng> routePoints = [];
   List<LatLng> fakeRoutePoints = [
    const LatLng(35.6812, 139.7693),
    const LatLng(35.6820, 139.7697),
    const LatLng(35.6828, 139.7705),
    const LatLng(35.6835, 139.7708),
    const LatLng(35.6843, 139.7674),
    const LatLng(35.6847, 139.7655),
    const LatLng(35.6835, 139.7652),
    const LatLng(35.6828, 139.7649),
    const LatLng(35.6822, 139.7647),
    const LatLng(35.6810, 139.7642),
    const LatLng(35.6802, 139.7649),
    const LatLng(35.6793, 139.7653),
    const LatLng(35.6774, 139.7648),
  ];

  final List<Map<String, dynamic>> posts = [
    {
      'position': LatLng(35.6820, 139.7697),
      'image': 'assets/images/biru.jpeg',
      'text': '都会のビル群'
    },
    {
      'position': LatLng(35.6843, 139.7674),
      'image': 'assets/images/miti.jpeg',
      'text': 'ここで写真を撮った'
    },
  ];

  Future<void> fetchRoute(LatLng start, LatLng end) async {
    const apiKey = 'eyJvcmciOiI1YjNjZTM1OTc4NTExMTAwMDFjZjYyNDgiLCJpZCI6ImEwNTZhNWY4ZDdhODQyYzFiYzk2ZDBmNTg5OGJhZmU3IiwiaCI6Im11cm11cjY0In0=';
    final url = Uri.parse(
        'https://api.openrouteservice.org/v2/directions/foot-walking?api_key=$apiKey');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'coordinates': [
          [start.longitude, start.latitude],
          [end.longitude, end.latitude],
        ]
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final geometry = data['features'][0]['geometry']['coordinates'];

      setState(() {
        routePoints = geometry
            .map<LatLng>((point) => LatLng(point[1], point[0]))
            .toList();
      });
    } else {
      print('ルート取得失敗: ${response.statusCode}');
      print(response.body); // ← エラーメッセージを確認できるようにする
    }
  }

  @override
  void initState() {
    super.initState();
    fetchRoute(LatLng(35.6812, 139.7671), LatLng(35.6895, 139.6917)); // 東京駅 → 新宿駅
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(35.6812, 139.7671), // 東京駅
          initialZoom: 15.0,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          ),
            PolylineLayer(
              polylines: [
                Polyline(
                  points: fakeRoutePoints,
                  strokeWidth: 8.0,
                  color: Colors.blue,
                ),
              ],
            ),
            MarkerLayer(
            markers: posts.map((post) {
              return Marker(
                point: post['position'],
                width: 40,
                height: 40,
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (_) {
                        return AlertDialog(
                          backgroundColor: const Color(0xFF3D1A6F),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(post['image'], width: 200),
                              SizedBox(height: 10),
                              Text(post['text'], style: TextStyle(color: Colors.white)),
                              
                            ],
                          ),
                        );
                      },
                    );
                  },
                  child: Icon(Icons.location_on, size: 40, color: Colors.red),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

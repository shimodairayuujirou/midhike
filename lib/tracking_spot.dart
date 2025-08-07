import 'dart:io';
import 'package:latlong2/latlong.dart';

class TrackingSpot {
  final LatLng location;
  final String? text;
  final File? imagePath;
  final DateTime timestamp;

  TrackingSpot({
    required this.location,
    this.text,
    this.imagePath,
    required this.timestamp,
  });
}

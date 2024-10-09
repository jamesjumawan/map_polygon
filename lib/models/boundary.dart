import 'package:google_maps_flutter/google_maps_flutter.dart';

class Boundary {
  final String id;
  final List<LatLng> points;

  const Boundary({
    required this.id,
    required this.points,
  });

  factory Boundary.fromJson(Map<String, dynamic> json) {
    return Boundary(
      id: json['id'],
      points: (json['points'] as List)
          .map((point) => LatLng(point['lat'], point['lng']))
          .toList(),
    );
  }

  static List<Boundary> fromJsonList(Map<String, dynamic> json) {
    return (json['polygons'] as List)
        .map((polygon) => Boundary.fromJson(polygon))
        .toList();
  }
}

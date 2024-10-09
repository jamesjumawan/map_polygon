import 'dart:async';
import 'dart:ui';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:logger/logger.dart';
import 'package:mapPolygon/app/app.locator.dart';
import 'package:mapPolygon/app/app.logger.dart';
import 'package:mapPolygon/models/boundary.dart';
import 'package:mapPolygon/services/boundary_service.dart';
import 'package:stacked/stacked.dart';

class HomeViewModel extends BaseViewModel {
  final BoundaryService _boundaryService = locator<BoundaryService>();
  final Logger _logger = getLogger('home_viewModel');

  Future<void> init() async {
    setBusy(true);
    await _boundaryService.init();
    setBusy(false);
  }

  final Completer<GoogleMapController> controller =
      Completer<GoogleMapController>();

  final CameraPosition _initialCameraPosition = const CameraPosition(
    target: LatLng(10.32672697477935, 123.9060690253973),
    zoom: 17,
  );
  CameraPosition get initialCameraPosition => _initialCameraPosition;

  List<Boundary> get boundaries => _boundaryService.boundaries;

  MapType _mapType = MapType.terrain;
  MapType get mapType => _mapType;

  Set<Polygon> getPolygonByName(String name) {
    List<LatLng> points = [];

    if (boundaries.any((b) => b.id == name)) {
      points = boundaries.firstWhere((b) => b.id == name).points;
    } else {
      points = [];
    }

    return {
      Polygon(
        polygonId: const PolygonId('polygonId'),
        points: points,
        strokeColor: const Color(0XFFFF0000),
        strokeWidth: 4,
        fillColor: const Color.fromARGB(25, 0, 0, 0),
        onTap: () {},
      ),
    };
  }

  CameraPosition getInitialCameraPositionByBoundaryName(String name) {
    double lat = 0;
    double lng = 0;
    List<LatLng> points = [];

    if (boundaries.any((b) => b.id == name)) {
      points = boundaries.firstWhere((b) => b.id == name).points;
      lat = _getAverage(points.map((p) => p.latitude).toList());
      lng = _getAverage(points.map((p) => p.longitude).toList());
    } else {
      lat = 10.32672697477935;
      lng = 123.9060690253973;
    }

    return CameraPosition(
      target: LatLng(lat, lng),
      zoom: 17,
    );
  }

  double _getAverage(List<double> numbers) {
    if (numbers.isEmpty) return 0;
    return numbers.reduce((a, b) => a + b) / numbers.length;
  }

  void test(String boundaryName) {
    _logger.w(boundaryName);
    _logger.w("here");
  }

  changeMapType(MapType type) {
    _mapType = type;
    rebuildUi();
  }
}

import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:mapPolygon/app/app.locator.dart';
import 'package:mapPolygon/app/app.logger.dart';
import 'package:mapPolygon/models/boundary.dart';

class BoundaryService {
  late Dio _httpClient;
  late Logger _logger;
  BoundaryService() {
    _httpClient = locator<Dio>();
    _logger = getLogger('boundary_service');
  }

  Future<void> init() async {
    await getBoundaries();
  }

  List<Boundary> _boundaries = [];
  List<Boundary> get boundaries => _boundaries;

  Future<List<Boundary>> getBoundaries() async {
    final response =
        await _httpClient.get('https://api.npoint.io/4fa393ce3e817b453dc4');
    _logger.w(response.data);
    _boundaries = Boundary.fromJsonList(response.data);

    return _boundaries;
  }
}

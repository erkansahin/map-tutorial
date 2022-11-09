import 'location_model.dart';

abstract class ILocationService {
  Stream<LocationModel> get positionStream;
}

import 'location_permission_status.dart';

abstract class IPermissionService {
  // If the user granted location permission at a time
  Future<bool> isLocationPermissionGranted();
  // The changes in location permission state
  // If the user enabled location services at a time
  Future<bool> isLocationServicesEnabled();
  // The changes in location services status
  Stream<bool> get locationServicesStatusStream;
  // Request location permission
  Future<LocationPermissionStatus> requestLocationPermission();
}

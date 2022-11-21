import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';
import 'package:map_tutorial_template/domain/permission/location_permission_status.dart';

import '../../domain/permission/i_permission_service.dart';

@LazySingleton(as: IPermissionService)
class PermissionService implements IPermissionService {
  @override
  Stream<bool> get locationServicesStatusStream =>
      Geolocator.getServiceStatusStream()
          .map((serviceStatus) => serviceStatus == ServiceStatus.enabled);

  @override
  Future<bool> isLocationPermissionGranted() async {
    final status = await Geolocator.checkPermission();
    print("permissionStatus $status");
    final isGranted = status == LocationPermission.always ||
        status == LocationPermission.whileInUse;

    return isGranted;
  }

  @override
  Future<bool> isLocationServicesEnabled() {
    return Geolocator.isLocationServiceEnabled();
  }

  @override
  Future<void> openAppSettings() {
    return Geolocator.openAppSettings();
  }

  @override
  Future<void> openLocationSettings() {
    return Geolocator.openLocationSettings();
  }

  @override
  Future<LocationPermissionStatus> requestLocationPermission() async {
    final status = await Geolocator.requestPermission();
    LocationPermissionStatus result = LocationPermissionStatus.granted;
    if (status == LocationPermission.deniedForever) {
      result = LocationPermissionStatus.deniedForever;
    } else if (status == LocationPermission.denied ||
        status == LocationPermission.unableToDetermine) {
      result = LocationPermissionStatus.denied;
    }
    return result;
  }
}

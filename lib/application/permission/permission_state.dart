part of 'permission_cubit.dart';

@freezed
class PermissionState with _$PermissionState {
  const factory PermissionState({
    required bool isLocationPermissionGranted,
    required bool isLocationServicesEnabled,
    required bool displayOpenAppSettingsDialog,
  }) = _PermissionState;
  factory PermissionState.initial() => const PermissionState(
        isLocationPermissionGranted: false,
        isLocationServicesEnabled: false,
        displayOpenAppSettingsDialog: false,
      );
  const PermissionState._();

  bool get isLocationPermissionGrantedAndServicesEnabled =>
      isLocationPermissionGranted && isLocationServicesEnabled;
}

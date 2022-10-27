part of 'permission_cubit.dart';

@freezed
class PermissionState with _$PermissionState {
  const factory PermissionState({
    required bool isLocationPermissionGranted,
    required bool isLocationServicesEnabled,
  }) = _PermissionState;
  factory PermissionState.initial() => const PermissionState(
        isLocationPermissionGranted: false,
        isLocationServicesEnabled: false,
      );
  const PermissionState._();
}

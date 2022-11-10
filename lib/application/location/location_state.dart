part of 'location_cubit.dart';

@freezed
class LocationState with _$LocationState {
  const factory LocationState({
    required LocationModel userLocation,
  }) = _LocationState;
  factory LocationState.initial() => LocationState(
        userLocation: LocationModel.empty(),
      );
  const LocationState._();
}

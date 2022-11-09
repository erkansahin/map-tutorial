import 'package:freezed_annotation/freezed_annotation.dart';

part 'location_model.freezed.dart';

@freezed
class LocationModel with _$LocationModel {
  const factory LocationModel({
    required double latitude,
    required double longitude,
  }) = _LocationModel;
  factory LocationModel.empty() =>
      const LocationModel(latitude: 0, longitude: 0);
}

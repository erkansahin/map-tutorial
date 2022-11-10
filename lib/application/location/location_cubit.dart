import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:map_tutorial_template/application/permission/permission_cubit.dart';
import 'package:map_tutorial_template/domain/location/i_location_service.dart';
import 'package:map_tutorial_template/domain/location/location_model.dart';
import 'package:rxdart/rxdart.dart';

part 'location_cubit.freezed.dart';
part 'location_state.dart';

@injectable
class LocationCubit extends Cubit<LocationState> {
  final ILocationService _locationService;
  final PermissionCubit _permissionCubit;
  StreamSubscription<LocationModel>? _userPositionSubscription;
  StreamSubscription<List<PermissionState>>? _permissionStatePairSubscription;
  LocationCubit(this._locationService, this._permissionCubit)
      : super(LocationState.initial()) {
    if (_permissionCubit.state.isLocationPermissionGrantedAndServicesEnabled) {
      _userPositionSubscription =
          _locationService.positionStream.listen(_userPositionListener);
    }

    _permissionStatePairSubscription = _permissionCubit.stream
        .startWith(_permissionCubit.state)
        .pairwise()
        .listen((pair) async {
      final previous = pair.first;
      final current = pair.last;
      if (previous.isLocationPermissionGrantedAndServicesEnabled !=
              current.isLocationPermissionGrantedAndServicesEnabled &&
          current.isLocationPermissionGrantedAndServicesEnabled) {
        await _userPositionSubscription?.cancel();
        _userPositionSubscription =
            _locationService.positionStream.listen(_userPositionListener);
      } else if (previous.isLocationPermissionGrantedAndServicesEnabled !=
              current.isLocationPermissionGrantedAndServicesEnabled &&
          !current.isLocationPermissionGrantedAndServicesEnabled) {
        _userPositionSubscription?.cancel();
      }
    });
  }

  @override
  Future<void> close() {
    _userPositionSubscription?.cancel();
    _permissionStatePairSubscription?.cancel();

    return super.close();
  }

  void _userPositionListener(LocationModel location) {
    emit(state.copyWith(userLocation: location));
  }
}

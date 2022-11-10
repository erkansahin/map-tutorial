import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:map_tutorial_template/application/application_life_cycle/application_life_cycle_cubit.dart';
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
  final ApplicationLifeCycleCubit _applicationLifeCycleCubit;
  StreamSubscription<LocationModel>? _userPositionSubscription;
  StreamSubscription<List<PermissionState>>? _permissionStatePairSubscription;
  StreamSubscription<List<ApplicationLifeCycleState>>?
      _appLifeCycleStatePairSubscription;
  LocationCubit(this._locationService, this._permissionCubit,
      this._applicationLifeCycleCubit)
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

    _appLifeCycleStatePairSubscription = _applicationLifeCycleCubit.stream
        .startWith(_applicationLifeCycleCubit.state)
        .pairwise()
        .listen((pair) async {
      final previous = pair.first;
      final current = pair.last;
      final isLocationPermissionGrantedAndServicesEnabled =
          _permissionCubit.state.isLocationPermissionGrantedAndServicesEnabled;
      if (previous.isResumed != current.isResumed &&
          current.isResumed &&
          isLocationPermissionGrantedAndServicesEnabled) {
        await _userPositionSubscription?.cancel();
        _userPositionSubscription =
            _locationService.positionStream.listen(_userPositionListener);
      } else if (previous.isResumed != current.isResumed &&
          !current.isResumed) {
        await _userPositionSubscription?.cancel();
      }
    });
  }

  @override
  Future<void> close() {
    _userPositionSubscription?.cancel();
    _permissionStatePairSubscription?.cancel();
    _appLifeCycleStatePairSubscription?.cancel();

    return super.close();
  }

  void _userPositionListener(LocationModel location) {
    emit(state.copyWith(userLocation: location));
  }
}

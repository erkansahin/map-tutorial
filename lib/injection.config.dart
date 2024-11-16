// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:map_tutorial_template/application/application_life_cycle/application_life_cycle_cubit.dart'
    as _i80;
import 'package:map_tutorial_template/application/location/location_cubit.dart'
    as _i156;
import 'package:map_tutorial_template/application/permission/permission_cubit.dart'
    as _i537;
import 'package:map_tutorial_template/domain/location/i_location_service.dart'
    as _i328;
import 'package:map_tutorial_template/domain/permission/i_permission_service.dart'
    as _i700;
import 'package:map_tutorial_template/infrastructure/location/geolocator_location_service.dart'
    as _i734;
import 'package:map_tutorial_template/infrastructure/permission/permission_service.dart'
    as _i985;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.lazySingleton<_i80.ApplicationLifeCycleCubit>(
        () => _i80.ApplicationLifeCycleCubit());
    gh.lazySingleton<_i700.IPermissionService>(() => _i985.PermissionService());
    gh.factory<_i328.ILocationService>(() => _i734.GeolocatorLocationService());
    gh.lazySingleton<_i537.PermissionCubit>(() => _i537.PermissionCubit(
          gh<_i700.IPermissionService>(),
          gh<_i80.ApplicationLifeCycleCubit>(),
        ));
    gh.factory<_i156.LocationCubit>(() => _i156.LocationCubit(
          gh<_i328.ILocationService>(),
          gh<_i537.PermissionCubit>(),
          gh<_i80.ApplicationLifeCycleCubit>(),
        ));
    return this;
  }
}

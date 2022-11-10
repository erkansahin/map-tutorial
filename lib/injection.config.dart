// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import 'application/application_life_cycle/application_life_cycle_cubit.dart'
    as _i3;
import 'application/permission/permission_cubit.dart' as _i8;
import 'domain/location/i_location_service.dart' as _i4;
import 'domain/permission/i_permission_service.dart' as _i6;
import 'infrastructure/location/geolocator_location_service.dart' as _i5;
import 'infrastructure/permission/permission_service.dart'
    as _i7; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt $initGetIt(
  _i1.GetIt get, {
  String? environment,
  _i2.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i2.GetItHelper(
    get,
    environment,
    environmentFilter,
  );
  gh.lazySingleton<_i3.ApplicationLifeCycleCubit>(
      () => _i3.ApplicationLifeCycleCubit());
  gh.factory<_i4.ILocationService>(() => _i5.GeolocatorLocationService());
  gh.lazySingleton<_i6.IPermissionService>(() => _i7.PermissionService());
  gh.lazySingleton<_i8.PermissionCubit>(() => _i8.PermissionCubit(
        get<_i6.IPermissionService>(),
        get<_i3.ApplicationLifeCycleCubit>(),
      ));
  return get;
}

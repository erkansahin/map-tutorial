// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import 'application/permission/permission_cubit.dart' as _i5;
import 'domain/permission/i_permission_service.dart' as _i3;
import 'infrastructure/permission/permission_service.dart'
    as _i4; // ignore_for_file: unnecessary_lambdas

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
  gh.lazySingleton<_i3.IPermissionService>(() => _i4.PermissionService());
  gh.lazySingleton<_i5.PermissionCubit>(
      () => _i5.PermissionCubit(get<_i3.IPermissionService>()));
  return get;
}

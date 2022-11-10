import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:map_tutorial_template/application/location/location_cubit.dart';
import 'package:map_tutorial_template/application/permission/permission_cubit.dart';
import 'package:map_tutorial_template/domain/location/location_model.dart';

import '../../injection.dart';

class MapPage extends StatelessWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<LocationCubit>(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Map Tutorial"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BlocSelector<PermissionCubit, PermissionState, bool>(
                selector: (state) {
                  return state.isLocationPermissionGranted;
                },
                builder: (context, isLocationPermissionGranted) {
                  return Text(
                      "Location Permission: ${isLocationPermissionGranted ? "enabled" : "disabled"}");
                },
              ),
              const SizedBox(height: 20),
              BlocSelector<PermissionCubit, PermissionState, bool>(
                selector: (state) {
                  return state.isLocationServicesEnabled;
                },
                builder: (context, isLocationServicesEnabled) {
                  return Text(
                      "Location Services: ${isLocationServicesEnabled ? "enabled" : "disabled"}");
                },
              ),
              const SizedBox(height: 20),
              OutlinedButton(
                onPressed: () {
                  debugPrint("Location Services button Pressed!");
                  context.read<PermissionCubit>().requestLocationPermission();
                },
                child: const Text("Request Location Permission"),
              ),
              const SizedBox(height: 20),
              BlocSelector<LocationCubit, LocationState, LocationModel>(
                selector: (state) {
                  return state.userLocation;
                },
                builder: (context, userLocation) {
                  return Text(
                      "Latitude: ${userLocation.latitude}  Longitude: ${userLocation.longitude}");
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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
      child: MultiBlocListener(
        listeners: [
          BlocListener<PermissionCubit, PermissionState>(
            listenWhen: (p, c) {
              return p.isLocationPermissionGrantedAndServicesEnabled !=
                      c.isLocationPermissionGrantedAndServicesEnabled &&
                  c.isLocationPermissionGrantedAndServicesEnabled;
            },
            listener: (context, state) {
              Navigator.of(context).pop();
            },
          ),
          BlocListener<PermissionCubit, PermissionState>(
            listenWhen: (previous, current) =>
                previous.displayOpenAppSettingsDialog !=
                    current.displayOpenAppSettingsDialog &&
                current.displayOpenAppSettingsDialog,
            listener: (context, state) {
              //
              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    content: AppSettingsDialog(
                      openAppSettings: () {
                        debugPrint("Open App Settings pressed!");
                        context.read<PermissionCubit>().openAppSettings();
                      },
                      cancelDialog: () {
                        debugPrint("Cancel pressed!");
                        context
                            .read<PermissionCubit>()
                            .hideOpenAppSettingsDialog();
                      },
                    ),
                  );
                },
              );
            },
          ),
          BlocListener<PermissionCubit, PermissionState>(
            listenWhen: (previous, current) =>
                previous.displayOpenAppSettingsDialog !=
                    current.displayOpenAppSettingsDialog &&
                !current.displayOpenAppSettingsDialog,
            listener: (context, state) {
              Navigator.of(context).pop();
            },
          ),
        ],
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
                        "Location Permission: //${isLocationPermissionGranted ? "enabled" : "disabled"}");
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
                    // context.read<PermissionCubit>().requestLocationPermission();
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        final bool isLocationPermissionGranted = context.select(
                            (PermissionCubit element) =>
                                element.state.isLocationPermissionGranted);
                        final bool isLocationServicesEnabled = context.select(
                            (PermissionCubit element) =>
                                element.state.isLocationServicesEnabled);
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          content: PermissionDialog(
                            isLocationPermissionGranted:
                                isLocationPermissionGranted,
                            isLocationServicesEnabled:
                                isLocationServicesEnabled,
                          ),
                        );
                      },
                    );
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
                // PermissionDialog(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PermissionDialog extends StatelessWidget {
  final bool isLocationPermissionGranted;
  final bool isLocationServicesEnabled;
  const PermissionDialog({
    Key? key,
    required this.isLocationPermissionGranted,
    required this.isLocationServicesEnabled,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 10),
        const Text(
            "Please allow location permission and services to view your location:)"),
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Location Permission: "),
            TextButton(
              onPressed: isLocationPermissionGranted
                  ? null
                  : () {
                      debugPrint("Location permission button pressed!");
                      context
                          .read<PermissionCubit>()
                          .requestLocationPermission();
                    },
              child: Text(isLocationPermissionGranted ? "allowed" : "allow"),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Location Services: "),
            TextButton(
              onPressed: isLocationServicesEnabled
                  ? null
                  : () {
                      debugPrint("Location services button pressed!");
                      context.read<PermissionCubit>().openLocationSettings();
                    },
              child: Text(isLocationServicesEnabled
                  ? "Allowed"
                  : "Open Location Settings"),
            ),
          ],
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}

class AppSettingsDialog extends StatelessWidget {
  final Function openAppSettings;
  final Function cancelDialog;
  const AppSettingsDialog({
    Key? key,
    required this.openAppSettings,
    required this.cancelDialog,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 10),
        const Text(
            "You need to open app settings to grant Location Permission"),
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () {
                openAppSettings();
              },
              child: const Text("Open App Settings"),
            ),
            TextButton(
              onPressed: () {
                cancelDialog();
              },
              child: const Text(
                "Cancel",
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}

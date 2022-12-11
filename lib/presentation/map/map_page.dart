import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
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
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              }
            },
          ),
          BlocListener<PermissionCubit, PermissionState>(
            listenWhen: (p, c) =>
                p.displayOpenAppSettingsDialog !=
                    c.displayOpenAppSettingsDialog &&
                c.displayOpenAppSettingsDialog,
            listener: (context, state) {
              showDialog(
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
              listenWhen: (p, c) =>
                  p.displayOpenAppSettingsDialog !=
                      c.displayOpenAppSettingsDialog &&
                  !c.displayOpenAppSettingsDialog,
              listener: (context, state) {
                Navigator.of(context).pop();
              }),
        ],
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Map Tutorial"),
          ),
          body: Stack(
            children: [
              Center(
                child: BlocBuilder<LocationCubit, LocationState>(
                  buildWhen: (p, c) {
                    return p.userLocation != c.userLocation;
                  },
                  builder: (context, state) {
                    return FlutterMap(
                      options: MapOptions(
                        center: LatLng(51.509, -0.128),
                        zoom: 3.0,
                      ),
                      layers: [
                        TileLayerOptions(
                          urlTemplate:
                              'https://stamen-tiles.a.ssl.fastly.net/watercolor/{z}/{x}/{y}.png',
                          userAgentPackageName: 'com.example.map_tutorial',
                        ),
                        MarkerLayerOptions(
                          markers: [
                            Marker(
                              point: LatLng(state.userLocation.latitude,
                                  state.userLocation.longitude),
                              width: 60,
                              height: 60,
                              builder: (context) {
                                return const UserMarker();
                              },
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
              BlocSelector<PermissionCubit, PermissionState, bool>(
                selector: (state) {
                  return state.isLocationPermissionGrantedAndServicesEnabled;
                },
                builder:
                    (context, isLocationPermissionGrantedAndServicesEnabled) {
                  return isLocationPermissionGrantedAndServicesEnabled
                      ? const SizedBox.shrink()
                      : const Positioned(
                          right: 30,
                          bottom: 50,
                          child: LocationButton(),
                        );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UserMarker extends StatefulWidget {
  const UserMarker({Key? key}) : super(key: key);

  @override
  State<UserMarker> createState() => _UserMarkerState();
}

class _UserMarkerState extends State<UserMarker>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> sizeAnimation;

  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    sizeAnimation = Tween<double>(
      begin: 45,
      end: 60,
    ).animate(CurvedAnimation(
        parent: animationController, curve: Curves.fastOutSlowIn));
    animationController.repeat(
      reverse: true,
    );
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: sizeAnimation,
      builder: (context, child) {
        return Center(
          child: Container(
            width: sizeAnimation.value,
            height: sizeAnimation.value,
            decoration: const BoxDecoration(
              color: Colors.black,
              shape: BoxShape.circle,
            ),
            child: child,
          ),
        );
      },
      child: const Icon(
        Icons.person_pin,
        color: Colors.white,
        size: 35,
      ),
    );
  }
}

class LocationButton extends StatelessWidget {
  const LocationButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
            return Colors.black;
          },
        ),
      ),
      onPressed: () {
        debugPrint("Location Services button Pressed!");

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
                isLocationPermissionGranted: isLocationPermissionGranted,
                isLocationServicesEnabled: isLocationServicesEnabled,
              ),
            );
          },
        );
      },
      child: const Text("Request Location Permission"),
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
              child: Text(isLocationServicesEnabled ? "allowed" : "allow"),
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

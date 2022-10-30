import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:map_tutorial_template/application/permission/permission_cubit.dart';

class MapPage extends StatelessWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          ],
        ),
      ),
    );
  }
}

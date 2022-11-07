import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'application_life_cycle_cubit.freezed.dart';
part 'application_life_cycle_state.dart';

@lazySingleton
class ApplicationLifeCycleCubit extends Cubit<ApplicationLifeCycleState>
    with WidgetsBindingObserver {
  ApplicationLifeCycleCubit()
      : super(const ApplicationLifeCycleState.resumed()) {
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Future<void> close() {
    WidgetsBinding.instance.removeObserver(this);
    return super.close();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      emit(const ApplicationLifeCycleState.resumed());
    } else if (state == AppLifecycleState.paused) {
      emit(const ApplicationLifeCycleState.paused());
    } else if (state == AppLifecycleState.inactive) {
      emit(const ApplicationLifeCycleState.inactive());
    } else if (state == AppLifecycleState.detached) {
      emit(const ApplicationLifeCycleState.detached());
    }
    debugPrint("AppLifecycleState $state");
  }
}

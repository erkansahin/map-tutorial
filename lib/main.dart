import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:map_tutorial_template/presentation/core/app_widget.dart';

import 'injection.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  configureInjection(Environment.dev);
  runApp(const AppWidget());
}

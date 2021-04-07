import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'package:ably_cryptocurrency/service/ably_service.dart';
import 'package:ably_cryptocurrency/view/dashboard.dart';

/// registering the service using get_it package
GetIt getIt = GetIt.instance;

void main() {
  getIt.registerSingletonAsync<AblyService>(() => AblyService.init());
  runApp(MyApp());
}


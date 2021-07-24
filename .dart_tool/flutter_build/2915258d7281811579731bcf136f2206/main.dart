// @dart=2.9

import 'dart:ui' as ui;

import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'package:chatapp_draft/generated_plugin_registrant.dart';
import 'package:chatapp_draft/main.dart' as entrypoint;

Future<void> main() async {
  registerPlugins(webPluginRegistrar);
  await ui.webOnlyInitializePlatform();
  entrypoint.main();
}

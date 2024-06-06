import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:glide_web/app/app.dart';

main(){
  WidgetsFlutterBinding.ensureInitialized();
  runApp(DevicePreview(builder: (_)=> const GlideWeb()));
}
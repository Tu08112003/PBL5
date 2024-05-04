import 'package:flutter/material.dart';
import 'package:iseeapp2/camera/data_camera.dart';
import 'package:iseeapp2/map_page/get_data_api.dart';
import 'package:iseeapp2/map_page/get_your_location.dart';
import 'package:iseeapp2/map_page/map.dart';
import 'camera/get_data.dart';
import 'home_page.dart';

void main(List<String> args) {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: ESP32CamViewer(), // Sử dụng HomePage làm trang chính
  ));
}

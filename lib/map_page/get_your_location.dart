import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';


class GetYourLocation extends StatefulWidget {
  const GetYourLocation({super.key});
  @override
  _GetYourLocationState createState() => _GetYourLocationState();
}

class _GetYourLocationState extends State<GetYourLocation> {
  final channel = IOWebSocketChannel.connect('ws://192.168.43.96:3000'); // Thay đổi địa chỉ IP và cổng cho đúng

  String latitude = '';
  String longitude = '';

  @override
  void initState() {
    super.initState();
    channel.stream.listen((message) {
      // Xử lý dữ liệu nhận được từ máy chủ
      setState(() {
        Map<String, dynamic> data = json.decode(message);
        latitude = data['latitude'];
        longitude = data['longitude'];
      });
    });
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Location Data'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Latitude: $latitude'),
              Text('Longitude: $longitude'),
            ],
          ),
        ),
      ),
    );
  }
}
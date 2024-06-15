import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:typed_data';

class FollowCameraPage extends StatefulWidget {
  final String ipCam;
  const FollowCameraPage({Key? key, required this.ipCam});
  @override
  _FollowCameraPageState createState() => _FollowCameraPageState();
}

class _FollowCameraPageState extends State<FollowCameraPage> {
  // final String _baseImageUrl = 'http://192.168.37.174/cam-lo.jpg';
  late final String _baseImageUrl;
  Uint8List? _imageBytes;
  Timer? _fetchTimer;
  Timer? _displayTimer;
  final List<Uint8List> _imageQueue = [];
  bool _isFetching = false;
  bool _isDisplaying = false;

  @override
  void initState() {
    super.initState();
    _baseImageUrl = 'http://' + widget.ipCam ;
    print("----ipCam:" + _baseImageUrl);
    _startFetchingImages();
    _startDisplayingImages();
  }

  @override
  void dispose() {
    _fetchTimer?.cancel();
    _displayTimer?.cancel();
    super.dispose();
  }

  void _startFetchingImages() {
    _fetchTimer = Timer.periodic(Duration(milliseconds: 1000), (timer) {
      if (!_isFetching) {
        _fetchImage();
      }
    });
  }

  void _startDisplayingImages() {
    _displayTimer = Timer.periodic(Duration(milliseconds: 1000), (timer) {
      if (_imageQueue.isNotEmpty && !_isDisplaying) {
        setState(() {
          _imageBytes = _imageQueue.removeAt(0);
        });
      }
    });
  }

  Future<void> _fetchImage() async {
    _isFetching = true;

    try {
      final response = await http.get(Uri.parse('$_baseImageUrl?${DateTime.now().millisecondsSinceEpoch}'));
      if (response.statusCode == 200) {
        _imageQueue.add(response.bodyBytes);
      } else {
        print('Failed to load image');
      }
    } catch (e) {
      print('Error: $e');
    }

    _isFetching = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('ESP32-CAM Viewer'),
      //   backgroundColor: Colors.black,
      // ),
      backgroundColor: Colors.black,
      body: Center(
        child: _imageBytes != null
            ? Image.memory(_imageBytes!)
            : Text(
          'Chưa tải được ảnh',
          style: TextStyle(color: Colors.white), // Đặt màu chữ là trắng
        ),
      ),
    );
  }
}


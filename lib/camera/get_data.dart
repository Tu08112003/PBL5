import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ESP32CamViewer extends StatefulWidget {
  const ESP32CamViewer({super.key});
  @override
  _ESP32CamViewerState createState() => _ESP32CamViewerState();
}

class _ESP32CamViewerState extends State<ESP32CamViewer> {
  late WebViewController _webViewController;
  late bool _streamStarted;

  @override
  void initState() {
    super.initState();
    _streamStarted = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ESP32-CAM Video Stream'),
      ),
      body: Column(
        children: [
          Expanded(
            child: WebView(
              initialUrl: 'http://192.168.43.179/',
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (controller) {
                _webViewController = controller;
              },
              onPageFinished: (url) {
                if (!_streamStarted) {
                  // Kích hoạt stream video sau khi trang web tải xong
                  _startStream();
                }
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // Kích hoạt stream video khi nhấn nút
              _startStream();
            },
            child: Text('Start Stream'),
          ),
        ],
      ),
    );
  }

  Future<void> _startStream() async {
    // Gửi lệnh JavaScript để kích hoạt stream video
    await _webViewController.evaluateJavascript('startStream()');
    setState(() {
      _streamStarted = true;
    });
  }
}

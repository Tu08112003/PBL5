import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DataCamera extends StatelessWidget {
  const DataCamera({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('ESP32-CAM Video'),
        ),
        body: WebViewWidget(),
      ),
    );
  }
}

class WebViewWidget extends StatefulWidget {
  @override
  _WebViewWidgetState createState() => _WebViewWidgetState();
}

class _WebViewWidgetState extends State<WebViewWidget> {
  final String initialUrl = "http://192.168.43.24";
  // final String initialUrl = "http://10.10.2.26";

  @override
  Widget build(BuildContext context) {
    return WebView(
      initialUrl: initialUrl,
      javascriptMode: JavascriptMode.unrestricted,
      onPageFinished: (String url) {
        // Sau khi trang web được tải hoàn thành, bạn có thể thực hiện các thao tác tùy chỉnh ở đây
        print('Page finished loading: $url');
      },
    );
  }
}

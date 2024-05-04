import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GetDataApi extends StatefulWidget {
  const GetDataApi({super.key});
  @override
  _GetDataApiState createState() => _GetDataApiState();
}

class _GetDataApiState extends State<GetDataApi> {
  // Đường link API
  final String apiUrl = 'http://192.168.43.96:3000/get_location';

  // Hàm để lấy dữ liệu từ API
  Future fetchData() async {
    var result = await http.get(Uri.parse(apiUrl));

    if (result.statusCode == 200) {
      // Chuyển đổi dữ liệu JSON thành Dart object
      var data = json.decode(result.body);
      // Xử lý dữ liệu ở đây
      print(data);
    } else {
      // Xử lý lỗi ở đây
      print('Failed to load data: ${result.statusCode}');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData(); // Gọi hàm để lấy dữ liệu khi Widget được tạo
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // Widget của bạn ở đây
    );
  }
}

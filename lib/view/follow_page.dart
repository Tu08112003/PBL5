import 'package:flutter/material.dart';

class FollowPage extends StatelessWidget {
  const FollowPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(64),
        child: AppBar(
          backgroundColor: const Color(0xFFB1FFD9),
          title: Row(
            children: [
              // IconButton(
              //   icon: Icon(Icons.arrow_back),
              //   onPressed: () {
              //     Navigator.pop(context);
              //   },// Quay lại trang trước đó
              // ),
              Spacer(),
              CircleAvatar(
                radius: 20,
                backgroundImage: AssetImage('assets/images/avatar.jpg'),
              ),
              SizedBox(width: 8), // Khoảng cách giữa avatar và tên
              Text(
                'Chị Minh',
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xFF0D5E37),
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spacer(), // Để căn giữa avatar và nút trở về
            ],
          ),
        ),
      ),
    );
  }
}


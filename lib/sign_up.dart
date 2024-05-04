import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SignUp extends StatelessWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/login.png'), // Thay đổi đường dẫn tới hình ảnh của bạn
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            right: 26,
            top: 58,

            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset(
                  'assets/images/location.png',
                  width: 40,
                  height: 40,
                ),
                Text(
                  'S',
                  style: TextStyle(
                    fontSize: 38,
                    fontFamily: 'Modak',
                    color: const Color(0xFF1EC9FF),
                    shadows: [
                      Shadow(
                        blurRadius: 5,
                        color: Colors.black, // Màu của viền
                        offset: Offset(0, 0), // Độ lệch của viền
                      ),
                    ],
                  ),
                ),
                Text(
                  'E',
                  style: TextStyle(
                    fontSize: 38,
                    fontFamily: 'Modak',
                    color: const Color(0xFFFFE712),
                    shadows: [
                      Shadow(
                        blurRadius: 5,
                        color: Colors.black, // Màu của viền
                        offset: Offset(0, 0), // Độ lệch của viền
                      ),
                    ],
                  ),
                ),
                Text(
                  'E',
                  style: TextStyle(
                    fontSize: 38,
                    fontFamily: 'Modak',
                    color: const Color(0xFF22FD45),
                    shadows: [
                      Shadow(
                        blurRadius: 5,
                        color: Colors.black, // Màu của viền
                        offset: Offset(0, 0), // Độ lệch của viền
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
              left: 40,
              top: 70,
              child: Text(
                'Đăng ký\n     tài khoản',
                style: TextStyle(
                    fontSize: 30,
                    fontFamily: 'Rubik',
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0D5E37)
                ),
              )
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Positioned(
                left: 26,
                top: 190, // Thay đổi vị trí tùy theo yêu cầu của bạn
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 300,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.black), // Đổi màu viền thành màu đen
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 17),
                            child: Icon(Icons.person), // Icon user
                          ),
                          SizedBox(width: 10), // Khoảng cách giữa icon và chữ
                          Expanded(
                            child: Center(
                              child: TextFormField(
                                style: TextStyle(fontSize: 18),
                                decoration: InputDecoration(
                                  hintText: 'Số điện thoại/email', // Đặt "Tên đăng nhập" làm hint
                                  hintStyle: TextStyle(color: Colors.grey), // Đổi màu chữ hint thành màu xám
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(horizontal: 4),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 40), // Khoảng cách giữa hai container

                    Container(
                      width: 300,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.black), // Đổi màu viền thành màu đen
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 17),
                            child: Icon(Icons.lock), // Icon user
                          ),
                          SizedBox(width: 10), // Khoảng cách giữa icon và chữ
                          Expanded(
                            child: Center(
                              child: TextFormField(
                                style: TextStyle(fontSize: 18),
                                obscureText: true, // Ẩn mật khẩu
                                decoration: InputDecoration(
                                  hintText: 'Mật khẩu', // Đặt "Tên đăng nhập" làm hint
                                  hintStyle: TextStyle(color: Colors.grey), // Đổi màu chữ hint thành màu xám
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(horizontal: 4),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 40), // Khoảng cách giữa hai container

                    Container(
                      width: 300,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.black), // Đổi màu viền thành màu đen
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 17),
                            child: Icon(Icons.lock), // Icon user
                          ),
                          SizedBox(width: 10), // Khoảng cách giữa icon và chữ
                          Expanded(
                            child: Center(
                              child: TextFormField(
                                style: TextStyle(fontSize: 18),
                                obscureText: true, // Ẩn mật khẩu
                                decoration: InputDecoration(
                                  hintText: 'Nhập lại mật khẩu', // Đặt "Tên đăng nhập" làm hint
                                  hintStyle: TextStyle(color: Colors.grey), // Đổi màu chữ hint thành màu xám
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(horizontal: 4),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 50),

                    // SizedBox(height: 20),
                    Container(
                      width: 300,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          // Xử lý sự kiện khi nút được nhấn
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF0D5E37), // Đặt màu nền của nút là màu xanh
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        child: Text(
                          'Đăng ký',
                          style: TextStyle(
                            color: Colors.white, // Đặt màu cho chữ là màu trắng
                            fontFamily: 'Inter',
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),


                  ],
                ),
              ),
            ],
          ),

        ],
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:iseeapp2/view/home_page.dart';
import 'package:iseeapp2/view/sign_up.dart';

import '../Database/DatabaseUser.dart';
import '../session/SessionManager.dart';
class LogIn extends StatefulWidget {

  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {

  final _formKey = GlobalKey<FormState>();
  String username = '';
  String password = '';
  bool isObscured = true;
  final TextEditingController _controller = TextEditingController();
  String _username = '';

  @override
  void initState() {
    super.initState();
    isObscured = true;
    // _loadSession();
  }

  _loadSession() async {
    String? username = await SessionManager.getSession('username');
    setState(() {
      _username = username ?? '';
    });
  }

  _saveSession() async {
    print("-------Trước khi lưu----username"+_username + "-------" + _controller.text);
    await SessionManager.saveSession('username', _controller.text);
    setState(() {
      _username = _controller.text;
    });
  }


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
              left: 26,
              top: 88,
              child: Text(
                'Đăng nhập',
                style: TextStyle(
                    fontSize: 38,
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
                top: 120, // Thay đổi vị trí tùy theo yêu cầu của bạn
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
                                controller: _controller,
                                style: TextStyle(fontSize: 18),
                                decoration: InputDecoration(
                                  hintText: 'Email/số điện thoại', // Đặt "Tên đăng nhập" làm hint
                                  hintStyle: TextStyle(color: Colors.grey), // Đổi màu chữ hint thành màu xám
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(horizontal: 4),
                                ),
                                onChanged: (value) {
                                  username = value; // Update ipServer when text changes
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 30), // Khoảng cách giữa hai container

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
                            padding: const EdgeInsets.only(left: 5),
                            child: IconButton(
                              icon: Icon(
                                isObscured ? Icons.lock : Icons.lock_open,
                              ),
                              onPressed: () {
                                setState(() {
                                  isObscured = !isObscured;
                                });
                              },
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: TextFormField(
                                style: TextStyle(fontSize: 18),
                                obscureText: isObscured, // Ẩn mật khẩu
                                decoration: InputDecoration(
                                  hintText: 'Mật khẩu', // Đặt "Tên đăng nhập" làm hint
                                  hintStyle: TextStyle(color: Colors.grey), // Đổi màu chữ hint thành màu xám
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(horizontal: 4),
                                ),
                                onChanged: (value) {
                                  password = value; // Update ipServer when text changes
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30),

                    // SizedBox(height: 20),
                    Container(
                      width: 300,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          handleLogIn();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF0D5E37), // Đặt màu nền của nút là màu xanh
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        child: Text(
                          'Đăng nhập',
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
          // SizedBox(height: 20),
          Positioned(
            right: 50,
            bottom: 220, // Điều chỉnh vị trí dưới cùng bên phải
            child: GestureDetector(
              onTap: () {
                // Xử lý sự kiện khi quên mật khẩu được nhấn
              },
              child: Text(
                'Quên mật khẩu?',
                style: TextStyle(
                  color: Color(0xFF0D5E37),
                  fontFamily: 'Inter',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  // fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ),
          Positioned(
            right: 150,
            bottom: 170, // Điều chỉnh vị trí dưới cùng bên phải
            child: GestureDetector(
              onTap: () {
                // Xử lý sự kiện khi quên mật khẩu được nhấn
              },
              child: Text(
                'HOẶC',
                style: TextStyle(
                  color: Color(0xFF0D5E37),
                  fontFamily: 'Inter',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Positioned(
            right: 100,
            bottom: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Ink(
                  decoration: ShapeDecoration(
                    color: Colors.transparent,
                    shape: CircleBorder(),
                  ),
                  child: InkWell(
                    onTap: () {
                      // Xử lý sự kiện khi ảnh đại diện được nhấn
                    },
                    child: Container(
                      width: 54,
                      height: 54,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage('assets/images/facebook.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 40),
                Ink(
                  decoration: ShapeDecoration(
                    color: Colors.transparent,
                    shape: CircleBorder(),
                  ),
                  child: InkWell(
                    onTap: () {
                      // Xử lý sự kiện khi ảnh đại diện được nhấn
                    },
                    child: Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage('assets/images/gg.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 30,
            bottom: 20,
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Bạn chưa có tài khoản?',
                  style: TextStyle(
                    color: Color(0xFF0D5E37),
                    fontFamily: 'Inter',
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    // fontStyle: FontStyle.italic,
                  ),
                ),
                Positioned(
                  right: 80,
                  bottom: 280, // Điều chỉnh vị trí dưới cùng bên phải
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignUp()),
                      );
                    },
                    child: Text(
                      '  Đăng ký ngay',
                      style: TextStyle(
                        color: Color(0xFF0D5E37),
                        fontFamily: 'Inter',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        // fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> handleLogIn() async {
    final databaseHelper = DatabaseUser();
    if(username == '' || password == ''){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.pink,
          content: Text('Hãy nhập đủ nội dung'),
        ),
      );
    }
    else{
      var checkLogIn = await databaseHelper.isCorrectUser(username, password) ;
      if(!checkLogIn)
      {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.pink,
            content: Text('Tên đăng nhập hoặc mật khẩu ko đúng'),
          ),
        );
      }
      else {
        _saveSession();
        print('========username:'+_username);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      }

    }
  }
}

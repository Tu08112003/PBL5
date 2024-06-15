import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:iseeapp2/Database/DatabaseUser.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

import 'log_in.dart';

class ForgetPassword extends StatefulWidget {

  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {

  final _formKey = GlobalKey<FormState>();

  bool isObscured1 = true, isObscured2  = true; // State variable for password visibility
  TextEditingController _emailController = TextEditingController();
  TextEditingController _otpController = TextEditingController();
  // String email ='';
  String generatedOtp = '';
  Random random = Random();
  final databaseUserHelper = DatabaseUser();
  bool emailError = false;
  bool emailExisted = true;
  bool sendOTP = false;
  bool isEmailValid(String email) {
    // Mẫu email chuẩn
    String pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    RegExp regex = RegExp(pattern);
    return regex.hasMatch(email);
  }

  void sendOtp(String email) async {
    // Generate OTP
    // generatedOtp = (100000 + (999999 - 100000) * (new DateTime.now().millisecondsSinceEpoch % 1000000)).toString();
    generatedOtp =  (100000 + random.nextInt(900000)).toString();
    String username = 'hopefullyweb@gmail.com';
    String password = 'xwwa ckxm qhfe jska';
    final smtpServer = gmail(username, password); // Sử dụng hàm gmail() từ gói mailer

    final message = Message()
      ..from = Address(username, 'ISEE APP')
      ..recipients.add(email)
      ..subject = 'Cấp lại mật khẩu trên ISEE APP'
      ..text = 'Mã OTP của bạn là: $generatedOtp';

    if (isEmailValid(email)) {
      emailError = false;
      try {
        UserRecord? userRecord = await databaseUserHelper.getUserByUsername(email);
        if(userRecord == null){
          setState(() {
            emailExisted = false;
          });
        }
        else{
          setState(() {
            emailExisted = true;
            sendOTP = true;
          });
          final sendReport = await send(message, smtpServer);
          print('Message sent: ' + sendReport.toString());
        }

      } on MailerException catch (e) {
        print('Message not sent. \n${e.toString()}');
      }
    } else {
      setState(() {
        emailError = true;
      });
    }

  }
  bool verifyOtp(String userOtp) {
    return generatedOtp == userOtp;
  }

  @override
  void initState() {
    super.initState();
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
              left: 40,
              top: 70,
              child: Text(
                'Quên\n     mật khẩu',
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
                top: 230, // Thay đổi vị trí tùy theo yêu cầu của bạn
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 300,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: emailError ? Colors.red : emailExisted == false ? Colors.red : Colors.black),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            Expanded(
                              child: Center(
                                child: TextFormField(
                                  controller: _emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  style: TextStyle(fontSize: 18),
                                  decoration: InputDecoration(
                                    hintText: 'Gửi tới email',
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(horizontal: 2),
                                  ),

                                ),
                              ),
                            ),
                          ],

                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.transparent), // Border màu trong suốt
                        ),
                        child: Text(
                          emailError ? 'Email không hợp lệ!' : emailExisted == false ? 'Email chưa được đăng ký!' : '',
                          style: TextStyle(color: emailError ? Colors.red : emailExisted == false ? Colors.red : Colors.grey),
                        ),
                      ),
                      SizedBox(height: 40),
                      Container(
                        width: 300,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () => sendOtp(_emailController.text),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: sendOTP == false ? Color(0xFF0D5E37) : Color(
                                0xFF009688),
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                          child: Text(
                            sendOTP == false ? 'Gửi OTP' : 'Đã gửi OTP' ,
                            style: TextStyle(
                              color: Colors.white, // Đặt màu cho chữ là màu trắng
                              fontFamily: 'Inter',
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 80),
                      Container(
                        width: 300,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            // Padding(
                            //   padding: const EdgeInsets.only(left: 17),
                            //   // child: Icon(Icons.person),
                            // ),
                            SizedBox(width: 5),
                            Expanded(
                              child: Center(
                                child: TextFormField(
                                  controller: _otpController,
                                  keyboardType: TextInputType.number,
                                  style: TextStyle(fontSize: 18),
                                  decoration: InputDecoration(
                                    hintText: 'Nhập OTP',
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(horizontal: 2),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 40),
                      Container(
                        width: 300,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            if (verifyOtp(_otpController.text)) {
                              print('OTP verified');
                              resetPassword();
                            } else {
                              print('Invalid OTP');
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF0D5E37), // Đặt màu nền của nút là màu xanh
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                          child: Text(
                            'Xác nhận',
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
              ),
            ],
          ),

        ],
      ),
    );
  }
  void _showSuccessSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Mật khẩu của bạn đã được cấp lại: ' + generatedOtp),
        duration: Duration(seconds: 6),
        backgroundColor: Colors.green,
      ),
    );
  }
  void resetPassword() async{
    UserRecord? userRecord = await databaseUserHelper.getUserByUsername(_emailController.text);
    if(userRecord != null){
      databaseUserHelper.updateUser(userRecord.username, null, generatedOtp, null, null);
      _showSuccessSnackBar();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LogIn()),
      );
    }

  }
}

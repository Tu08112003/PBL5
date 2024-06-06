import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iseeapp2/Database/DatabaseUser.dart';
import '../Database/CreateDatabase.dart';
import 'log_in.dart';

class SignUp extends StatefulWidget {

  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  final _formKey = GlobalKey<FormState>();

  bool isObscured1 = true, isObscured2  = true; // State variable for password visibility
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _passwordAgainController = TextEditingController();

  String username ='';
  String password = '';
  String password_again = '';
  @override
  void initState() {
    super.initState();
    isObscured1 = true;
    isObscured2 = true;
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
                                  controller: _usernameController,
                                  style: TextStyle(fontSize: 18),
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                    hintText: 'Email',
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(horizontal: 4),
                                  ),
                                  onChanged: (value) {
                                    print("===============nhập vào nè: username :" + value);
                                    // username = value.toString(); // Update ipServer when text changes
                                  },
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
                              padding: const EdgeInsets.only(left: 5),
                              child: IconButton(
                                icon: Icon(
                                  isObscured1 ? Icons.lock : Icons.lock_open,
                                ),
                                onPressed: () {
                                  setState(() {
                                    isObscured1 = !isObscured1;
                                  });
                                },
                              ),
                            ),
                            SizedBox(width: 0), // Khoảng cách giữa icon và chữ
                            Expanded(
                              child: Center(
                                child: TextFormField(
                                  controller: _passwordController,
                                  style: TextStyle(fontSize: 18),
                                  obscureText: isObscured1, // Ẩn mật khẩu
                                  decoration: InputDecoration(
                                    hintText: 'Mật khẩu', // Đặt "Tên đăng nhập" làm hint
                                    hintStyle: TextStyle(color: Colors.grey), // Đổi màu chữ hint thành màu xám
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(horizontal: 4),
                                  ),
                                  onChanged: (value) {
                                    // password = value.toString(); // Update ipServer when text changes
                                  },
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
                              padding: const EdgeInsets.only(left: 5),
                              child: IconButton(
                                icon: Icon(
                                  isObscured2 ? Icons.lock : Icons.lock_open,
                                ),
                                onPressed: () {
                                  setState(() {
                                    isObscured2 = !isObscured2;
                                  });
                                },
                              ),
                            ),

                            Expanded(
                              child: Center(
                                child: TextFormField(
                                  controller: _passwordAgainController,
                                  style: TextStyle(fontSize: 18),
                                  obscureText: isObscured2, // Ẩn mật khẩu
                                  decoration: InputDecoration(
                                    hintText: 'Nhập lại mật khẩu', // Đặt "Tên đăng nhập" làm hint
                                    hintStyle: TextStyle(color: Colors.grey), // Đổi màu chữ hint thành màu xám
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(horizontal: 4),
                                  ),
                                  onChanged: (value) {
                                    // password_again = value.toString(); // Update ipServer when text changes
                                  },
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
                            if (_formKey.currentState!.validate()) {
                              // Form is valid, proceed with adding Cane
                              handleSignUp();
                            } else {
                              // Show a snackbar or other error message
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Không được bỏ trống !!!'),
                                ),
                              );
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
              ),
            ],
          ),

        ],
      ),
    );
  }

  bool isValidEmail(String email) {
    final regex = RegExp(r'^[a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$');
    return regex.hasMatch(email);
  }

  void handleSignUp()  async{
    // Ẩn bàn phím trước khi thực hiện hành động
    FocusScope.of(context).unfocus();
    username = _usernameController.text;
    if(isValidEmail(username)){
      CreateDatabase().openDatabaseConnection();
      // CreateDatabase().createTableWithDb();
      password = _passwordController.text;
      password_again = _passwordAgainController.text;
      final databaseHelper = DatabaseUser();
      // databaseHelper.encryptExistingPasswords();
      var listUsername = await databaseHelper.getAllUsername();
      if(username == '' || password == ''){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.pink,
            content: Text('Hãy nhập đủ nội dung'),
          ),
        );
      }
      else{
        if(password == password_again){
          if(listUsername.contains(username))
          {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.pink,
                content: Text('Tên đăng nhập đã tồn tại'),
              ),
            );
          }
          else{
            databaseHelper.addUser(username, password, null);
            _showSuccessSnackBar();
            print("============THÀNH CÔNG===============");
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LogIn()),
            );
          }
        }
        else{
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.pink,
              content: Text('Mật khẩu nhập lại không đúng!'),
            ),
          );
        }
      }
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.pink,
          content: Text('Email không đúng định dạng!'),
        ),
      );
    }

  }
  void _showSuccessSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Đăng ký thành công!'),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.green,
      ),
    );
  }
}

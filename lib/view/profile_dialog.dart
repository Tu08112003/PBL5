import 'package:flutter/material.dart';

import '../session/SessionManager.dart';
import 'change_password_dialog.dart';
import 'edit_profile_dialog.dart';
import 'log_in.dart';
class ProfileDialog extends StatefulWidget {

  const ProfileDialog({super.key});

  @override
  State<ProfileDialog> createState() => _ProfileDialogState();
}

class _ProfileDialogState extends State<ProfileDialog> {
  final TextEditingController _controller = TextEditingController();

  _clearSession() async {
    await SessionManager.removeSession('username');
    // setState(() {
    //   _username = '';
    //   // _controller.clear();
    // });
  }
  String _username = '';
  void initState() {
    super.initState();
    _loadSession();
    print("==================vo dialog profile page roi ne, username = " + _username);
  }
  _loadSession() async {
    String? username = await SessionManager.getSession('username');
    setState(() {
      _username = username ?? '';
    });
  }
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: _dialogContent(context),
    );
  }

  Widget _dialogContent(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: 450, maxWidth: 300),
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    height: 5,
                  ),
                ),
                CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/images/avatar.jpg'),
                ),
                SizedBox(height: 10),
                Text(
                  'Username',
                  style: TextStyle(
                    fontSize: 24,
                    color: Color(0xFF0D5E37),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  _username,
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFF0D5E37),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: 300, // Đặt chiều rộng của SizedBox là 300
                  child: _buildButton('Chỉnh sửa thông tin', context, 'editProfile'),
                ),
                SizedBox(height: 10),
                SizedBox(
                  width: 300, // Đặt chiều rộng của SizedBox là 300
                  child: _buildButton('Thay đổi mật khẩu', context, 'changePassword'),
                ),
                SizedBox(height: 10),
                SizedBox(
                  width: 300, // Đặt chiều rộng của SizedBox là 300
                  child: _buildMainButton('Đăng xuất', context),
                ),
              ],
            ),
          ),
          Positioned(
            top: 10,
            right: 20,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop(); // Đóng dialog
              },
              child: Container(
                padding: EdgeInsets.all(1),
                child: Icon(Icons.close),
              ),
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildButton(String label, BuildContext context, String typeButton) {
    return ElevatedButton(
      onPressed: () {
        // Navigator.of(context).pop(); // Đóng dialog hiện tại
        if(typeButton == "changePassword"){
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return ChangePassDialog(); // Hiển thị dialog
            },
          );
        }
        else if(typeButton == "editProfile"){
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return EditProfileDialog(username: _username); // Hiển thị dialog
            },
          );
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFFDEF9EC),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 18,
          fontFamily: 'Inter',
          color: Color(0xFF0D5E37),
        ),
      ),
    );
  }
  Widget _buildMainButton(String label, BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        print('truoc khi clear ne------========username:'+_username);
        _clearSession;
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LogIn()),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF0D5E37),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 18,
          fontFamily: 'Inter',
          color: Colors.white,
        ),
      ),
    );
  }
}

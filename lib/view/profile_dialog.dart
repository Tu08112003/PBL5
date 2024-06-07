import 'dart:io';

import 'package:flutter/material.dart';

import '../Database/DatabaseUser.dart';
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
  final databaseUserHelper = DatabaseUser();

  _clearSession() async {
    await SessionManager.removeSession('username');
  }

  String _username = '';
  Future<UserRecord?>? _userFuture;

  @override
  void initState() {
    super.initState();
    _loadSession();
  }

  _loadSession() async {
    String? username = await SessionManager.getSession('username');
    setState(() {
      _username = username ?? '';
      _userFuture = databaseUserHelper.getUserByUsername(_username);
    });
    print("_________________"+_username);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: FutureBuilder<UserRecord?>(
        future: _userFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            _userFuture = databaseUserHelper.getUserByUsername(_username);
            UserRecord user = snapshot.data!;
            return _dialogContent(context, user);
          }
        },
      ),
    );
  }

  Widget _dialogContent(BuildContext context, UserRecord user) {
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
                FutureBuilder<UserRecord?>(
                  future: databaseUserHelper.getUserByUsername(_username),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else {
                      var user = snapshot.data!;
                      return CircleAvatar(
                        radius: 50,
                        backgroundImage: user.image != null
                            ? FileImage(File(user.image!))
                            : AssetImage('assets/images/avatar.jpg') as ImageProvider,
                      );
                    }
                  },
                ),

                SizedBox(height: 10),
                Text(
                  user.name ?? 'Username',
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
                  width: 300,
                  child: _buildButton('Chỉnh sửa thông tin', context, 'editProfile'),
                ),
                SizedBox(height: 10),
                SizedBox(
                  width: 300,
                  child: _buildButton('Thay đổi mật khẩu', context, 'changePassword'),
                ),
                SizedBox(height: 10),
                SizedBox(
                  width: 300,
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
        Navigator.of(context).pop();
        if (typeButton == "changePassword") {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return ChangePasswordDialog(username: _username);
            },
          );
        } else if (typeButton == "editProfile") {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return EditProfileDialog(username: _username);
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
        _clearSession();
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

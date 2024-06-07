import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iseeapp2/Database/DatabaseUser.dart';

import '../session/SessionManager.dart';

class ChangePasswordDialog extends StatefulWidget {
  final String username;

  ChangePasswordDialog({required this.username});

  @override
  _ChangePasswordDialogState createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<ChangePasswordDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController oldPassController = TextEditingController();
  final TextEditingController newPassController = TextEditingController();
  final databaseUserHelper = DatabaseUser();
  String? oldPassError;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: _dialogContent(context),
      ),
    );
  }

  Widget _dialogContent(BuildContext context) {
    return Stack(
      children: [
        Container(
          constraints: BoxConstraints(maxHeight: 450, maxWidth: 300),
          child: Form(
            key: _formKey,
            child: Stack(
              children: [
                Container(
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
                          height: 1,
                        ),
                      ),
                      FutureBuilder<UserRecord?>(
                        future: databaseUserHelper.getUserByUsername(widget.username),
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
                      SizedBox(height: 20),
                      Container(
                        width: 240,
                        child: TextFormField(
                          controller: oldPassController,
                          decoration: InputDecoration(
                            labelText: 'Mật khẩu cũ',
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFF072516),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFF0D5E37),
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.red,
                              ),
                            ),
                            labelStyle: TextStyle(color: Color(0xFF072516)),
                            errorText: oldPassError,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Hãy nhập mật khẩu cũ';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        width: 240,
                        child: TextFormField(
                          controller: newPassController,
                          decoration: InputDecoration(
                            labelText: 'Mật khẩu mới',
                            labelStyle: TextStyle(
                              color: Color(0xFF072516),
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFF0D5E37),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFF0D5E37),
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.red,
                              ),
                            ),
                          ),
                          style: TextStyle(
                            color: Color(0xFF072516),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Hãy nhập mật khẩu mới';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: 100),
                    ],
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 20,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      padding: EdgeInsets.all(1),
                      child: Icon(Icons.close),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 20,
          right: 50,
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(30),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Color(0xFF0D5E37),
              ),
              child: ElevatedButton(
                onPressed: () {
                  _handleSaveChangePass(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Text(
                    'Lưu thay đổi',
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Inter',
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _handleSaveChangePass(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      // Lấy mật khẩu cũ từ cơ sở dữ liệu
      String? storedOldPass = await databaseUserHelper.getPasswordByUsername(widget.username);
      // if (oldPassController.text == storedOldPass) {
      if (await databaseUserHelper.isCorrectUser(widget.username, oldPassController.text)) {
        // Nếu mật khẩu cũ đúng, cập nhật mật khẩu mới
        databaseUserHelper.updateUser(widget.username, null, newPassController.text, null, null);
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lưu thành công!'),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        // Nếu mật khẩu cũ không đúng, hiển thị lỗi
        setState(() {
          oldPassError = 'Mật khẩu cũ không đúng';
        });
      }
    }
  }
}

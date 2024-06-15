import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:image_picker/image_picker.dart';
import 'package:iseeapp2/Database/DatabaseUser.dart';

import '../session/SessionManager.dart';
import 'follow_page.dart';
import 'home_page.dart';
class EditProfileDialog extends StatefulWidget {
  String username;
  EditProfileDialog({Key? key, required this.username}) : super(key: key);
  @override
  State<EditProfileDialog> createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<EditProfileDialog> {
  String name = "";
  String newUsername = "";
  final databaseUserHelper = DatabaseUser();
  String? imagePath;
  // late final user = databaseUserHelper.getUserByUsername(username);
  Future<void> _pickImage() async {
    print("vào");
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    print("vào1");
    if (pickedImage != null) {
      print("vào2");
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = path.basename(pickedImage.path);
      final savedImage = await File(pickedImage.path).copy('${appDir.path}/$fileName');

      setState(() {
        print("vào4");
        imagePath = savedImage.path;
      });
      print("vào3");
      // Lưu đường dẫn ảnh vào cơ sở dữ liệu
      // await databaseUserHelper.updateUserAvatar(widget.username, savedImage.path);
    }else {
      // Trường hợp người dùng không chọn ảnh, không làm gì cả.
      print("Người dùng đã hủy chọn ảnh");
    }
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
    return Stack(
        children: [
          Container(
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
                    child: FutureBuilder<UserRecord?>(
                      future: databaseUserHelper.getUserByUsername(widget.username),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(child: Text('Error: ${snapshot.error}'));
                        } else {
                          var user = snapshot.data!;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Container(
                                  height: 1,
                                ), // Container trống để tạo khoảng trống ở trên cùng
                              ),
                              GestureDetector(
                                onTap: _pickImage,
                                child: CircleAvatar(
                                  radius: 50,
                                  backgroundImage: imagePath != null
                                      ? FileImage(File(imagePath!))
                                      : user.image != null
                                        ? FileImage(File(user.image!))
                                        : AssetImage('assets/images/avatar.jpg') as ImageProvider,
                                ),
                              ),
                              SizedBox(height: 20),
                              Container(
                                width: 240,
                                child: TextFormField(
                                  initialValue: user.name ?? 'Họ tên',
                                  decoration: InputDecoration(
                                    labelText: 'Họ tên',
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
                                  ),
                                  onChanged: (newValue) {
                                    name = newValue;
                                  },
                                ),
                              ),
                              SizedBox(height: 20),
                              // Text(
                              //   username,
                              //   style: TextStyle(
                              //     fontSize: 18,
                              //     fontWeight: FontWeight.bold,
                              //   ),
                              // ),
                              Container(
                                width: 240,
                                child: TextFormField(
                                  initialValue: widget.username,
                                  decoration: InputDecoration(
                                    labelText: 'Nhập email',
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
                                  onChanged: (newValue) {
                                    newUsername = newValue;
                                  },
                                ),
                              ),
                              SizedBox(height: 20),
                              Material(
                                elevation: 4, // Độ nổi bật của nút
                                borderRadius: BorderRadius.circular(30),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: Color(0xFF0D5E37),
                                  ),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      // Xử lý sự kiện khi nút được nhấn
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent, // Đặt màu nền của nút là trong suốt
                                      shadowColor: Colors.transparent, // Đặt màu viền nút là trong suốt
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                      child: GestureDetector(
                                        onTap: () {
                                          _handleSaveChangeProfile(context);
                                        },
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
                      },
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
                        // decoration: BoxDecoration(
                        //   shape: BoxShape.circle,
                        //   color: Colors.grey.withOpacity(0.3),
                        // ),
                        child: Icon(Icons.close),
                      ),
                    ),
                  ),


                ]
            ),
          ),
          // Positioned(
          //   bottom: 20,
          //   right: 70,
          //   child: Material(
          //     elevation: 4, // Độ nổi bật của nút
          //     borderRadius: BorderRadius.circular(30),
          //     child: Container(
          //       decoration: BoxDecoration(
          //         borderRadius: BorderRadius.circular(30),
          //         color: Color(0xFF0D5E37),
          //       ),
          //       child: ElevatedButton(
          //         onPressed: () {
          //           // Xử lý sự kiện khi nút được nhấn
          //         },
          //         style: ElevatedButton.styleFrom(
          //           backgroundColor: Colors.transparent, // Đặt màu nền của nút là trong suốt
          //           shadowColor: Colors.transparent, // Đặt màu viền nút là trong suốt
          //           shape: RoundedRectangleBorder(
          //             borderRadius: BorderRadius.circular(30),
          //           ),
          //         ),
          //         child: Padding(
          //           padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          //           child: GestureDetector(
          //             onTap: () {
          //               _handleSaveChangeProfile(context);
          //             },
          //             child: Text(
          //               'Lưu thay đổi',
          //               style: TextStyle(
          //                 fontSize: 18,
          //                 fontFamily: 'Inter',
          //                 color: Colors.white,
          //               ),
          //             ),
          //           ),
          //         ),
          //
          //       ),
          //     ),
          //   ),
          // ),
        ]
    );

  }
  void _showSuccessSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Lưu thành công!'),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.green,
      ),
    );
  }
  void _handleSaveChangeProfile(BuildContext context) {
    print("+++++++ lưu name = " + name);

    if (newUsername == ''){
      if(name != ""){
        databaseUserHelper.updateUser(widget.username,null, null, null, name);
      }
      else{
        databaseUserHelper.updateUser(widget.username,null, null, null, null);
      }
    }
    else{
      if(name != ""){
        databaseUserHelper.updateUser(widget.username,newUsername, null, null, name);
        widget.username = newUsername;
        print("-------Trước khi lưu----username1"+newUsername + "====" +widget.username + "-------" );
        SessionManager.removeSession('username');
        SessionManager.saveSession('username', widget.username);
      }
      else{
        databaseUserHelper.updateUser(widget.username,newUsername, null, null, null);
        widget.username = newUsername;
        print("-------Trước khi lưu----username2"+newUsername + "====" +widget.username + "-------" );
        SessionManager.removeSession('username');
        SessionManager.saveSession('username', widget.username);
      }
    }
    if(imagePath != null){
      databaseUserHelper.updateUserAvatar(widget.username, imagePath!);
    }
    _showSuccessSnackBar(context);
    // Navigator.of(context).pop();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
          (route) => false, // Xóa tất cả các trang trước đó trong ngăn xếp
    );
  }
}



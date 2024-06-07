import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import '../Database/DatabaseCane.dart';
import 'home_page.dart';

class EditCane extends StatefulWidget {
  int idCane;
  EditCane({Key? key, required this.idCane}) : super(key: key);
  @override
  State<EditCane> createState() => _EditCaneState();
}

class _EditCaneState extends State<EditCane> {
  String nickname = "";
  String ipServer = "";
  String ipCam = "";
  String newIpCam = "initial";
  final databaseCaneHelper = DatabaseCane();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? imagePath;
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
      // await databaseCaneHelper.updateCaneAvatar(widget.idCane, savedImage.path);
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
            constraints: BoxConstraints(maxHeight: 560, maxWidth: 300),
            child: Form(
              key: _formKey,
              child: Stack(
                  children: [
                    Container(
                      // padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child:  FutureBuilder<CaneRecord?>(
                        future: databaseCaneHelper.getCaneByID(widget.idCane),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(child: Text('Error: ${snapshot.error}'));
                          } else {
                            var cane = snapshot.data!;
                            ipCam = cane.ipCam ?? "";
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
                                    backgroundImage: imagePath != null ?
                                      FileImage(File(imagePath!))
                                      : cane.image != null
                                        ? FileImage(File(cane.image!))
                                        : AssetImage('assets/images/chiMinh.jpg') as ImageProvider,
                                  ),
                                ),
                                SizedBox(height: 20),
                                Container(
                                  width: 240,
                                  child: TextFormField(
                                    initialValue: cane.nickname,
                                    decoration: InputDecoration(
                                      labelText: 'Tên gợi nhắc',
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
                                      nickname = newValue;
                                    },
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Không được đẻ trống!';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                SizedBox(height: 20),
                                Container(
                                  width: 240,
                                  child: TextFormField(
                                    initialValue: cane.ipServer,
                                    decoration: InputDecoration(
                                      labelText: 'IP Server',
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
                                      ipServer = newValue;
                                    },
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Không được để trồng IP Server!';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                SizedBox(height: 20),
                                Container(
                                  width: 240,
                                  child: TextFormField(
                                    initialValue: ipCam,
                                    decoration: InputDecoration(
                                      labelText: 'IP Camera',
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
                                      newIpCam = newValue;
                                    },
                                  ),
                                ),
                                SizedBox(height: 100),

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
          ),
          Positioned(
            bottom: 20,
            right: 70,
            child: Material(
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
                        _handleSaveChange(context);
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
          ),
        ]
    );
  }

  void _handleSaveChange(BuildContext context) async {
    if (_formKey.currentState!.validate()){
      if(ipServer == ""){
        if(nickname == ""){
          print("---------0: ipcam:"+ipCam+"-new:"+newIpCam);
          if(newIpCam == "initial"){
            databaseCaneHelper.updateCane(widget.idCane, null, null, null);
          }
          else if (newIpCam == ""){
            databaseCaneHelper.updateCane(widget.idCane, null, "-1", null);
          }
          else{
            databaseCaneHelper.updateCane(widget.idCane, null, newIpCam, null);
          }
        }
        else{
          print("---------1: ipcam:"+ipCam+"-new:"+newIpCam);
          if(newIpCam == "initial"){
            databaseCaneHelper.updateCane(widget.idCane, null, null, nickname);
          }
          else if (newIpCam == ""){
            databaseCaneHelper.updateCane(widget.idCane, null, "-1", nickname);
          }
          else{
            databaseCaneHelper.updateCane(widget.idCane, null, newIpCam, nickname);
          }
        }
      }
      else{
        if(nickname == ""){
          print("---------2: ipcam:"+ipCam+"-new:"+newIpCam);
          if(newIpCam == "initial"){
            databaseCaneHelper.updateCane(widget.idCane, ipServer, null, null);
          }
          else if (newIpCam == ""){
            databaseCaneHelper.updateCane(widget.idCane, ipServer, "-1", null);
          }
          else{
            databaseCaneHelper.updateCane(widget.idCane, ipServer, newIpCam, null);
          }
        }
        else{
          print("---------3: ipcam:"+ipCam+"-new:"+newIpCam);
          if(newIpCam == "initial"){
            databaseCaneHelper.updateCane(widget.idCane, ipServer, null, nickname);
          }
          else if (newIpCam == ""){
            databaseCaneHelper.updateCane(widget.idCane, ipServer, "-1", nickname);
          }
          else{
            databaseCaneHelper.updateCane(widget.idCane, ipServer, newIpCam, nickname);
          }
        }
      }
      if(imagePath != null){
        databaseCaneHelper.updateCaneAvatar(widget.idCane, imagePath!);
      }
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
            (route) => false, // Xóa tất cả các trang trước đó trong ngăn xếp
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lưu thành công!'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.green,
        ),
      );
    }
    else{

    }



  }
}

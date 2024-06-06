import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../Database/DatabaseCane.dart';
import 'log_in.dart';

class EditCane extends StatefulWidget {
  final int idCane;
  EditCane({required this.idCane});
  @override
  State<EditCane> createState() => _EditCaneState();
}

class _EditCaneState extends State<EditCane> {
  String nickname = "";
  String ipServer = "";
  String ipCam = "";
  final databaseCaneHelper = DatabaseCane();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();


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
                      child: Column(
                        // mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Container(
                              height: 1,
                            ), // Container trống để tạo khoảng trống ở trên cùng
                          ),
                          CircleAvatar(
                            radius: 50,
                            backgroundImage: AssetImage('assets/images/chiMinh.jpg'), // Đường dẫn đến hình ảnh đại diện
                          ),
                          SizedBox(height: 20),
                          // Text(
                          //   'Họ tên',
                          //   style: TextStyle(
                          //     fontSize: 18,
                          //     fontWeight: FontWeight.bold,
                          //   ),
                          // ),
                          FutureBuilder<CaneRecord?>(
                            future: databaseCaneHelper.getCaneByID(widget.idCane),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return Center(child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                return Center(child: Text('Error: ${snapshot.error}'));
                              } else {
                                var cane = snapshot.data!;
                                return Column(
                                  children: [
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
                                        initialValue: cane.ipCam,
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
                                          ipCam = newValue;
                                        },
                                      ),
                                    ),

                                  ],
                                );

                              }
                            },
                          ),
                          SizedBox(height: 100),
                          // ElevatedButton(
                          //   onPressed: () {
                          //     // Xử lý sự kiện khi nút được nhấn
                          //   },
                          //   child: Text('Theo dõi'),
                          // ),
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
      // if(ipServer != "" || nickname != ""){
        databaseCaneHelper.updateCane(widget.idCane, ipServer, ipCam, nickname);
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lưu thành công!'),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.green,
          ),
        );

      // }
      // else{
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(
      //       content: Text('Tên gợi nhắc và IP Server không được để trống!'),
      //       duration: Duration(seconds: 2),
      //       backgroundColor: Colors.pink,
      //     ),
      //   );
      // }
    }
    else{

    }



  }
}

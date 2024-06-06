import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Database/DatabaseCane.dart';
import 'edit_cane.dart';
import 'follow_page.dart';// Giả sử bạn có một tập tin DatabaseUser.dart chứa class DatabaseUser

class DetailDialog extends StatefulWidget {
  final int idCane;

  const DetailDialog({Key? key, required this.idCane}) : super(key: key);

  @override
  State<DetailDialog> createState() => _DetailDialogState();
}

class _DetailDialogState extends State<DetailDialog> {
  final databaseCaneHelper = DatabaseCane();
  CaneRecord? caneRecord; // Biến trạng thái để lưu trữ dữ liệu

  @override
  void initState() {
    super.initState();
    getCane();
  }

  Future<void> getCane() async {
    CaneRecord? record = await databaseCaneHelper.getCaneByID(widget.idCane);
    setState(() {
      caneRecord = record;
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
      child: caneRecord != null ? _dialogContent(context) : _loadingIndicator(),
    );
  }
  Widget _dialogContent(BuildContext context) {
    return Stack(
      children: [
        Container(
          constraints: BoxConstraints(maxHeight: 370, maxWidth: 300),
          child: Stack(
            children: [
              Container(
                // padding: EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Column(
                  // mainAxisSize: MainAxisSize.min,
                  // crossAxisAlignment: CrossAxisAlignment.center,
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
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(width: 50),
                        Text(
                          caneRecord!.nickname,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 20),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return EditCane(idCane: widget.idCane);
                              },
                            );
                            print('Icon tapped!');
                            // You can add your custom logic here, like navigating to another screen or performing an action
                          },
                          child: Icon(Icons.edit),
                        ),
                        // Spacer(),
                      ],
                    ),
                    SizedBox(height: 10),

                    ClipRRect(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                      child: Container(
                        height: 200,
                        width: 300,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/map.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
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
        Positioned(
          bottom: 20,
          right: 50,
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => FollowPage(idCane: widget.idCane)),
                      );
                    },
                    child: Text(
                      'Theo dõi',
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
  Widget _loadingIndicator() {
    return Center(
      child: CircularProgressIndicator(), // Hiển thị vòng tròn loading khi dữ liệu chưa tải xong
    );
  }
}

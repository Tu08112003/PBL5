import 'package:flutter/material.dart';

import 'detail_dialog.dart';
import 'profile_dialog.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(64),
        child: AppBar(
          backgroundColor: const Color(0xFFB1FFD9),
          title: Stack(
            children: [
              Row(
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
                      ],                    ),
                  ),
                ],
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Ink(
                  decoration: ShapeDecoration(
                    color: Colors.transparent,
                    shape: CircleBorder(),
                  ),
                  child: InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return ProfileDialog(); // Hiển thị dialog
                        },
                      );
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage('assets/images/avatar.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: Container(
        alignment: Alignment.bottomCenter,
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
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return DetailDialog(); // Hiển thị dialog
                    },
                  );
                },
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage('assets/images/avatar.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 40),
            FloatingActionButton(
              onPressed: () {
                // Xử lý sự kiện khi nút được nhấn
              },
              child: Icon(
                Icons.add,
                size: 30,
                color: const Color(0xFFFFFFFF),
              ),
              backgroundColor: const Color(0xFF0D5E37),
              shape: CircleBorder(),
            ),
          ],
        ),
      ),
    );
  }
}

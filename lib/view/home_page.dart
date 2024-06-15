import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:iseeapp2/Database/DatabaseUser.dart';
import 'package:iseeapp2/QRCode/QRScan.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sqflite/sqlite_api.dart';

import '../Database/DatabaseCane.dart';
import '../session/SessionManager.dart';
import 'detail_dialog.dart';
import 'log_in.dart';
import 'profile_dialog.dart';
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String myLocation = '';
  List<Marker> markers = [];
  String address = '';
  final MapController mapController = MapController();
  String _username = '';
  final databaseUserHelper = DatabaseUser();
  final databaseCaneHelper = DatabaseCane();
  late Future<List<int>> _idCaneFuture;
  @override
  void initState() {
    super.initState();
    _loadSession();
    print("==================vo Home page roi ne, username = " + _username);

    _requestLocationPermission();
    _getCurrentLocation();
  }
  // _loadSession() async {
  //   String? username = await SessionManager.getSession('username');
  //   if (username == null) {
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(builder: (context) => LogIn()),
  //     );
  //   } else {
  //     print("==================vo Home page roi ne, username = " + _username + '------------------' + username);
  //     setState(() {
  //       _username = username;
  //     });
  //   }
  // }
  _loadSession() async {
    String? username = await SessionManager.getSession('username');
    print("==================vo Home page roi ne, username = " + _username + '------------------' + username!);
    setState(() {
      _username = username ?? '';
      _idCaneFuture = databaseUserHelper.getIdCaneByUsername(_username);
    });
    _idCaneFuture.then((idCanes) {
      print("++++ +++++ idcane +++++ ${idCanes.join(', ')}");
    }).catchError((error) {
      print("Error: $error");
    });

  }
  Future<void> printIdCane() async {
    List<int> idCanes = await _idCaneFuture;
    print("++++ +++++ idcane +++++ ${idCanes.join(', ')}");
  }




  @override
  Widget build(BuildContext context) {
    // _getCurrentLocation();
    return Scaffold(
      backgroundColor: const Color(0xFFB1FFD9),

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
                    child: FutureBuilder<UserRecord?>(
                      future: databaseUserHelper.getUserByUsername(_username),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(child: Text('Error: ${snapshot.error}'));
                        } else {
                          var user = snapshot.data!;
                          return Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: user.image != null
                                    ? FileImage(File(user.image!))
                                    : AssetImage('assets/images/avatar.jpg') as ImageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      // =======================================================================================
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 677,
                  width: 450,
                  child: Stack(
                    children: [
                      Visibility(
                        visible: true,
                        child: FlutterMap(
                          options: MapOptions(
                            // center: routpoints[0],
                            zoom: 18,
                            onPositionChanged: (position, hasGesture) {},
                          ),
                          nonRotatedChildren: [
                            AttributionWidget.defaultWidget(
                              source: 'OpenStreetMap contributors',
                              onSourceTapped: null,
                            ),
                          ],
                          children: [
                            TileLayer(
                              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                              userAgentPackageName: 'com.example.iseeapp2',
                            ),
                            PolylineLayer(
                              polylineCulling: false,
                              polylines: [
                                // Polyline(points: routpoints, color: Colors.blue, strokeWidth: 9)
                              ],
                            ),
                            MarkerLayer(
                              markers: markers,
                            ),
                          ],
                          mapController: mapController,
                        ),
                      ),
                      Positioned(
                        top: 20,
                        right: 20,
                        child: Column(
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                mapController.move(mapController.center, mapController.zoom + 1);
                              },
                              child: Icon(Icons.add),
                            ),
                            SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: () {
                                mapController.move(mapController.center, mapController.zoom - 1);
                              },
                              child: Icon(Icons.remove),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      // =======================================================================================
      bottomNavigationBar: PreferredSize(
        preferredSize: Size.fromHeight(150),
        child: BottomAppBar(
          color: const Color(0xFFB1FFD9),
          height: 100,
          child: FutureBuilder<List<int>>(
            future: _idCaneFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                final idCanes = snapshot.data  ?? [];
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (var idCane in idCanes)
                      if (idCane > 0)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Ink(
                            decoration: ShapeDecoration(
                              shape: CircleBorder(),
                            ),
                            child: GestureDetector(
                              onLongPress: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Xác nhận', style: TextStyle(color: Color(0xFF0D5E37))),
                                      content: Text('Bạn có chắc chắn muốn xóa người này không?', style: TextStyle(color: Color(0xFF0D5E37))),
                                      actions: [
                                        TextButton(
                                          onPressed: () async {
                                            List<int> idCanes = await _idCaneFuture;
                                            if (idCanes.length == 1){
                                              print("=================== có 1 cane thoi =============");
                                              databaseUserHelper.updateUser(_username, null, null, -1,null);
                                              print("=================== cập nhật =============" + idCane.toString() + "--user:" + _username);
                                            }
                                            else{
                                              print("=================== hơn 1 cane =============");
                                              databaseUserHelper.deleteCaneOfUser(_username, idCane);
                                              print("=================== xóa =============" + idCane.toString() + "--user:" + _username);
                                            }
                                            // Navigator.of(context).pop();
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(builder: (context) => HomePage()),
                                            );
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                backgroundColor: Colors.green,
                                                content: Text('Xóa thành công!'),
                                              ),
                                            );
                                          },
                                          child: Text('Đồng ý', style: TextStyle(color: Color(0xFF0D5E37))),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('Hủy', style: TextStyle(color: Color(0xFF0D5E37)),),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                          child: InkWell(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return DetailDialog(idCane: idCane);
                                  },
                                );
                              },
                              // child: Container(
                              //   width: 64,
                              //   height: 64,
                              //   decoration: BoxDecoration(
                              //     shape: BoxShape.circle,
                              //     image: DecorationImage(
                              //       image: AssetImage('assets/images/chiMinh.jpg'),
                              //       fit: BoxFit.cover,
                              //     ),
                              //   ),
                              // ),
                              child: FutureBuilder<CaneRecord?>(
                                future: databaseCaneHelper.getCaneByID(idCane),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return Center(child: CircularProgressIndicator());
                                  } else if (snapshot.hasError) {
                                    return Center(child: Text('Error: ${snapshot.error}'));
                                  } else {
                                    var cane = snapshot.data!;
                                    return Container(
                                      width: 64,
                                      height: 64,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                          image: cane.image != null
                                              ? FileImage(File(cane.image!))
                                              : AssetImage('assets/images/chiMinh.jpg') as ImageProvider,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                   );
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 40),
                    FloatingActionButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => QRScan()),
                        );
                      },
                      child: Icon(
                        Icons.add,
                        size: 30,
                        color: const Color(0xFFFFFFFF),
                      ),
                      backgroundColor: const Color(0xFF0D5E37),
                      shape: CircleBorder(),
                    ),
                    SizedBox(width: 40),
                  ],
                );
              }
            },
          ),
        ),
      ),

    );
  }

  Future<List<int>> fetchIdCane() async {
    // Thay đổi đoạn code dưới đây để phù hợp với cách bạn lấy dữ liệu từ cơ sở dữ liệu của bạn
    // Đây chỉ là một ví dụ giả định
    return [1, 2, 0, 3, 4]; // Giả sử đây là danh sách các idCane
  }

  Future<void> _requestLocationPermission() async {
    // Kiểm tra xem đã có quyền truy cập vị trí chưa
    if (await Permission.location.isDenied) {
      // Nếu chưa, yêu cầu quyền truy cập
      await Permission.location.request();
    }
  }
  Future<void> _getCurrentLocation() async {
    if (await Permission.location.isGranted) {
      Position position = await Geolocator.getCurrentPosition();
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        address = '${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}';
        print("=============================================" + address);
        _moveToLocation(address);
      }
    }
  }
  // Hàm để lấy vị trí từ địa chỉ và di chuyển trung tâm của bản đồ đến đó
  Future<void> _moveToLocation(String address) async {
    try {
      List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        Location location = locations.first;
        double latitude = location.latitude;
        double longitude = location.longitude;

        // Tạo Marker mới với popup
        Marker marker = Marker(
          width: 200.0,
          height: 80.0,
          point: LatLng(latitude, longitude),
          builder: (context) => Stack(  // Use Stack for efficient layering
            children: [
              InkWell(  // Handle marker clicks
                onTap: () {
                  // Implement your on-click logic here (e.g., show info window)
                },
                child: Icon(
                  Icons.location_pin,
                  color: Colors.red,
                  size: 60.0,
                ),
              ),
              Positioned(  // Position text precisely within the marker
                bottom: 0.0,  // Place text at the bottom
                right: 0.0,   // Align text to the right
                child: Container(
                  padding: EdgeInsets.all(4.0),  // Add some padding around text
                  decoration: BoxDecoration(
                    color: Colors.white,  // Text background color
                    borderRadius: BorderRadius.circular(4.0),  // Rounded corners
                  ),
                  child: Text(
                    address,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 10.0,  // Adjust font size as needed
                    ),
                  ),
                ),
              ),
            ],
          ),
        );


        setState(() {
          markers.add(marker);
        });

        mapController.move(LatLng(latitude, longitude), mapController.zoom);
      } else {
        print("Không tìm thấy vị trí cho địa chỉ này.");
      }
    } catch (e) {
      print("Đã xảy ra lỗi: $e");
    }

  }
}

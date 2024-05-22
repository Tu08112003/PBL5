import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:iseeapp2/Database/DatabaseLocation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:web_socket_channel/io.dart';

import 'package:http/http.dart' as http;
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:webview_flutter/platform_interface.dart';
import 'package:webview_flutter/webview_flutter.dart';
final channel = IOWebSocketChannel.connect('ws://192.168.43.96:3000');
class FollowPage extends StatefulWidget {
  const FollowPage({Key? key}) : super(key: key);

  @override
  State<FollowPage> createState() => _FollowPageState();
  static const String ipCam = "http://10.10.2.26";
  // static const List<Marker> markers = [];
  // static const MapController mapController = MapController();
}

class _FollowPageState extends State<FollowPage> {
  String yourLocation = '';
  String myLocation = '';
  List<Marker> markers = [];
  MapController mapController = MapController();
  List<LatLng> routpoints = [LatLng(52.05884, -1.34558)];
  bool isVisible = true;//bool isVisible = false;

  final dbLocationHelper = DatabaseLocation();

  String latitude = '';
  String longitude = '';
  String ip = '';

  String _selectedMenuItem = '';

  int datetime = 0;

  // String ipCam = "http://192.168.43.200";
  // Sample data for different body content based on menu selection
  final Map<String, Widget> bodyContentMap = {
    // 'history': Text('History content'),
    // 'directions': Text('Directions content'),
    'camera':
    SizedBox(
      height: 2000,
      width: 450,
      child: WebView(
        initialUrl: FollowPage.ipCam ,
        javascriptMode: JavascriptMode.unrestricted,
        onPageFinished: (String url) {
          // Sau khi trang web được tải hoàn thành, bạn có thể thực hiện các thao tác tùy chỉnh ở đây
          print('Page finished loading: $url');
        },
      ),
    ),

  };
  @override
  void initState() {
    super.initState();
    // _moveToLocation(yourLocation);
    fetchData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(64),
        child: AppBar(
          backgroundColor: const Color(0xFFB1FFD9),
          title: Center(
            child: Row(
              children: [
                Spacer(), // Keep trailing Spacer for right alignment
                CircleAvatar(
                  radius: 20,
                  backgroundImage: AssetImage('assets/images/avatar.jpg'),
                ),
                SizedBox(width: 10), // Khoảng cách giữa avatar và tên
                Text(
                  'Chị Minh',
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFF0D5E37),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 10),
                Spacer(),
                PopupMenuButton<String>(
                  color: const Color(0xFFB1FFD9),
                  icon: Icon(Icons.more_vert), // Three-dot menu icon
                  onSelected: (String value) {
                    setState(() async {
                      _selectedMenuItem = value;
                      if (value == 'location') {
                        markers.clear();
                        routpoints = routpoints.sublist(0, 1);
                        fetchData(); // Fetch data again when location is selected
                      }
                      if(value == 'directions'){
                        routpoints = routpoints.sublist(0, 1);
                        markers.clear();
                        fetchData();
                        if (myLocation.isEmpty) {
                          // Nếu trường start rỗng, sử dụng vị trí hiện tại
                         await _getCurrentLocation();
                        }
                        await _moveToLocation(myLocation, 'start');
                        await _fetchRoute();
                      }
                      if(value == 'history'){
                        routpoints = routpoints.sublist(0, 1);
                        markers.clear();
                        await _fetchHistoryLocation();
                      }
                    });
                  },
                  itemBuilder: (BuildContext context) => [
                    PopupMenuItem<String>(
                      value: 'camera',
                      child: Text(
                        'Xem camera',
                        style: TextStyle(
                          color: _selectedMenuItem == 'camera'
                              ? Color(0xFF9BA602)
                              : Color(0xFF0D5E37),
                        ),
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: 'history',
                      child: Text(
                        'Xem lịch sử',
                        style: TextStyle(
                          color: _selectedMenuItem == 'history'
                              ? Color(0xFF9BA602)
                              : Color(0xFF0D5E37),
                        ),
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: 'location',
                      child: Text(
                        'Vị trí',
                        style: TextStyle(
                          color: _selectedMenuItem == 'location'
                              ? Color(0xFF9BA602)
                              : Color(0xFF0D5E37),
                        ),
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: 'directions',
                      child: Text(
                        'Đường đi',
                        style: TextStyle(
                          color: _selectedMenuItem == 'directions'
                              ? Color(0xFF9BA602)
                              : Color(0xFF0D5E37),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),

      //   ================================================================================

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                // bodyContentMap[_selectedMenuItem] ?? SizedBox(
                //   height: 860,
                //   width: 450,
                //   child: Stack(
                //     children: [
                //       Visibility(
                //         visible: true,
                //         child: FlutterMap(
                //           options: MapOptions(
                //             // center: routpoints[0],
                //             zoom: 18,
                //             onPositionChanged: (position, hasGesture) {},
                //           ),
                //           nonRotatedChildren: [
                //             AttributionWidget.defaultWidget(
                //               source: 'OpenStreetMap contributors',
                //               onSourceTapped: null,
                //             ),
                //           ],
                //           children: [
                //             TileLayer(
                //               urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                //               userAgentPackageName: 'com.example.iseeapp2',
                //             ),
                //             PolylineLayer(
                //               polylineCulling: false,
                //               polylines: [
                //                 // Polyline(points: routpoints, color: Colors.blue, strokeWidth: 9)
                //               ],
                //             ),
                //             MarkerLayer(
                //               markers: markers,
                //             ),
                //           ],
                //           mapController: mapController,
                //         ),
                //       ),
                //       Positioned(
                //         top: 20,
                //         right: 20,
                //         child: Column(
                //           children: [
                //             ElevatedButton(
                //               onPressed: () {
                //                 mapController.move(mapController.center, mapController.zoom + 1);
                //               },
                //               child: Icon(Icons.add),
                //             ),
                //             SizedBox(height: 10),
                //             ElevatedButton(
                //               onPressed: () {
                //                 mapController.move(mapController.center, mapController.zoom - 1);
                //               },
                //               child: Icon(Icons.remove),
                //             ),
                //           ],
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                // ============================================================
                bodyContentMap[_selectedMenuItem] ??SizedBox(
                  height: 860,
                  width: 450,
                  child: Stack(
                    children: [
                      Visibility(
                        visible: true,
                        child: FlutterMap(
                          options: MapOptions(
                            center: routpoints[0],
                            // center: ,
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
                                Polyline(points: routpoints, color: Colors.blue, strokeWidth: 9)
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
                // ============================================================
                // bodyContentMap[_selectedMenuItem == 'camera'] ??
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Future<void> fetchData() async {
  //   channel.stream.listen((message) async {
  //     // Xử lý dữ liệu nhận được từ máy chủ
  //     setState(() {
  //       final data = json.decode(message);
  //       print(data);
  //       print(data['location']['latitude']);
  //       latitude = data['location']['latitude'];
  //       longitude = data['location']['longitude'];
  //
  //       // latitude = data['location']?.['latitude'];
  //       print(longitude);
  //       print(latitude);
  //       print(ip);
  //       // longitude = data['longitude'];
  //       if(ip == ''){
  //         ip = data['ip']['ip'];
  //       }
  //       print(latitude);
  //       print(longitude);
  //       print(ip);
  //
  //       // end.text = '$latitude, $longitude';
  //     });
  //
  //   });
  // }

  // Hàm để lấy vị trí từ địa chỉ và di chuyển trung tâm của bản đồ đến đó
  Future<void> _moveToLocation(String address, String title) async { // 1: start
    try {
      List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        Location location = locations.first;
        double latitude = location.latitude;
        double longitude = location.longitude;

        // Tạo Marker mới với popup
        // Marker marker = Marker(
        //   width: 80.0,
        //   height: 80.0,
        //   point: LatLng(latitude, longitude),
        //   builder: (ctx) => Container(
        //     child: Icon(
        //       Icons.location_pin,
        //       color: Colors.red,
        //       size: 60.0,
        //     ),
        //     // child: Tooltip(
        //     //   message: 'Nội dung chú thích',
        //     // ),
        //   ),
        // );

        Marker marker = Marker(
          width: (title == 'start' || title == 'finish') ? 350.0 : 130.0,
          height: (title == 'start' || title == 'finish') ? 80.0 : 30.0,
          point: LatLng(latitude, longitude),
          builder: (context) => Stack(  // Use Stack for efficient layering
            children: [
              InkWell(  // Handle marker clicks
                onTap: () {
                  // Implement your on-click logic here (e.g., show info window)
                },
                child: Icon(
                  Icons.location_pin,
                  color: (title == 'start') ? Colors.amberAccent : (title == 'finish') ? Colors.red : Color(0xFFCC7069),
                  size: (title == 'start' || title == 'finish') ? 60.0 : 26,
                ),
              ),
              Positioned(  // Position text precisely within the marker
                bottom: 0.0,  // Place text at the bottom
                right: 0.0,   // Align text to the right
                child: Container(
                  padding: (title == 'start' || title == 'finish') ? EdgeInsets.all(4.0): EdgeInsets.all(0),  // Add some padding around text
                  decoration: BoxDecoration(
                    color: Colors.white,  // Text background color
                    borderRadius: BorderRadius.circular(4.0),  // Rounded corners
                  ),
                  child: Text(
                    (title == 'start') ? myLocation : (title == 'finish') ?yourLocation : title,
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
  Future<void> _getCurrentLocation() async {
    if (await Permission.location.isGranted) {
      Position position = await Geolocator.getCurrentPosition();
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        myLocation = '${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}';
        // myLocation = '536 Điện Biên Phủ, Thanh Khê Đông, Thanh Khê, Đà Nẵng 550000, Việt Nam';
        print("=============================================" + myLocation);

      }
    }
  }

  Future<void> _fetchRoute() async {
    // List<Location> start_l = await locationFromAddress(start.text);
    // List<Location> end_l = await locationFromAddress(end.text);
    List<Location> start_l = await locationFromAddress(myLocation);
    List<Location> end_l = await locationFromAddress(yourLocation);

    var v1 = start_l[0].latitude;
    var v2 = start_l[0].longitude;
    var v3 = end_l[0].latitude;
    var v4 = end_l[0].longitude;

    var url = Uri.parse(
        'http://router.project-osrm.org/route/v1/driving/$v2,$v1;$v4,$v3?steps=true&annotations=true&geometries=geojson&overview=full');
    var response = await http.get(url);

    setState(() {
      routpoints = [];
      var ruter = jsonDecode(response.body)['routes'][0]['geometry']['coordinates'];
      for (int i = 0; i < ruter.length; i++) {
        var reep = ruter[i].toString();
        reep = reep.replaceAll("[", "");
        reep = reep.replaceAll("]", "");
        var lat1 = reep.split(",");
        var long1 = reep.split(",");

        routpoints.add(LatLng(double.parse(lat1[1]), double.parse(long1[0])));
      }
      // isVisible = !isVisible;
    });
  }
  Future<void> fetchData() async {
    // latitude = '16.065963';
    // longitude = '108.185101';
    // latitude = '16.094673';
    // longitude = '108.146576';
    // print(longitude);
    // print(latitude);
    // yourLocation = latitude + ',' + longitude;
    // yourLocation = 'Nguyễn Tất Thành, Hoà Hiệp Nam, Liên Chiểu, Đà Nẵng, Việt Nam';
    // _moveToLocation(yourLocation, 'finish');
// ====================================================================================================================

    // print("Không nhận được dữ liệu từ channel");
    String locationHistory;
    String timeHistory;
    LocationRecord lastLocation;
    final locations = await dbLocationHelper.getAllLocationsByIP(1) as List;
    int i = 1;

    lastLocation = locations[locations.length - 1];
    print('Last Location: ${lastLocation.latitude}, ${lastLocation.longitude}');
    yourLocation = lastLocation.latitude.toString() + ', ' + lastLocation.longitude.toString();
    // _moveToLocation( yourLocation, dateTimeFromTimestamp(lastLocation.timestamp).toString() + '\n' + getNameLocation(lastLocation).toString());
    _moveToLocation( yourLocation, dateTimeFromTimestamp(lastLocation.timestamp).toString());

    // ====================================================================================================================
    // print("voo ne");
    // channel.stream.listen((message) async {
    //   if (message == null || message.isEmpty) {
    //     // -----------------Không có dữ liệu mới, xử lý sự im lặng
    //     print("Không nhận được dữ liệu từ channel");
    //     String locationHistory;
    //     String timeHistory;
    //     LocationRecord lastLocation;
    //     final locations = await dbLocationHelper.getAllLocationsByIP(1) as List;
    //     int i = 1;
    //
    //     lastLocation = locations[locations.length - 1];
    //     print('Last Location: ${lastLocation.latitude}, ${lastLocation.longitude}');
    //     yourLocation = lastLocation.latitude.toString() + ', ' + lastLocation.longitude.toString();
    //     // _moveToLocation( yourLocation, dateTimeFromTimestamp(lastLocation.timestamp).toString() + '\n' + getNameLocation(lastLocation).toString());
    //     _moveToLocation( yourLocation, dateTimeFromTimestamp(lastLocation.timestamp).toString());
    //
    //   } else {
    //     print("voo ne 2");
    //     // ------------------Xử lý dữ liệu nhận được từ máy chủ
    //     Future.microtask(() {
    //       setState(() {
    //         print("voo ne 4");
    //         final data = json.decode(message);
    //         if (data['location'] is List) {
    //           // Handle array of location data
    //           final locations = data['location'] as List;
    //
    //           print('--- Printing location array ---');
    //           for (var location in locations) {
    //             print(location); // Print each location object in the array
    //           }
    //           print('--- End of location array ---');
    //
    //           // You can also access specific elements within each location object
    //           // for example, to print all latitudes:
    //           for (var location in locations) {
    //             print(location['latitude']);
    //             print(location['longitude']);
    //             print(location['datetime']);
    //             // =================================================
    //             print('lưu csdl');
    //             longitude = location['longitude'];
    //             latitude = location['latitude'];
    //             datetime = location['datetime'];
    //             // Lưu trữ dữ liệu vị trí vào SQLite
    //             if(longitude != null && latitude != null){
    //               final locationRecord = LocationRecord(
    //                 latitude: double.parse(latitude),
    //                 longitude: double.parse(longitude),
    //                 // latitude: 110,
    //                 // longitude: 100,
    //                 // timestamp: DateTime.now().millisecondsSinceEpoch,
    //                 timestamp: datetime,
    //               );
    //               final databaseHelper = DatabaseLocation();
    //               databaseHelper.addLocation(locationRecord.latitude, locationRecord.longitude, locationRecord.timestamp, 1);
    //               print("lưu xong");
    //             }
    //           }
    //         } else {
    //           // Handle unexpected data format (not an array)
    //           print('Received data is not a list of locations');
    //         }
    //         // longitude = data['longitude'];
    //         if(ip == ''){
    //           ip = data['ip']['ip'];
    //         }
    //         print(ip);
    //
    //         // end.text = '$latitude, $longitude';
    //       });
    //     });
    //   }
    // });
    // ============================================================================================

    // channel.stream.listen((message) async {
    //   // Xử lý dữ liệu nhận được từ máy chủ
    //   setState(() async {
    //     final data = json.decode(message);
    //     if (data['location'] is List) {
    //       // Handle array of location data
    //       final locations = data['location'] as List;
    //
    //       print('--- Printing location array ---');
    //       for (var location in locations) {
    //         print(location); // Print each location object in the array
    //       }
    //       print('--- End of location array ---');
    //
    //       // You can also access specific elements within each location object
    //       // for example, to print all latitudes:
    //       for (var location in locations) {
    //         print(location['latitude']);
    //         print(location['longitude']);
    //         print(location['datetime']);
    //         // =================================================
    //         print('lưu csdl');
    //         longitude = location['longitude'];
    //         latitude = location['latitude'];
    //         datetime = location['datetime'];
    //         // Lưu trữ dữ liệu vị trí vào SQLite
    //         if(longitude != null && latitude != null){
    //           final locationRecord = LocationRecord(
    //             latitude: double.parse(latitude),
    //             longitude: double.parse(longitude),
    //             // latitude: 110,
    //             // longitude: 100,
    //             // timestamp: DateTime.now().millisecondsSinceEpoch,
    //             timestamp: datetime,
    //           );
    //           final databaseHelper = DatabaseLocation();
    //           await databaseHelper.addLocation(locationRecord.latitude, locationRecord.longitude, locationRecord.timestamp, 1);
    //         }
    //       }
    //     } else {
    //       // Handle unexpected data format (not an array)
    //       print('Received data is not a list of locations');
    //     }
    //     // longitude = data['longitude'];
    //     if(ip == ''){
    //       ip = data['ip']['ip'];
    //     }
    //     print(ip);
    //
    //     end.text = '$latitude, $longitude';
    //   });
    //
    //
    // });
  }

  Future<void> _fetchHistoryLocation() async{
    String locationHistory;
    String timeHistory;
    final locations = await dbLocationHelper.getAllLocationsByIP(1) as List;
    int i = 1;
    for (LocationRecord location in locations) {
      print(i);
      locationHistory = location.latitude.toString() + ', ' + location.longitude.toString();
      // print('====' + location.latitude.toString() + '------' + location.longitude.toString() + '---' + dateTimeFromTimestamp(location.timestamp).toString() + '===');
      print(locationHistory);
      timeHistory = dateTimeFromTimestamp(location.timestamp).toString();
      print(timeHistory);
      i ++;
      _moveToLocation(locationHistory, timeHistory);
    }
  }
  DateTime dateTimeFromTimestamp(int timestamp) {
    return DateTime.fromMillisecondsSinceEpoch(timestamp);
  }
  Future<String> getNameLocation(LocationRecord position) async{
    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude) as List<Placemark>;

    // if (placemarks.isNotEmpty) {
      Placemark place = placemarks[0];
      String address = '${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}';
      print("=============================================" + address);
      return address;
    // }
  }

}

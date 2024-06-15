import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:iseeapp2/Database/DatabaseLocation.dart';
import 'package:iseeapp2/camera/follow_camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:web_socket_channel/io.dart';

import 'package:http/http.dart' as http;
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../Database/DatabaseCane.dart';
import 'package:intl/intl.dart';
// final channel = IOWebSocketChannel.connect('ws://192.168.43.96:3000');
// late final String ipCam;
class FollowPage extends StatefulWidget {
  // final int idCane;
  // const FollowPage({Key? key, required this.idCane}) : super(key: key);
   CaneRecord caneRecord;
   // String idC="";
  FollowPage({Key? key, required this.caneRecord}) : super(key: key);

  @override
  State<FollowPage> createState() => _FollowPageState();
  // static const String ipCam = "http://10.10.2.26";

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
  late String ipCam = ""; // Sử dụng 'late' để khai báo biến ipCam

  late final Map<String, Widget> bodyContentMap; // Sử dụng 'late' ở đây

  String _selectedMenuItem = '';

  int datetime = 0;
  DateTime _selectedDate = DateTime.now();

  final databaseCaneHelper = DatabaseCane();
  // CaneRecord caneRecord = widget.caneRecord;
  IOWebSocketChannel? channel;
  Timer? timer;
  Duration timeoutDuration = Duration(seconds: 30);
  String ipServer = '';
  


  Uint8List? _imageBytes;
  Timer? _fetchTimer;
  Timer? _displayTimer;
  final List<Uint8List> _imageQueue = [];
  bool _isFetching = false;
  bool _isDisplaying = false;
  // late final String ipCam;


  @override
  void initState() {
    super.initState();
    // init();
    getCane();
    if(widget.caneRecord.ipCam != null){
      ipCam = widget.caneRecord.ipCam!;
    }
    // ip = ipCam;
    print("---ip:" + ip + "--ipCam:"+ipCam);

    bodyContentMap = {
      'camera': SizedBox(
        height: 740,
        width: 470,
        child: FollowCameraPage(ipCam: ipCam),
      ),
    };
    // _moveToLocation(yourLocation);
    fetchData();
    print("//////////////// ---- ok4:========================" );
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
                  backgroundImage: widget.caneRecord.image != null
                      ? FileImage(File(widget.caneRecord.image!))
                      : AssetImage('assets/images/chiMinh.jpg') as ImageProvider,
                ),
                SizedBox(width: 10), // Khoảng cách giữa avatar và tên
                Text(
                  widget.caneRecord.nickname,
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
                    // setState(() async {
                    //   _selectedMenuItem = value;
                    //   if (value == 'location') {
                    //     markers.clear();
                    //     routpoints = routpoints.sublist(0, 1);
                    //     fetchData(); // Fetch data again when location is selected
                    //   }
                    //   if(value == 'directions'){
                    //     routpoints = routpoints.sublist(0, 1);
                    //     markers.clear();
                    //     fetchData();
                    //     fetchData();
                    //     if (myLocation.isEmpty) {
                    //       // Nếu trường start rỗng, sử dụng vị trí hiện tại
                    //      await _getCurrentLocation();
                    //     }
                    //     await _moveToLocation(myLocation, 'start');
                    //     await _fetchRoute();
                    //   }
                    //   if(value == 'history'){
                    //     routpoints = routpoints.sublist(0, 1);
                    //     markers.clear();
                    //     await _selectDate(context);
                    //     await _fetchHistoryLocation(_selectedDate);
                    //   }
                    //   if(value == 'camera'){
                    //     markers.clear();
                    //     // _startFetchingImages();
                    //     // _startDisplayingImages();
                    //
                    //   }
                    // });
                    setState(() {
                      _selectedMenuItem = value;
                      if (value == 'location') {
                        _handleLocationMenuSelected();
                      }
                      if (value == 'directions') {
                        _handleDirectionsMenuSelected();
                      }
                      if (value == 'history') {
                        _handleHistoryMenuSelected();
                      }
                      if (value == 'camera') {
                        _handleCameraMenuSelected();
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
                            if(_selectedMenuItem == 'history')
                              Column(
                                children: [
                                  SizedBox(height: 10),
                                  ElevatedButton(
                                    onPressed: ()  =>  _handleSelectedDate(),
                                    child: Icon(Icons.calendar_today),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    "${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}",
                                    style: TextStyle(color: Color(0xFF0D5E37), backgroundColor: Colors.white, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              )
                          ],
                        ),
                      ),
                    ],
                  ),
                ) ,
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
  // Phương thức xử lý khi chọn mục 'location'
  void _handleLocationMenuSelected() {
    markers.clear();
    routpoints = routpoints.sublist(0, 1);
    fetchData(); // Fetch data again when location is selected
  }

// Phương thức xử lý khi chọn mục 'directions'
  void _handleDirectionsMenuSelected() async {
    routpoints = routpoints.sublist(0, 1);
    markers.clear();
    fetchData();
    fetchData();
    if (myLocation.isEmpty) {
      // Nếu trường start rỗng, sử dụng vị trí hiện tại
      await _getCurrentLocation();
    }
    await _moveToLocation(myLocation, 'start');
    await _fetchRoute();
  }

// Phương thức xử lý khi chọn mục 'history'
  void _handleHistoryMenuSelected() async {
    routpoints = routpoints.sublist(0, 1);
    markers.clear();
    await _selectDate(context);
    await _fetchHistoryLocation(_selectedDate);
  }
  void _handleSelectedDate() async {
    await _selectDate(context);
    setState(() {
      routpoints = routpoints.sublist(0, 1);
      markers.clear();
    });
    await _fetchHistoryLocation(_selectedDate);
  }

// Phương thức xử lý khi chọn mục 'camera'
  void _handleCameraMenuSelected() {
    markers.clear();
    // _startFetchingImages();
    // _startDisplayingImages();
  }
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    print("------selectDate1: " + _selectedDate.toString());
    if (picked != null && picked != _selectedDate) {
      // setState(() {
        _selectedDate = picked;
        print("------selectDate: " + _selectedDate.toString());
        // Thêm các hành động khi ngày đã chọn thay đổi (nếu cần)
      // });
    }
    // routpoints = routpoints.sublist(0, 1);
    // markers.clear();
    // await _fetchHistoryLocation(_selectedDate);
    // return _selectedDate;
  }

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
              GestureDetector(
                onTap: () async {
                  if (title != 'start' && title != 'finish') {
                    String getNameAddress = await getAddressFromLatLng(latitude, longitude);
                    print("-------name address:" + getNameAddress);
                    print("=== lat:"+latitude.toString()+"--longi"+longitude.toString());
                    _showLocationDialog(context, getNameAddress);
                  }
                },
                child: Positioned(
                  bottom: 0.0,
                  right: 0.0,
                  child: Container(
                    padding: (title == 'start' || title == 'finish')
                        ? EdgeInsets.all(4.0)
                        : EdgeInsets.all(0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: Text(
                      (title == 'start') ? myLocation : (title == 'finish') ? yourLocation : title,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 10.0,
                      ),
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
  Future<String> getAddressFromLatLng(double latitude, double longitude) async {
    String nameAddress = "";
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          latitude, longitude);

      Placemark place = placemarks[0];
      // setState(() {
        nameAddress = '${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}';
      // });
      return nameAddress;
    } catch (e) {
      print('Error getting address: $e');
      return nameAddress;
    }
  }
  void _showLocationDialog(BuildContext context, String location) {
    print("================ location ==================" + location);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Vị trí"),
          content: Text("Vị trí: $location"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: Text("Đóng"),
            ),
          ],
        );
      },
    );
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


  Future<void> _fetchHistoryLocation(DateTime selectdatetime) async{
    String locationHistory;
    String timeHistory;
    final locations = await dbLocationHelper.getAllLocationsByID(widget.caneRecord.idCane!) as List;
    int i = 1;
    for (LocationRecord location in locations) {
      final DateTime locationDate = DateTime.fromMillisecondsSinceEpoch(location.timestamp);
      print("----locationdate:" + locationDate.toString() + "---select: " + _selectedDate.toString());
      if (isSameDate(locationDate, _selectedDate)){

        print(i);
        locationHistory = location.latitude.toString() + ', ' + location.longitude.toString();
        // print('====' + location.latitude.toString() + '------' + location.longitude.toString() + '---' + dateTimeFromTimestamp(location.timestamp).toString() + '===');
        print(locationHistory);
        // timeHistory = dateTimeFromTimestamp(location.timestamp).toString();
        timeHistory = _formatDateTime(location.timestamp);
        print(timeHistory);
        i ++;
        _moveToLocation(locationHistory, timeHistory);
      }

    }
  }
  // DateTime dateTimeFromTimestamp(int timestamp) {
  //   return DateTime.fromMillisecondsSinceEpoch(timestamp);
  // }
  String _formatDateTime(int timestamp) {
    final DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final DateFormat formatter = DateFormat('HH:mm:ss, dd/MM/yyyy');
    return formatter.format(dateTime);
  }
  bool isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
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
  Future<void> getCane() async {
    // CaneRecord? record = await databaseCaneHelper.getCaneByID(widget.idCane);
    print("//////////////// ---- ok1:========================" );
    // if (record != null) {
    setState(() {
      // caneRecord = record;
      ipServer = widget.caneRecord.ipServer.toString();
      print("//////////////// ---- ok2:========================" + ipServer);
      // Kết nối WebSocket sau khi có ipServer
      // channel = IOWebSocketChannel.connect(ipServer);
      print("//////////////// ---- ok3:========================" );
      // if(widget.caneRecord.ipCam != null){
      //   // ipCam = widget.caneRecord.ipCam.toString();
      //   print("//////////////// ipCam:" + ipCam + "---- ipServer:" + ipServer);
      // }
      print("//////////////// ---- ipServer:" + ipServer);

    });
  }
  // final Map<String, Widget> bodyContentMap = {

    // 'directions': Text('Directions content'),
    // 'camera': Text('History content'),
    // 'camera':
    // SizedBox(
    //   height: 2000,
    //   width: 450,
    //   child: WebView(
    //     initialUrl: ipCam,
    //     javascriptMode: JavascriptMode.unrestricted,
    //     onPageFinished: (String url) {
    //       // Sau khi trang web được tải hoàn thành, bạn có thể thực hiện các thao tác tùy chỉnh ở đây
    //       print('Page finished loading: $url');
    //     },
    //   ),
    // ),
  //   'camera':
  //   SizedBox(
  //     height: 760,
  //     width: 470,
  //     child: FollowCameraPage(ipCam: ipCam),
  //   ),
  // };

  // String ipCam = "http://192.168.43.200";


// void init() async {
//   await getCane();
//   fetchData();
//   print("//////////////// ---- ok4:========================" );
// }

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

    // // print("Không nhận được dữ liệu từ channel");
    // String locationHistory;
    // String timeHistory;
    // int i = 1;
    // LocationRecord lastLocation;
    // final locations = await dbLocationHelper.getAllLocationsByID(widget.caneRecord.idCane!) as List;
    //
    // lastLocation = locations[locations.length - 1];
    // print('Last Location: ${lastLocation.latitude}, ${lastLocation.longitude}');
    // yourLocation = lastLocation.latitude.toString() + ', ' + lastLocation.longitude.toString();
    // // _moveToLocation( yourLocation, dateTimeFromTimestamp(lastLocation.timestamp).toString() + '\n' + getNameLocation(lastLocation).toString());
    // _moveToLocation( yourLocation, dateTimeFromTimestamp(lastLocation.timestamp).toString());

    // ====================================================================================================================
    // ipServer = 'ws://192.168.43.96:3000';
    // print('====ipServer :' + ipServer);
    try{
      channel = IOWebSocketChannel.connect(ipServer);
      print("-----vvo ipServer"+ipServer);
      // Thời gian chờ kết nối (ví dụ: 10 giây)
      // final connectionTimeout = Duration(seconds: 30);
      // await channel?.stream.first.timeout(connectionTimeout);

      // Nếu không có lỗi thời gian chờ, tiếp tục lắng nghe dữ liệu từ máy chủ
      // await for (var message in channel!.stream) {
      //   // Xử lý dữ liệu từ máy chủ ở đây
      //   print("-----vvo ipServer"+ipServer+ "--chanel:"+channel.toString());
      //
      //   print("voo ne 4");
      //   final data = json.decode(message);
      //   int i = 1;
      //   if (data['location'] is List) {
      //     // Handle array of location data
      //     final locations = data['location'] as List;
      //
      //     print('--- Printing location array ---');
      //     for (var location in locations) {
      //       print(location); // Print each location object in the array
      //     }
      //     print('--- End of location array ---');
      //
      //     // You can also access specific elements within each location object
      //     // for example, to print all latitudes:
      //     for (var location in locations) {
      //       print(location['latitude']);
      //       print(location['longitude']);
      //       print(location['datetime']);
      //       // =================================================
      //       print('lưu csdl');
      //       longitude = location['longitude'];
      //       latitude = location['latitude'];
      //       datetime = location['datetime'];
      //       // Lưu trữ dữ liệu vị trí vào SQLite
      //       // if(longitude != '' && latitude != ''){
      //       if (longitude.isNotEmpty && latitude.isNotEmpty) {
      //         List<int> listTime = await dbLocationHelper.getDatetimesByIDCane(widget.caneRecord.idCane!
      //         );
      //         if(!listTime.contains(datetime)){
      //           final locationRecord = LocationRecord(
      //             latitude: double.parse(latitude),
      //             longitude: double.parse(longitude),
      //             // latitude: 110,
      //             // longitude: 100,
      //             // timestamp: DateTime.now().millisecondsSinceEpoch,
      //             timestamp: datetime,
      //           );
      //           //   final databaseHelper = DatabaseLocation();
      //           dbLocationHelper.addLocation(locationRecord.latitude, locationRecord.longitude, locationRecord.timestamp, widget.caneRecord.idCane!);
      //           print("========== lưu xong ================" + i.toString());
      //           yourLocation = locationRecord.latitude.toString() + ', ' + locationRecord.longitude.toString();
      //           // _moveToLocation( yourLocation, dateTimeFromTimestamp(lastLocation.timestamp).toString() + '\n' + getNameLocation(lastLocation).toString());
      //           String nameYourLocation = await getAddressFromLatLng(locationRecord.latitude, locationRecord.longitude);
      //           _moveToLocation(yourLocation, nameYourLocation);
      //           i++;
      //         }
      //       }
      //     }
      //   } else {
      //     // Handle unexpected data format (not an array)
      //     print('Received data is not a list of locations');
      //   }
      //   // longitude = data['longitude'];
      //   if(ip == ''){
      //     ip = data['ip']['ip'];
      //     print("-------------ip:"+ip + "---lưu csdl:idCane"+widget.caneRecord.idCane.toString());
      //     databaseCaneHelper.updateCane(widget.caneRecord.idCane!, null, ip, null);
      //     ipCam = widget.caneRecord.ipCam!;
      //   }
      //   print(ip);
      //
      //   // end.text = '$latitude, $longitude';
      // }
      channel?.stream.listen((message) async {
        print("voo ne 2");
        // Xử lý dữ liệu nhận được từ máy chủ
        Future.microtask(() {
          setState(() async {
            print("voo ne 4");
              final data = json.decode(message);
              int i = 1;
              if (data['location'] is List) {
                // Handle array of location data
                final locations = data['location'] as List;

                print('--- Printing location array ---');
                for (var location in locations) {
                  print(location); // Print each location object in the array
                }
                print('--- End of location array ---');
                if(locations.length == 0){
                  print('///// ==== khinh do, vi do trong');
                  // Thực hiện các hành động sau khi xảy ra ngoại lệ
                  LocationRecord lastLocation;
                  final locations = await dbLocationHelper.getAllLocationsByID(widget.caneRecord.idCane!) as List;
                  lastLocation = locations[locations.length - 1];
                  print('Last Location: ${lastLocation.latitude}, ${lastLocation.longitude}');
                  yourLocation = lastLocation.latitude.toString() + ', ' + lastLocation.longitude.toString();
                  // _moveToLocation( yourLocation, dateTimeFromTimestamp(lastLocation.timestamp).toString());
                  _moveToLocation( yourLocation, _formatDateTime(lastLocation.timestamp));
                }
                // You can also access specific elements within each location object
                // for example, to print all latitudes:
                for (var location in locations) {
                  print(location['latitude']);
                  print(location['longitude']);
                  print(location['datetime']);
                  // =================================================
                  print('lưu csdl');
                  longitude = location['longitude'];
                  latitude = location['latitude'];
                  datetime = location['datetime'];
                  // Lưu trữ dữ liệu vị trí vào SQLite
                  // if(longitude != '' && latitude != ''){
                  if (longitude.isNotEmpty && latitude.isNotEmpty) {
                    List<int> listTime = await dbLocationHelper.getDatetimesByIDCane(widget.caneRecord.idCane!);
                    if(!listTime.contains(datetime)){
                      final locationRecord = LocationRecord(
                        latitude: double.parse(latitude),
                        longitude: double.parse(longitude),
                        // latitude: 110,
                        // longitude: 100,
                        // timestamp: DateTime.now().millisecondsSinceEpoch,
                        timestamp: datetime,
                      );

                      dbLocationHelper.addLocation(locationRecord.latitude, locationRecord.longitude, locationRecord.timestamp, widget.caneRecord.idCane!);




                      final int j = 1;
                      final listIDs = await databaseCaneHelper.getListIdCanesByIpServer(ipServer);
                      for(int id in listIDs){
                        if(id != widget.caneRecord.idCane){
                          dbLocationHelper.addLocation(locationRecord.latitude, locationRecord.longitude, locationRecord.timestamp, id);
                          print("---lưu:"+ id.toString()+"; j="+j.toString());
                          i++;
                        }
                      }




                      print("========== lưu xong ================" + i.toString());
                      yourLocation = locationRecord.latitude.toString() + ', ' + locationRecord.longitude.toString();
                      // _moveToLocation( yourLocation, dateTimeFromTimestamp(lastLocation.timestamp).toString() + '\n' + getNameLocation(lastLocation).toString());
                      String nameYourLocation = await getAddressFromLatLng(locationRecord.latitude, locationRecord.longitude);
                      _moveToLocation(yourLocation, nameYourLocation);
                      i++;
                    }
                  }
                }
              } else {
                // Handle unexpected data format (not an array)
                print('Received data is not a list of locations');
              }

              // longitude = data['longitude'];
              if(ip == ''){
                ip = data['ip']['ip'];
                print("-------------ip:"+ip + "---lưu csdl:idCane"+widget.caneRecord.idCane.toString());
                databaseCaneHelper.updateCane(widget.caneRecord.idCane!, null, ip, null);
                ipCam = widget.caneRecord.ipCam!;
              }
              print(ip);

              // end.text = '$latitude, $longitude';
          });

        });
      });
      // Xử lý ngoại lệ từ kết nối WebSocket
      print('///// ==== ko vo duoc thi hien lich su');
      // Thực hiện các hành động sau khi xảy ra ngoại lệ
      LocationRecord lastLocation;
      final locations = await dbLocationHelper.getAllLocationsByID(widget.caneRecord.idCane!) as List;
      lastLocation = locations[locations.length - 1];
      print('Last Location: ${lastLocation.latitude}, ${lastLocation.longitude}');
      yourLocation = lastLocation.latitude.toString() + ', ' + lastLocation.longitude.toString();
      // _moveToLocation( yourLocation, dateTimeFromTimestamp(lastLocation.timestamp).toString());
      _moveToLocation( yourLocation, _formatDateTime(lastLocation.timestamp));
    }
    catch (e) {
      // Xử lý ngoại lệ từ kết nối WebSocket
      print('///// ==== Error from WebSocket connection: $e');
      // Thực hiện các hành động sau khi xảy ra ngoại lệ
      LocationRecord lastLocation;
      final locations = await dbLocationHelper.getAllLocationsByID(widget.caneRecord.idCane!) as List;
      lastLocation = locations[locations.length - 1];
      print('Last Location: ${lastLocation.latitude}, ${lastLocation.longitude}');
      yourLocation = lastLocation.latitude.toString() + ', ' + lastLocation.longitude.toString();
      // _moveToLocation( yourLocation, dateTimeFromTimestamp(lastLocation.timestamp).toString());
      _moveToLocation( yourLocation, _formatDateTime(lastLocation.timestamp));
    }

    // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    // ====================================================================================================================

    // try{
    //   print("------voo ne");
    //   print("-----ipServer"+ipServer);
    //   channel = IOWebSocketChannel.connect(ipServer);
    //   print("-----vvo ipServer"+ipServer);
    //   if (channel != null && channel?.stream != null) {
    //     channel?.stream.listen((message) async {
    //       if (message == null || message.isEmpty) {
    //         // -----------------Không có dữ liệu mới, xử lý sự im lặng
    //         print("Không nhận được dữ liệu từ channel");
    //         String locationHistory;
    //         String timeHistory;
    //         LocationRecord lastLocation;
    //         final locations = await dbLocationHelper.getAllLocationsByID(
    //             widget.caneRecord.idCane!) as List;
    //
    //
    //         lastLocation = locations[locations.length - 1];
    //         print('Last Location: ${lastLocation.latitude}, ${lastLocation.longitude}');
    //         yourLocation = lastLocation.latitude.toString() + ', ' + lastLocation.longitude.toString();
    //         // _moveToLocation( yourLocation, dateTimeFromTimestamp(lastLocation.timestamp).toString() + '\n' + getNameLocation(lastLocation).toString());
    //         _moveToLocation(yourLocation, dateTimeFromTimestamp(lastLocation.timestamp).toString());
    //       }
    //       else{
    //         print("voo ne 2");
    //         // ------------------Xử lý dữ liệu nhận được từ máy chủ
    //         Future.microtask(() {
    //           setState(() async {
    //             print("voo ne 4");
    //             final data = json.decode(message);
    //             int i = 1;
    //             if (data['location'] is List) {
    //               // Handle array of location data
    //               final locations = data['location'] as List;
    //
    //               print('--- Printing location array ---');
    //               for (var location in locations) {
    //                 print(location); // Print each location object in the array
    //               }
    //               print('--- End of location array ---');
    //
    //               // You can also access specific elements within each location object
    //               // for example, to print all latitudes:
    //               for (var location in locations) {
    //                 print(location['latitude']);
    //                 print(location['longitude']);
    //                 print(location['datetime']);
    //                 // =================================================
    //                 print('lưu csdl');
    //                 longitude = location['longitude'];
    //                 latitude = location['latitude'];
    //                 datetime = location['datetime'];
    //                 // Lưu trữ dữ liệu vị trí vào SQLite
    //                 if(longitude != null && latitude != null){
    //                   final locationRecord = LocationRecord(
    //                     latitude: double.parse(latitude),
    //                     longitude: double.parse(longitude),
    //                     // latitude: 110,
    //                     // longitude: 100,
    //                     // timestamp: DateTime.now().millisecondsSinceEpoch,
    //                     timestamp: datetime,
    //                   );
    //                   //   final databaseHelper = DatabaseLocation();
    //                   dbLocationHelper.addLocation(locationRecord.latitude, locationRecord.longitude, locationRecord.timestamp, widget.caneRecord.idCane!);
    //                   print("========== lưu xong ================" + i.toString());
    //                   yourLocation = locationRecord.latitude.toString() + ', ' + locationRecord.longitude.toString();
    //                   // _moveToLocation( yourLocation, dateTimeFromTimestamp(lastLocation.timestamp).toString() + '\n' + getNameLocation(lastLocation).toString());
    //                   String nameYourLocation = await getAddressFromLatLng(locationRecord.latitude, locationRecord.longitude);
    //                   _moveToLocation(yourLocation, nameYourLocation);
    //                   i++;
    //                 }
    //               }
    //             } else {
    //               // Handle unexpected data format (not an array)
    //               print('Received data is not a list of locations');
    //             }
    //             // longitude = data['longitude'];
    //             if(ip == ''){
    //               ip = data['ip']['ip'];
    //               print("-------------ip:"+ip + "---lưu csdl:idCane"+widget.caneRecord.idCane.toString());
    //               databaseCaneHelper.updateCane(widget.caneRecord.idCane!, null, ip, null);
    //             }
    //             print(ip);
    //
    //             // end.text = '$latitude, $longitude';
    //           });
    //         });
    //       }
    //     },
    //     // onError: (error) {
    //     //   print("Error occurred: $error");
    //     //   // Xử lý lỗi khi nghe thông điệp
    //     //   channel?.sink.close();
    //     // },
    //     // onDone: () {
    //     //   print("Connection closed.");
    //     //   // Xử lý khi kết nối bị đóng
    //     //   channel?.sink.close();
    //     // }
    //     );
    //
    //   } else {
    //     print("Could not establish connection to the server.");
    //     // -----------------Không có dữ liệu mới, xử lý sự im lặng
    //     print("Không nhận được dữ liệu từ channel");
    //     String locationHistory;
    //     String timeHistory;
    //     LocationRecord lastLocation;
    //     final locations = await dbLocationHelper.getAllLocationsByID(widget.caneRecord.idCane!) as List;
    //     int i = 1;
    //
    //     lastLocation = locations[locations.length - 1];
    //     print('Last Location: ${lastLocation.latitude}, ${lastLocation.longitude}');
    //     yourLocation = lastLocation.latitude.toString() + ', ' + lastLocation.longitude.toString();
    //     // _moveToLocation( yourLocation, dateTimeFromTimestamp(lastLocation.timestamp).toString() + '\n' + getNameLocation(lastLocation).toString());
    //     _moveToLocation(yourLocation, dateTimeFromTimestamp(lastLocation.timestamp).toString());
    //   }
    //
    // }
    // catch (e) {
    //   print("Exception: $e");
    //   // Xử lý ngoại lệ khi cố gắng kết nối
    //   channel?.sink.close();
    //   // -----------------Không có dữ liệu mới, xử lý sự im lặng
    //   print("+++ ---- Ngoại lệ từ channel --- +++");
    //   String locationHistory;
    //   String timeHistory;
    //   LocationRecord lastLocation;
    //   final locations = await dbLocationHelper.getAllLocationsByID(
    //       widget.caneRecord.idCane!) as List;
    //   int i = 1;
    //
    //   lastLocation = locations[locations.length - 1];
    //   print('Last Location: ${lastLocation.latitude}, ${lastLocation.longitude}');
    //   yourLocation = lastLocation.latitude.toString() + ', ' + lastLocation.longitude.toString();
    //   // _moveToLocation( yourLocation, dateTimeFromTimestamp(lastLocation.timestamp).toString() + '\n' + getNameLocation(lastLocation).toString());
    //   _moveToLocation(yourLocation, dateTimeFromTimestamp(lastLocation.timestamp).toString());
    // }

    // ============================================================================================

    // ====================================================================================================================

    // print("------voo ne");
    // channel = IOWebSocketChannel.connect(ipServer);
    // print("-----ipServer"+ipServer);
    // channel?.stream.listen((message) async {
    //   if (message == null || message.isEmpty) {
    //     // -----------------Không có dữ liệu mới, xử lý sự im lặng
    //     print("Không nhận được dữ liệu từ channel");
    //     String locationHistory;
    //     String timeHistory;
    //     LocationRecord lastLocation;
    //     final locations = await dbLocationHelper.getAllLocationsByID(widget.idCane) as List;
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
    //            //   final databaseHelper = DatabaseLocation();
    //               dbLocationHelper.addLocation(locationRecord.latitude, locationRecord.longitude, locationRecord.timestamp, widget.idCane);
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
    //        //   final databaseHelper = DatabaseLocation();
    //           await databaseHelper.addLocation(locationRecord.latitude, locationRecord.longitude, locationRecord.timestamp, widget.idCane);
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
}

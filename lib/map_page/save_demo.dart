// import 'dart:convert';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:web_socket_channel/io.dart';
//
// import 'my_input.dart';
// import 'package:http/http.dart' as http;
// import 'package:latlong2/latlong.dart';
//
// final channel = IOWebSocketChannel.connect('ws://192.168.183.96:3000');
//
// class MapPage extends StatefulWidget {
//   const MapPage({Key? key}) : super(key: key);
//
//   @override
//   State<MapPage> createState() => _MapPageState();
// }
//
// class _MapPageState extends State<MapPage> {
//   final start = TextEditingController();
//   final end = TextEditingController();
//   String latitude = '';
//   String longitude = '';
//   bool isVisible = false;
//   List<LatLng> routpoints = [LatLng(52.05884, -1.34558)];
//   final MapController mapController = MapController();
//
//   @override
//   void initState() {
//     super.initState();
//     fetchData();
//     _requestLocationPermission();
//   }
//
//   @override
//   void dispose() {
//     channel.sink.close();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Routing',
//           style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
//         ),
//         backgroundColor: Colors.grey[500],
//       ),
//       backgroundColor: Colors.grey[300],
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(12.0),
//           child: SingleChildScrollView(
//             child: Column(
//               children: [
//                 myInput(controller: start, hint: 'Enter Starting PostCode'),
//                 SizedBox(height: 15),
//                 myInput(controller: end, hint: 'Enter Ending PostCode'),
//                 SizedBox(height: 15),
//                 ElevatedButton(
//                   style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[500]),
//                   onPressed: () async {
//                     if (start.text.isEmpty) {
//                       // Nếu trường start rỗng, sử dụng vị trí hiện tại
//                       await _getCurrentLocation();
//                     }
//                     await _fetchRoute();
//                   },
//                   child: Text('Press'),
//                 ),
//                 SizedBox(height: 10),
//                 SizedBox(
//                   height: 500,
//                   width: 400,
//                   child: Stack(
//                     children: [
//                       Visibility(
//                         visible: isVisible,
//                         child: FlutterMap(
//                           options: MapOptions(
//                             center: routpoints[0],
//                             zoom: 8,
//                             onPositionChanged: (position, hasGesture) {},
//                           ),
//                           nonRotatedChildren: [
//                             AttributionWidget.defaultWidget(
//                               source: 'OpenStreetMap contributors',
//                               onSourceTapped: null,
//                             ),
//                           ],
//                           children: [
//                             TileLayer(
//                               urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
//                               userAgentPackageName: 'com.example.iseeapp2',
//                             ),
//                             PolylineLayer(
//                               polylineCulling: false,
//                               polylines: [
//                                 Polyline(points: routpoints, color: Colors.blue, strokeWidth: 9)
//                               ],
//                             ),
//                           ],
//                           mapController: mapController,
//                         ),
//                       ),
//                       Positioned(
//                         top: 20,
//                         right: 20,
//                         child: Column(
//                           children: [
//                             ElevatedButton(
//                               onPressed: () {
//                                 mapController.move(mapController.center, mapController.zoom + 1);
//                               },
//                               child: Icon(Icons.add),
//                             ),
//                             SizedBox(height: 10),
//                             ElevatedButton(
//                               onPressed: () {
//                                 mapController.move(mapController.center, mapController.zoom - 1);
//                               },
//                               child: Icon(Icons.remove),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Future<void> fetchData() async {
//     channel.stream.listen((message) {
//       setState(() {
//         Map<String, dynamic> data = json.decode(message);
//         latitude = data['latitude'];
//         longitude = data['longitude'];
//         end.text = '$latitude, $longitude';
//       });
//     });
//   }
//
//   Future<void> _requestLocationPermission() async {
//     // Kiểm tra xem đã có quyền truy cập vị trí chưa
//     if (await Permission.location.isDenied) {
//       // Nếu chưa, yêu cầu quyền truy cập
//       await Permission.location.request();
//     }
//   }
//
//   Future<void> _getCurrentLocation() async {
//     // Kiểm tra xem đã có quyền truy cập vị trí chưa
//     if (await Permission.location.isGranted) {
//       // Nếu đã có quyền, lấy vị trí hiện tại
//       Position position = await Geolocator.getCurrentPosition();
//       setState(() {
//         // start.text = '${position.latitude}, ${position.longitude}';
//       });
//     }
//   }
//
//
//   Future<void> _fetchRoute() async {
//     List<Location> start_l = await locationFromAddress(start.text);
//     List<Location> end_l = await locationFromAddress(end.text);
//
//     var v1 = start_l[0].latitude;
//     var v2 = start_l[0].longitude;
//     var v3 = end_l[0].latitude;
//     var v4 = end_l[0].longitude;
//
//     var url = Uri.parse(
//         'http://router.project-osrm.org/route/v1/driving/$v2,$v1;$v4,$v3?steps=true&annotations=true&geometries=geojson&overview=full');
//     var response = await http.get(url);
//
//     setState(() {
//       routpoints = [];
//       var ruter = jsonDecode(response.body)['routes'][0]['geometry']['coordinates'];
//       for (int i = 0; i < ruter.length; i++) {
//         var reep = ruter[i].toString();
//         reep = reep.replaceAll("[", "");
//         reep = reep.replaceAll("]", "");
//         var lat1 = reep.split(",");
//         var long1 = reep.split(",");
//
//         routpoints.add(LatLng(double.parse(lat1[1]), double.parse(long1[0])));
//       }
//       isVisible = !isVisible;
//     });
//   }
// }
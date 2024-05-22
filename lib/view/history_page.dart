// import 'dart:convert';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:web_socket_channel/io.dart';
// class HistoryPage extends StatefulWidget {
//   const HistoryPage({Key? key}) : super(key: key);
//
//   @override
//   _HistoryPageState createState() => _HistoryPageState();
// }
// class _HistoryPageState extends State<HistoryPage> {
//   // Khai báo các biến cần thiết
//   DateTime _selectedDate = DateTime.now();
//   List<LocationModel> _locations = [];
//   Map<LatLng, Marker> _markers = {};
//   GoogleMapController? _mapController;
//
//   // Hàm lấy dữ liệu vị trí từ database theo ngày
//   Future<void> _getLocationsForDate(DateTime date) async {
//     // Mở kết nối database (thay thế bằng code kết nối database của bạn)
//     final database = await databaseHelper.instance.database;
//
//     // Thực hiện truy vấn SQL để lấy dữ liệu vị trí theo ngày
//     final query = 'SELECT * FROM locations WHERE date = ?';
//     final arguments = [date.toString()];
//     final results = await database.query('locations', query: query, arguments: arguments);
//
//     // Chuyển đổi dữ liệu từ database sang List<LocationModel>
//     setState(() {
//       _locations = results.map((row) => LocationModel.fromMap(row)).toList();
//       _updateMapMarkers();
//     });
//   }
//
//   // Hàm cập nhật marker trên bản đồ
//   void _updateMapMarkers() {
//     _markers.clear();
//     for (final location in _locations) {
//       final latLng = LatLng(location.latitude, location.longitude);
//       if (!_markers.containsKey(latLng)) {
//         _markers[latLng] = Marker(
//           markerId: MarkerId(location.id.toString()),
//           position: latLng,
//         );
//       }
//     }
//     setState(() {});
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _getLocationsForDate(_selectedDate);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Lịch sử vị trí'),
//       ),
//       body: Column(
//         children: [
//           // DatePicker để chọn ngày
//           DatePicker(
//             initialDate: _selectedDate,
//             firstDate: DateTime(2000),
//             lastDate: DateTime.now(),
//             onDateChanged: (DateTime date) {
//               setState(() {
//                 _selectedDate = date;
//                 _getLocationsForDate(date);
//               });
//             },
//           ),
//
//           // Bản đồ hiển thị vị trí
//           Expanded(
//             child: GoogleMap(
//               initialCameraPosition: CameraPosition(
//                 target: LatLng(0, 0),
//                 zoom: 10,
//               ),
//               markers: Set.from(_markers.values),
//               mapType: MapType.normal,
//               onMapCreated: (GoogleMapController controller) {
//                 _mapController = controller;
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// ====================================================================================
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:web_socket_channel/io.dart';
import 'package:latlong2/latlong.dart';
import 'package:sqflite/sqflite.dart';

// Import database helper class
import '../Database/DatabaseLocation.dart';

// Replace with your actual API URL (if applicable)
final String apiUrl = 'http://192.168.43.96:3000/get_location';

// Connect to WebSocket server (replace with your server address)
final channel = IOWebSocketChannel.connect('ws://192.168.43.96:3000');

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final MapController mapController = MapController(); // Tạo MapController
  List<LatLng> _locations = [];
  final databaseHelper = DatabaseLocation(); // Create database helper instance

  @override
  void initState() {
    super.initState();
    _fetchDataFromDatabase(); // Fetch data from database on init
  }

  @override
  void dispose() {
    channel.sink.close(); // Close WebSocket connection
    super.dispose();
  }

  void _fetchDataFromDatabase() async {
    List<LocationRecord> locations = await databaseHelper.getLocations();
    setState(() {
      _locations = locations.map((location) => LatLng(location.latitude, location.longitude)).toList();
    });
  }

  // Additional methods for WebSocket handling (if applicable)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lịch sử vị trí'),
      ),
      body: Stack( // Stack to handle zoom buttons and map
        children: [
          FlutterMap(
            options: MapOptions(
              center: _locations.isNotEmpty ? _locations.first : LatLng(0, 0),
              zoom: 14, // Adjust zoom level as needed
            ),
            nonRotatedChildren: [
              AttributionWidget.defaultWidget(
                source: 'OpenStreetMap contributors',
                onSourceTapped: null,
              ),
            ],
            children: [
              TileLayer(
                urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.your_app',
              ),
              MarkerLayer(
                markers: _locations.isNotEmpty
                    ? _locations.map((location) => Marker(
                  point: location,
                  builder: (context) => const Icon(Icons.place),
                )).toList()
                    : [],
              ),
            ],
            mapController: mapController,
          ),
          Positioned( // Position zoom buttons
            top: 20,
            right: 20,
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () => mapController.move(mapController.center, mapController.zoom + 1),
                  child: const Icon(Icons.add),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => mapController.move(mapController.center, mapController.zoom - 1),
                  child: const Icon(Icons.remove),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


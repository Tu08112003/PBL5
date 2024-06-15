// import 'package:flutter/material.dart';
// import 'package:iseeapp2/camera/data_camera.dart';
// import 'package:iseeapp2/map_page/get_data_api.dart';
// import 'package:iseeapp2/map_page/get_device_location.dart';
// import 'package:iseeapp2/map_page/get_your_location.dart';
// import 'package:iseeapp2/map_page/map.dart';
// import 'camera/get_data.dart';
// import 'home_page.dart';
//
// void main(List<String> args) {
//   runApp(const MaterialApp(
//     debugShowCheckedModeBanner: false,
//     home: GetDeviceLocation(), // Sử dụng HomePage làm trang chính
//   ));
// }
import 'package:flutter/material.dart';
import 'package:iseeapp2/map_page/map_demo.dart';
import 'package:iseeapp2/view/log_in.dart';

import 'camera/follow_camera.dart';

const _url = 'https://github.com/Lyokone/flutterlocation';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Location',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: const LogIn(),
      // home: const FollowCameraPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
// ==================================================================================================
// import 'dart:async';
// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
//
// void main() => runApp(MyApp());
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'ESP32-CAM Image Viewer',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: MyHomePage(),
//     );
//   }
// }
//
// class MyHomePage extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   String imageUrl = 'http://192.168.31.106/cam-lo.jpg'; // Your ESP32-CAM image URL
//
//   Future<Uint8List> getImage() async {
//     try {
//       final response = await http.get(Uri.parse(imageUrl));
//       if (response.statusCode == 200) {
//         return response.bodyBytes;
//       } else {
//         throw Exception('Failed to load image');
//       }
//     } catch (e) {
//       print('Error: $e');
//       rethrow;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('ESP32-CAM Image Viewer'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             FutureBuilder<Uint8List>(
//               future: getImage(),
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return CircularProgressIndicator();
//                 } else if (snapshot.hasError) {
//                   return Text('Error: ${snapshot.error}');
//                 } else {
//                   return Image.memory(
//                     snapshot.data!,
//                     width: 300,
//                     height: 300,
//                   );
//                 }
//               },
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 setState(() {}); // Refresh the image
//               },
//               child: Text('Refresh Image'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// ==========================================================================================================

// import 'package:flutter/material.dart';
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Location Demo',
//       home: MyHomePage(),
//     );
//   }
// }
//
// class MyHomePage extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   String currentLocation = 'HaNoi';
//   bool autoUpdateLocation = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Current Location'),
//       ),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               Text(
//                 'Current location',
//                 style: TextStyle(fontSize: 30),
//               ),
//               SizedBox(height: 20),
//               Text(
//                 currentLocation,
//                 style: TextStyle(fontSize: 20),
//               ),
//               SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: () {
//                   // Code to get location
//                   setState(() {
//                     currentLocation = 'New Location';
//                   });
//                 },
//                 child: Text('Get Location'),
//               ),
//               SizedBox(height: 20),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text('Update location automatically'),
//                   Switch(
//                     value: autoUpdateLocation,
//                     onChanged: (value) {
//                       setState(() {
//                         autoUpdateLocation = value;
//                       });
//                     },
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
// ==============================================================================================================
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }
//
// class _MyAppState extends State<MyApp> {
//   static const platform = const MethodChannel('locationChannel');
//
//   @override
//   void initState() {
//     super.initState();
//     _requestLocationUpdates();
//   }
//
//   Future<void> _requestLocationUpdates() async {
//     try {
//       await platform.invokeMethod('requestLocationUpdates');
//     } on PlatformException catch (e) {
//       print("Failed to request location updates: '${e.message}'.");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('Location Demo'),
//         ),
//         body: Center(
//           child: Text('Waiting for location updates...'),
//         ),
//       ),
//     );
//   }
// }


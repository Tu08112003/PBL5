// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:location/location.dart';
// Location location = new Location();
// bool _serviceEnabled = false; // Khởi tạo với giá trị mặc định là false
// PermissionStatus _permissionGranted = PermissionStatus.denied; // Khởi tạo với giá trị mặc định là denied
// LocationData? _locationData; // Khởi tạo với giá trị mặc định là null, dấu ? chỉ ra rằng biến này có thể trả về giá trị null
//
// //Create get location function
// Future<dynamic> getLocation() async{
//   _serviceEnabled = await location.serviceEnabled();
//   if(!_serviceEnabled) _serviceEnabled = await location.requestService();
//
//   _permissionGranted = await location.hasPermission();
//   if(_permissionGranted == PermissionStatus.denied){
//     _permissionGranted = await location.requestPermission();
//   }
//
//   _locationData = await location.getLocation();
// }
//
//
// class GetDeviceLocation extends StatefulWidget {
//   const GetDeviceLocation({super.key});
//   @override
//   _GetDeviceLocationState createState() => _GetDeviceLocationState();
// }
//
// class _GetDeviceLocationState extends State<GetDeviceLocation>{
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       height: double.infinity,
//       child: Center(
//         child: GestureDetector(
//           onTap: (){
//             getLocation().then((value) {
//               print(value);
//             });
//           },
//           child: Container(
//             width: 100,
//             height: 50,
//             color: Colors.blue,
//             child: Center(child: Text("Location", style: TextStyle(fontSize: 10))),
//           ),
//         ),
//       ),
//     );
//   }
// }
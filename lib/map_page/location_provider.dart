// import 'package:flutter/foundation.dart';
// import 'package:latlong2/latlong.dart';
// import 'package:location/location.dart';
//
// class LocationProvider with ChangeNotifier {
//   Location _location = Location();
//   Location get location => _location;
//
//   late LatLng _locationPosition;
//   LatLng get locationPosition => _locationPosition;
//
//   bool locationServiceActive = false;
//
//   LocationProvider() {
//     initialization();
//   }
//
//   initialization() async {
//     await getUserLocation();
//   }
//
//   getUserLocation() async {
//     bool _serviceEnabled;
//     PermissionStatus _permissionGranted;
//
//     _serviceEnabled = await _location.serviceEnabled();
//     if (!_serviceEnabled) {
//       _serviceEnabled = await _location.requestService();
//
//       if (!_serviceEnabled) {
//         return;
//       }
//     }
//
//     _permissionGranted = await _location.hasPermission();
//     if (_permissionGranted == PermissionStatus.denied) {
//       _permissionGranted = await _location.requestPermission();
//       if (_permissionGranted != PermissionStatus.granted) {
//         return;
//       }
//     }
//
//     _location.onLocationChanged.listen((LocationData currentLocation) {
//       _locationPosition = LatLng(
//           currentLocation.latitude!, // Sử dụng ! để khẳng định rằng latitude không null
//           currentLocation.longitude!, // Sử dụng ! để khẳng định rằng longitude không null
//       );
//       print(_locationPosition);
//       notifyListeners();
//     });
//
//     locationServiceActive = true;
//   }
// }

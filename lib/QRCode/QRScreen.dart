// // import 'package:flutter/material.dart';
// // import 'package:qr_code_scanner/qr_code_scanner.dart';
// //
// // class QRScannerScreen extends StatefulWidget {
// //   const QRScannerScreen({super.key});
// //   @override
// //   State<StatefulWidget> createState() => _QRScannerScreenState();
// // }
// //
// // class _QRScannerScreenState extends State<QRScannerScreen> {
// //   final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
// //   // late QRViewController controller;
// //   String qrText = '';
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('QR Scanner'),
// //       ),
// //       body: Column(
// //         children: <Widget>[
// //           Expanded(
// //             flex: 4,
// //             child: QRView(
// //               key: qrKey,
// //               onQRViewCreated: _onQRViewCreated,
// //             ),
// //           ),
// //           Expanded(
// //             flex: 1,
// //             child: Center(
// //               child: Text('Scanned QR Code: $qrText'),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   void _onQRViewCreated(QRViewController controller) {
// //     this.controller = controller;
// //     controller.scannedDataStream.listen((scanData) {
// //       setState(() {
// //         qrText = scanData.code;
// //       });
// //     });
// //   }
// //
// //   @override
// //   void dispose() {
// //     controller.dispose();
// //     super.dispose();
// //   }
// // }
// // ==================================================================
// // import 'package:flutter/material.dart';
// // import 'package:qr_code_scanner/qr_code_scanner.dart';
// //
// // class ScanQRCode extends StatefulWidget {
// //   @override
// //   _ScanQRCodeState createState() => _ScanQRCodeState();
// // }
// //
// // class _ScanQRCodeState extends State<ScanQRCode> {
// //   final GlobalKey<QrScannerController> _controller = GlobalKey();
// //   String result = 'No QR code scanned yet';
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('Scan QR Code'),
// //       ),
// //       body: Stack(
// //         children: [
// //           QrScanner(
// //             onScanResult: (code) => setState(() {
// //               result = code;
// //             }),
// //             controller: _controller,
// //           ),
// //           Center(
// //             child: Text(
// //               result,
// //               style: TextStyle(fontSize: 20.0),
// //             ),
// //           ),
// //           Positioned(
// //             bottom: 20,
// //             left: 20,
// //             child: ElevatedButton(
// //               onPressed: () {
// //                 final camera = _controller.currentState.camera;
// //                 if (camera != null) {
// //                   camera.stopRecording();
// //                   setState(() {});
// //                 }
// //               },
// //               child: Text('Stop Scanning'),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:qr_code_scanner/qr_code_scanner.dart';
//
// class QRScannerScreen extends StatefulWidget {
//   const QRScannerScreen({super.key});
//   @override
//   State<StatefulWidget> createState() => _QRScannerScreenState();
// }
//
// class _QRScannerScreenState extends State<QRScannerScreen> {
//   late CameraController _cameraController;
//   String _linkQR = '';
//
//   get status => null;
//
//   void _checkAndRequestPermissions() async {
//
//     if (status == PermissionStatus.denied ) {
//       final permissions = await ([Permission.camera]);
//       if (permissions.any((status) => status != PermissionStatus.granted)) {
//         // Handle permission denied scenario (e.g., show a warning)
//         return;
//       }
//     }
//
//     // Permission granted, proceed with camera access
//     _initCamera();
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _checkAndRequestPermissions(); // Request camera permissions
//   }
//
//   void _initCamera() async {
//     final cameras = await availableCameras();
//     final firstCamera = cameras.first;
//     _cameraController = CameraController(firstCamera, ResolutionPreset.medium);
//     await _cameraController.initialize();
//     setState(() {});
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Máy quét mã QR'),
//       ),
//       body: _cameraController.value.isInitialized
//           ? QRCodeScanner(
//         controller: barcodeScanner,
//         child: Stack(
//           alignment: Alignment.center,
//           children: [
//             // Optional: Add a transparent layer to cover the camera preview
//             Opacity(
//               opacity: 0.7,
//               child: Container(color: Colors.black),
//             ),
//             // QR code scanner viewfinder (optional customization)
//             DecoratedBox(
//               decoration: BoxDecoration(
//                 border: Border.all(color: Colors.red, width: 3),
//               ),
//               child: SizedBox(
//                 height: 250,
//                 width: 250,
//               ),
//             ),
//           ],
//         ),
//       )
//           : Center(child: CircularProgressIndicator()),
//       floatingActionButton: FloatingActionButton(
//         child: Icon(Icons.qr_code_scanner),
//         onPressed: () async {
//           try {
//             // final barcodeScanner = QRCodeScannerController(
//             //   context: context, // Truyền context
//             //   options: QRCodeScannerOptions(), // Tùy chọn cho trình quét (không bắt buộc)
//             // );
//             // barcodeScanner.scan().then((result) {
//             //   if (result != null) {
//             //     setState(() {
//             //       _linkQR = result.text; // Update the linkQR variable
//             //     });
//             //     // Handle the decoded QR code value (e.g., navigate to a URL)
//             //     print('QR Code: $_linkQR');
//             //   }
//             // });
//           } catch (e) {
//             print(e.toString());
//           }
//         },
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     _cameraController.dispose();
//   }
//
//   // @override
//   // Widget build(BuildContext context) {
//   //   // TODO: implement build
//   //   throw UnimplementedError();
//   // }
// }
//
//

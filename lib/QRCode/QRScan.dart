
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:iseeapp2/Database/DatabaseCane.dart';
import 'package:iseeapp2/Database/DatabaseUser.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'dart:io' show Platform;

import '../Database/DatabaseLocation.dart';
import '../session/SessionManager.dart';
import '../view/home_page.dart';
class QRScan extends StatefulWidget {
  const QRScan({super.key});
  @override
  State<StatefulWidget> createState() => _QRScanState();
}
class _QRScanState extends State<QRScan> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  String nickname= "";
  TextEditingController nicknameController = TextEditingController();
  final databaseCaneHelper = DatabaseCane();
  final databaseUserHelper = DatabaseUser();
  final databaseLocationHelper = DatabaseLocation();
  String _username = '';
  String password = '';
  late Future<List<int>> _idCaneFuture;
  @override
  void initState() {
    super.initState();
    _loadSession();
    print("==================vo QR Scan roi ne, username = " + _username);

  }
  _loadSession() async {
    String? username = await SessionManager.getSession('username');
    print("==================vo Home page roi ne, username = " + _username + '------------------' + username!);
    setState(() {
      _username = username ?? '';

      _idCaneFuture = databaseUserHelper.getIdCaneByUsername(_username);

      print("==================vo QR Scan roi ne, _idCaneFuture = " );
      // Kiểm tra kết quả của Future và xử lý nó
      // Kiểm tra kết quả của Future và xử lý nó
      _idCaneFuture.then((List<int> idCane) {
        if (idCane.isEmpty) {
          print('Danh sách idCane rỗng');
        } else {
          print('Danh sách idCane: $idCane');
        }
      }).catchError((error) {
        print('Có lỗi xảy ra: $error');
      });
    });
  }
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      // controller!.pauseCamera();
      controller?.flipCamera();
      controller!.resumeCamera();
      CameraFacing.back;
    } else if (Platform.isIOS) {
      // controller!.resumeCamera();
      controller!.pauseCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: const Color(0xFF0D5E37),),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'Thêm theo dõi',
          style: TextStyle(
            color: const Color(0xFF0D5E37),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 3,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              children: [
                Center(
                    child: Container(
                      margin: EdgeInsets.all(10), // Thêm margin 10 cho Text widget
                      child: (result != null)
                          ? Text(
                        // 'Barcode Type: ${describeEnum(result!.format)}   '
                        'IP Server: ${result!.code}',
                      )
                          : Text('Scan a code'),
                    ),
                ),
                if (result != null) ...[
                  Center(
                    child:
                      Row(
                        children: [
                          Container(
                            width: 200,
                            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                            child: TextField(
                              controller: nicknameController,
                              decoration: InputDecoration(hintText: "Enter nickname"),
                              style: TextStyle(
                                color: const Color(0xFF0D5E37),
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: const Color(0xFF0D5E37),
                            ),

                            child: Text('Thêm'),
                            onPressed: () async {
                              setState(() {
                                nickname = nicknameController.text;
                              });
                              if(nickname != ""){
                                print('Nickname: $nickname');

                                if(await databaseCaneHelper.isExistCane(_username,result!.code!)){
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: Colors.pink,
                                      content: Text('IPServer đã tồn tại'),
                                    ),
                                  );
                                }
                                else{
                                  print('Lưu csdl :' + result!.code! + "----" + nickname);
                                  // Thêm người dùng vào bảng "user" và lấy idCane trả về
                                  int idCane = await databaseCaneHelper.addCane(result!.code!, nickname);

                                  print('Lưu csdl user:' + _username + "----" + idCane.toString());
                                  // print('+++++++++++++++++++++++++++ idCaneFuture' + _idCaneFuture);
                                  List<int> idCanes = await _idCaneFuture;
                                  if (idCanes.isEmpty) {
                                    print("+++++ cập nhật ++++");
                                    await databaseUserHelper.updateUser(_username,null, null, idCane, null);
                                    _idCaneFuture = databaseUserHelper.getIdCaneByUsername(_username);
                                    _showSuccessSnackBar();



                                    print("----- add location cho ne");
                                    databaseLocationHelper.addLocationForExistServer(result!.code!, idCane);



                                    // Navigator.pop(context);
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(builder: (context) => HomePage()),
                                    );
                                  }
                                  else{

                                    password = (await databaseUserHelper.getPasswordByUsername(_username))!;
                                    print("+++++ thêm mới ++++ pass:" + password);
                                    await databaseUserHelper.addCaneOfUser(_username, password, idCane);
                                    _idCaneFuture = databaseUserHelper.getIdCaneByUsername(_username);



                                    print("----- add location cho ne1");
                                    databaseLocationHelper.addLocationForExistServer(result!.code!, idCane);



                                    _showSuccessSnackBar();
                                    // Navigator.pop(context);
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(builder: (context) => HomePage()),
                                    );
                                  }
                                }
                              }
                              else{
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: Colors.pink,
                                    content: Text('Hãy nhập tên gợi nhắc cho theo dõi này !'),
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                ],
              ],
            ),
          )
        ],
      ),
    );
  }
  void _showSuccessSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Thêm thành công!'),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.green,
      ),
    );
  }
  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;

      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }



}
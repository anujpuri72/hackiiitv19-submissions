import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:ui';
import 'package:flutter/rendering.dart';
import 'package:qrgen/Qr.dart';
import 'package:qrgen/main.dart';
import 'dart:convert';

class QrScreen extends StatefulWidget {
  @override
  _QrScreenState createState() => _QrScreenState();
}

class _QrScreenState extends State<QrScreen> {
  static const double _topSectionTopPadding = 50.0;
  static const double _topSectionBottomPadding = 20.0;
  GlobalKey globalKey = new GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('QR Code Generator')),
      body: _contentWidget(),
    );
  }

  _contentWidget() {
    print("-------------------");
    print(QR.jsonData);
    var data1 = json.decode(QR.jsonData);
    print(data1);
    var a = data1['phone'];
    print(a);

    // var dta1 = json.decode(QR.jsonData.toString());

    // print(dta1.body["phone"]);
    final bodyHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).viewInsets.bottom;
    return Container(
      color: const Color(0xFFFFFFFF),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
              top: _topSectionTopPadding,
              left: 20.0,
              right: 10.0,
              bottom: _topSectionBottomPadding,
            ),
            child: Container(),
          ),
          Expanded(
            child: Center(
              child: RepaintBoundary(
                key: globalKey,
                child: QrImage(
                  data: QR.jsonData.toString(),
                  size: 0.5 * bodyHeight,
                  // onError: (ex) {
                  //   print("[QR] ERROR - $ex");
                  //   setState(() {
                  //     _inputErrorText =
                  //         "Error! Maybe your input value is too long?";
                  //   });
                  // },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

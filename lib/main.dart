import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

void main() => runApp(MaterialApp(home: QRViewExample()));

class QRViewExample extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

  // In order to get hot reload to work we need to pause camera if mounted
  @override
  void reassemble() {
    super.reassemble();
    // if (Platform.isAndroid) {
    //   controller!.pauseCamera();
    // }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('QR Code Scanner')),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: (result != null)
                  ? Text('Data: ${result!.code}')
                  : Text('Scan a code'),
            ),
          )
        ],
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

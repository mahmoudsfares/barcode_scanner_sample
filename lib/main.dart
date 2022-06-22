import 'package:barcode_scanner_sample/barcode_scanner_view.dart';
import 'package:barcode_scanner_sample/camera_manager.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isBarcodeScannerOn = false;

  final CameraManager _cameraManager = CameraManager();

  Future<void> _initCamera() async {
    _cameraManager.cameras = await availableCameras();
  }

  @override
  Widget build(BuildContext context) {
    _initCamera();
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: <Widget>[
              const Text(
                'Scan QR Code',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              const Text(
                'Align QR code within the frame to scan',
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              Expanded(
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: isBarcodeScannerOn
                          ? Padding(
                              padding: const EdgeInsets.all(16),
                              child: BarcodeScannerView(
                                key: UniqueKey(),
                                cameraManager: _cameraManager,
                                onBarcodeDetected: (String qrCode) {
                                  if (isBarcodeScannerOn) {
                                    print(qrCode);
                                    setState((){isBarcodeScannerOn = false;});
                                  }
                                },
                              ),
                            )
                          : const Center(child: Text('press scan')),
                    ),
                    ElevatedButton(
                      child: const Text('scan'),
                      onPressed: () => setState((){isBarcodeScannerOn = true;}),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

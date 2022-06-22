import 'package:barcode_scanner_sample/barcode_scanner_view.dart';
import 'package:barcode_scanner_sample/camera_manager.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Barcode Scanner',
      debugShowCheckedModeBanner: false,
      initialRoute: '/home',
      getPages: <GetPage> [
        GetPage(
          name: '/home',
          page: () => HomeScreen(),
          binding: HomeBinding(),
        ),
      ],
    );
  }
}

class HomeBinding extends Bindings {
  @override
  Future<void> dependencies() async {
    CameraManager cameraManager = Get.put(CameraManager());
    cameraManager.cameras = await availableCameras();
  }
}

class HomeScreen extends GetView {

  final RxBool isBarcodeScannerOn = false.obs;
  final RxInt state = 1.obs;
  final CameraManager _cameraManager = Get.find();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Obx(
                  () {
                if(state.value == 1){
                  return Column(
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
                              child: Obx(() {
                                if (isBarcodeScannerOn.value) {
                                  return Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: BarcodeScannerView(
                                      key: UniqueKey(),
                                      cameraManager: _cameraManager,
                                      onBarcodeDetected: (String qrCode) {
                                        if (isBarcodeScannerOn.value) {
                                          print(qrCode);
                                          isBarcodeScannerOn.value = false;
                                        }
                                      },
                                    ),
                                  );
                                } else {
                                  return const Center(
                                    child: Text('press scan'),
                                  );
                                }
                              }),
                            ),
                            ElevatedButton(
                              child: const Text('scan'),
                              onPressed: () => isBarcodeScannerOn.value = true,
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              }
          ),
        ),
      ),
    );
  }
}


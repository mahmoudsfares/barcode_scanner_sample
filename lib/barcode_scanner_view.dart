import 'package:barcode_scanner_sample/camera_manager.dart';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:google_ml_kit/google_ml_kit.dart';

class BarcodeScannerView extends StatefulWidget {
  final CameraManager cameraManager;
  final Function(String barcode) onBarcodeDetected;

  const BarcodeScannerView(
      {Key? key, required this.cameraManager, required this.onBarcodeDetected,})
      : super(key: key);

  @override
  _BarcodeScannerViewState createState() => _BarcodeScannerViewState();
}

class _BarcodeScannerViewState extends State<BarcodeScannerView> {
  // BarcodeScanner barcodeScanner = GoogleMlKit.vision.barcodeScanner();

  bool isBusy = false;

  @override
  void dispose() {
    // barcodeScanner.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CameraWidget(
      // onImageFrameReady: null,
     cameraManager: widget.cameraManager,
      lensDirection: CameraLensDirection.back,
    );
  }

  // Future<void> processImage(InputImage inputImage) async {
  //   if (isBusy) return;
  //   isBusy = true;
  //   final List<Barcode> barcodes =
  //       await barcodeScanner.processImage(inputImage);
  //   if (barcodes.isNotEmpty && barcodes.first.value.displayValue != null) {
  //     widget.onBarcodeDetected(barcodes.first.value.displayValue!);
  //   }
  //   isBusy = false;
  //   if (mounted) {
  //     setState(() {});
  //   }
  // }
}


class CameraWidget extends StatefulWidget {
  const CameraWidget({
    Key? key,
    required this.cameraManager,
    // this.onImageFrameReady,
    required this.lensDirection,
    this.onCameraControllerReady,
  }) : super(key: key);

  // final Function(InputImage inputImage)? onImageFrameReady;
  final CameraLensDirection lensDirection;
  final CameraManager cameraManager;
  final Function()? onCameraControllerReady;

  @override
  _CameraWidgetState createState() => _CameraWidgetState();
}

class _CameraWidgetState extends State<CameraWidget>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  int _cameraIndex = -1;

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < widget.cameraManager.cameras.length; i++) {
      if (widget.cameraManager.cameras[i].lensDirection ==
          widget.lensDirection) {
        _cameraIndex = i;
        _startLiveFeed();
        break;
      }
    }
  }

  @override
  void dispose() {
    _stopLiveFeed();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // App state changed before we got the chance to initialize.
    if (widget.cameraManager.cameraController == null ||
        !widget.cameraManager.cameraController!.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      _stopLiveFeed();
    } else if (state == AppLifecycleState.resumed) {
      _startLiveFeed();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.cameraManager.cameraController?.value.isInitialized == false) {
      return const SizedBox();
    }
    return Container(
      child: _cameraIndex == -1 || widget.cameraManager.cameraController == null
          ? const Text(
        'Camera unavailable',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
      )
          : CameraPreview(widget.cameraManager.cameraController!),
    );
  }

  Future<void> _startLiveFeed() async {
    final CameraDescription camera = widget.cameraManager.cameras[_cameraIndex];
    widget.cameraManager.cameraController = CameraController(
      camera,
      ResolutionPreset.low,
      // app might crash when capturing in max resolution due to a bug:
      // https://github.com/flutter/flutter/issues/95499
      // https://github.com/flutter/flutter/issues/69874
      // kIsWeb ? ResolutionPreset.max : ResolutionPreset.low,
    );

    widget.cameraManager.cameraController!.addListener(() {
      if (widget.cameraManager.cameraController!.value.hasError) {
        if (kDebugMode) {
          print(widget.cameraManager.cameraController!.value.errorDescription);
        }
      }
    });

    try {
      widget.cameraManager.cameraController?.initialize().then((_) {
        if (!mounted) {
          return;
        }
        widget.cameraManager.cameraController
            ?.startImageStream(_processCameraImage);

        widget.onCameraControllerReady?.call();

        setState(() {});
      });
    } on CameraException catch (e) {
      if (kDebugMode) {
        print("Camera exception $e");
      }
    }
  }

  Future<void> _stopLiveFeed() async {
    try {
      await widget.cameraManager.cameraController?.stopImageStream();
      await widget.cameraManager.cameraController?.dispose();
    } catch (e) {
      if (kDebugMode) {
        print("Exception stopping camera live feed+ ${e.toString()}");
      }
    }
    widget.cameraManager.cameraController = null;
  }

  Future<void> _processCameraImage(CameraImage image) async {
    final WriteBuffer allBytes = WriteBuffer();
    for (final Plane plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final Uint8List bytes = allBytes.done().buffer.asUint8List();

    final Size imageSize =
    Size(image.width.toDouble(), image.height.toDouble());

    final CameraDescription camera = widget.cameraManager.cameras[_cameraIndex];
    // final InputImageRotation imageRotation =
    //     InputImageRotationMethods.fromRawValue(camera.sensorOrientation) ??
    //         InputImageRotation.Rotation_0deg;
    //
    // final InputImageFormat inputImageFormat =
    //     InputImageFormatMethods.fromRawValue(image.format.raw as int) ??
    //         InputImageFormat.NV21;
    //
    // final List<InputImagePlaneMetadata> planeData = image.planes.map(
    //       (Plane plane) {
    //     return InputImagePlaneMetadata(
    //       bytesPerRow: plane.bytesPerRow,
    //       height: plane.height,
    //       width: plane.width,
    //     );
    //   },
    // ).toList();
    //
    // final InputImageData inputImageData = InputImageData(
    //   size: imageSize,
    //   imageRotation: imageRotation,
    //   inputImageFormat: inputImageFormat,
    //   planeData: planeData,
    // );
    //
    // final InputImage inputImage =
    // InputImage.fromBytes(bytes: bytes, inputImageData: inputImageData);
    //
    // if (widget.onImageFrameReady != null) widget.onImageFrameReady!(inputImage);
  }
}

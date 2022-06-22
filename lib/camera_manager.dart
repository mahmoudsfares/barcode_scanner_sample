
import 'package:camera/camera.dart';

class CameraManager {
  List<CameraDescription> cameras = <CameraDescription>[];
  CameraController? cameraController;
  XFile? videoFile;
}

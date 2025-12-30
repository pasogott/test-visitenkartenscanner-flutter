import 'dart:io';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class CameraService {
  CameraController? _controller;
  List<CameraDescription> _cameras = [];
  bool _isInitialized = false;

  CameraController? get controller => _controller;
  bool get isInitialized => _isInitialized;

  Future<void> initialize({bool frontCamera = false}) async {
    _cameras = await availableCameras();
    if (_cameras.isEmpty) {
      throw Exception('Keine Kamera verfügbar');
    }

    final cameraIndex = frontCamera
        ? _cameras.indexWhere((c) => c.lensDirection == CameraLensDirection.front)
        : _cameras.indexWhere((c) => c.lensDirection == CameraLensDirection.back);

    final selectedCamera = cameraIndex != -1 ? _cameras[cameraIndex] : _cameras.first;

    _controller = CameraController(
      selectedCamera,
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    await _controller!.initialize();
    _isInitialized = true;
  }

  Future<void> switchCamera() async {
    if (_cameras.length < 2) return;

    final currentDirection = _controller?.description.lensDirection;
    final useFrontCamera = currentDirection != CameraLensDirection.front;

    await dispose();
    await initialize(frontCamera: useFrontCamera);
  }

  Future<String?> takePicture() async {
    if (_controller == null || !_controller!.value.isInitialized) {
      return null;
    }

    try {
      final XFile image = await _controller!.takePicture();
      final Directory appDir = await getApplicationDocumentsDirectory();
      final String fileName = 'card_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final String savedPath = path.join(appDir.path, 'cards', fileName);

      final Directory cardsDir = Directory(path.join(appDir.path, 'cards'));
      if (!await cardsDir.exists()) {
        await cardsDir.create(recursive: true);
      }

      await File(image.path).copy(savedPath);
      return savedPath;
    } catch (e) {
      return null;
    }
  }

  Future<void> dispose() async {
    await _controller?.dispose();
    _controller = null;
    _isInitialized = false;
  }
}

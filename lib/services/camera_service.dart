import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class CameraService {
  CameraController? _controller;
  List<CameraDescription> _cameras = [];
  bool _isInitialized = false;
  bool _isSimulator = false;

  CameraController? get controller => _controller;
  bool get isInitialized => _isInitialized;
  bool get isSimulator => _isSimulator;

  Future<void> initialize({bool frontCamera = false}) async {
    try {
      _cameras = await availableCameras();
    } catch (e) {
      _cameras = [];
    }

    // No cameras available = likely simulator
    if (_cameras.isEmpty) {
      _isSimulator = true;
      _isInitialized = true;
      return;
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
    if (_isSimulator) return;
    if (_cameras.length < 2) return;

    final currentDirection = _controller?.description.lensDirection;
    final useFrontCamera = currentDirection != CameraLensDirection.front;

    await dispose();
    await initialize(frontCamera: useFrontCamera);
  }

  Future<String?> takePicture() async {
    if (_isSimulator) {
      return _createMockImage();
    }

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

  Future<String?> _createMockImage() async {
    try {
      final Directory appDir = await getApplicationDocumentsDirectory();
      final String fileName = 'card_${DateTime.now().millisecondsSinceEpoch}.png';
      final String savedPath = path.join(appDir.path, 'cards', fileName);

      final Directory cardsDir = Directory(path.join(appDir.path, 'cards'));
      if (!await cardsDir.exists()) {
        await cardsDir.create(recursive: true);
      }

      // Create a simple placeholder image
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);
      final paint = Paint()..color = const Color(0xFFE0E0E0);
      canvas.drawRect(const Rect.fromLTWH(0, 0, 400, 250), paint);

      final borderPaint = Paint()
        ..color = const Color(0xFF9E9E9E)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;
      canvas.drawRect(const Rect.fromLTWH(0, 0, 400, 250), borderPaint);

      final textPainter = TextPainter(
        text: const TextSpan(
          text: 'Mock Business Card\n(Simulator)',
          style: TextStyle(color: Color(0xFF616161), fontSize: 24),
        ),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
      );
      textPainter.layout(maxWidth: 380);
      textPainter.paint(canvas, Offset(200 - textPainter.width / 2, 100));

      final picture = recorder.endRecording();
      final img = await picture.toImage(400, 250);
      final byteData = await img.toByteData(format: ui.ImageByteFormat.png);

      if (byteData != null) {
        await File(savedPath).writeAsBytes(byteData.buffer.asUint8List());
        return savedPath;
      }
      return null;
    } catch (e) {
      debugPrint('Mock image creation failed: $e');
      return null;
    }
  }

  Future<void> dispose() async {
    await _controller?.dispose();
    _controller = null;
    _isInitialized = false;
  }
}

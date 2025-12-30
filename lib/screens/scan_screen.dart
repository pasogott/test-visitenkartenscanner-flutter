import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../providers/scan_provider.dart';
import '../services/camera_service.dart';
import 'preview_screen.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> with WidgetsBindingObserver {
  final CameraService _cameraService = CameraService();
  bool _hasPermission = false;
  bool _isCapturing = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cameraService.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive) {
      _cameraService.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initializeCamera();
    }
  }

  Future<void> _initializeCamera() async {
    final scanProvider = context.read<ScanProvider>();
    final status = await Permission.camera.request();

    if (!mounted) return;

    if (status.isGranted) {
      setState(() => _hasPermission = true);

      try {
        final useFrontCamera = scanProvider.currentStep == ScanStep.selfie;
        await _cameraService.initialize(frontCamera: useFrontCamera);
        if (mounted) setState(() {});
      } catch (e) {
        if (mounted) {
          setState(() => _errorMessage = 'Kamera konnte nicht initialisiert werden');
        }
      }
    } else {
      setState(() {
        _hasPermission = false;
        _errorMessage = 'Kamera-Berechtigung erforderlich';
      });
    }
  }

  Future<void> _takePicture() async {
    if (_isCapturing) return;

    setState(() => _isCapturing = true);

    final path = await _cameraService.takePicture();

    if (path != null && mounted) {
      final scanProvider = context.read<ScanProvider>();

      switch (scanProvider.currentStep) {
        case ScanStep.front:
          scanProvider.setFrontImage(path);
          break;
        case ScanStep.back:
          scanProvider.setBackImage(path);
          break;
        case ScanStep.selfie:
          scanProvider.setSelfieImage(path);
          break;
        case ScanStep.preview:
          break;
      }

      if (scanProvider.currentStep == ScanStep.selfie) {
        await _cameraService.dispose();
        await _cameraService.initialize(frontCamera: true);
      }

      if (scanProvider.currentStep == ScanStep.preview) {
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const PreviewScreen()),
          );
        }
      }
    }

    setState(() => _isCapturing = false);
  }

  void _skip() {
    final scanProvider = context.read<ScanProvider>();

    if (scanProvider.currentStep == ScanStep.back) {
      scanProvider.skipBack();
      _cameraService.switchCamera();
    } else if (scanProvider.currentStep == ScanStep.selfie) {
      scanProvider.skipSelfie();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const PreviewScreen()),
      );
    }
    setState(() {});
  }

  void _cancel() {
    context.read<ScanProvider>().reset();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (_errorMessage != null) {
      return _buildErrorView();
    }

    if (!_hasPermission) {
      return _buildPermissionView();
    }

    if (!_cameraService.isInitialized) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }

    return _buildCameraView();
  }

  Widget _buildErrorView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 64),
          const SizedBox(height: 16),
          Text(
            _errorMessage!,
            style: const TextStyle(color: Colors.white, fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _cancel,
            child: const Text('Zurück'),
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.camera_alt, color: Colors.white54, size: 64),
          const SizedBox(height: 16),
          const Text(
            'Kamera-Berechtigung benötigt',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => openAppSettings(),
            child: const Text('Einstellungen öffnen'),
          ),
        ],
      ),
    );
  }

  Widget _buildCameraView() {
    return Consumer<ScanProvider>(
      builder: (context, scanProvider, child) {
        return Stack(
          fit: StackFit.expand,
          children: [
            CameraPreview(_cameraService.controller!),
            _buildOverlay(scanProvider),
            _buildTopBar(scanProvider),
            _buildBottomControls(scanProvider),
          ],
        );
      },
    );
  }

  Widget _buildOverlay(ScanProvider scanProvider) {
    final isSelfie = scanProvider.currentStep == ScanStep.selfie;

    return CustomPaint(
      painter: ScanOverlayPainter(isCircular: isSelfie),
    );
  }

  Widget _buildTopBar(ScanProvider scanProvider) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 28),
              onPressed: _cancel,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                scanProvider.stepLabel,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(width: 48),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomControls(ScanProvider scanProvider) {
    final canSkip = scanProvider.currentStep == ScanStep.back ||
        scanProvider.currentStep == ScanStep.selfie;

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            if (canSkip)
              TextButton(
                onPressed: _skip,
                child: const Text(
                  'Überspringen',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
              ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: _isCapturing ? null : _takePicture,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 4),
                ),
                child: Container(
                  margin: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _isCapturing ? Colors.grey : Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildProgressIndicator(scanProvider),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator(ScanProvider scanProvider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildDot(scanProvider.currentStep == ScanStep.front, scanProvider.hasFront),
        const SizedBox(width: 8),
        _buildDot(scanProvider.currentStep == ScanStep.back, scanProvider.hasBack),
        const SizedBox(width: 8),
        _buildDot(scanProvider.currentStep == ScanStep.selfie, scanProvider.hasSelfie),
      ],
    );
  }

  Widget _buildDot(bool isActive, bool isCompleted) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isCompleted
            ? Colors.green
            : isActive
                ? Colors.white
                : Colors.white38,
      ),
    );
  }
}

class ScanOverlayPainter extends CustomPainter {
  final bool isCircular;

  ScanOverlayPainter({this.isCircular = false});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black54
      ..style = PaintingStyle.fill;

    final path = Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    final centerX = size.width / 2;
    final centerY = size.height / 2;

    if (isCircular) {
      final radius = size.width * 0.35;
      path.addOval(Rect.fromCircle(center: Offset(centerX, centerY - 50), radius: radius));
    } else {
      final cardWidth = size.width * 0.85;
      final cardHeight = cardWidth * 0.6;
      final cardRect = RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(centerX, centerY), width: cardWidth, height: cardHeight),
        const Radius.circular(12),
      );
      path.addRRect(cardRect);
    }

    path.fillType = PathFillType.evenOdd;
    canvas.drawPath(path, paint);

    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    if (isCircular) {
      final radius = size.width * 0.35;
      canvas.drawCircle(Offset(centerX, centerY - 50), radius, borderPaint);
    } else {
      final cardWidth = size.width * 0.85;
      final cardHeight = cardWidth * 0.6;
      final cardRect = RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(centerX, centerY), width: cardWidth, height: cardHeight),
        const Radius.circular(12),
      );
      canvas.drawRRect(cardRect, borderPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

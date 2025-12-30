import 'dart:io';
import 'package:flutter/foundation.dart';

enum ScanStep { front, back, selfie, preview }

class ScanProvider extends ChangeNotifier {
  String? _frontImagePath;
  String? _backImagePath;
  String? _selfieImagePath;
  ScanStep _currentStep = ScanStep.front;

  String? get frontImagePath => _frontImagePath;
  String? get backImagePath => _backImagePath;
  String? get selfieImagePath => _selfieImagePath;
  ScanStep get currentStep => _currentStep;

  bool get hasFront => _frontImagePath != null;
  bool get hasBack => _backImagePath != null;
  bool get hasSelfie => _selfieImagePath != null;

  int get capturedCount {
    int count = 0;
    if (hasFront) count++;
    if (hasBack) count++;
    if (hasSelfie) count++;
    return count;
  }

  String get stepLabel {
    switch (_currentStep) {
      case ScanStep.front:
        return 'Vorderseite';
      case ScanStep.back:
        return 'Rückseite';
      case ScanStep.selfie:
        return 'Foto';
      case ScanStep.preview:
        return 'Vorschau';
    }
  }

  void setFrontImage(String path) {
    _frontImagePath = path;
    _currentStep = ScanStep.back;
    notifyListeners();
  }

  void setBackImage(String path) {
    _backImagePath = path;
    _currentStep = ScanStep.selfie;
    notifyListeners();
  }

  void setSelfieImage(String path) {
    _selfieImagePath = path;
    _currentStep = ScanStep.preview;
    notifyListeners();
  }

  void skipBack() {
    _currentStep = ScanStep.selfie;
    notifyListeners();
  }

  void skipSelfie() {
    _currentStep = ScanStep.preview;
    notifyListeners();
  }

  void retakeCurrentStep() {
    switch (_currentStep) {
      case ScanStep.back:
        _frontImagePath = null;
        _currentStep = ScanStep.front;
        break;
      case ScanStep.selfie:
        if (_backImagePath != null) {
          _deleteFile(_backImagePath!);
          _backImagePath = null;
          _currentStep = ScanStep.back;
        } else {
          _deleteFile(_frontImagePath!);
          _frontImagePath = null;
          _currentStep = ScanStep.front;
        }
        break;
      case ScanStep.preview:
        if (_selfieImagePath != null) {
          _deleteFile(_selfieImagePath!);
          _selfieImagePath = null;
          _currentStep = ScanStep.selfie;
        } else if (_backImagePath != null) {
          _deleteFile(_backImagePath!);
          _backImagePath = null;
          _currentStep = ScanStep.back;
        }
        break;
      default:
        break;
    }
    notifyListeners();
  }

  void reset() {
    if (_frontImagePath != null) _deleteFile(_frontImagePath!);
    if (_backImagePath != null) _deleteFile(_backImagePath!);
    if (_selfieImagePath != null) _deleteFile(_selfieImagePath!);

    _frontImagePath = null;
    _backImagePath = null;
    _selfieImagePath = null;
    _currentStep = ScanStep.front;
    notifyListeners();
  }

  void clearWithoutDelete() {
    _frontImagePath = null;
    _backImagePath = null;
    _selfieImagePath = null;
    _currentStep = ScanStep.front;
    notifyListeners();
  }

  void _deleteFile(String path) {
    try {
      final file = File(path);
      if (file.existsSync()) {
        file.deleteSync();
      }
    } catch (_) {}
  }
}

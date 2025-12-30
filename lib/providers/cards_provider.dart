import 'dart:io';
import 'package:flutter/foundation.dart';
import '../models/business_card.dart';
import '../services/database_service.dart';

class CardsProvider extends ChangeNotifier {
  final DatabaseService _databaseService;
  List<BusinessCard> _cards = [];
  bool _isLoading = false;

  CardsProvider(this._databaseService);

  List<BusinessCard> get cards => _cards;
  bool get isLoading => _isLoading;
  int get cardCount => _cards.length;

  Future<void> loadCards() async {
    _isLoading = true;
    notifyListeners();

    try {
      _cards = await _databaseService.getAllCards();
    } catch (e) {
      _cards = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<BusinessCard?> addCard({
    required String frontImagePath,
    String? backImagePath,
    String? selfieImagePath,
    String? notes,
  }) async {
    final card = BusinessCard(
      frontImagePath: frontImagePath,
      backImagePath: backImagePath,
      selfieImagePath: selfieImagePath,
      createdAt: DateTime.now(),
      notes: notes,
    );

    try {
      final id = await _databaseService.insertCard(card);
      final savedCard = card.copyWith(id: id);
      _cards.insert(0, savedCard);
      notifyListeners();
      return savedCard;
    } catch (e) {
      return null;
    }
  }

  Future<bool> deleteCard(int id) async {
    try {
      final card = _cards.firstWhere((c) => c.id == id);

      _deleteImageFile(card.frontImagePath);
      if (card.backImagePath != null) _deleteImageFile(card.backImagePath!);
      if (card.selfieImagePath != null) _deleteImageFile(card.selfieImagePath!);

      await _databaseService.deleteCard(id);
      _cards.removeWhere((c) => c.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateCardNotes(int id, String notes) async {
    try {
      final index = _cards.indexWhere((c) => c.id == id);
      if (index == -1) return false;

      final updatedCard = _cards[index].copyWith(notes: notes);
      await _databaseService.updateCard(updatedCard);
      _cards[index] = updatedCard;
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  void _deleteImageFile(String path) {
    try {
      final file = File(path);
      if (file.existsSync()) {
        file.deleteSync();
      }
    } catch (_) {}
  }
}

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/business_card.dart';
import '../providers/cards_provider.dart';

class CardDetailScreen extends StatefulWidget {
  final BusinessCard card;

  const CardDetailScreen({super.key, required this.card});

  @override
  State<CardDetailScreen> createState() => _CardDetailScreenState();
}

class _CardDetailScreenState extends State<CardDetailScreen> {
  late PageController _pageController;
  int _currentPage = 0;

  List<_ImagePage> get _pages {
    final pages = <_ImagePage>[];
    pages.add(_ImagePage('Vorderseite', widget.card.frontImagePath));
    if (widget.card.backImagePath != null) {
      pages.add(_ImagePage('Rückseite', widget.card.backImagePath!));
    }
    if (widget.card.selfieImagePath != null) {
      pages.add(_ImagePage('Foto', widget.card.selfieImagePath!));
    }
    return pages;
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(_pages[_currentPage].label),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _confirmDelete(context),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: _pages.length,
              onPageChanged: (index) {
                setState(() => _currentPage = index);
              },
              itemBuilder: (context, index) {
                return InteractiveViewer(
                  minScale: 0.5,
                  maxScale: 4.0,
                  child: Center(
                    child: Image.file(
                      File(_pages[index].path),
                      fit: BoxFit.contain,
                    ),
                  ),
                );
              },
            ),
          ),
          if (_pages.length > 1) _buildPageIndicator(),
          _buildInfoBar(),
        ],
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(_pages.length, (index) {
          return GestureDetector(
            onTap: () {
              _pageController.animateToPage(
                index,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
            child: Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentPage == index ? Colors.white : Colors.white38,
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildInfoBar() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[900],
      ),
      child: SafeArea(
        child: Row(
          children: [
            const Icon(Icons.calendar_today, color: Colors.white54, size: 16),
            const SizedBox(width: 8),
            Text(
              _formatDate(widget.card.createdAt),
              style: const TextStyle(color: Colors.white70),
            ),
            const Spacer(),
            Text(
              '${_currentPage + 1} / ${_pages.length}',
              style: const TextStyle(color: Colors.white54),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mär', 'Apr', 'Mai', 'Jun',
      'Jul', 'Aug', 'Sep', 'Okt', 'Nov', 'Dez'
    ];
    return '${date.day}. ${months[date.month - 1]} ${date.year}, ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Visitenkarte löschen?'),
        content: const Text('Diese Aktion kann nicht rückgängig gemacht werden.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Abbrechen'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _deleteCard();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Löschen'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteCard() async {
    final cardsProvider = context.read<CardsProvider>();
    final success = await cardsProvider.deleteCard(widget.card.id!);

    if (success && mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Visitenkarte gelöscht'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }
}

class _ImagePage {
  final String label;
  final String path;

  _ImagePage(this.label, this.path);
}

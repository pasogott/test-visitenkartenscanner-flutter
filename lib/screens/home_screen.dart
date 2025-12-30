import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cards_provider.dart';
import '../models/business_card.dart';
import 'scan_screen.dart';
import 'card_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<CardsProvider>().loadCards();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Visitenkarten'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: Consumer<CardsProvider>(
        builder: (context, cardsProvider, child) {
          if (cardsProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (cardsProvider.cards.isEmpty) {
            return _buildEmptyState();
          }

          return _buildCardGrid(cardsProvider.cards);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _startScan(context),
        icon: const Icon(Icons.camera_alt),
        label: const Text('Scannen'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.credit_card_outlined,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 24),
            Text(
              'Noch keine Visitenkarten',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Tippe auf "Scannen" um deine erste Visitenkarte zu erfassen',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardGrid(List<BusinessCard> cards) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.0,
        ),
        itemCount: cards.length,
        padding: const EdgeInsets.only(bottom: 80),
        itemBuilder: (context, index) {
          return _buildCardTile(cards[index]);
        },
      ),
    );
  }

  Widget _buildCardTile(BusinessCard card) {
    return GestureDetector(
      onTap: () => _openCardDetail(card),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.file(
              File(card.frontImagePath),
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[300],
                  child: const Icon(Icons.broken_image, size: 40),
                );
              },
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.7),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Row(
                  children: [
                    if (card.backImagePath != null)
                      const Icon(Icons.flip, color: Colors.white70, size: 16),
                    if (card.selfieImagePath != null) ...[
                      const SizedBox(width: 4),
                      const Icon(Icons.person, color: Colors.white70, size: 16),
                    ],
                    const Spacer(),
                    Text(
                      _formatDate(card.createdAt),
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}.${date.month}.${date.year}';
  }

  void _startScan(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const ScanScreen()),
    );
  }

  void _openCardDetail(BusinessCard card) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => CardDetailScreen(card: card)),
    );
  }
}

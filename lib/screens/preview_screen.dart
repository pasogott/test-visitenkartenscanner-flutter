import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/scan_provider.dart';
import '../providers/cards_provider.dart';

class PreviewScreen extends StatelessWidget {
  const PreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Vorschau'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => _cancel(context),
        ),
      ),
      body: Consumer<ScanProvider>(
        builder: (context, scanProvider, child) {
          return Column(
            children: [
              Expanded(
                child: _buildImageGrid(scanProvider),
              ),
              _buildBottomActions(context, scanProvider),
            ],
          );
        },
      ),
    );
  }

  Widget _buildImageGrid(ScanProvider scanProvider) {
    final images = <_ImageData>[];

    if (scanProvider.frontImagePath != null) {
      images.add(_ImageData('Vorderseite', scanProvider.frontImagePath!));
    }
    if (scanProvider.backImagePath != null) {
      images.add(_ImageData('Rückseite', scanProvider.backImagePath!));
    }
    if (scanProvider.selfieImagePath != null) {
      images.add(_ImageData('Foto', scanProvider.selfieImagePath!));
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.8,
        ),
        itemCount: images.length,
        itemBuilder: (context, index) {
          return _buildImageCard(images[index]);
        },
      ),
    );
  }

  Widget _buildImageCard(_ImageData imageData) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Image.file(
              File(imageData.path),
              fit: BoxFit.cover,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            color: Colors.white,
            child: Text(
              imageData.label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActions(BuildContext context, ScanProvider scanProvider) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _cancel(context),
                icon: const Icon(Icons.delete_outline),
                label: const Text('Verwerfen'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: ElevatedButton.icon(
                onPressed: () => _save(context, scanProvider),
                icon: const Icon(Icons.check),
                label: const Text('Speichern'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _cancel(BuildContext context) {
    context.read<ScanProvider>().reset();
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  Future<void> _save(BuildContext context, ScanProvider scanProvider) async {
    final cardsProvider = context.read<CardsProvider>();

    final card = await cardsProvider.addCard(
      frontImagePath: scanProvider.frontImagePath!,
      backImagePath: scanProvider.backImagePath,
      selfieImagePath: scanProvider.selfieImagePath,
    );

    if (card != null && context.mounted) {
      scanProvider.clearWithoutDelete();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Visitenkarte gespeichert'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }
}

class _ImageData {
  final String label;
  final String path;

  _ImageData(this.label, this.path);
}

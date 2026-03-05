import 'package:flutter/material.dart';
import '../models/qr_scan_model.dart';
import '../services/mock_data_service.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';
import '../widgets/scan_history_item.dart';
import 'scan_detail_screen.dart';

/// Favorites Screen - Menampilkan daftar scan yang difavoritkan
class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final MockDataService _dataService = MockDataService();
  List<QRScanModel> _favorites = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
    _dataService.addListener(_onDataChanged);
  }

  @override
  void dispose() {
    _dataService.removeListener(_onDataChanged);
    super.dispose();
  }

  void _onDataChanged(List<QRScanModel> scans) {
    if (mounted) {
      _loadFavorites();
    }
  }

  Future<void> _loadFavorites() async {
    setState(() => _isLoading = true);
    
    try {
      final favorites = await _dataService.getFavoriteScans();
      if (mounted) {
        setState(() {
          _favorites = favorites;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _toggleFavorite(String id) async {
    await _dataService.toggleFavorite(id);
    // Data akan di-refresh otomatis via listener
  }

  Future<void> _deleteScan(String id) async {
    final confirmed = await Helpers.showConfirmDialog(
      context,
      title: 'Remove from Favorites',
      message: 'Are you sure you want to remove this from favorites?',
      confirmText: 'Remove',
      confirmColor: AppColors.error,
    );

    if (confirmed) {
      await _dataService.toggleFavorite(id);
    }
  }

  Future<void> _clearAllFavorites() async {
    if (_favorites.isEmpty) return;

    final confirmed = await Helpers.showConfirmDialog(
      context,
      title: 'Clear All Favorites',
      message: 'Are you sure you want to remove all items from favorites?',
      confirmText: 'Clear All',
      confirmColor: AppColors.error,
    );

    if (confirmed) {
      setState(() => _isLoading = true);
      
      // Toggle favorite untuk semua item
      for (final scan in _favorites) {
        await _dataService.toggleFavorite(scan.id);
      }
      
      if (mounted) {
        Helpers.showSnackBar(context, 'All favorites cleared');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Favorites'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (_favorites.isNotEmpty)
            IconButton(
              onPressed: _clearAllFavorites,
              icon: const Icon(Icons.delete_sweep),
              tooltip: 'Clear All',
            ),
        ],
      ),
      body: _isLoading
          ? const ScanHistoryShimmer()
          : _favorites.isEmpty
              ? EmptyScanHistory(
                  icon: Icons.favorite_border,
                  title: 'No favorites yet',
                  subtitle: 'Mark scans as favorite to see them here',
                )
              : RefreshIndicator(
                  onRefresh: _loadFavorites,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                    itemCount: _favorites.length,
                    itemBuilder: (context, index) {
                      final scan = _favorites[index];
                      return ScanHistoryItem(
                        scan: scan,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ScanDetailScreen(scan: scan),
                            ),
                          );
                        },
                        onFavoriteToggle: () => _toggleFavorite(scan.id),
                        onDelete: () => _deleteScan(scan.id),
                        showDivider: index < _favorites.length - 1,
                      );
                    },
                  ),
                ),
    );
  }
}

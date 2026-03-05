import 'package:flutter/material.dart';
import '../models/qr_scan_model.dart';
import '../services/mock_data_service.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';
import '../widgets/scan_history_item.dart';
import 'scanner_screen.dart';
import 'scan_detail_screen.dart';
import 'favorites_screen.dart';

/// Home Screen - Halaman utama aplikasi
/// Menampilkan daftar riwayat scan dan tombol untuk scan baru
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final MockDataService _dataService = MockDataService();
  List<QRScanModel> _scans = [];
  bool _isLoading = true;
  String? _searchQuery;

  @override
  void initState() {
    super.initState();
    _loadData();
    
    // Listen untuk perubahan data
    _dataService.addListener(_onDataChanged);
  }

  @override
  void dispose() {
    _dataService.removeListener(_onDataChanged);
    super.dispose();
  }

  void _onDataChanged(List<QRScanModel> scans) {
    if (mounted) {
      setState(() {
        _scans = scans;
      });
    }
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    
    try {
      final scans = await _dataService.getScanHistory();
      if (mounted) {
        setState(() {
          _scans = scans;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        Helpers.showSnackBar(context, 'Failed to load data');
      }
    }
  }

  Future<void> _toggleFavorite(String id) async {
    final newStatus = await _dataService.toggleFavorite(id);
    if (mounted) {
      Helpers.showSnackBar(
        context,
        newStatus ? 'Added to favorites' : 'Removed from favorites',
      );
    }
  }

  Future<void> _deleteScan(String id) async {
    final confirmed = await Helpers.showConfirmDialog(
      context,
      title: 'Delete Scan',
      message: 'Are you sure you want to delete this scan?',
      confirmText: 'Delete',
      confirmColor: AppColors.error,
    );

    if (confirmed) {
      final success = await _dataService.deleteScan(id);
      if (mounted && success) {
        Helpers.showSnackBar(context, 'Scan deleted');
      }
    }
  }

  Future<void> _navigateToScanner() async {
    final result = await Navigator.push<QRScanModel>(
      context,
      MaterialPageRoute(
        builder: (context) => const ScannerScreen(),
      ),
    );

    if (result != null && mounted) {
      // Navigate ke detail screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ScanDetailScreen(scan: result),
        ),
      );
    }
  }

  void _navigateToFavorites() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const FavoritesScreen(),
      ),
    );
  }

  Future<void> _searchScans(String query) async {
    if (query.isEmpty) {
      _loadData();
      return;
    }

    setState(() => _isLoading = true);
    
    try {
      final results = await _dataService.searchScans(query);
      if (mounted) {
        setState(() {
          _scans = results;
          _isLoading = false;
          _searchQuery = query;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            expandedHeight: 120,
            floating: true,
            pinned: true,
            backgroundColor: AppColors.primary,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                AppConstants.appName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: AppColors.primaryGradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                onPressed: _navigateToFavorites,
                icon: const Icon(Icons.favorite),
                tooltip: 'Favorites',
              ),
              IconButton(
                onPressed: () {
                  // Show info dialog
                  showAboutDialog(
                    context: context,
                    applicationName: AppConstants.appName,
                    applicationVersion: AppConstants.appVersion,
                  );
                },
                icon: const Icon(Icons.info_outline),
                tooltip: 'About',
              ),
            ],
          ),

          // Search Bar
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: TextField(
                onChanged: _searchScans,
                decoration: InputDecoration(
                  hintText: 'Search scans...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchQuery != null
                      ? IconButton(
                          onPressed: () {
                            _searchQuery = null;
                            _loadData();
                          },
                          icon: const Icon(Icons.clear),
                        )
                      : null,
                  filled: true,
                  fillColor: AppColors.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                    borderSide: const BorderSide(
                      color: AppColors.primary,
                      width: 2,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Stats Cards
          SliverToBoxAdapter(
            child: _buildStatsSection(),
          ),

          // Section Title
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.lg,
                AppSpacing.md,
                AppSpacing.sm,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recent Scans',
                    style: AppTypography.h4,
                  ),
                  if (_scans.isNotEmpty)
                    TextButton(
                      onPressed: () {
                        // Show all scans (could navigate to separate screen)
                      },
                      child: const Text('See All'),
                    ),
                ],
              ),
            ),
          ),

          // Scan List
          _isLoading
              ? const SliverFillRemaining(
                  child: ScanHistoryShimmer(),
                )
              : _scans.isEmpty
                  ? SliverFillRemaining(
                      child: EmptyScanHistory(
                        onAction: _navigateToScanner,
                        actionLabel: 'Scan QR Code',
                      ),
                    )
                  : SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final scan = _scans[index];
                          return ScanHistoryItem(
                            scan: scan,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ScanDetailScreen(scan: scan),
                                ),
                              );
                            },
                            onFavoriteToggle: () => _toggleFavorite(scan.id),
                            onDelete: () => _deleteScan(scan.id),
                            showDivider: index < _scans.length - 1,
                          );
                        },
                        childCount: _scans.length,
                      ),
                    ),

          // Bottom padding
          const SliverToBoxAdapter(
            child: SizedBox(height: 100),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _navigateToScanner,
        backgroundColor: AppColors.secondary,
        icon: const Icon(Icons.qr_code_scanner),
        label: const Text('Scan'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildStatsSection() {
    return FutureBuilder<Map<String, dynamic>>(
      future: _dataService.getStatistics(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox.shrink();
        }

        final stats = snapshot.data!;
        final totalScans = stats['totalScans'] as int;
        final favoriteScans = stats['favoriteScans'] as int;
        final todayScans = stats['todayScans'] as int;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Row(
            children: [
              Expanded(
                child: _StatCard(
                  icon: Icons.qr_code,
                  value: totalScans.toString(),
                  label: 'Total',
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: _StatCard(
                  icon: Icons.favorite,
                  value: favoriteScans.toString(),
                  label: 'Favorites',
                  color: Colors.red,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: _StatCard(
                  icon: Icons.today,
                  value: todayScans.toString(),
                  label: 'Today',
                  color: AppColors.secondary,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Widget untuk stat card
class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        boxShadow: const [AppShadows.card],
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 28,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: AppTypography.h3.copyWith(
              color: color,
              fontSize: 24,
            ),
          ),
          Text(
            label,
            style: AppTypography.caption,
          ),
        ],
      ),
    );
  }
}

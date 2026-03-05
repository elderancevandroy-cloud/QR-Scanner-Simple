import 'package:flutter/material.dart';
import '../models/qr_scan_model.dart';
import '../services/mock_data_service.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';
import '../widgets/qr_type_badge.dart';

/// Scan Detail Screen - Menampilkan detail hasil scan QR Code
class ScanDetailScreen extends StatefulWidget {
  final QRScanModel scan;

  const ScanDetailScreen({
    super.key,
    required this.scan,
  });

  @override
  State<ScanDetailScreen> createState() => _ScanDetailScreenState();
}

class _ScanDetailScreenState extends State<ScanDetailScreen> {
  final MockDataService _dataService = MockDataService();
  late QRScanModel _scan;

  @override
  void initState() {
    super.initState();
    _scan = widget.scan;
  }

  Future<void> _toggleFavorite() async {
    final newStatus = await _dataService.toggleFavorite(_scan.id);
    setState(() {
      _scan = _scan.copyWith(isFavorite: newStatus);
    });
    if (mounted) {
      Helpers.showSnackBar(
        context,
        newStatus ? 'Added to favorites' : 'Removed from favorites',
      );
    }
  }

  Future<void> _deleteScan() async {
    final confirmed = await Helpers.showConfirmDialog(
      context,
      title: 'Delete Scan',
      message: 'Are you sure you want to delete this scan?',
      confirmText: 'Delete',
      confirmColor: AppColors.error,
    );

    if (confirmed) {
      final success = await _dataService.deleteScan(_scan.id);
      if (mounted && success) {
        Navigator.pop(context);
        Helpers.showSnackBar(context, 'Scan deleted');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final actions = Helpers.getActionsForType(_scan.type, _scan);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            backgroundColor: Color(_scan.type.colorValue),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(_scan.type.colorValue),
                      Color(_scan.type.colorValue).withOpacity(0.7),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 60),
                      Icon(
                        QRTypeColors.getIcon(_scan.type.name),
                        size: 64,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _scan.type.label,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                onPressed: _toggleFavorite,
                icon: Icon(
                  _scan.isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: _scan.isFavorite ? Colors.red : Colors.white,
                ),
              ),
              IconButton(
                onPressed: _deleteScan,
                icon: const Icon(
                  Icons.delete_outline,
                  color: Colors.white,
                ),
              ),
            ],
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title Card
                  _buildTitleCard(),
                  const SizedBox(height: AppSpacing.md),

                  // Content Card
                  _buildContentCard(),
                  const SizedBox(height: AppSpacing.md),

                  // Metadata Card (jika ada)
                  if (_scan.metadata != null) ...[
                    _buildMetadataCard(),
                    const SizedBox(height: AppSpacing.md),
                  ],

                  // Action Buttons
                  _buildActionButtons(actions),
                  const SizedBox(height: AppSpacing.md),

                  // Timestamp
                  Center(
                    child: Text(
                      'Scanned on ${Helpers.formatDateTime(_scan.timestamp)}',
                      style: AppTypography.caption,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitleCard() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Title',
              style: AppTypography.label,
            ),
            const SizedBox(height: 4),
            Text(
              _scan.title,
              style: AppTypography.h4,
            ),
            const SizedBox(height: AppSpacing.sm),
            QRTypeBadge(type: _scan.type),
          ],
        ),
      ),
    );
  }

  Widget _buildContentCard() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Content',
                  style: AppTypography.label,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () => Helpers.copyToClipboard(
                        context,
                        _scan.content,
                      ),
                      icon: const Icon(Icons.copy, size: 20),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 32,
                        minHeight: 32,
                      ),
                      tooltip: 'Copy',
                    ),
                    IconButton(
                      onPressed: () => Helpers.shareText(
                        _scan.content,
                        subject: _scan.title,
                      ),
                      icon: const Icon(Icons.share, size: 20),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 32,
                        minHeight: 32,
                      ),
                      tooltip: 'Share',
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 4),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              ),
              child: SelectableText(
                _scan.content,
                style: AppTypography.bodyMedium.copyWith(
                  fontFamily: 'monospace',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetadataCard() {
    final metadata = _scan.metadata!;
    
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Details',
              style: AppTypography.label,
            ),
            const SizedBox(height: AppSpacing.sm),
            ...metadata.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 100,
                      child: Text(
                        _formatKey(entry.key),
                        style: AppTypography.bodySmall.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        entry.value?.toString() ?? '-',
                        style: AppTypography.bodyMedium,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(List<QRAction> actions) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: AppSpacing.md),
          child: Text(
            'Actions',
            style: AppTypography.label,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: actions.map((action) {
            return _ActionChip(
              icon: action.icon,
              label: action.label,
              onTap: () => action.onTap(context),
            );
          }).toList(),
        ),
      ],
    );
  }

  String _formatKey(String key) {
    return key
        .replaceAllMapped(
          RegExp(r'[A-Z]'),
          (match) => ' ${match.group(0)}',
        )
        .capitalize();
  }
}

/// Widget untuk action chip
class _ActionChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionChip({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      avatar: Icon(icon, size: 18),
      label: Text(label),
      onPressed: onTap,
      backgroundColor: AppColors.surface,
      side: BorderSide(
        color: AppColors.primary.withOpacity(0.3),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 4,
      ),
    );
  }
}

/// Extension untuk capitalize string
extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}

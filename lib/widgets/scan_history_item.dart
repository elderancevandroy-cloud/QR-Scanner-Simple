import 'package:flutter/material.dart';
import '../models/qr_scan_model.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';
import 'qr_type_badge.dart';

/// Widget untuk menampilkan item scan history dalam list
class ScanHistoryItem extends StatelessWidget {
  final QRScanModel scan;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteToggle;
  final VoidCallback? onDelete;
  final bool showDivider;

  const ScanHistoryItem({
    super.key,
    required this.scan,
    this.onTap,
    this.onFavoriteToggle,
    this.onDelete,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            child: Row(
              children: [
                // Type Icon
                QRTypeIcon(
                  type: scan.type,
                  size: 48,
                ),
                const SizedBox(width: AppSpacing.md),
                
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        scan.title,
                        style: AppTypography.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      
                      // Content preview
                      Text(
                        Helpers.truncateText(scan.content, 40),
                        style: AppTypography.bodySmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      
                      // Type badge and timestamp
                      Row(
                        children: [
                          QRTypeBadge(
                            type: scan.type,
                            isSmall: true,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            Helpers.formatRelativeTime(scan.timestamp),
                            style: AppTypography.caption,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // Actions
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Favorite button
                    if (onFavoriteToggle != null)
                      IconButton(
                        onPressed: onFavoriteToggle,
                        icon: Icon(
                          scan.isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: scan.isFavorite
                              ? Colors.red
                              : AppColors.textHint,
                          size: 22,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(
                          minWidth: 36,
                          minHeight: 36,
                        ),
                      ),
                    
                    // Delete button
                    if (onDelete != null)
                      IconButton(
                        onPressed: onDelete,
                        icon: const Icon(
                          Icons.delete_outline,
                          color: AppColors.textHint,
                          size: 22,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(
                          minWidth: 36,
                          minHeight: 36,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            indent: 72,
            endIndent: AppSpacing.md,
            color: AppColors.textHint.withOpacity(0.2),
          ),
      ],
    );
  }
}

/// Widget untuk empty state
class EmptyScanHistory extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final IconData? icon;
  final VoidCallback? onAction;
  final String? actionLabel;

  const EmptyScanHistory({
    super.key,
    this.title,
    this.subtitle,
    this.icon,
    this.onAction,
    this.actionLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon ?? Icons.qr_code_scanner,
              size: 80,
              color: AppColors.textHint.withOpacity(0.5),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              title ?? 'No scans yet',
              style: AppTypography.h3.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              subtitle ?? 'Scan your first QR code to see it here',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textHint,
              ),
              textAlign: TextAlign.center,
            ),
            if (onAction != null && actionLabel != null) ...[
              const SizedBox(height: AppSpacing.lg),
              ElevatedButton.icon(
                onPressed: onAction,
                icon: const Icon(Icons.qr_code_scanner),
                label: Text(actionLabel!),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.md,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Widget untuk shimmer loading effect
class ScanHistoryShimmer extends StatelessWidget {
  final int itemCount;

  const ScanHistoryShimmer({
    super.key,
    this.itemCount = 5,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          child: Row(
            children: [
              // Shimmer icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              
              // Shimmer content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 16,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: 80,
                      height: 20,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

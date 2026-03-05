import 'package:flutter/material.dart';
import '../models/qr_scan_model.dart';
import '../utils/constants.dart';

/// Widget badge untuk menampilkan tipe QR Code
class QRTypeBadge extends StatelessWidget {
  final QRType type;
  final bool showLabel;
  final bool isSmall;

  const QRTypeBadge({
    super.key,
    required this.type,
    this.showLabel = true,
    this.isSmall = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = Color(type.colorValue);
    
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isSmall ? 8 : 12,
        vertical: isSmall ? 4 : 6,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getIconForType(type),
            size: isSmall ? 12 : 16,
            color: color,
          ),
          if (showLabel) ...[
            const SizedBox(width: 4),
            Text(
              type.label,
              style: TextStyle(
                fontSize: isSmall ? 10 : 12,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ],
      ),
    );
  }

  IconData _getIconForType(QRType type) {
    switch (type) {
      case QRType.url:
        return Icons.link;
      case QRType.wifi:
        return Icons.wifi;
      case QRType.contact:
        return Icons.contact_page;
      case QRType.email:
        return Icons.email;
      case QRType.sms:
        return Icons.sms;
      case QRType.location:
        return Icons.location_on;
      case QRType.text:
        return Icons.text_fields;
      case QRType.unknown:
        return Icons.help_outline;
    }
  }
}

/// Widget untuk icon QR Type yang lebih besar
class QRTypeIcon extends StatelessWidget {
  final QRType type;
  final double size;
  final bool showBackground;

  const QRTypeIcon({
    super.key,
    required this.type,
    this.size = 48,
    this.showBackground = true,
  });

  @override
  Widget build(BuildContext context) {
    final color = Color(type.colorValue);
    
    return Container(
      width: size,
      height: size,
      decoration: showBackground
          ? BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(size * 0.25),
            )
          : null,
      child: Icon(
        _getIconForType(type),
        size: size * 0.5,
        color: color,
      ),
    );
  }

  IconData _getIconForType(QRType type) {
    switch (type) {
      case QRType.url:
        return Icons.link;
      case QRType.wifi:
        return Icons.wifi;
      case QRType.contact:
        return Icons.contact_page;
      case QRType.email:
        return Icons.email;
      case QRType.sms:
        return Icons.sms;
      case QRType.location:
        return Icons.location_on;
      case QRType.text:
        return Icons.text_fields;
      case QRType.unknown:
        return Icons.help_outline;
    }
  }
}

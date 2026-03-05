import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:clipboard/clipboard.dart';
import '../models/qr_scan_model.dart';

/// Helper class untuk fungsi-fungsi umum aplikasi
class Helpers {
  
  /// Format DateTime ke string yang readable
  static String formatDateTime(DateTime dateTime, {bool includeTime = true}) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dateToCheck = DateTime(dateTime.year, dateTime.month, dateTime.day);

    String dateStr;
    if (dateToCheck == today) {
      dateStr = 'Today';
    } else if (dateToCheck == yesterday) {
      dateStr = 'Yesterday';
    } else if (now.difference(dateTime).inDays < 7) {
      dateStr = DateFormat('EEEE').format(dateTime); // Day name
    } else {
      dateStr = DateFormat('MMM d, y').format(dateTime);
    }

    if (includeTime) {
      final timeStr = DateFormat('HH:mm').format(dateTime);
      return '$dateStr at $timeStr';
    }
    return dateStr;
  }

  /// Format relative time (e.g., "2 hours ago")
  static String formatRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      final minutes = difference.inMinutes;
      return '$minutes minute${minutes > 1 ? 's' : ''} ago';
    } else if (difference.inHours < 24) {
      final hours = difference.inHours;
      return '$hours hour${hours > 1 ? 's' : ''} ago';
    } else if (difference.inDays < 7) {
      final days = difference.inDays;
      return '$days day${days > 1 ? 's' : ''} ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks week${weeks > 1 ? 's' : ''} ago';
    } else {
      return DateFormat('MMM d, y').format(dateTime);
    }
  }

  /// Copy text ke clipboard
  static Future<void> copyToClipboard(BuildContext context, String text) async {
    await FlutterClipboard.copy(text);
    if (context.mounted) {
      showSnackBar(context, 'Copied to clipboard');
    }
  }

  /// Share text
  static Future<void> shareText(String text, {String? subject}) async {
    await Share.share(text, subject: subject);
  }

  /// Launch URL
  static Future<bool> launchURL(String url) async {
    Uri uri;
    
    if (url.startsWith('http://') || url.startsWith('https://')) {
      uri = Uri.parse(url);
    } else {
      uri = Uri.parse('https://$url');
    }

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
      return true;
    }
    return false;
  }

  /// Launch email
  static Future<bool> launchEmail({
    required String to,
    String? subject,
    String? body,
  }) async {
    final uri = Uri(
      scheme: 'mailto',
      path: to,
      queryParameters: {
        if (subject != null) 'subject': subject,
        if (body != null) 'body': body,
      },
    );

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
      return true;
    }
    return false;
  }

  /// Launch SMS
  static Future<bool> launchSMS(String phone, {String? message}) async {
    final uri = Uri(
      scheme: 'sms',
      path: phone,
      queryParameters: message != null ? {'body': message} : null,
    );

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
      return true;
    }
    return false;
  }

  /// Launch phone dialer
  static Future<bool> launchPhone(String phone) async {
    final uri = Uri(scheme: 'tel', path: phone);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
      return true;
    }
    return false;
  }

  /// Launch maps dengan koordinat
  static Future<bool> launchMaps(double latitude, double longitude, {String? query}) async {
    // Try Google Maps first
    final googleMapsUrl = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude',
    );

    if (await canLaunchUrl(googleMapsUrl)) {
      await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication);
      return true;
    }

    // Fallback ke geo URI
    final geoUri = Uri.parse('geo:$latitude,$longitude?q=$latitude,$longitude');
    if (await canLaunchUrl(geoUri)) {
      await launchUrl(geoUri);
      return true;
    }

    return false;
  }

  /// Connect ke WiFi (Android only, memerlukan plugin tambahan)
  static Future<void> connectToWifi({
    required String ssid,
    String? password,
    String encryption = 'WPA',
  }) async {
    // Note: Untuk implementasi sebenarnya, gunakan plugin wifi_iot
    // Ini hanya placeholder untuk demonstrasi
    debugPrint('Connecting to WiFi: $ssid');
  }

  /// Save contact (memerlukan plugin contacts_service)
  static Future<void> saveContact({
    required String name,
    String? phone,
    String? email,
  }) async {
    // Note: Untuk implementasi sebenarnya, gunakan plugin contacts_service
    // Ini hanya placeholder untuk demonstrasi
    debugPrint('Saving contact: $name, $phone, $email');
  }

  /// Show snackbar
  static void showSnackBar(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 2),
    SnackBarAction? action,
    Color? backgroundColor,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration,
        action: action,
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  /// Show dialog konfirmasi
  static Future<bool> showConfirmDialog(
    BuildContext context, {
    required String title,
    required String message,
    String confirmText = 'Yes',
    String cancelText = 'No',
    Color? confirmColor,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(cancelText),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: confirmColor != null
                ? TextButton.styleFrom(foregroundColor: confirmColor)
                : null,
            child: Text(confirmText),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  /// Truncate text dengan ellipsis
  static String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }

  /// Validasi URL
  static bool isValidUrl(String url) {
    final urlPattern = RegExp(
      r'^https?://'
      r'(?:(?:[A-Z0-9](?:[A-Z0-9-]{0,61}[A-Z0-9])?\.)+[A-Z]{2,6}\.?|'
      r'localhost|'
      r'\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})'
      r'(?::\d+)?'
      r'(?:/?|[/?]\S+)$',
      caseSensitive: false,
    );
    return urlPattern.hasMatch(url);
  }

  /// Validasi email
  static bool isValidEmail(String email) {
    final emailPattern = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailPattern.hasMatch(email);
  }

  /// Get action buttons berdasarkan QR Type
  static List<QRAction> getActionsForType(QRType type, QRScanModel scan) {
    final List<QRAction> actions = [];

    switch (type) {
      case QRType.url:
        actions.add(QRAction(
          icon: Icons.open_in_browser,
          label: 'Open Link',
          onTap: () => launchURL(scan.content),
        ));
        break;

      case QRType.wifi:
        final wifiData = QRScanModel.parseWifiData(scan.content);
        if (wifiData != null) {
          actions.add(QRAction(
            icon: Icons.wifi,
            label: 'Connect',
            onTap: () => connectToWifi(
              ssid: wifiData['ssid']!,
              password: wifiData['password'],
              encryption: wifiData['type']!,
            ),
          ));
        }
        break;

      case QRType.contact:
        final contactData = QRScanModel.parseContactData(scan.content);
        if (contactData != null) {
          actions.add(QRAction(
            icon: Icons.person_add,
            label: 'Save Contact',
            onTap: () => saveContact(
              name: contactData['name']!,
              phone: contactData['phone'],
              email: contactData['email'],
            ),
          ));
          if (contactData['phone']?.isNotEmpty == true) {
            actions.add(QRAction(
              icon: Icons.phone,
              label: 'Call',
              onTap: () => launchPhone(contactData['phone']!),
            ));
          }
        }
        break;

      case QRType.email:
        final emailData = QRScanModel.parseEmailData(scan.content);
        if (emailData != null) {
          actions.add(QRAction(
            icon: Icons.email,
            label: 'Send Email',
            onTap: () => launchEmail(
              to: emailData['to']!,
              subject: emailData['subject'],
              body: emailData['body'],
            ),
          ));
        }
        break;

      case QRType.sms:
        final smsData = QRScanModel.parseSmsData(scan.content);
        if (smsData != null) {
          actions.add(QRAction(
            icon: Icons.sms,
            label: 'Send SMS',
            onTap: () => launchSMS(
              smsData['phone']!,
              message: smsData['message'],
            ),
          ));
        }
        break;

      case QRType.location:
        final locationData = QRScanModel.parseLocationData(scan.content);
        if (locationData != null) {
          actions.add(QRAction(
            icon: Icons.map,
            label: 'Open Maps',
            onTap: () => launchMaps(
              locationData['latitude'] as double,
              locationData['longitude'] as double,
              query: locationData['query'] as String?,
            ),
          ));
        }
        break;

      case QRType.text:
      case QRType.unknown:
        // No specific actions
        break;
    }

    // Always add copy and share
    actions.add(QRAction(
      icon: Icons.copy,
      label: 'Copy',
      onTap: (context) => copyToClipboard(context as BuildContext, scan.content),
    ));
    actions.add(QRAction(
      icon: Icons.share,
      label: 'Share',
      onTap: (_) => shareText(scan.content, subject: scan.title),
    ));

    return actions;
  }
}

/// Class untuk representasi action button
class QRAction {
  final IconData icon;
  final String label;
  final Function onTap;

  QRAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });
}

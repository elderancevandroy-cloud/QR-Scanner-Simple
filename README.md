# Flutter QR Scanner App - Dokumentasi Lengkap

Aplikasi QR Scanner sederhana berbasis Flutter dengan mock data (tanpa database). Dokumentasi ini menjelaskan langkah demi langkah cara membuat project ini dari nol.

## 📋 Daftar Isi

1. [Persiapan](#persiapan)
2. [Struktur Project](#struktur-project)
3. [Langkah 1: Inisialisasi Project](#langkah-1-inisialisasi-project)
4. [Langkah 2: Konfigurasi Dependencies](#langkah-2-konfigurasi-dependencies)
5. [Langkah 3: Membuat Mock Data](#langkah-3-membuat-mock-data)
6. [Langkah 4: Membuat Model](#langkah-4-membuat-model)
7. [Langkah 5: Membuat Service](#langkah-5-membuat-service)
8. [Langkah 6: Membuat Utilities](#langkah-6-membuat-utilities)
9. [Langkah 7: Membuat Widgets](#langkah-7-membuat-widgets)
10. [Langkah 8: Membuat Screens](#langkah-8-membuat-screens)
11. [Langkah 9: Konfigurasi Main](#langkah-9-konfigurasi-main)
12. [Langkah 10: Running Aplikasi](#langkah-10-running-aplikasi)
13. [Fitur Aplikasi](#fitur-aplikasi)
14. [Penjelasan Arsitektur](#penjelasan-arsitektur)

---

## Persiapan

### Prerequisites

Pastikan Anda sudah menginstall:
- **Flutter SDK** (versi 3.0.0 atau lebih baru)
- **Dart SDK** (sudah include dengan Flutter)
- **Android Studio** atau **VS Code** dengan Flutter extension
- **Android SDK** untuk testing di emulator/device Android
- **Xcode** (Mac only) untuk testing di iOS Simulator

### Cek Flutter Installation

```bash
flutter doctor
```

Pastikan semua checkmarks hijau (✓).

---

## Struktur Project

```
flutter_qr_scanner/
├── android/                 # Android-specific code
├── ios/                     # iOS-specific code
├── lib/                     # Main Dart code
│   ├── models/              # Data models
│   │   └── qr_scan_model.dart
│   ├── services/            # Business logic & data
│   │   └── mock_data_service.dart
│   ├── screens/             # UI screens
│   │   ├── home_screen.dart
│   │   ├── scanner_screen.dart
│   │   ├── scan_detail_screen.dart
│   │   └── favorites_screen.dart
│   ├── widgets/             # Reusable widgets
│   │   ├── qr_type_badge.dart
│   │   ├── scan_history_item.dart
│   │   └── scanner_overlay.dart
│   ├── utils/               # Utilities & constants
│   │   ├── constants.dart
│   │   └── helpers.dart
│   └── main.dart            # Entry point
├── assets/                  # Static assets
│   └── json/
│       └── mock_scan_history.json
├── pubspec.yaml             # Dependencies
├── analysis_options.yaml    # Lint rules
└── README.md                # This file
```

---

## Langkah 1: Inisialisasi Project

### 1.1 Buat Project Baru

Buka terminal dan jalankan:

```bash
# Navigate ke folder tempat Anda ingin membuat project
cd /path/to/your/projects

# Buat project Flutter baru
flutter create flutter_qr_scanner

# Masuk ke folder project
cd flutter_qr_scanner
```

### 1.2 Buka Project di IDE

```bash
# VS Code
code .

# Android Studio
studio .
```

### 1.3 Test Project Default

```bash
# Jalankan di emulator/device yang tersedia
flutter run
```

Jika berhasil, Anda akan melihat aplikasi counter default Flutter.

---

## Langkah 2: Konfigurasi Dependencies

### 2.1 Edit pubspec.yaml

Buka file `pubspec.yaml` dan ganti isinya dengan:

```yaml
name: flutter_qr_scanner
description: A simple QR Scanner Flutter application with mock data

publish_to: 'none'

version: 1.0.0+1

environment:
  sdk: '>=3.0.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  
  # QR Scanner
  mobile_scanner: ^3.5.5
  
  # State Management
  provider: ^6.1.1
  
  # Utilities
  intl: ^0.19.0
  share_plus: ^7.2.1
  url_launcher: ^6.2.2
  clipboard: ^0.1.3
  
  # UI Components
  cupertino_icons: ^1.0.6
  lottie: ^3.0.0
  shimmer: ^3.0.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.1

flutter:
  uses-material-design: true
  
  assets:
    - assets/json/
```

### 2.2 Install Dependencies

```bash
flutter pub get
```

### 2.3 Penjelasan Packages

| Package | Fungsi |
|---------|--------|
| `mobile_scanner` | QR Code scanning menggunakan kamera |
| `provider` | State management |
| `intl` | Format tanggal dan waktu |
| `share_plus` | Share konten ke aplikasi lain |
| `url_launcher` | Buka URL, email, phone, maps |
| `clipboard` | Copy ke clipboard |
| `shimmer` | Loading animation effect |

---

## Langkah 3: Membuat Mock Data

### 3.1 Buat Folder Assets

```bash
mkdir -p assets/json
```

### 3.2 Buat File Mock Data

Buat file `assets/json/mock_scan_history.json`:

```json
{
  "scan_history": [
    {
      "id": "scan_001",
      "content": "https://flutter.dev",
      "type": "url",
      "title": "Flutter - Build apps for any screen",
      "timestamp": "2024-01-15T10:30:00Z",
      "isFavorite": true,
      "metadata": {
        "description": "Flutter transforms the entire app development process.",
        "icon": "https://flutter.dev/images/flutter-logo-sharing.png"
      }
    },
    {
      "id": "scan_002",
      "content": "WIFI:S:MyHomeNetwork;T:WPA;P:password123;;",
      "type": "wifi",
      "title": "WiFi: MyHomeNetwork",
      "timestamp": "2024-01-15T09:15:00Z",
      "isFavorite": false,
      "metadata": {
        "ssid": "MyHomeNetwork",
        "password": "password123",
        "encryption": "WPA"
      }
    }
  ]
}
```

### 3.3 Register Assets di pubspec.yaml

Tambahkan di bagian `flutter:`:

```yaml
flutter:
  uses-material-design: true
  
  assets:
    - assets/json/
```

---

## Langkah 4: Membuat Model

### 4.1 Buat Folder Models

```bash
mkdir -p lib/models
```

### 4.2 Buat QR Scan Model

Buat file `lib/models/qr_scan_model.dart`:

```dart
import 'dart:convert';

/// Enum untuk tipe konten QR Code
enum QRType {
  url,
  wifi,
  contact,
  email,
  sms,
  location,
  text,
  unknown;

  String get label {
    switch (this) {
      case QRType.url:
        return 'Website URL';
      case QRType.wifi:
        return 'WiFi Network';
      case QRType.contact:
        return 'Contact Card';
      case QRType.email:
        return 'Email';
      case QRType.sms:
        return 'SMS';
      case QRType.location:
        return 'Location';
      case QRType.text:
        return 'Plain Text';
      case QRType.unknown:
        return 'Unknown';
    }
  }
}

/// Model class untuk data hasil scan QR Code
class QRScanModel {
  final String id;
  final String content;
  final QRType type;
  final String title;
  final DateTime timestamp;
  bool isFavorite;
  final Map<String, dynamic>? metadata;

  QRScanModel({
    required this.id,
    required this.content,
    required this.type,
    required this.title,
    required this.timestamp,
    this.isFavorite = false,
    this.metadata,
  });

  /// Factory constructor untuk membuat instance dari JSON
  factory QRScanModel.fromJson(Map<String, dynamic> json) {
    return QRScanModel(
      id: json['id'] as String,
      content: json['content'] as String,
      type: _parseQRType(json['type'] as String),
      title: json['title'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      isFavorite: json['isFavorite'] as bool? ?? false,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  /// Parse string tipe ke enum QRType
  static QRType _parseQRType(String type) {
    return QRType.values.firstWhere(
      (e) => e.name == type,
      orElse: () => QRType.unknown,
    );
  }

  /// Mendeteksi tipe QR Code dari konten
  static QRType detectType(String content) {
    content = content.trim();

    if (content.startsWith('http://') || content.startsWith('https://')) {
      return QRType.url;
    } else if (content.startsWith('WIFI:')) {
      return QRType.wifi;
    } else if (content.startsWith('BEGIN:VCARD')) {
      return QRType.contact;
    } else if (content.startsWith('MATMSG:') || content.startsWith('mailto:')) {
      return QRType.email;
    } else if (content.startsWith('SMSTO:') || content.startsWith('sms:')) {
      return QRType.sms;
    } else if (content.startsWith('geo:')) {
      return QRType.location;
    } else {
      return QRType.text;
    }
  }
}

/// Model untuk response scan history
class ScanHistoryResponse {
  final List<QRScanModel> scans;

  ScanHistoryResponse({required this.scans});

  factory ScanHistoryResponse.fromJson(Map<String, dynamic> json) {
    final scansList = (json['scan_history'] as List<dynamic>)
        .map((e) => QRScanModel.fromJson(e as Map<String, dynamic>))
        .toList();
    
    return ScanHistoryResponse(scans: scansList);
  }
}
```

---

## Langkah 5: Membuat Service

### 5.1 Buat Folder Services

```bash
mkdir -p lib/services
```

### 5.2 Buat Mock Data Service

Buat file `lib/services/mock_data_service.dart`:

```dart
import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import '../models/qr_scan_model.dart';

/// Service untuk mengelola mock data QR Scan
class MockDataService {
  static final MockDataService _instance = MockDataService._internal();
  
  factory MockDataService() => _instance;
  
  MockDataService._internal();

  List<QRScanModel>? _cachedScans;

  /// Load scan history dari mock JSON file
  Future<List<QRScanModel>> getScanHistory() async {
    if (_cachedScans != null) {
      return List.from(_cachedScans!);
    }

    try {
      final String jsonString = await rootBundle.loadString(
        'assets/json/mock_scan_history.json',
      );
      
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      final response = ScanHistoryResponse.fromJson(jsonData);
      
      response.scans.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      
      _cachedScans = response.scans;
      return List.from(_cachedScans!);
    } catch (e) {
      print('Error loading mock data: $e');
      return [];
    }
  }

  /// Toggle favorite status
  Future<bool> toggleFavorite(String id) async {
    if (_cachedScans == null) await getScanHistory();
    
    final index = _cachedScans!.indexWhere((scan) => scan.id == id);
    if (index != -1) {
      _cachedScans![index].isFavorite = !_cachedScans![index].isFavorite;
      return _cachedScans![index].isFavorite;
    }
    return false;
  }

  /// Simulasi scan QR baru
  Future<QRScanModel> addNewScan(String content) async {
    if (_cachedScans == null) await getScanHistory();

    final type = QRScanModel.detectType(content);
    final title = 'Scanned ${type.label}';

    final newScan = QRScanModel(
      id: 'scan_${DateTime.now().millisecondsSinceEpoch}',
      content: content,
      type: type,
      title: title,
      timestamp: DateTime.now(),
      isFavorite: false,
    );

    _cachedScans!.insert(0, newScan);
    
    await Future.delayed(const Duration(milliseconds: 300));
    
    return newScan;
  }

  /// Delete scan dari history
  Future<bool> deleteScan(String id) async {
    if (_cachedScans == null) await getScanHistory();
    
    final initialLength = _cachedScans!.length;
    _cachedScans!.removeWhere((scan) => scan.id == id);
    
    return _cachedScans!.length < initialLength;
  }

  /// Get scan yang difavoritkan
  Future<List<QRScanModel>> getFavoriteScans() async {
    final scans = await getScanHistory();
    return scans.where((scan) => scan.isFavorite).toList();
  }
}
```

---

## Langkah 6: Membuat Utilities

### 6.1 Buat Folder Utils

```bash
mkdir -p lib/utils
```

### 6.2 Buat Constants

Buat file `lib/utils/constants.dart`:

```dart
import 'package:flutter/material.dart';

/// Konstanta aplikasi QR Scanner
class AppConstants {
  static const String appName = 'QR Scanner Pro';
  static const String appVersion = '1.0.0';
  
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
}

/// Warna aplikasi
class AppColors {
  static const Color primary = Color(0xFF6C63FF);
  static const Color secondary = Color(0xFF00BFA6);
  static const Color background = Color(0xFFF8F9FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF2D3436);
  static const Color textSecondary = Color(0xFF636E72);
  static const Color success = Color(0xFF00B894);
  static const Color warning = Color(0xFFFDCB6E);
  static const Color error = Color(0xFFFF7675);
}

/// Typography aplikasi
class AppTypography {
  static const String fontFamily = 'Poppins';

  static const TextStyle h1 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const TextStyle h2 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
  );
}

/// Spacing
class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
}
```

### 6.3 Buat Helpers

Buat file `lib/utils/helpers.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:clipboard/clipboard.dart';

/// Helper class untuk fungsi-fungsi umum
class Helpers {
  
  /// Format DateTime ke string yang readable
  static String formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dateToCheck = DateTime(dateTime.year, dateTime.month, dateTime.day);

    String dateStr;
    if (dateToCheck == today) {
      dateStr = 'Today';
    } else if (dateToCheck == yesterday) {
      dateStr = 'Yesterday';
    } else {
      dateStr = DateFormat('MMM d, y').format(dateTime);
    }

    final timeStr = DateFormat('HH:mm').format(dateTime);
    return '$dateStr at $timeStr';
  }

  /// Format relative time
  static String formatRelativeTime(DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
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
    Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
      return true;
    }
    return false;
  }

  /// Show snackbar
  static void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  /// Show confirm dialog
  static Future<bool> showConfirmDialog(
    BuildContext context, {
    required String title,
    required String message,
    String confirmText = 'Yes',
    String cancelText = 'No',
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(cancelText),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(confirmText),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  /// Truncate text
  static String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }
}
```

---

## Langkah 7: Membuat Widgets

### 7.1 Buat Folder Widgets

```bash
mkdir -p lib/widgets
```

### 7.2 Buat QR Type Badge Widget

Buat file `lib/widgets/qr_type_badge.dart`:

```dart
import 'package:flutter/material.dart';
import '../models/qr_scan_model.dart';
import '../utils/constants.dart';

/// Widget badge untuk menampilkan tipe QR Code
class QRTypeBadge extends StatelessWidget {
  final QRType type;
  final bool showLabel;

  const QRTypeBadge({
    super.key,
    required this.type,
    this.showLabel = true,
  });

  @override
  Widget build(BuildContext context) {
    final color = _getColorForType(type);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_getIconForType(type), size: 16, color: color),
          if (showLabel) ...[
            const SizedBox(width: 4),
            Text(
              type.label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _getColorForType(QRType type) {
    switch (type) {
      case QRType.url:
        return Colors.blue;
      case QRType.wifi:
        return Colors.green;
      case QRType.contact:
        return Colors.purple;
      case QRType.email:
        return Colors.orange;
      case QRType.sms:
        return Colors.cyan;
      case QRType.location:
        return Colors.pink;
      case QRType.text:
        return Colors.grey;
      default:
        return Colors.grey;
    }
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
      default:
        return Icons.help_outline;
    }
  }
}
```

### 7.3 Buat Scan History Item Widget

Buat file `lib/widgets/scan_history_item.dart`:

```dart
import 'package:flutter/material.dart';
import '../models/qr_scan_model.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';
import 'qr_type_badge.dart';

/// Widget untuk menampilkan item scan history
class ScanHistoryItem extends StatelessWidget {
  final QRScanModel scan;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteToggle;
  final VoidCallback? onDelete;

  const ScanHistoryItem({
    super.key,
    required this.scan,
    this.onTap,
    this.onFavoriteToggle,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            // Type Icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: _getColorForType(scan.type).withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _getIconForType(scan.type),
                color: _getColorForType(scan.type),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    scan.title,
                    style: AppTypography.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    Helpers.truncateText(scan.content, 40),
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      QRTypeBadge(type: scan.type, showLabel: false),
                      const SizedBox(width: 8),
                      Text(
                        Helpers.formatRelativeTime(scan.timestamp),
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
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
                IconButton(
                  onPressed: onFavoriteToggle,
                  icon: Icon(
                    scan.isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: scan.isFavorite ? Colors.red : AppColors.textSecondary,
                    size: 22,
                  ),
                ),
                IconButton(
                  onPressed: onDelete,
                  icon: const Icon(
                    Icons.delete_outline,
                    color: AppColors.textSecondary,
                    size: 22,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getColorForType(QRType type) {
    switch (type) {
      case QRType.url:
        return Colors.blue;
      case QRType.wifi:
        return Colors.green;
      case QRType.contact:
        return Colors.purple;
      case QRType.email:
        return Colors.orange;
      case QRType.sms:
        return Colors.cyan;
      case QRType.location:
        return Colors.pink;
      case QRType.text:
        return Colors.grey;
      default:
        return Colors.grey;
    }
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
      default:
        return Icons.help_outline;
    }
  }
}

/// Widget untuk empty state
class EmptyScanHistory extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final VoidCallback? onAction;
  final String? actionLabel;

  const EmptyScanHistory({
    super.key,
    this.title,
    this.subtitle,
    this.onAction,
    this.actionLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.qr_code_scanner,
            size: 80,
            color: AppColors.textSecondary,
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            title ?? 'No scans yet',
            style: AppTypography.h3,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            subtitle ?? 'Scan your first QR code to see it here',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          if (onAction != null && actionLabel != null) ...[
            const SizedBox(height: AppSpacing.lg),
            ElevatedButton.icon(
              onPressed: onAction,
              icon: const Icon(Icons.qr_code_scanner),
              label: Text(actionLabel!),
            ),
          ],
        ],
      ),
    );
  }
}

/// Widget untuk shimmer loading
class ScanHistoryShimmer extends StatelessWidget {
  const ScanHistoryShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return const ListTile(
          leading: CircleAvatar(),
          title: Text('Loading...'),
          subtitle: Text('Please wait'),
        );
      },
    );
  }
}
```

### 7.4 Buat Scanner Overlay Widget

Buat file `lib/widgets/scanner_overlay.dart`:

```dart
import 'package:flutter/material.dart';
import '../utils/constants.dart';

/// Widget overlay untuk scanner dengan cutout di tengah
class ScannerOverlay extends StatelessWidget {
  final double scanAreaSize;

  const ScannerOverlay({
    super.key,
    this.scanAreaSize = 280,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.infinite,
      painter: _ScannerOverlayPainter(scanAreaSize: scanAreaSize),
    );
  }
}

class _ScannerOverlayPainter extends CustomPainter {
  final double scanAreaSize;

  _ScannerOverlayPainter({required this.scanAreaSize});

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final halfScanArea = scanAreaSize / 2;

    // Overlay path dengan cutout
    final overlayPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset(centerX, centerY),
            width: scanAreaSize,
            height: scanAreaSize,
          ),
          const Radius.circular(16),
        ),
      )
      ..fillType = PathFillType.evenOdd;

    // Gambar overlay
    canvas.drawPath(
      overlayPath,
      Paint()..color = Colors.black.withOpacity(0.5),
    );

    // Gambar border corners
    final cornerLength = scanAreaSize * 0.15;
    final cornerPaint = Paint()
      ..color = AppColors.secondary
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    // Top-left
    _drawCorner(
      canvas,
      Offset(centerX - halfScanArea, centerY - halfScanArea),
      cornerLength,
      cornerPaint,
      isTopLeft: true,
    );

    // Top-right
    _drawCorner(
      canvas,
      Offset(centerX + halfScanArea, centerY - halfScanArea),
      cornerLength,
      cornerPaint,
      isTopRight: true,
    );

    // Bottom-left
    _drawCorner(
      canvas,
      Offset(centerX - halfScanArea, centerY + halfScanArea),
      cornerLength,
      cornerPaint,
      isBottomLeft: true,
    );

    // Bottom-right
    _drawCorner(
      canvas,
      Offset(centerX + halfScanArea, centerY + halfScanArea),
      cornerLength,
      cornerPaint,
      isBottomRight: true,
    );
  }

  void _drawCorner(
    Canvas canvas,
    Offset corner,
    double length,
    Paint paint, {
    bool isTopLeft = false,
    bool isTopRight = false,
    bool isBottomLeft = false,
    bool isBottomRight = false,
  }) {
    final path = Path();

    if (isTopLeft) {
      path.moveTo(corner.dx, corner.dy + length);
      path.lineTo(corner.dx, corner.dy);
      path.lineTo(corner.dx + length, corner.dy);
    } else if (isTopRight) {
      path.moveTo(corner.dx - length, corner.dy);
      path.lineTo(corner.dx, corner.dy);
      path.lineTo(corner.dx, corner.dy + length);
    } else if (isBottomLeft) {
      path.moveTo(corner.dx, corner.dy - length);
      path.lineTo(corner.dx, corner.dy);
      path.lineTo(corner.dx + length, corner.dy);
    } else if (isBottomRight) {
      path.moveTo(corner.dx - length, corner.dy);
      path.lineTo(corner.dx, corner.dy);
      path.lineTo(corner.dx, corner.dy - length);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Widget untuk instruksi scanner
class ScannerInstructions extends StatelessWidget {
  const ScannerInstructions({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 100,
      left: 0,
      right: 0,
      child: Column(
        children: [
          Text(
            'Scan QR Code',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Position the QR code within the frame',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
```

---

## Langkah 8: Membuat Screens

### 8.1 Buat Folder Screens

```bash
mkdir -p lib/screens
```

### 8.2 Buat Home Screen

Buat file `lib/screens/home_screen.dart`:

```dart
import 'package:flutter/material.dart';
import '../models/qr_scan_model.dart';
import '../services/mock_data_service.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';
import '../widgets/scan_history_item.dart';
import 'scanner_screen.dart';
import 'scan_detail_screen.dart';
import 'favorites_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final MockDataService _dataService = MockDataService();
  List<QRScanModel> _scans = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    
    try {
      final scans = await _dataService.getScanHistory();
      setState(() {
        _scans = scans;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _toggleFavorite(String id) async {
    await _dataService.toggleFavorite(id);
    _loadData();
  }

  Future<void> _deleteScan(String id) async {
    final confirmed = await Helpers.showConfirmDialog(
      context,
      title: 'Delete Scan',
      message: 'Are you sure?',
    );

    if (confirmed) {
      await _dataService.deleteScan(id);
      _loadData();
      if (mounted) {
        Helpers.showSnackBar(context, 'Scan deleted');
      }
    }
  }

  Future<void> _navigateToScanner() async {
    final result = await Navigator.push<QRScanModel>(
      context,
      MaterialPageRoute(builder: (context) => const ScannerScreen()),
    );

    if (result != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ScanDetailScreen(scan: result),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.appName),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FavoritesScreen(),
                ),
              );
            },
            icon: const Icon(Icons.favorite),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _scans.isEmpty
              ? EmptyScanHistory(
                  onAction: _navigateToScanner,
                  actionLabel: 'Scan QR Code',
                )
              : RefreshIndicator(
                  onRefresh: _loadData,
                  child: ListView.builder(
                    itemCount: _scans.length,
                    itemBuilder: (context, index) {
                      final scan = _scans[index];
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
                      );
                    },
                  ),
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _navigateToScanner,
        backgroundColor: AppColors.secondary,
        icon: const Icon(Icons.qr_code_scanner),
        label: const Text('Scan'),
      ),
    );
  }
}
```

### 8.3 Buat Scanner Screen

Buat file `lib/screens/scanner_screen.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../models/qr_scan_model.dart';
import '../services/mock_data_service.dart';
import '../utils/constants.dart';
import '../widgets/scanner_overlay.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  final MockDataService _dataService = MockDataService();
  late MobileScannerController _controller;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _controller = MobileScannerController(
      facing: CameraFacing.back,
      formats: [BarcodeFormat.qrCode],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) async {
    if (_isProcessing) return;

    final barcode = capture.barcodes.firstOrNull;
    if (barcode == null || barcode.rawValue == null) return;

    setState(() => _isProcessing = true);
    _controller.stop();

    try {
      final newScan = await _dataService.addNewScan(barcode.rawValue!);
      if (mounted) {
        Navigator.pop(context, newScan);
      }
    } catch (e) {
      setState(() => _isProcessing = false);
      _controller.start();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          MobileScanner(
            controller: _controller,
            onDetect: _onDetect,
          ),
          const ScannerOverlay(),
          const ScannerInstructions(),
          
          // Close button
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 16,
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.close, color: Colors.white),
            ),
          ),
          
          // Processing indicator
          if (_isProcessing)
            Container(
              color: Colors.black54,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
```

### 8.4 Buat Scan Detail Screen

Buat file `lib/screens/scan_detail_screen.dart`:

```dart
import 'package:flutter/material.dart';
import '../models/qr_scan_model.dart';
import '../services/mock_data_service.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';
import '../widgets/qr_type_badge.dart';

class ScanDetailScreen extends StatefulWidget {
  final QRScanModel scan;

  const ScanDetailScreen({super.key, required this.scan});

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Detail'),
        backgroundColor: Color(_scan.type.colorValue),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: _toggleFavorite,
            icon: Icon(
              _scan.isFavorite ? Icons.favorite : Icons.favorite_border,
              color: _scan.isFavorite ? Colors.red : Colors.white,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Title', style: AppTypography.label),
                    Text(_scan.title, style: AppTypography.h4),
                    const SizedBox(height: AppSpacing.sm),
                    QRTypeBadge(type: _scan.type),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Content'),
                    const SizedBox(height: 8),
                    SelectableText(_scan.content),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        ElevatedButton.icon(
                          onPressed: () => Helpers.copyToClipboard(
                            context,
                            _scan.content,
                          ),
                          icon: const Icon(Icons.copy),
                          label: const Text('Copy'),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton.icon(
                          onPressed: () => Helpers.shareText(_scan.content),
                          icon: const Icon(Icons.share),
                          label: const Text('Share'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            if (_scan.type == QRType.url)
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.md),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => Helpers.launchURL(_scan.content),
                    icon: const Icon(Icons.open_in_browser),
                    label: const Text('Open Link'),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
```

### 8.5 Buat Favorites Screen

Buat file `lib/screens/favorites_screen.dart`:

```dart
import 'package:flutter/material.dart';
import '../models/qr_scan_model.dart';
import '../services/mock_data_service.dart';
import '../utils/constants.dart';
import '../widgets/scan_history_item.dart';
import 'scan_detail_screen.dart';

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
  }

  Future<void> _loadFavorites() async {
    setState(() => _isLoading = true);
    
    try {
      final favorites = await _dataService.getFavoriteScans();
      setState(() {
        _favorites = favorites;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _favorites.isEmpty
              ? const Center(child: Text('No favorites yet'))
              : ListView.builder(
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
                    );
                  },
                ),
    );
  }
}
```

---

## Langkah 9: Konfigurasi Main

### 9.1 Update main.dart

Buka `lib/main.dart` dan ganti dengan:

```dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/home_screen.dart';
import 'utils/constants.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  runApp(const QRScannerApp());
}

class QRScannerApp extends StatelessWidget {
  const QRScannerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
```

---

## Langkah 10: Running Aplikasi

### 10.1 Install Dependencies

```bash
flutter pub get
```

### 10.2 Jalankan di Emulator/Device

```bash
# Cek devices yang tersedia
flutter devices

# Jalankan aplikasi
flutter run

# Atau spesifik device
flutter run -d <device_id>
```

### 10.3 Build Release (Optional)

```bash
# Build APK Android
flutter build apk --release

# Build App Bundle Android
flutter build appbundle --release

# Build iOS (Mac only)
flutter build ios --release
```

---

## Fitur Aplikasi

| Fitur | Deskripsi |
|-------|-----------|
| **Scan QR Code** | Scan QR menggunakan kamera dengan overlay visual |
| **Deteksi Otomatis** | Deteksi tipe QR (URL, WiFi, Contact, Email, SMS, Location, Text) |
| **Riwayat Scan** | Lihat semua scan yang telah dilakukan |
| **Favorit** | Tandai scan sebagai favorit |
| **Detail Scan** | Lihat detail lengkap hasil scan |
| **Copy & Share** | Copy ke clipboard atau share ke aplikasi lain |
| **Open URL** | Buka URL langsung dari hasil scan |
| **Mock Data** | Data dummy tanpa database |

---

## Penjelasan Arsitektur

### Layer Architecture

```
┌─────────────────────────────────────┐
│           PRESENTATION              │
│  ┌─────────┐ ┌─────────┐ ┌────────┐ │
│  │ Screens │ │ Widgets │ │  Main  │ │
│  └─────────┘ └─────────┘ └────────┘ │
├─────────────────────────────────────┤
│           BUSINESS LOGIC            │
│  ┌───────────────────────────────┐  │
│  │      MockDataService          │  │
│  └───────────────────────────────┘  │
├─────────────────────────────────────┤
│              DATA                   │
│  ┌─────────┐ ┌───────────────────┐  │
│  │  Models │ │  Mock JSON Files  │  │
│  └─────────┘ └───────────────────┘  │
└─────────────────────────────────────┘
```

### Data Flow

1. **User** melakukan scan QR
2. **ScannerScreen** mendeteksi QR code
3. **MockDataService** menyimpan data baru
4. **HomeScreen** menampilkan updated list
5. **ScanDetailScreen** menampilkan detail

---

## Troubleshooting

### Issue: Camera tidak berfungsi

**Solusi:**
```bash
# Clean dan rebuild
flutter clean
flutter pub get
flutter run
```

### Issue: Permission denied

**Solusi:**
Tambahkan di `android/app/src/main/AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.CAMERA" />
```

### Issue: iOS build error

**Solusi:**
```bash
cd ios
pod install
cd ..
flutter run
```

---

## Selamat! 🎉

Anda telah berhasil membuat aplikasi Flutter QR Scanner dengan mock data!

### Next Steps

1. **Tambahkan Database**: Ganti mock data dengan SQLite atau Hive
2. **Tambahkan Backend**: Connect ke API untuk sync data
3. **Generate QR**: Tambahkan fitur generate QR code
4. **Export Data**: Export riwayat ke CSV/PDF
5. **Cloud Sync**: Sync data antar device

---

## Resources

- [Flutter Documentation](https://docs.flutter.dev)
- [Mobile Scanner Package](https://pub.dev/packages/mobile_scanner)
- [Flutter Widget Catalog](https://docs.flutter.dev/ui/widgets)

---

**Dibuat dengan ❤️ menggunakan Flutter**

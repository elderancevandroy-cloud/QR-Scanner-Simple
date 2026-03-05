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

  # For web support
  flutter_web_plugins:
    sdk: flutter

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

  /// Mendapatkan label yang readable untuk UI
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

  /// Mendapatkan icon berdasarkan tipe
  String get iconAsset {
    switch (this) {
      case QRType.url:
        return 'assets/icons/link.png';
      case QRType.wifi:
        return 'assets/icons/wifi.png';
      case QRType.contact:
        return 'assets/icons/contact.png';
      case QRType.email:
        return 'assets/icons/email.png';
      case QRType.sms:
        return 'assets/icons/sms.png';
      case QRType.location:
        return 'assets/icons/location.png';
      case QRType.text:
        return 'assets/icons/text.png';
      case QRType.unknown:
        return 'assets/icons/unknown.png';
    }
  }

  /// Mendapatkan color berdasarkan tipe
  int get colorValue {
    switch (this) {
      case QRType.url:
        return 0xFF2196F3; // Blue
      case QRType.wifi:
        return 0xFF4CAF50; // Green
      case QRType.contact:
        return 0xFF9C27B0; // Purple
      case QRType.email:
        return 0xFFFF9800; // Orange
      case QRType.sms:
        return 0xFF00BCD4; // Cyan
      case QRType.location:
        return 0xFFE91E63; // Pink
      case QRType.text:
        return 0xFF607D8B; // Blue Grey
      case QRType.unknown:
        return 0xFF757575; // Grey
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

  /// Mengkonversi instance ke JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'type': type.name,
      'title': title,
      'timestamp': timestamp.toIso8601String(),
      'isFavorite': isFavorite,
      'metadata': metadata,
    };
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

  /// Generate title otomatis berdasarkan konten dan tipe
  static String generateTitle(String content, QRType type) {
    switch (type) {
      case QRType.url:
        try {
          final uri = Uri.parse(content);
          return uri.host;
        } catch (_) {
          return 'Website';
        }
      case QRType.wifi:
        final ssidMatch = RegExp(r'S:([^;]+)').firstMatch(content);
        return ssidMatch != null 
            ? 'WiFi: ${ssidMatch.group(1)}' 
            : 'WiFi Network';
      case QRType.contact:
        final nameMatch = RegExp(r'FN:([^\n]+)').firstMatch(content);
        return nameMatch != null 
            ? 'Contact: ${nameMatch.group(1)}' 
            : 'Contact Card';
      case QRType.email:
        if (content.startsWith('MATMSG:')) {
          final toMatch = RegExp(r'TO:([^;]+)').firstMatch(content);
          return toMatch != null 
              ? 'Email: ${toMatch.group(1)}' 
              : 'Email';
        }
        return 'Email';
      case QRType.sms:
        final phoneMatch = RegExp(r'SMSTO:([^:]+)').firstMatch(content);
        return phoneMatch != null 
            ? 'SMS: ${phoneMatch.group(1)}' 
            : 'SMS';
      case QRType.location:
        final queryMatch = RegExp(r'q=([^&]+)').firstMatch(content);
        return queryMatch != null 
            ? 'Location: ${Uri.decodeComponent(queryMatch.group(1)!)}' 
            : 'Location';
      case QRType.text:
        if (content.length > 30) {
          return '${content.substring(0, 30)}...';
        }
        return content;
      case QRType.unknown:
        return 'Unknown Content';
    }
  }

  /// Parse WiFi data dari konten
  static Map<String, String>? parseWifiData(String content) {
    if (!content.startsWith('WIFI:')) return null;

    final ssidMatch = RegExp(r'S:([^;]+)').firstMatch(content);
    final passwordMatch = RegExp(r'P:([^;]+)').firstMatch(content);
    final typeMatch = RegExp(r'T:([^;]+)').firstMatch(content);

    if (ssidMatch == null) return null;

    return {
      'ssid': ssidMatch.group(1) ?? '',
      'password': passwordMatch?.group(1) ?? '',
      'type': typeMatch?.group(1) ?? 'WPA',
    };
  }

  /// Parse contact data dari konten vCard
  static Map<String, String>? parseContactData(String content) {
    if (!content.startsWith('BEGIN:VCARD')) return null;

    final nameMatch = RegExp(r'FN:([^\n]+)').firstMatch(content);
    final phoneMatch = RegExp(r'TEL:([^\n]+)').firstMatch(content);
    final emailMatch = RegExp(r'EMAIL:([^\n]+)').firstMatch(content);

    return {
      'name': nameMatch?.group(1) ?? '',
      'phone': phoneMatch?.group(1) ?? '',
      'email': emailMatch?.group(1) ?? '',
    };
  }

  /// Parse email data dari konten
  static Map<String, String>? parseEmailData(String content) {
    if (content.startsWith('MATMSG:')) {
      final toMatch = RegExp(r'TO:([^;]+)').firstMatch(content);
      final subjectMatch = RegExp(r'SUB:([^;]+)').firstMatch(content);
      final bodyMatch = RegExp(r'BODY:([^;]+)').firstMatch(content);

      return {
        'to': toMatch?.group(1) ?? '',
        'subject': subjectMatch?.group(1) ?? '',
        'body': bodyMatch?.group(1) ?? '',
      };
    }
    return null;
  }

  /// Parse SMS data dari konten
  static Map<String, String>? parseSmsData(String content) {
    if (content.startsWith('SMSTO:')) {
      final parts = content.split(':');
      if (parts.length >= 3) {
        return {
          'phone': parts[1],
          'message': parts.sublist(2).join(':'),
        };
      }
    }
    return null;
  }

  /// Parse location data dari konten
  static Map<String, dynamic>? parseLocationData(String content) {
    if (!content.startsWith('geo:')) return null;

    final coordsMatch = RegExp(r'geo:([^,]+),([^?]+)').firstMatch(content);
    final queryMatch = RegExp(r'q=([^&]+)').firstMatch(content);

    if (coordsMatch == null) return null;

    return {
      'latitude': double.tryParse(coordsMatch.group(1) ?? '0') ?? 0,
      'longitude': double.tryParse(coordsMatch.group(2) ?? '0') ?? 0,
      'query': queryMatch != null 
          ? Uri.decodeComponent(queryMatch.group(1)!) 
          : null,
    };
  }

  /// Copy dengan perubahan tertentu
  QRScanModel copyWith({
    String? id,
    String? content,
    QRType? type,
    String? title,
    DateTime? timestamp,
    bool? isFavorite,
    Map<String, dynamic>? metadata,
  }) {
    return QRScanModel(
      id: id ?? this.id,
      content: content ?? this.content,
      type: type ?? this.type,
      title: title ?? this.title,
      timestamp: timestamp ?? this.timestamp,
      isFavorite: isFavorite ?? this.isFavorite,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  String toString() {
    return 'QRScanModel(id: $id, type: ${type.name}, title: $title)';
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

  Map<String, dynamic> toJson() {
    return {
      'scan_history': scans.map((e) => e.toJson()).toList(),
    };
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
/// 
/// Service ini menyediakan data dummy untuk aplikasi tanpa memerlukan
/// database atau backend. Data di-load dari file JSON assets.
class MockDataService {
  static final MockDataService _instance = MockDataService._internal();
  
  factory MockDataService() => _instance;
  
  MockDataService._internal();

  // Cache untuk menyimpan data di memory
  List<QRScanModel>? _cachedScans;
  
  // Stream controller untuk realtime updates (simulasi)
  final List<Function(List<QRScanModel>)> _listeners = [];

  /// Load scan history dari mock JSON file
  Future<List<QRScanModel>> getScanHistory() async {
    // Return cached data jika sudah di-load
    if (_cachedScans != null) {
      return List.from(_cachedScans!);
    }

    try {
      // Load JSON dari assets
      final String jsonString = await rootBundle.loadString(
        'assets/json/mock_scan_history.json',
      );
      
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      final response = ScanHistoryResponse.fromJson(jsonData);
      
      // Sort by timestamp descending (terbaru di atas)
      response.scans.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      
      _cachedScans = response.scans;
      return List.from(_cachedScans!);
    } catch (e) {
      print('Error loading mock data: $e');
      return [];
    }
  }

  /// Get scan berdasarkan ID
  Future<QRScanModel?> getScanById(String id) async {
    final scans = await getScanHistory();
    try {
      return scans.firstWhere((scan) => scan.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Get scan yang difavoritkan
  Future<List<QRScanModel>> getFavoriteScans() async {
    final scans = await getScanHistory();
    return scans.where((scan) => scan.isFavorite).toList();
  }

  /// Toggle favorite status
  Future<bool> toggleFavorite(String id) async {
    if (_cachedScans == null) await getScanHistory();
    
    final index = _cachedScans!.indexWhere((scan) => scan.id == id);
    if (index != -1) {
      _cachedScans![index].isFavorite = !_cachedScans![index].isFavorite;
      _notifyListeners();
      return _cachedScans![index].isFavorite;
    }
    return false;
  }

  /// Simulasi scan QR baru
  /// 
  /// Dalam aplikasi nyata, ini akan menyimpan ke database
  Future<QRScanModel> addNewScan(String content) async {
    if (_cachedScans == null) await getScanHistory();

    final type = QRScanModel.detectType(content);
    final title = QRScanModel.generateTitle(content, type);
    
    // Generate metadata berdasarkan tipe
    final metadata = _generateMetadata(content, type);

    final newScan = QRScanModel(
      id: 'scan_${_generateRandomId()}',
      content: content,
      type: type,
      title: title,
      timestamp: DateTime.now(),
      isFavorite: false,
      metadata: metadata,
    );

    _cachedScans!.insert(0, newScan);
    _notifyListeners();
    
    // Simulasi delay network
    await Future.delayed(const Duration(milliseconds: 300));
    
    return newScan;
  }

  /// Delete scan dari history
  Future<bool> deleteScan(String id) async {
    if (_cachedScans == null) await getScanHistory();
    
    final initialLength = _cachedScans!.length;
    _cachedScans!.removeWhere((scan) => scan.id == id);
    
    if (_cachedScans!.length < initialLength) {
      _notifyListeners();
      return true;
    }
    return false;
  }

  /// Search scans berdasarkan query
  Future<List<QRScanModel>> searchScans(String query) async {
    final scans = await getScanHistory();
    final lowercaseQuery = query.toLowerCase();
    
    return scans.where((scan) {
      return scan.title.toLowerCase().contains(lowercaseQuery) ||
             scan.content.toLowerCase().contains(lowercaseQuery) ||
             scan.type.name.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }

  /// Filter scans berdasarkan tipe
  Future<List<QRScanModel>> filterByType(QRType type) async {
    final scans = await getScanHistory();
    return scans.where((scan) => scan.type == type).toList();
  }

  /// Get statistik scan
  Future<Map<String, dynamic>> getStatistics() async {
    final scans = await getScanHistory();
    
    final typeCounts = <String, int>{};
    for (final scan in scans) {
      typeCounts[scan.type.name] = (typeCounts[scan.type.name] ?? 0) + 1;
    }

    final today = DateTime.now();
    final todayScans = scans.where((scan) {
      return scan.timestamp.year == today.year &&
             scan.timestamp.month == today.month &&
             scan.timestamp.day == today.day;
    }).length;

    return {
      'totalScans': scans.length,
      'favoriteScans': scans.where((s) => s.isFavorite).length,
      'todayScans': todayScans,
      'typeDistribution': typeCounts,
    };
  }

  /// Clear semua history (simulasi)
  Future<void> clearHistory() async {
    _cachedScans?.clear();
    _notifyListeners();
  }

  /// Simulasi refresh data dari server
  Future<void> refreshData() async {
    _cachedScans = null;
    await getScanHistory();
    _notifyListeners();
  }

  /// Subscribe untuk perubahan data
  void addListener(Function(List<QRScanModel>) listener) {
    _listeners.add(listener);
  }

  /// Unsubscribe dari perubahan data
  void removeListener(Function(List<QRScanModel>) listener) {
    _listeners.remove(listener);
  }

  /// Notify semua listeners
  void _notifyListeners() {
    if (_cachedScans != null) {
      for (final listener in _listeners) {
        listener(List.from(_cachedScans!));
      }
    }
  }

  /// Generate metadata berdasarkan tipe konten
  Map<String, dynamic>? _generateMetadata(String content, QRType type) {
    switch (type) {
      case QRType.wifi:
        return QRScanModel.parseWifiData(content);
      case QRType.contact:
        return QRScanModel.parseContactData(content);
      case QRType.email:
        return QRScanModel.parseEmailData(content);
      case QRType.sms:
        return QRScanModel.parseSmsData(content);
      case QRType.location:
        return QRScanModel.parseLocationData(content);
      case QRType.url:
        return {
          'description': 'Website URL scanned',
          'icon': null,
        };
      case QRType.text:
        return {
          'length': content.length,
        };
      case QRType.unknown:
        return null;
    }
  }

  /// Generate random ID untuk scan baru
  String _generateRandomId() {
    final random = Random();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final randomPart = random.nextInt(9999).toString().padLeft(4, '0');
    return '${timestamp}_$randomPart';
  }

  /// Simulasi error (untuk testing error handling)
  Future<void> simulateError() async {
    await Future.delayed(const Duration(milliseconds: 500));
    throw Exception('Simulated network error');
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
  // App Info
  static const String appName = 'QR Scanner Pro';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Simple & Powerful QR Code Scanner';

  // Animation Durations
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 350);
  static const Duration longAnimationDuration = Duration(milliseconds: 500);

  // Scanner Settings
  static const int scannerDetectionTimeout = 10; // seconds
  static const double scannerOverlayRatio = 0.7;

  // Storage Keys (untuk SharedPreferences jika diperlukan)
  static const String keyScanHistory = 'scan_history';
  static const String keyFavorites = 'favorites';
  static const String keySettings = 'settings';
  static const String keyFirstLaunch = 'first_launch';

  // Limits
  static const int maxHistoryItems = 1000;
  static const int maxSearchResults = 50;
}

/// Warna aplikasi
class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFF6C63FF);
  static const Color primaryDark = Color(0xFF5A52D5);
  static const Color primaryLight = Color(0xFF8B85FF);
  
  // Secondary Colors
  static const Color secondary = Color(0xFF00BFA6);
  static const Color secondaryDark = Color(0xFF00A693);
  static const Color secondaryLight = Color(0xFF33CCB8);

  // Background Colors
  static const Color background = Color(0xFFF8F9FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color cardBackground = Color(0xFFFFFFFF);

  // Text Colors
  static const Color textPrimary = Color(0xFF2D3436);
  static const Color textSecondary = Color(0xFF636E72);
  static const Color textHint = Color(0xFFB2BEC3);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // Status Colors
  static const Color success = Color(0xFF00B894);
  static const Color warning = Color(0xFFFDCB6E);
  static const Color error = Color(0xFFFF7675);
  static const Color info = Color(0xFF74B9FF);

  // Type-specific Colors (untuk QR Type)
  static const Color urlColor = Color(0xFF3498DB);
  static const Color wifiColor = Color(0xFF27AE60);
  static const Color contactColor = Color(0xFF9B59B6);
  static const Color emailColor = Color(0xFFE67E22);
  static const Color smsColor = Color(0xFF1ABC9C);
  static const Color locationColor = Color(0xFFE91E63);
  static const Color textColor = Color(0xFF607D8B);
  static const Color unknownColor = Color(0xFF95A5A6);

  // Gradient Colors
  static const List<Color> primaryGradient = [
    Color(0xFF6C63FF),
    Color(0xFF5A52D5),
  ];

  static const List<Color> scannerGradient = [
    Color(0xFF00BFA6),
    Color(0xFF00A693),
  ];

  // Overlay Colors
  static const Color scannerOverlay = Color(0x80000000);
  static const Color scannerCorner = Color(0xFF00BFA6);
}

/// Typography aplikasi
class AppTypography {
  // Font Family - menggunakan system default
  static const String fontFamily = 'Roboto';

  // Heading Styles
  static const TextStyle h1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  static const TextStyle h2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  static const TextStyle h3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  static const TextStyle h4 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  // Body Styles
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
    height: 1.5,
  );

  // Special Styles
  static const TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textOnPrimary,
    height: 1.0,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    height: 1.4,
  );

  static const TextStyle label = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: AppColors.textHint,
    height: 1.4,
    letterSpacing: 0.5,
  );
}

/// Spacing dan sizing
class AppSpacing {
  // Padding
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;

  // Border Radius
  static const double radiusSm = 4;
  static const double radiusMd = 8;
  static const double radiusLg = 12;
  static const double radiusXl = 16;
  static const double radiusXXl = 24;
  static const double radiusFull = 999;

  // Icon Sizes
  static const double iconSm = 16;
  static const double iconMd = 24;
  static const double iconLg = 32;
  static const double iconXl = 48;

  // Button Heights
  static const double buttonHeightSm = 36;
  static const double buttonHeightMd = 48;
  static const double buttonHeightLg = 56;
}

/// Shadows
class AppShadows {
  static const BoxShadow small = BoxShadow(
    color: Color(0x1A000000),
    blurRadius: 4,
    offset: Offset(0, 2),
  );

  static const BoxShadow medium = BoxShadow(
    color: Color(0x1A000000),
    blurRadius: 8,
    offset: Offset(0, 4),
  );

  static const BoxShadow large = BoxShadow(
    color: Color(0x1A000000),
    blurRadius: 16,
    offset: Offset(0, 8),
  );

  static const BoxShadow card = BoxShadow(
    color: Color(0x0D000000),
    blurRadius: 10,
    offset: Offset(0, 4),
  );
}

/// QR Type Colors Helper
class QRTypeColors {
  static Color getColor(String typeName) {
    switch (typeName) {
      case 'url':
        return AppColors.urlColor;
      case 'wifi':
        return AppColors.wifiColor;
      case 'contact':
        return AppColors.contactColor;
      case 'email':
        return AppColors.emailColor;
      case 'sms':
        return AppColors.smsColor;
      case 'location':
        return AppColors.locationColor;
      case 'text':
        return AppColors.textColor;
      default:
        return AppColors.unknownColor;
    }
  }

  static IconData getIcon(String typeName) {
    switch (typeName) {
      case 'url':
        return Icons.link;
      case 'wifi':
        return Icons.wifi;
      case 'contact':
        return Icons.contact_page;
      case 'email':
        return Icons.email;
      case 'sms':
        return Icons.sms;
      case 'location':
        return Icons.location_on;
      case 'text':
        return Icons.text_fields;
      default:
        return Icons.qr_code;
    }
  }
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
```

### 7.3 Buat Scan History Item Widget

Buat file `lib/widgets/scan_history_item.dart`:

```dart
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
```

### 7.4 Buat Scanner Overlay Widget

Buat file `lib/widgets/scanner_overlay.dart`:

```dart
import 'package:flutter/material.dart';
import '../utils/constants.dart';

/// Widget overlay untuk scanner dengan cutout di tengah
class ScannerOverlay extends StatelessWidget {
  final double scanAreaSize;
  final Color overlayColor;
  final Color borderColor;
  final double borderWidth;
  final double cornerRadius;

  const ScannerOverlay({
    super.key,
    this.scanAreaSize = 280,
    this.overlayColor = AppColors.scannerOverlay,
    this.borderColor = AppColors.scannerCorner,
    this.borderWidth = 3,
    this.cornerRadius = 16,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.infinite,
      painter: _ScannerOverlayPainter(
        scanAreaSize: scanAreaSize,
        overlayColor: overlayColor,
        borderColor: borderColor,
        borderWidth: borderWidth,
        cornerRadius: cornerRadius,
      ),
    );
  }
}

/// Custom painter untuk menggambar overlay scanner
class _ScannerOverlayPainter extends CustomPainter {
  final double scanAreaSize;
  final Color overlayColor;
  final Color borderColor;
  final double borderWidth;
  final double cornerRadius;

  _ScannerOverlayPainter({
    required this.scanAreaSize,
    required this.overlayColor,
    required this.borderColor,
    required this.borderWidth,
    required this.cornerRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final halfScanArea = scanAreaSize / 2;

    // Buat path untuk cutout (area scan)
    final cutoutPath = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset(centerX, centerY),
            width: scanAreaSize,
            height: scanAreaSize,
          ),
          Radius.circular(cornerRadius),
        ),
      );

    // Buat path untuk overlay (seluruh layar dengan cutout)
    final overlayPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addPath(cutoutPath, Offset.zero)
      ..fillType = PathFillType.evenOdd;

    // Gambar overlay
    canvas.drawPath(
      overlayPath,
      Paint()..color = overlayColor,
    );

    // Gambar border corners
    final cornerLength = scanAreaSize * 0.15;
    final cornerPaint = Paint()
      ..color = borderColor
      ..strokeWidth = borderWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Top-left corner
    _drawCorner(
      canvas,
      Offset(centerX - halfScanArea, centerY - halfScanArea),
      cornerLength,
      cornerPaint,
      isTopLeft: true,
    );

    // Top-right corner
    _drawCorner(
      canvas,
      Offset(centerX + halfScanArea, centerY - halfScanArea),
      cornerLength,
      cornerPaint,
      isTopRight: true,
    );

    // Bottom-left corner
    _drawCorner(
      canvas,
      Offset(centerX - halfScanArea, centerY + halfScanArea),
      cornerLength,
      cornerPaint,
      isBottomLeft: true,
    );

    // Bottom-right corner
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
      // Horizontal line
      path.moveTo(corner.dx, corner.dy + length);
      path.lineTo(corner.dx, corner.dy);
      path.lineTo(corner.dx + length, corner.dy);
    } else if (isTopRight) {
      // Horizontal line
      path.moveTo(corner.dx - length, corner.dy);
      path.lineTo(corner.dx, corner.dy);
      path.lineTo(corner.dx, corner.dy + length);
    } else if (isBottomLeft) {
      // Horizontal line
      path.moveTo(corner.dx, corner.dy - length);
      path.lineTo(corner.dx, corner.dy);
      path.lineTo(corner.dx + length, corner.dy);
    } else if (isBottomRight) {
      // Horizontal line
      path.moveTo(corner.dx - length, corner.dy);
      path.lineTo(corner.dx, corner.dy);
      path.lineTo(corner.dx, corner.dy - length);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Widget untuk animasi scanning line
class ScanningLine extends StatefulWidget {
  final double scanAreaSize;
  final Color lineColor;
  final Duration duration;

  const ScanningLine({
    super.key,
    this.scanAreaSize = 280,
    this.lineColor = AppColors.scannerCorner,
    this.duration = const Duration(milliseconds: 2000),
  });

  @override
  State<ScanningLine> createState() => _ScanningLineState();
}

class _ScanningLineState extends State<ScanningLine>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    
    _animation = Tween<double>(begin: -1, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return CustomPaint(
          size: Size.infinite,
          painter: _ScanningLinePainter(
            scanAreaSize: widget.scanAreaSize,
            lineColor: widget.lineColor,
            progress: _animation.value,
          ),
        );
      },
    );
  }
}

class _ScanningLinePainter extends CustomPainter {
  final double scanAreaSize;
  final Color lineColor;
  final double progress;

  _ScanningLinePainter({
    required this.scanAreaSize,
    required this.lineColor,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final halfScanArea = scanAreaSize / 2;

    // Calculate line position
    final lineY = centerY + (progress * halfScanArea);

    // Draw gradient line
    final linePaint = Paint()
      ..shader = LinearGradient(
        colors: [
          lineColor.withOpacity(0),
          lineColor.withOpacity(0.8),
          lineColor.withOpacity(0.8),
          lineColor.withOpacity(0),
        ],
        stops: const [0.0, 0.3, 0.7, 1.0],
      ).createShader(
        Rect.fromCenter(
          center: Offset(centerX, lineY),
          width: scanAreaSize - 20,
          height: 2,
        ),
      )
      ..strokeWidth = 2;

    canvas.drawLine(
      Offset(centerX - halfScanArea + 10, lineY),
      Offset(centerX + halfScanArea - 10, lineY),
      linePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// Widget untuk menampilkan instruksi scanner
class ScannerInstructions extends StatelessWidget {
  final String? title;
  final String? subtitle;

  const ScannerInstructions({
    super.key,
    this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 100,
      left: 0,
      right: 0,
      child: Column(
        children: [
          Text(
            title ?? 'Scan QR Code',
            style: AppTypography.h4.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              subtitle ?? 'Position the QR code within the frame to scan',
              style: AppTypography.bodyMedium.copyWith(
                color: Colors.white.withOpacity(0.8),
              ),
              textAlign: TextAlign.center,
            ),
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
```

### 8.3 Buat Scanner Screen

Buat file `lib/screens/scanner_screen.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../models/qr_scan_model.dart';
import '../services/mock_data_service.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';
import '../widgets/scanner_overlay.dart';

/// Scanner Screen - Halaman untuk scan QR Code
/// Menggunakan package mobile_scanner untuk deteksi QR
class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen>
    with SingleTickerProviderStateMixin {
  final MockDataService _dataService = MockDataService();
  late MobileScannerController _controller;
  
  bool _isScanning = true;
  bool _isProcessing = false;
  bool _torchEnabled = false;
  bool _isFrontCamera = false;

  @override
  void initState() {
    super.initState();
    _controller = MobileScannerController(
      facing: CameraFacing.back,
      torchEnabled: false,
      formats: [BarcodeFormat.qrCode],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) async {
    if (!_isScanning || _isProcessing) return;

    final barcode = capture.barcodes.firstOrNull;
    if (barcode == null || barcode.rawValue == null) return;

    setState(() => _isProcessing = true);

    // Pause scanning
    _controller.stop();

    // Play success sound (optional)
    // await SystemSound.play(SystemSoundType.click);

    // Save scan ke mock data
    try {
      final newScan = await _dataService.addNewScan(barcode.rawValue!);
      
      if (mounted) {
        // Return scan result ke caller
        Navigator.pop(context, newScan);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isProcessing = false);
        Helpers.showSnackBar(context, 'Failed to save scan');
        _controller.start();
      }
    }
  }

  void _toggleTorch() {
    setState(() {
      _torchEnabled = !_torchEnabled;
    });
    _controller.toggleTorch();
  }

  void _switchCamera() {
    setState(() {
      _isFrontCamera = !_isFrontCamera;
    });
    _controller.switchCamera();
  }

  void _manualInput() {
    showDialog(
      context: context,
      builder: (context) => _ManualInputDialog(
        onSubmit: (content) async {
          Navigator.pop(context);
          
          setState(() => _isProcessing = true);
          _controller.stop();

          try {
            final newScan = await _dataService.addNewScan(content);
            if (mounted) {
              Navigator.pop(context, newScan);
            }
          } catch (e) {
            if (mounted) {
              setState(() => _isProcessing = false);
              Helpers.showSnackBar(context, 'Failed to save scan');
              _controller.start();
            }
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Camera Preview
          MobileScanner(
            controller: _controller,
            onDetect: _onDetect,
            errorBuilder: (context, error, child) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.camera_alt_outlined,
                      color: Colors.white,
                      size: 64,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Camera error: ${error.errorCode}',
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => _controller.start(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            },
          ),

          // Scanner Overlay
          const ScannerOverlay(
            scanAreaSize: 280,
          ),

          // Scanning Animation Line
          const ScanningLine(
            scanAreaSize: 280,
          ),

          // Instructions
          const ScannerInstructions(),

          // Top Controls
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Close button
                _CircularButton(
                  icon: Icons.close,
                  onPressed: () => Navigator.pop(context),
                ),

                Row(
                  children: [
                    // Torch button
                    _CircularButton(
                      icon: _torchEnabled
                          ? Icons.flash_on
                          : Icons.flash_off,
                      onPressed: _toggleTorch,
                      isActive: _torchEnabled,
                    ),
                    const SizedBox(width: 12),
                    
                    // Camera switch button
                    _CircularButton(
                      icon: Icons.flip_camera_ios,
                      onPressed: _switchCamera,
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Bottom Controls
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Column(
              children: [
                // Manual input button
                ElevatedButton.icon(
                  onPressed: _manualInput,
                  icon: const Icon(Icons.keyboard),
                  label: const Text('Enter Manually'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.2),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Processing indicator
          if (_isProcessing)
            Container(
              color: Colors.black54,
              child: const Center(
                child: CircularProgressIndicator(
                  color: AppColors.secondary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Widget untuk tombol circular
class _CircularButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final bool isActive;

  const _CircularButton({
    required this.icon,
    required this.onPressed,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isActive
          ? AppColors.secondary.withOpacity(0.8)
          : Colors.black.withOpacity(0.5),
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        child: Container(
          padding: const EdgeInsets.all(12),
          child: Icon(
            icon,
            color: Colors.white,
            size: 24,
          ),
        ),
      ),
    );
  }
}

/// Dialog untuk manual input QR content
class _ManualInputDialog extends StatefulWidget {
  final Function(String) onSubmit;

  const _ManualInputDialog({
    required this.onSubmit,
  });

  @override
  State<_ManualInputDialog> createState() => _ManualInputDialogState();
}

class _ManualInputDialogState extends State<_ManualInputDialog> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Request focus setelah dialog muncul
    Future.delayed(const Duration(milliseconds: 100), () {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Enter QR Content'),
      content: TextField(
        controller: _controller,
        focusNode: _focusNode,
        decoration: const InputDecoration(
          hintText: 'Paste or type QR content here...',
          border: OutlineInputBorder(),
        ),
        maxLines: 3,
        textInputAction: TextInputAction.done,
        onSubmitted: (value) {
          if (value.isNotEmpty) {
            widget.onSubmit(value);
          }
        },
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_controller.text.isNotEmpty) {
              widget.onSubmit(_controller.text);
            }
          },
          child: const Text('Submit'),
        ),
      ],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
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

```

### 8.5 Buat Favorites Screen

Buat file `lib/screens/favorites_screen.dart`:

```dart
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

/// Entry point aplikasi Flutter QR Scanner
/// 
/// Aplikasi ini adalah QR Scanner sederhana dengan fitur:
/// - Scan QR Code menggunakan kamera
/// - Riwayat scan dengan mock data
/// - Favorit scan
/// - Detail scan dengan action sesuai tipe
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set preferred orientations
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppColors.background,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  
  runApp(const QRScannerApp());
}

/// Root widget aplikasi
class QRScannerApp extends StatelessWidget {
  const QRScannerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: _buildLightTheme(),
      darkTheme: _buildDarkTheme(),
      themeMode: ThemeMode.system,
      home: const HomeScreen(),
    );
  }

  /// Build light theme
  ThemeData _buildLightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      
      // Color Scheme
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.surface,
        background: AppColors.background,
        error: AppColors.error,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: AppColors.textPrimary,
        onBackground: AppColors.textPrimary,
        onError: Colors.white,
      ),
      
      // App Bar Theme
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        titleTextStyle: TextStyle(
          fontFamily: AppTypography.fontFamily,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      
      // Card Theme
      cardTheme: const CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        color: AppColors.surface,
      ),
      
      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
          textStyle: AppTypography.button,
        ),
      ),
      
      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: AppTypography.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
        ),
      ),
      
      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
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
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          borderSide: const BorderSide(
            color: AppColors.error,
            width: 1,
          ),
        ),
        hintStyle: AppTypography.bodyMedium.copyWith(
          color: AppColors.textHint,
        ),
      ),
      
      // Floating Action Button Theme
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.secondary,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      
      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textHint,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      
      // Divider Theme
      dividerTheme: DividerThemeData(
        color: AppColors.textHint.withOpacity(0.2),
        thickness: 1,
        space: 1,
      ),
      
      // Snack Bar Theme
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        backgroundColor: AppColors.textPrimary,
        contentTextStyle: AppTypography.bodyMedium.copyWith(
          color: Colors.white,
        ),
      ),
      
      // Dialog Theme
      dialogTheme: const DialogThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        backgroundColor: AppColors.surface,
      ),
      
      // Bottom Sheet Theme
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppSpacing.radiusXl),
          ),
        ),
      ),
      
      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.background,
        selectedColor: AppColors.primary.withOpacity(0.2),
        labelStyle: AppTypography.bodySmall,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: 4,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
        ),
      ),
      
      // Font Family
      fontFamily: AppTypography.fontFamily,
      
      // Text Theme
      textTheme: const TextTheme(
        displayLarge: AppTypography.h1,
        displayMedium: AppTypography.h2,
        displaySmall: AppTypography.h3,
        headlineMedium: AppTypography.h4,
        bodyLarge: AppTypography.bodyLarge,
        bodyMedium: AppTypography.bodyMedium,
        bodySmall: AppTypography.bodySmall,
        labelLarge: AppTypography.button,
        labelSmall: AppTypography.label,
      ),
    );
  }

  /// Build dark theme
  ThemeData _buildDarkTheme() {
    // Dark theme dengan warna yang disesuaikan
    return _buildLightTheme().copyWith(
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primaryLight,
        secondary: AppColors.secondaryLight,
        surface: Color(0xFF2D3436),
        background: Color(0xFF1E1E1E),
        error: AppColors.error,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Colors.white,
        onBackground: Colors.white,
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: const Color(0xFF1E1E1E),
      cardTheme: const CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        color: Color(0xFF2D3436),
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Color(0xFF2D3436),
        foregroundColor: Colors.white,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF2D3436),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          borderSide: BorderSide.none,
        ),
        hintStyle: AppTypography.bodyMedium.copyWith(
          color: Colors.white54,
        ),
      ),
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

## Resources

- [Flutter Documentation](https://docs.flutter.dev)
- [Mobile Scanner Package](https://pub.dev/packages/mobile_scanner)
- [Flutter Widget Catalog](https://docs.flutter.dev/ui/widgets)

---

Arif Budi Atmaja, S.Kom

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

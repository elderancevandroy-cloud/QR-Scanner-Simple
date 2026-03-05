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

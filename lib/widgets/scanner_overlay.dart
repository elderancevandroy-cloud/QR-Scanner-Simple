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

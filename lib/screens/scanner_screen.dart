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

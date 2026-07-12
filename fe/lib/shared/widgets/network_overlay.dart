import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class NetworkOverlay extends StatefulWidget {
  final Widget child;

  const NetworkOverlay({super.key, required this.child});

  @override
  State<NetworkOverlay> createState() => _NetworkOverlayState();
}

class _NetworkOverlayState extends State<NetworkOverlay> {
  late StreamSubscription<List<ConnectivityResult>> _subscription;
  bool _hasInternet = true;

  @override
  void initState() {
    super.initState();
    _checkInitialConnection();
    _subscription = Connectivity().onConnectivityChanged.listen(_updateConnectionStatus);
  }

  Future<void> _checkInitialConnection() async {
    final results = await Connectivity().checkConnectivity();
    _updateConnectionStatus(results);
  }

  void _updateConnectionStatus(List<ConnectivityResult> results) {
    // If the only result is none, we don't have internet
    bool hasConnection = results.isNotEmpty && !results.contains(ConnectivityResult.none);
    // Note: If results contains [ConnectivityResult.none], but also [ConnectivityResult.wifi], 
    // it usually means it has multiple adapters but at least one is connected.
    // To be safe, if ALL results are 'none', then disconnected.
    if (results.length == 1 && results.first == ConnectivityResult.none) {
      hasConnection = false;
    } else if (results.isEmpty) {
      hasConnection = false;
    } else {
      hasConnection = true;
    }

    if (_hasInternet != hasConnection) {
      setState(() {
        _hasInternet = hasConnection;
      });
    }
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      textDirection: TextDirection.ltr,
      children: [
        widget.child,
        if (!_hasInternet)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Material(
              color: Colors.transparent,
              child: SafeArea(
                bottom: false,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  color: Colors.redAccent,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.wifi_off, color: Colors.white, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Tidak ada koneksi internet',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          fontFamily: "QuickSand",
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

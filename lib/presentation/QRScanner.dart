import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:turnstile_admin/theme/AppBar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'assetDetail.dart';
import 'dashboardPage.dart';


class QRScanner extends StatefulWidget {
  const QRScanner({super.key});


  @override
  State<QRScanner> createState() => _QRScannerState();
}

class _QRScannerState extends State<QRScanner> {
  late QRViewController controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: AppLocalizations.of(context)!.qr, backgroundColor: Color(0xff071390),
        icon: Icons.dashboard, onPressed: (){
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => dashboardPage()));

        },
      ),
      body: Center(
        child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0), // Adjust the radius as needed
              border: Border.all(color: Colors.black, width: 5.0), // Add border if required
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: QRView(
                key: qrKey,
                onQRViewCreated: _onQRViewCreated,
              ),
            ),
          ),
      ),
    );
  }


  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      String scannedCode = scanData.code!; // Get the scanned code as a string
      print(scannedCode);
      try {
        int assetId = int.parse(scannedCode); // Convert the string to an integer
        print(assetId.runtimeType);

        controller.stopCamera();

        // Navigate to AssetDetailScreen with the parsed integer asset ID
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AssetDetail(assetId: assetId),
          ),
        );
      } catch (e) {
        // Handle the case where the scanned data cannot be parsed as an integer
        print("Error parsing asset ID: $e");
      }
    });
  }}

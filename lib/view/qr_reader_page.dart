import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:native_device_orientation/native_device_orientation.dart';
import 'package:go_router/go_router.dart';

import '../view_model/qr_notifier.dart';

class QRReaderPage extends ConsumerStatefulWidget {
  const QRReaderPage({super.key});
  @override
  ConsumerState<QRReaderPage> createState() => _QRReaderPageState();
}

class _QRReaderPageState extends ConsumerState<QRReaderPage> {
  final MobileScannerController cameraController = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    formats: [BarcodeFormat.qrCode],
  );

  Barcode? barcode;

  BarcodeCapture? capture;

  String? scannedQRCode;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {});
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final qrNotifier = ref.read(qrCodeProvider.notifier);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('RotatedBox with QR Reader'),
        ),
        body: NativeDeviceOrientationReader(
          builder: (context) {
            NativeDeviceOrientation orientation =
                NativeDeviceOrientationReader.orientation(context);

            int turns;

            switch (orientation) {
              case NativeDeviceOrientation.landscapeLeft:
                turns = 3;
                break;
              case NativeDeviceOrientation.landscapeRight:
                turns = 1;
                break;
              case NativeDeviceOrientation.portraitDown:
                turns = 2;
                break;
              default:
                turns = 0;
                break;
            }

            return RotatedBox(
              quarterTurns: turns,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: MobileScanner(
                      controller: cameraController,
                      // onScannerStarted: (args) {
                      //   qrNotifier.setMobileScannerArguments(args!);
                      // },
                      onDetect: (capture) {
                        final barcode = capture.barcodes.first;
                        final qrCodeValue = barcode.rawValue;

                        if (qrCodeValue != null) {
                          qrNotifier.setQRReaderMode(qrCodeValue);
                          setState(() {
                            scannedQRCode = qrCodeValue;
                          });
                        }
                        showModalBottomSheet<void>(
                          context: context,
                          builder: (BuildContext context) {
                            return _ModalBottomSheet();
                          },
                        );
                      },
                      errorBuilder: (context, error, child) {
                        cameraController.stop();
                        cameraController.start();
                        if (!cameraController.isStarting) {
                          showModalBottomSheet<void>(
                            context: context,
                            builder: (BuildContext context) {
                              return _ModalBottomSheet();
                            },
                          );
                        }
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Center(
                            child: Text(
                              error.toString(),
                              style: const TextStyle(
                                fontSize: 20,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: ElevatedButton(
                      onPressed: () {
                        showModalBottomSheet<void>(
                          context: context,
                          builder: (BuildContext context) {
                            return _ModalBottomSheet();
                          },
                        );
                      },
                      child: const Text('Show Modal Bottom Sheet'),
                    ),
                  ),
                ],
              ),
            );
          },
          useSensor: true,
        ),
      ),
    );
  }
}

class _ModalBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text('Modal Bottom Sheet'),
              ElevatedButton(
                onPressed: () {
                  context.pop();
                },
                child: const Text('Close'),
              ),
            ],
          ),
        ));
  }
}

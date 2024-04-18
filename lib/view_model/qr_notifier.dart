import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../model/qr_state.dart';

final qrCodeProvider = StateNotifierProvider<QRReaderNotifier, QRState>(
  (ref) => QRReaderNotifier(),
);

class QRReaderNotifier extends StateNotifier<QRState> {
  QRReaderNotifier() : super(const QRState());

  void setQRReaderMode(String qrReaderMode) {
    state = state.copyWith(qrReaderMode: qrReaderMode);
  }

  void setMobileScannerArguments(
      MobileScannerArguments? mobileScannerArguments) {
    state = state.copyWith(mobileScannerArguments: mobileScannerArguments);
  }
}

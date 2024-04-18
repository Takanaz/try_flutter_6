import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

part '../generated/model/qr_state.freezed.dart';

@freezed
class QRState with _$QRState {
  const factory QRState({
    String? qrReaderMode,
    MobileScannerArguments? mobileScannerArguments,
  }) = _QRState;
}

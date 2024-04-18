import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:try_flutter_6/view/qr_reader_page.dart';

import '../view/native_device_orientation_page.dart';

final GlobalKey<NavigatorState> _navigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');

final router = GoRouter(
  navigatorKey: _navigatorKey,
  initialLocation: '/',
  errorPageBuilder: (context, state) => MaterialPage(
    key: state.pageKey,
    child: Scaffold(
      body: Center(
        child: Text('Page not found: ${state.uri}'),
      ),
    ),
  ),
  routes: [
    GoRoute(
      path: '/',
      pageBuilder: (context, state) => MaterialPage(
        key: state.pageKey,
        child: const NativeDeviceOrientationPage(),
      ),
    ),
    GoRoute(
      path: '/qrreader',
      pageBuilder: (context, state) => MaterialPage(
        key: state.pageKey,
        child: const QRReaderPage(),
      ),
    ),
  ],
);

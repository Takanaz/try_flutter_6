import 'package:flutter/material.dart';

import 'package:native_device_orientation/native_device_orientation.dart';
import 'package:go_router/go_router.dart';

class NativeDeviceOrientationPage extends StatefulWidget {
  const NativeDeviceOrientationPage({super.key});

  @override
  _NativeDeviceOrientationPageState createState() =>
      _NativeDeviceOrientationPageState();
}

class _NativeDeviceOrientationPageState
    extends State<NativeDeviceOrientationPage> {
  // NativeDeviceOrientation orientation = NativeDeviceOrientation.unknown;

  // @override
  // void initState() {
  //   super.initState();
  //   NativeDeviceOrientationCommunicator()
  //       .onOrientationChanged(useSensor: true)
  //       .listen((NativeDeviceOrientation newOrientation) {
  //     setState(() {
  //       orientation = newOrientation;
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Native Device Orientation'),
        actions: [
          IconButton(
            icon: const Icon(Icons.cameraswitch_outlined),
            onPressed: () {
              GoRouter.of(context).go('/qrreader');
            },
          ),
        ],
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
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Orientation: $orientation'),
                  ElevatedButton(
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
                ],
              ),
            ),
          );
        },
        useSensor: true,
      ),
    );

    // return Scaffold(
    //   appBar: AppBar(
    //     title: const Text('Native Device Orientation'),
    //   ),
    //   body: Center(
    //     child: Column(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: <Widget>[
    //         Text('Orientation: $orientation'),
    //         ElevatedButton(
    //           onPressed: () {
    //             showModalBottomSheet<void>(
    //               context: context,
    //               builder: (BuildContext context) {
    //                 return _ModalBottomSheet();
    //               },
    //             );
    //           },
    //           child: const Text('Show Modal Bottom Sheet'),
    //         ),
    //       ],
    //     ),
    //   ),
    // );
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

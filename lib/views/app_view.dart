import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
// ignore_for_file: public_member_api_docs
/// An example of using the plugin, controlling lifecycle and playback of the
/// video.
class VideoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        key: const ValueKey<String>('home_page'),
        appBar: AppBar(
          title: const Text('Video player example'),
          actions: <Widget>[
            IconButton(
              key: const ValueKey<String>('push_tab'),
              icon: const Icon(Icons.navigation),
              onPressed: () {
                Navigator.push<_PlayerVideoAndPopPage>(
                  context,
                  MaterialPageRoute<_PlayerVideoAndPopPage>(
                    builder: (BuildContext context) => _PlayerVideoAndPopPage(),
                  ),
                );
              },
            )
          ],
          bottom: const TabBar(
            isScrollable: true,
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.cloud),
                text: 'Remote',
              ),
              Tab(icon: Icon(Icons.insert_drive_file), text: 'Asset'),
              Tab(icon: Icon(Icons.list), text: 'List example'),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            _BumbleBeeRemoteVideo(),
            _ButterFlyAssetVideo(),
            _ButterFlyAssetVideoInList(),
          ],
        ),
      ),
    );
  }
}
class _ButterFlyAssetVideoInList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        const _ExampleCard(title: 'Item a'),
        const _ExampleCard(title: 'Item b'),
        const _ExampleCard(title: 'Item c'),
        const _ExampleCard(title: 'Item d'),
        const _ExampleCard(title: 'Item e'),
        const _ExampleCard(title: 'Item f'),
        const _ExampleCard(title: 'Item g'),
        Card(
            child: Column(children: <Widget>[
              Column(
                children: <Widget>[
                  const ListTile(
                    leading: Icon(Icons.cake),
                    title: Text('Video video'),
                  ),
                  Stack(
                      alignment: FractionalOffset.bottomRight +
                          const FractionalOffset(-0.1, -0.1),
                      children: <Widget>[
                        _ButterFlyAssetVideo(),
                        Image.asset('assets/flutter-mark-square-64.png'),
                      ]),
                ],
              ),
            ])),
        const _ExampleCard(title: 'Item h'),
        const _ExampleCard(title: 'Item i'),
        const _ExampleCard(title: 'Item j'),
        const _ExampleCard(title: 'Item k'),
        const _ExampleCard(title: 'Item l'),
      ],
    );
  }
}
/// A filler card to show the video in a list of scrolling contents.
class _ExampleCard extends StatelessWidget {
  const _ExampleCard({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: const Icon(Icons.airline_seat_flat_angled),
            title: Text(title),
          ),
          ButtonBar(
            children: <Widget>[
              TextButton(
                child: const Text('BUY TICKETS'),
                onPressed: () {
                  /* ... */
                },
              ),
              TextButton(
                child: const Text('SELL TICKETS'),
                onPressed: () {
                  /* ... */
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
class _ButterFlyAssetVideo extends StatefulWidget {
  @override
  _ButterFlyAssetVideoState createState() => _ButterFlyAssetVideoState();
}
class _ButterFlyAssetVideoState extends State<_ButterFlyAssetVideo> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/Butterfly-209.mp4');

    _controller.addListener(() {
      setState(() {});
    });
    _controller.setLooping(true);
    _controller.initialize().then((_) => setState(() {}));
    _controller.play();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(top: 20.0),
          ),
          const Text('With assets mp4'),
          Container(
            padding: const EdgeInsets.all(20),
            child: AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: <Widget>[
                  VideoPlayer(_controller),
                  _ControlsOverlay(controller: _controller),
                  VideoProgressIndicator(_controller, allowScrubbing: true),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
class _BumbleBeeRemoteVideo extends StatefulWidget {
  @override
  _BumbleBeeRemoteVideoState createState() => _BumbleBeeRemoteVideoState();
}
class _BumbleBeeRemoteVideoState extends State<_BumbleBeeRemoteVideo> {
  late VideoPlayerController _controller;

  Future<ClosedCaptionFile> _loadCaptions() async {
    final String fileContents = await DefaultAssetBundle.of(context)
        .loadString('assets/bumble_bee_captions.vtt');
    return WebVTTCaptionFile(
        fileContents); // For vtt files, use WebVTTCaptionFile
  }

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
      'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
      closedCaptionFile: _loadCaptions(),
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    );

    _controller.addListener(() {
      setState(() {});
    });
    _controller.setLooping(true);
    _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(padding: const EdgeInsets.only(top: 20.0)),
          const Text('With remote mp4'),
          Container(
            padding: const EdgeInsets.all(20),
            child: AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: <Widget>[
                  VideoPlayer(_controller),
                  ClosedCaption(text: _controller.value.caption.text),
                  _ControlsOverlay(controller: _controller),
                  VideoProgressIndicator(_controller, allowScrubbing: true),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
class _ControlsOverlay extends StatelessWidget {
  const _ControlsOverlay({required this.controller});

  static const List<Duration> _exampleCaptionOffsets = <Duration>[
    Duration(seconds: -10),
    Duration(seconds: -3),
    Duration(seconds: -1, milliseconds: -500),
    Duration(milliseconds: -250),
    Duration.zero,
    Duration(milliseconds: 250),
    Duration(seconds: 1, milliseconds: 500),
    Duration(seconds: 3),
    Duration(seconds: 10),
  ];
  static const List<double> _examplePlaybackRates = <double>[
    0.25,
    0.5,
    1.0,
    1.5,
    2.0,
    3.0,
    5.0,
    10.0,
  ];

  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 50),
          reverseDuration: const Duration(milliseconds: 200),
          child: controller.value.isPlaying
              ? const SizedBox.shrink()
              : Container(
            color: Colors.black26,
            child: const Center(
              child: Icon(
                Icons.play_arrow,
                color: Colors.white,
                size: 100.0,
                semanticLabel: 'Play',
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            controller.value.isPlaying ? controller.pause() : controller.play();
          },
        ),
        Align(
          alignment: Alignment.topLeft,
          child: PopupMenuButton<Duration>(
            initialValue: controller.value.captionOffset,
            tooltip: 'Caption Offset',
            onSelected: (Duration delay) {
              controller.setCaptionOffset(delay);
            },
            itemBuilder: (BuildContext context) {
              return <PopupMenuItem<Duration>>[
                for (final Duration offsetDuration in _exampleCaptionOffsets)
                  PopupMenuItem<Duration>(
                    value: offsetDuration,
                    child: Text('${offsetDuration.inMilliseconds}ms'),
                  )
              ];
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                // Using less vertical padding as the text is also longer
                // horizontally, so it feels like it would need more spacing
                // horizontally (matching the aspect ratio of the video).
                vertical: 12,
                horizontal: 16,
              ),
              child: Text('${controller.value.captionOffset.inMilliseconds}ms'),
            ),
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: PopupMenuButton<double>(
            initialValue: controller.value.playbackSpeed,
            tooltip: 'Playback speed',
            onSelected: (double speed) {
              controller.setPlaybackSpeed(speed);
            },
            itemBuilder: (BuildContext context) {
              return <PopupMenuItem<double>>[
                for (final double speed in _examplePlaybackRates)
                  PopupMenuItem<double>(
                    value: speed,
                    child: Text('${speed}x'),
                  )
              ];
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                // Using less vertical padding as the text is also longer
                // horizontally, so it feels like it would need more spacing
                // horizontally (matching the aspect ratio of the video).
                vertical: 12,
                horizontal: 16,
              ),
              child: Text('${controller.value.playbackSpeed}x'),
            ),
          ),
        ),
      ],
    );
  }
}
class _PlayerVideoAndPopPage extends StatefulWidget {
  @override
  _PlayerVideoAndPopPageState createState() => _PlayerVideoAndPopPageState();
}
class _PlayerVideoAndPopPageState extends State<_PlayerVideoAndPopPage> {
  late VideoPlayerController _videoPlayerController;
  bool startedPlaying = false;

  @override
  void initState() {
    super.initState();

    _videoPlayerController =
        VideoPlayerController.asset('assets/Butterfly-209.mp4');
    _videoPlayerController.addListener(() {
      if (startedPlaying && !_videoPlayerController.value.isPlaying) {
        Navigator.pop(context);
      }
    });
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  Future<bool> started() async {
    await _videoPlayerController.initialize();
    await _videoPlayerController.play();
    startedPlaying = true;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: FutureBuilder<bool>(
          future: started(),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (snapshot.data ?? false) {
              return AspectRatio(
                aspectRatio: _videoPlayerController.value.aspectRatio,
                child: VideoPlayer(_videoPlayerController),
              );
            } else {
              return const Text('waiting for video to load');
            }
          },
        ),
      ),
    );
  }
}
class VideoPage extends StatefulWidget {
  const VideoPage({Key? key}) : super(key: key);

  @override
  State<VideoPage> createState() => _VideoPageState();
}
class _VideoPageState extends State<VideoPage> {
  late VideoPlayerController controller;
  @override
  void initState() {
   controller=VideoPlayerController.network('https://youtu.be/VBpyWz8cMMI?list=RDVBpyWz8cMMI')..initialize().then((_) {
         setState(() {
controller.play();
         });
   });
   
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('video tube'),),
      body: Center(
        child: controller.value.isInitialized?AspectRatio(aspectRatio: controller.value.aspectRatio,
        child: VideoPlayer(controller)):SizedBox(),
      ),
    );
  }
}

// import 'dart:math';
// import 'dart:typed_data';
// import 'package:path_provider/path_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:nearby_connections/nearby_connections.dart';
//
// void main() => runApp(MyApp());
//
// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }
//
// class _MyAppState extends State<MyApp> {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('Nearby Connections example app'),
//         ),
//         body: Body(),
//       ),
//     );
//   }
// }
//
// class Body extends StatefulWidget {
//   @override
//   _MyBodyState createState() => _MyBodyState();
// }
//
// class _MyBodyState extends State<Body> {
//   final String userName = Random().nextInt(10000).toString();
//   final Strategy strategy = Strategy.P2P_STAR;
//   Map<String, ConnectionInfo> endpointMap = Map();
//
//   String? tempFileUri; //reference to the file currently being transferred
//   Map<int, String> map =
//   Map(); //store filename mapped to corresponding payloadId
//
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: ListView(
//           children: <Widget>[
//             Text(
//               "Permissions",
//             ),
//             Wrap(
//               children: <Widget>[
//                 ElevatedButton(
//                   child: Text("checkLocationPermission"),
//                   onPressed: () async {
//                     if (await Nearby().checkLocationPermission()) {
//                       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                           content: Text("Location permissions granted :)")));
//                     } else {
//                       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                           content:
//                           Text("Location permissions not granted :(")));
//                     }
//                   },
//                 ),
//                 ElevatedButton(
//                   child: Text("askLocationPermission"),
//                   onPressed: () async {
//                     if (await Nearby().askLocationPermission()) {
//                       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                           content: Text("Location Permission granted :)")));
//                     } else {
//                       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                           content:
//                           Text("Location permissions not granted :(")));
//                     }
//                   },
//                 ),
//                 ElevatedButton(
//                   child: Text("checkExternalStoragePermission"),
//                   onPressed: () async {
//                     if (await Nearby().checkExternalStoragePermission()) {
//                       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                           content:
//                           Text("External Storage permissions granted :)")));
//                     } else {
//                       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                           content: Text(
//                               "External Storage permissions not granted :(")));
//                     }
//                   },
//                 ),
//                 ElevatedButton(
//                   child: Text("askExternalStoragePermission"),
//                   onPressed: () {
//                     Nearby().askExternalStoragePermission();
//                   },
//                 ),
//                 ElevatedButton(
//                   child: Text("checkBluetoothPermission (Android 12+)"),
//                   onPressed: () async {
//                     if (await Nearby().checkBluetoothPermission()) {
//                       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                           content: Text("Bluethooth permissions granted :)")));
//                     } else {
//                       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                           content:
//                           Text("Bluetooth permissions not granted :(")));
//                     }
//                   },
//                 ),
//                 ElevatedButton(
//                   child: Text("askBluetoothPermission (Android 12+)"),
//                   onPressed: () {
//                     Nearby().askBluetoothPermission();
//                   },
//                 ),
//               ],
//             ),
//             Divider(),
//             Text("Location Enabled"),
//             Wrap(
//               children: <Widget>[
//                 ElevatedButton(
//                   child: Text("checkLocationEnabled"),
//                   onPressed: () async {
//                     if (await Nearby().checkLocationEnabled()) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(content: Text("Location is ON :)")));
//                     } else {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(content: Text("Location is OFF :(")));
//                     }
//                   },
//                 ),
//                 ElevatedButton(
//                   child: Text("enableLocationServices"),
//                   onPressed: () async {
//                     if (await Nearby().enableLocationServices()) {
//                       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                           content: Text("Location Service Enabled :)")));
//                     } else {
//                       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                           content:
//                           Text("Enabling Location Service Failed :(")));
//                     }
//                   },
//                 ),
//               ],
//             ),
//             Divider(),
//             Text("User Name: " + userName),
//             Wrap(
//               children: <Widget>[
//                 ElevatedButton(
//                   child: Text("Start Advertising"),
//                   onPressed: () async {
//                     try {
//                       bool a = await Nearby().startAdvertising(
//                         userName,
//                         strategy,
//                         onConnectionInitiated: onConnectionInit,
//                         onConnectionResult: (id, status) {
//                           showSnackbar(status);
//                         },
//                         onDisconnected: (id) {
//                           showSnackbar(
//                               "Disconnected: ${endpointMap[id]!.endpointName}, id $id");
//                           setState(() {
//                             endpointMap.remove(id);
//                           });
//                         },
//                       );
//                       showSnackbar("ADVERTISING: " + a.toString());
//                     } catch (exception) {
//                       showSnackbar(exception);
//                     }
//                   },
//                 ),
//                 ElevatedButton(
//                   child: Text("Stop Advertising"),
//                   onPressed: () async {
//                     await Nearby().stopAdvertising();
//                   },
//                 ),
//               ],
//             ),
//             Wrap(
//               children: <Widget>[
//                 ElevatedButton(
//                   child: Text("Start Discovery"),
//                   onPressed: () async {
//                     try {
//                       bool a = await Nearby().startDiscovery(
//                         userName,
//                         strategy,
//                         onEndpointFound: (id, name, serviceId) {
//                           // show sheet automatically to request connection
//                           showModalBottomSheet(
//                             context: context,
//                             builder: (builder) {
//                               return Center(
//                                 child: Column(
//                                   children: <Widget>[
//                                     Text("id: " + id),
//                                     Text("Name: " + name),
//                                     Text("ServiceId: " + serviceId),
//                                     ElevatedButton(
//                                       child: Text("Request Connection"),
//                                       onPressed: () {
//                                         Navigator.pop(context);
//                                         Nearby().requestConnection(
//                                           userName,
//                                           id,
//                                           onConnectionInitiated: (id, info) {
//                                             onConnectionInit(id, info);
//                                           },
//                                           onConnectionResult: (id, status) {
//                                             showSnackbar(status);
//                                           },
//                                           onDisconnected: (id) {
//                                             setState(() {
//                                               endpointMap.remove(id);
//                                             });
//                                             showSnackbar(
//                                                 "Disconnected from: ${endpointMap[id]!.endpointName}, id $id");
//                                           },
//                                         );
//                                       },
//                                     ),
//                                   ],
//                                 ),
//                               );
//                             },
//                           );
//                         },
//                         onEndpointLost: (id) {
//                           showSnackbar(
//                               "Lost discovered Endpoint: ${endpointMap[id]!.endpointName}, id $id");
//                         },
//                       );
//                       showSnackbar("DISCOVERING: " + a.toString());
//                     } catch (e) {
//                       showSnackbar(e);
//                     }
//                   },
//                 ),
//                 ElevatedButton(
//                   child: Text("Stop Discovery"),
//                   onPressed: () async {
//                     await Nearby().stopDiscovery();
//                   },
//                 ),
//               ],
//             ),
//             Text("Number of connected devices: ${endpointMap.length}"),
//             ElevatedButton(
//               child: Text("Stop All Endpoints"),
//               onPressed: () async {
//                 await Nearby().stopAllEndpoints();
//                 setState(() {
//                   endpointMap.clear();
//                 });
//               },
//             ),
//             Divider(),
//             Text(
//               "Sending Data",
//             ),
//             ElevatedButton(
//               child: Text("Send Random Bytes Payload"),
//               onPressed: () async {
//                 endpointMap.forEach((key, value) {
//                   String a = Random().nextInt(100).toString();
//
//                   showSnackbar("Sending $a to ${value.endpointName}, id: $key");
//                   Nearby()
//                       .sendBytesPayload(key, Uint8List.fromList(a.codeUnits));
//                 });
//               },
//             ),
//             ElevatedButton(
//               child: Text("Send File Payload"),
//               onPressed: () async {
//                 XFile? file =
//                 await ImagePicker().pickImage(source: ImageSource.gallery);
//
//                 if (file == null) return;
//
//                 for (MapEntry<String, ConnectionInfo> m
//                 in endpointMap.entries) {
//                   int payloadId =
//                   await Nearby().sendFilePayload(m.key, file.path);
//                   showSnackbar("Sending file to ${m.key}");
//                   Nearby().sendBytesPayload(
//                       m.key,
//                       Uint8List.fromList(
//                           "$payloadId:${file.path.split('/').last}".codeUnits));
//                 }
//               },
//             ),
//             ElevatedButton(
//               child: Text("Print file names."),
//               onPressed: () async {
//                 final dir = (await getExternalStorageDirectory())!;
//                 final files = (await dir.list(recursive: true).toList())
//                     .map((f) => f.path)
//                     .toList()
//                     .join('\n');
//                 showSnackbar(files);
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   void showSnackbar(dynamic a) {
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//       content: Text(a.toString()),
//     ));
//   }
//
//   Future<bool> moveFile(String uri, String fileName) async {
//     String parentDir = (await getExternalStorageDirectory())!.absolute.path;
//     final b =
//     await Nearby().copyFileAndDeleteOriginal(uri, '$parentDir/$fileName');
//
//     showSnackbar("Moved file:" + b.toString());
//     return b;
//   }
//
//   /// Called upon Connection request (on both devices)
//   /// Both need to accept connection to start sending/receiving
//   void onConnectionInit(String id, ConnectionInfo info) {
//     showModalBottomSheet(
//       context: context,
//       builder: (builder) {
//         return Center(
//           child: Column(
//             children: <Widget>[
//               Text("id: " + id),
//               Text("Token: " + info.authenticationToken),
//               Text("Name" + info.endpointName),
//               Text("Incoming: " + info.isIncomingConnection.toString()),
//               ElevatedButton(
//                 child: Text("Accept Connection"),
//                 onPressed: () {
//                   Navigator.pop(context);
//                   setState(() {
//                     endpointMap[id] = info;
//                   });
//                   Nearby().acceptConnection(
//                     id,
//                     onPayLoadRecieved: (endid, payload) async {
//                       if (payload.type == PayloadType.BYTES) {
//                         String str = String.fromCharCodes(payload.bytes!);
//                         showSnackbar(endid + ": " + str);
//
//                         if (str.contains(':')) {
//                           // used for file payload as file payload is mapped as
//                           // payloadId:filename
//                           int payloadId = int.parse(str.split(':')[0]);
//                           String fileName = (str.split(':')[1]);
//
//                           if (map.containsKey(payloadId)) {
//                             if (tempFileUri != null) {
//                               moveFile(tempFileUri!, fileName);
//                             } else {
//                               showSnackbar("File doesn't exist");
//                             }
//                           } else {
//                             //add to map if not already
//                             map[payloadId] = fileName;
//                           }
//                         }
//                       } else if (payload.type == PayloadType.FILE) {
//                         showSnackbar(endid + ": File transfer started");
//                         tempFileUri = payload.uri;
//                       }
//                     },
//                     onPayloadTransferUpdate: (endid, payloadTransferUpdate) {
//                       if (payloadTransferUpdate.status ==
//                           PayloadStatus.IN_PROGRESS) {
//                         print(payloadTransferUpdate.bytesTransferred);
//                       } else if (payloadTransferUpdate.status ==
//                           PayloadStatus.FAILURE) {
//                         print("failed");
//                         showSnackbar(endid + ": FAILED to transfer file");
//                       } else if (payloadTransferUpdate.status ==
//                           PayloadStatus.SUCCESS) {
//                         showSnackbar(
//                             "$endid success, total bytes = ${payloadTransferUpdate.totalBytes}");
//
//                         if (map.containsKey(payloadTransferUpdate.id)) {
//                           //rename the file now
//                           String name = map[payloadTransferUpdate.id]!;
//                           moveFile(tempFileUri!, name);
//                         } else {
//                           //bytes not received till yet
//                           map[payloadTransferUpdate.id] = "";
//                         }
//                       }
//                     },
//                   );
//                 },
//               ),
//               ElevatedButton(
//                 child: Text("Reject Connection"),
//                 onPressed: () async {
//                   Navigator.pop(context);
//                   try {
//                     await Nearby().rejectConnection(id);
//                   } catch (e) {
//                     showSnackbar(e);
//                   }
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
// return Scaffold(
// appBar: AppBar(title: Text('app page'),),
// body: Container(
// width: double.infinity,
// child: Expanded(child: MainListView())
// // Column(
// //   children: [
// //    Container(
// //      width: double.infinity,
// //      height: 100,
// //      child: ReagentsListView(data: 'reagent name',),
// //    ),
// //     Container(
// //       width: double.infinity,
// //       height: 100,
// //       child: ReagentsListView(data: 'lot number',),
// //     ),
// //     Container(
// //       width: double.infinity,
// //       height: 100,
// //       child: ReagentsListView(data: 'minimum count',),
// //     ),
// //     Container(
// //       width: double.infinity,
// //       height: 100,
// //       child: ReagentsListView(data: 'stock temperature',),
// //     ),
// //     SizedBox(height: 10,),
// //     Expanded(child: MainListView())
// //   ],
// // ),
// ),
// );
// class ReagentsListView extends StatelessWidget {
//   const ReagentsListView({Key? key,required this.data}) : super(key: key);
// final String data;
//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       scrollDirection: Axis.horizontal,
//       itemCount: 10,
//         itemBuilder:(context,index){
//             return Container(
//               width: 100,
//               height: 100,
//               decoration: BoxDecoration(
//                 border: Border.all(color: Colors.black54)
//               ),
//               child: Text(data),
//             );
//         });
//   }
// }
// class MainListView extends StatelessWidget {
//   const MainListView({Key? key}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       scrollDirection: Axis.horizontal,
//         itemCount: 10,//count of lots
//         itemBuilder:(c,i){
//         // get all lots =>[lots]
//         // get reagent by reagent id from lots[index]
//         // get lot operation from lot_track by lot_number=>[lotTrarck]
//           return Column(
//             children: [
//               Container(
//                 width:100 ,
//                 height: 100,
//                 child: Text('reagent name'),//reagent(reagent_id from lot)
//               ),
//               Container(
//                 width:100 ,
//                 height: 100,
//                 child: Text('lot number'),// lot.lotnumber
//               ),
//               Container(
//                 width:100 ,
//                 height: 100,
//                 child: Text('min count'),//reagent.mincount
//               ),
//               Container(
//                 width:100 ,
//                 height: 100,
//                 child: Text('stock temp'),//reagent.temp
//               ),
//               Expanded(
//                 child: Container(
//                   width: 100,
//                   child: ListView.builder(
//                       itemCount: 10,
//                       itemBuilder: (c,i){
//                         return
//                           Column(
//                           children: [
//                             Container(
//                               width: 100,
//                               height: 100,
//                               decoration: BoxDecoration(
//                                   border: Border.all(color: Colors.black54)
//                               ),
//                               child: Text('100'),//lot track[index].lotcount
//                             ),
//                             Container(
//                               width: 100,
//                               height: 100,
//                               decoration: BoxDecoration(
//                                   border: Border.all(color: Colors.black54)
//                               ),
//                               child: Text('10'),// lottrack.adding>0? => add : subtract
//                             ),
//
//                           ],
//                         );
//                       }),
//                 ),
//               ),
//               // Container(
//               //   height: 100,
//               //   child: ListView.builder(
//               //       scrollDirection: Axis.horizontal,
//               //       itemCount: 10,
//               //       itemBuilder: (c,i){
//               //         return  Container(
//               //           width: 100,
//               //           height: 100,
//               //           decoration: BoxDecoration(
//               //               border: Border.all(color: Colors.black54)
//               //           ),
//               //           child: Text('adding'),
//               //         );
//               //       }),
//               // ),
//             ],
//           );
//         });
//        }
// }
/*
*  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(onPressed:(){
                        MyCubit.instance(context).decrement();

                      }, child:Text('minus'.toUpperCase())),
                      SizedBox(width: 10,),
                      Text('${MyCubit.instance(context).counter}'),
                      SizedBox(width: 10,),
                      TextButton(onPressed:(){
                        MyCubit.instance(context).increment();
                      }, child:Text('plus'.toUpperCase())),

                    ],
                  )
* */
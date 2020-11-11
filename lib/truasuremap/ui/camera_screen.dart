import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../models/place.dart';

class CameraScreen extends StatefulWidget {
  final Place place;
  CameraScreen(this.place);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  Place place;
  CameraController _controller;

  List<CameraDescription> cameras;
  CameraDescription camera;
  Widget cameraPreview;
  Image image;

  @override
  void initState() {
    setCamera().then(
      (_) {
        _controller = CameraController(
          camera,
          ResolutionPreset.medium,
        );
        _controller.initialize().then(
          (snapshot) {
            cameraPreview = Center(
              child: CameraPreview(_controller),
            );
            setState(() {
              cameraPreview = cameraPreview;
            });
          },
        );
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future setCamera() async {
    cameras = await availableCameras();
    if (cameras.length != 0) {
      camera = cameras.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Take Picture'),
      ),
      body: Container(
        child: cameraPreview,
      ),
    );
  }
}

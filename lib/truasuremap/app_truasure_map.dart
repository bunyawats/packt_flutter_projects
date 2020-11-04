import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() => runApp(MapApp());

class MapApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'The Treasure Map',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainMap(),
    );
  }
}

class MainMap extends StatefulWidget {
  @override
  _MainMapState createState() => _MainMapState();
}

class _MainMapState extends State<MainMap> {
  final CameraPosition position = CameraPosition(
    target: LatLng(13.751330328, 100.489664708),
    zoom: 12,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('The Treasure Map'),
      ),
      body: Container(
        child: GoogleMap(
          initialCameraPosition: position,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

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
  List<Marker> markers = [];

  final CameraPosition position = CameraPosition(
    target: LatLng(13.764, 100.568),
    zoom: 12,
  );

  Future _getCurrentLocation() async {
    bool isGeolocationAvailable = await Geolocator().isLocationServiceEnabled();

    Position _position = Position(
      latitude: this.position.target.latitude,
      longitude: this.position.target.longitude,
    );

    if (isGeolocationAvailable) {
      try {
        _position = await Geolocator().getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best,
        );
      } catch (error) {
        print(error);
      }
    }
    return _position;
  }

  void addMarker(Position pos, String markerId, String markerTitle) {
    final marker = Marker(
      markerId: MarkerId(markerId),
      position: LatLng(pos.latitude, pos.longitude),
      infoWindow: InfoWindow(
        title: markerTitle,
      ),
      icon: (markerId == 'currpos')
          ? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure)
          : BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
    );
    markers.add(marker);
    setState(() {
      markers = markers;
    });
  }

  @override
  void initState() {
    _getCurrentLocation()
        .then(
          (pos) => addMarker(pos, 'currpos', 'You are here!'),
        )
        .catchError(
          (err) => print(err.toString()),
        );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('The Treasure Map'),
      ),
      body: Container(
        child: GoogleMap(
          initialCameraPosition: position,
          markers: Set<Marker>.of(markers),
        ),
      ),
    );
  }
}

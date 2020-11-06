import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hello_world/truasuremap/ui/manage_places.dart';
import 'package:hello_world/truasuremap/ui/place_dialog.dart';
import './helpers/dbhelper.dart';
import './models/place.dart';

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
  DbHelper helper;

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
    print('addMarker: $marker');
    markers.add(marker);
    setState(() {
      markers = markers;
    });
  }

  Future _getData() async {
    await helper.openDb();
    await this.helper.deleteMockData();
    await this.helper.insertMockData();

    // await helper.deleteMockData();
    List places = await helper.getPlaces();
    for (Place p in places) {
      addMarker(
        Position(
          latitude: p.lat,
          longitude: p.lon,
        ),
        p.id.toString(),
        p.name,
      );
    }
    setState(() {
      markers = markers;
    });
  }

  @override
  void initState() {
    this.helper = DbHelper();

    _getData();
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
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.list),
            onPressed: () {
              MaterialPageRoute route = MaterialPageRoute(
                builder: (context) => ManagePlace(),
              );
              Navigator.push(context, route);
            },
          )
        ],
      ),
      body: Container(
        child: GoogleMap(
          initialCameraPosition: position,
          markers: Set<Marker>.of(markers),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add_location),
        onPressed: () {
          int here = markers.indexWhere(
            (p) => p.markerId == MarkerId('currpos'),
          );
          Place place;
          if (here == -1) {
            //the current position is not available
            place = Place(0, '', 0, 0, '');
          } else {
            LatLng pos = markers[here].position;
            place = Place(0, '', pos.latitude, pos.longitude, '');
          }
          PlaceDialog dialog = PlaceDialog(place, true);
          showDialog(
            context: context,
            builder: (context) => dialog.buildAlert(context),
          );
        },
      ),
    );
  }
}

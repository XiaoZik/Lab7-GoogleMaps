import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GMap extends StatefulWidget {
  GMap({Key key}) : super(key: key);

  @override
  _GMapState createState() => _GMapState();
}

class _GMapState extends State<GMap> {
  Set<Marker> _markers = HashSet<Marker>();
  Set<Polygon> _polygons = HashSet<Polygon>();
  Set<Polyline> _polylines = HashSet<Polyline>();
  Set<Circle> _circles = HashSet<Circle>();

  GoogleMapController _mapController;
  BitmapDescriptor _markerIcon;

  @override
  void initState() {
    super.initState();
    _setMarkerIcon();
    _setPolygons();
    _setPolylines();
    _setCircles();
  }

  //method to create a custom marker icon
  void _setMarkerIcon() async {
    _markerIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(), 'assets/shinto-shrine_26e9.png');
  }

  void _setMapStyle() async {
    String style = await DefaultAssetBundle.of(context)
        .loadString('assets/map_style.json');
    _mapController.setMapStyle(style);
  }

  //Create a list of longitudes and langitudes
  void _setPolygons() {
    List<LatLng> polygonLatLongs = [];
    polygonLatLongs.add(LatLng(35.717146, 139.667852));
    polygonLatLongs.add(LatLng(35.718139, 139.664483));
    polygonLatLongs.add(LatLng(35.716499, 139.663850));
    polygonLatLongs.add(LatLng(35.715314, 139.665459));
    //Create a polygon and assign them the longitudes and langitudes from the above method
    _polygons.add(
      Polygon(
        polygonId: PolygonId("0"),
        points: polygonLatLongs,
        fillColor: Colors.white,
        strokeWidth: 1,
      ),
    );
  }

//Create a list of longitudes and langitudes
  void _setPolylines() {
    List<LatLng> polylineLatLongs = [];
    polylineLatLongs.add(LatLng(35.644039, 139.631435));
    polylineLatLongs.add(LatLng(35.643655, 139.634471));
    polylineLatLongs.add(LatLng(35.642783, 139.633774));
    polylineLatLongs.add(LatLng(35.642033, 139.629751));
    polylineLatLongs.add(LatLng(35.644039, 139.631435));
//Create a set of polylines from the above longitudes and langitudes
    _polylines.add(
      Polyline(
        polylineId: PolylineId("0"),
        points: polylineLatLongs,
        color: Colors.purple,
        width: 1,
      ),
    );
  }

//create a circle
  void _setCircles() {
    _circles.add(
      Circle(
          circleId: CircleId("0"),
          center: LatLng(35.6762, 139.6503),
          radius: 1000,
          strokeWidth: 2,
          fillColor: Color.fromRGBO(102, 51, 153, .5)),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;

    setState(() {
      //to add a marker on top of the designated position with the set title and snippet
      _markers.add(
        Marker(
            markerId: MarkerId("0"),
            position: LatLng(35.6762, 139.6503),
            infoWindow: InfoWindow(
              title: "Tokyo",
              snippet: "Old meets New",
            ),
            icon: _markerIcon),
      );
    });
    _setMapStyle();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Map')),
      body: Stack(
        children: <Widget>[
          GoogleMap(
            onMapCreated: _onMapCreated,
            //Initial coordinate of Tokyo, Japan
            initialCameraPosition: CameraPosition(
              target: LatLng(35.6762, 139.6503),
              zoom: 12,
            ),
            markers: _markers,
            polygons: _polygons,
            polylines: _polylines,
            circles: _circles,
            myLocationEnabled: true,
          ),
          //Add a text overlay at the center bottom of the screen
          Container(
            alignment: Alignment.bottomCenter,
            padding: EdgeInsets.fromLTRB(0, 0, 0, 80),
            child: Text("Tokyo, Japan",
                style: const TextStyle(color: Colors.white)),
          )
        ],
      ),
    );
  }
}

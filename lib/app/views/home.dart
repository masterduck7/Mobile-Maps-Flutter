import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:open_route_service/open_route_service.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';


class MapsWidget extends StatefulWidget {
  const MapsWidget({super.key});

  @override
  State<MapsWidget> createState() => _MapsWidgetState();
}

class _MapsWidgetState extends State<MapsWidget> {
  String originAddress = "";
  String destinationAddress = "";

  double startLat = -33.418973;
  double startLng = -70.603883;
  double endLat = -33.421731;
  double endLng = -70.557491;

  Future<List<LatLng>> _getMarkers() async {
    final OpenRouteService client = OpenRouteService(apiKey: '5b3ce3597851110001cf62488cc3fa394381496ebd8cf121dcf76d07');
    final List<ORSCoordinate> routeCoordinates = await client.directionsRouteCoordsGet(
      startCoordinate: ORSCoordinate(latitude: startLat, longitude: startLng),
      endCoordinate: ORSCoordinate(latitude: endLat, longitude: endLng),
    );

    List<LatLng> points = [];
    for (var coordinate in routeCoordinates){
      points.add(LatLng(coordinate.latitude, coordinate.longitude));
    }

    return points;
  }

  Future<LatLng> _fetchDirection(String address) async {
    var response = await http.get(Uri.parse('https://api.openrouteservice.org/geocode/search?api_key=5b3ce3597851110001cf62488cc3fa394381496ebd8cf121dcf76d07&text=$address'));
    var addressFetched = json.decode(response.body);
    LatLng coordinate = LatLng(
        addressFetched["features"][0]["geometry"]["coordinates"][1],
        addressFetched["features"][0]["geometry"]["coordinates"][0]
    );

    return coordinate;
  }

  @override
  Widget build(BuildContext context) {
    Marker origin = Marker(
        point: LatLng(startLat, startLng),
        builder: (ctx) => const FlutterLogo()
    );

    Marker destination = Marker(
        point: LatLng(endLat, endLng),
        builder: (ctx) => const FlutterLogo()
    );

    getDirections() async {
      if (originAddress != "" && destinationAddress != "") {
        LatLng origin = await _fetchDirection(originAddress);
        LatLng destination = await _fetchDirection(destinationAddress);
        setState(() {
          startLat = origin.latitude;
          startLng = origin.longitude;
          endLat = destination.latitude;
          endLng = destination.longitude;
        });
      }
    }

    return FutureBuilder(
      future: _getMarkers(),
      builder: (context,snapshot){
        if ( snapshot.data != null){
          List<LatLng> points = snapshot.data!;
          return Scaffold(
            appBar: AppBar(title: const Center(child: Text("Maps"))),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 8),
                  child: TextField(
                    onChanged: (value) { originAddress= value; },
                    decoration: const InputDecoration(border: OutlineInputBorder(),labelText: "Origin"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 8),
                  child: TextField(
                    onChanged: (value) { destinationAddress= value; },
                    decoration: const InputDecoration(border: OutlineInputBorder(),labelText: "Destination"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 8),
                  child: OutlinedButton(
                      onPressed: () {getDirections();},
                      child: const Text("Go")
                  ),
                ),
                Flexible(
                    child: FlutterMap(
                      options: MapOptions(center: LatLng(-33.420549, -70.581652)),
                      children: [
                        TileLayer(urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png', userAgentPackageName: 'dev.fleaflet.flutter_map.example',),
                        MarkerLayer(
                          markers: [origin, destination],
                        ),
                        PolylineLayer(
                          polylineCulling: false,
                          polylines: [
                            Polyline(points: points, color: Colors.greenAccent, strokeWidth: 10, isDotted: true, borderStrokeWidth: 7, borderColor: Colors.black),
                          ],
                        )
                      ],
                    ),
                )
              ],
            ),
          );
        }
        else {
          return Scaffold(
            appBar: AppBar(title: const Center(child: Text("Maps"))),
            body: const Center(
              child: Text("Loading"),
            ),
          );
        }
      },
    );
  }
}
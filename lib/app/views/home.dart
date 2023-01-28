import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:open_route_service/open_route_service.dart';
import 'package:latlong2/latlong.dart';


class MapsWidget extends StatefulWidget {
  const MapsWidget({super.key});

  @override
  State<MapsWidget> createState() => _MapsWidgetState();
}

class _MapsWidgetState extends State<MapsWidget> {
  Future<List<LatLng>> _getMarkers() async {
    final OpenRouteService client = OpenRouteService(apiKey: '5b3ce3597851110001cf62488cc3fa394381496ebd8cf121dcf76d07');

    // Example coordinates to test between
    const double startLat = -33.418973;
    const double startLng = -70.603883;
    const double endLat = -33.421731;
    const double endLng = -70.557491;

    // Form Route between coordinates
    final List<ORSCoordinate> routeCoordinates = await client.directionsRouteCoordsGet(
      startCoordinate: const ORSCoordinate(latitude: startLat, longitude: startLng),
      endCoordinate: const ORSCoordinate(latitude: endLat, longitude: endLng),
    );

    List<LatLng> points = [];
    for (var coordinate in routeCoordinates){
      points.add(LatLng(coordinate.latitude, coordinate.longitude));
    }

    List<Marker> markers = routeCoordinates
        .map((coordinate) =>
        Marker(
            point: LatLng(coordinate.latitude, coordinate.longitude),
            builder: (ctx) => const FlutterLogo(
              textColor: Colors.red,
              key: ObjectKey(Colors.red),
            )
        )
    ).toList();

    return points;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getMarkers(),
      builder: (context,snapshot){
        if ( snapshot.data != null){
          List<LatLng> points = snapshot.data!;
          return Scaffold(
            appBar: AppBar(title: const Text("Yes")),
            body: FlutterMap(
                options: MapOptions(center: LatLng(-33.420549, -70.581652)),
                children: [
                  TileLayer(urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png', userAgentPackageName: 'dev.fleaflet.flutter_map.example',),
                  PolylineLayer(
                    polylineCulling: false,
                    polylines: [
                      Polyline(points: points, color: Colors.greenAccent, strokeWidth: 10, isDotted: true, borderStrokeWidth: 7, borderColor: Colors.black),
                    ],
                  )
                ],
            ),
          );
        }
        else {
          return const Text("no");
        }
      },
    );
  }
}

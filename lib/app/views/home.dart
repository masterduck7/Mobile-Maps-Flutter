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
  Future<List<Marker>> _getMarkers() async {
    final OpenRouteService client = OpenRouteService(apiKey: '5b3ce3597851110001cf62488cc3fa394381496ebd8cf121dcf76d07');

    // Example coordinates to test between
    const double startLat = -51.698441;
    const double startLng = -57.879153;
    const double endLat = -51.693653;
    const double endLng = -57.857008;

    // Form Route between coordinates
    final List<ORSCoordinate> routeCoordinates = await client.directionsRouteCoordsGet(
      startCoordinate: const ORSCoordinate(latitude: startLat, longitude: startLng),
      endCoordinate: const ORSCoordinate(latitude: endLat, longitude: endLng),
    );

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

    return markers;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getMarkers(),
      builder: (context,snapshot){
        if ( snapshot.data != null){
          List<Marker> markers = snapshot.data!;
          return Scaffold(
            appBar: AppBar(title: const Text("Yes")),
            body: FlutterMap(
                options: MapOptions(center: LatLng(-51.694132, -57.862244)),
                children: [
                  TileLayer(urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png', userAgentPackageName: 'dev.fleaflet.flutter_map.example',),
                  MarkerLayer(markers: markers)
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

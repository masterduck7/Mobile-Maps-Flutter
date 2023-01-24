// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong2/latlong.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MapsWidget(),
    );
  }
}

class MapsWidget extends StatefulWidget {
  const MapsWidget({super.key});

  @override
  State<MapsWidget> createState() => _MapsWidgetState();
}

class _MapsWidgetState extends State<MapsWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Maps"),
        ),
        body: FlutterMap(
          options: MapOptions(center: LatLng(-51.694132, -57.862244)),
          children: [
            TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'dev.fleaflet.flutter_map.example'),
            MarkerLayer(
              markers: [
                Marker(
                    point: LatLng(-51.694132, -57.862244),
                    builder: (ctx) => const FlutterLogo(
                          textColor: Colors.red,
                          key: ObjectKey(Colors.red),
                        ))
              ],
            )
          ],
        ));
  }
}

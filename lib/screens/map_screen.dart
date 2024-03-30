import 'package:favorite_places_app/models/place_location.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({
    super.key,
    this.location =
        const PlaceLocation(latitude: 28.6139, longitude: 77.2090, address: ''),
    this.isSelecting = true,
  });

  final PlaceLocation location;
  final bool isSelecting;

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  LatLng? _pickedLoaction;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isSelecting ? 'Pick your location' : 'Your loaction',
        ),
      ),
      floatingActionButton: widget.isSelecting
          ? FloatingActionButton(
              onPressed: () {
                Navigator.of(context).pop(_pickedLoaction);
              },
              child: const Icon(
                Icons.save,
              ),
            )
          : null,
      body: GoogleMap(
        zoomGesturesEnabled: true,
        zoomControlsEnabled: false,
        onTap: !widget.isSelecting
            ? null
            : (position) {
                setState(() {
                  _pickedLoaction = position;
                });
              },
        initialCameraPosition: CameraPosition(
          target: LatLng(
            widget.location.latitude,
            widget.location.longitude,
          ),
          zoom: 10,
        ),
        markers: (_pickedLoaction == null && widget.isSelecting)
            ? {}
            : {
                Marker(
                  markerId: const MarkerId(
                    'm1',
                  ),
                  position: _pickedLoaction != null
                      ? _pickedLoaction!
                      : LatLng(
                          widget.location.latitude,
                          widget.location.longitude,
                        ),
                ),
              },
      ),
    );
  }
}

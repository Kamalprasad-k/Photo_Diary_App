import 'dart:convert';

import 'package:favorite_places_app/main.dart';
import 'package:favorite_places_app/models/place_location.dart';

import 'package:favorite_places_app/screens/map_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

class LoactionInput extends StatefulWidget {
  const LoactionInput({super.key, required this.saveLoaction});

  final void Function(PlaceLocation location) saveLoaction;

  @override
  State<LoactionInput> createState() => _LoactionInputState();
}

class _LoactionInputState extends State<LoactionInput> {
  var isGettingLoaction = false;
  PlaceLocation? pickedLoaction;

  String get locationImage {
    if (pickedLoaction == null) {
      return '';
    }

    final lat = pickedLoaction!.latitude;
    final lng = pickedLoaction!.longitude;

    return 'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$lng&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:C%7C$lat,$lng&key=AIzaSyC_949SFPGneIttJyLwNdoXp4vZUtKpHco';
  }

  void _saveLoaction(double lat, double lng) async {
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=AIzaSyC_949SFPGneIttJyLwNdoXp4vZUtKpHco');
    final response = await http.get(url);
    final resData = json.decode(response.body);
    final address = resData["results"][0]["formatted_address"];

    setState(() {
      pickedLoaction =
          PlaceLocation(latitude: lat, longitude: lng, address: address);
      isGettingLoaction = false;
    });
    widget.saveLoaction(pickedLoaction!);
  }

  void _getLoaction() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    setState(() {
      isGettingLoaction = true;
    });

    locationData = await location.getLocation();
    final lat = locationData.latitude;
    final lng = locationData.longitude;

    if (lat == null || lng == null) {
      return;
    }
    _saveLoaction(lat, lng);
  }

  @override
  Widget build(BuildContext context) {
    void selectOnMap() async {
      final pickedLoaction = await Navigator.of(context).push<LatLng>(
        MaterialPageRoute(
          builder: (context) => const MapScreen(),
        ),
      );
      if (pickedLoaction == null) {
        return;
      }
      _saveLoaction(pickedLoaction.latitude, pickedLoaction.longitude);
    }

    Widget previewContent = Text(
      'No loaction chosen.',
      style: TextStyle(color: colorScheme.onBackground),
    );

    if (isGettingLoaction) {
      previewContent = const CircularProgressIndicator();
    }

    if (pickedLoaction != null) {
      previewContent = ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.network(
          locationImage,
          fit: BoxFit.cover,
          height: double.infinity,
          width: double.infinity,
        ),
      );
    }

    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          height: 160,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: colorScheme.primary,
            ),
          ),
          child: previewContent,
        ),
        const SizedBox(
          height: 2,
        ),
        const Text('*Please check your internet connection before selecting*',style: TextStyle(fontSize: 12),),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton.icon(
              onPressed: _getLoaction,
              icon: const Icon(Icons.location_on),
              label: const Text('Get current location'),
            ),
            const SizedBox(
              width: 4,
            ),
            TextButton.icon(
              onPressed: selectOnMap,
              icon: const Icon(Icons.map),
              label: const Text('Select on map'),
            ),
          ],
        )
      ],
    );
  }
}

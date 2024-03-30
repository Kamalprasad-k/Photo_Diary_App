import 'dart:io';
import 'package:favorite_places_app/models/place_location.dart';

import 'package:uuid/uuid.dart';

const uuid = Uuid();

class Place {
  final String id;

  final String title;

  final String date;

  final String notes;

  final File image;

  final PlaceLocation location;

  Place({
    required this.title,
    required this.notes,
    required this.image,
    required this.location,
    required this.date,
    String? id,
  }) : id = id ?? uuid.v4();
}

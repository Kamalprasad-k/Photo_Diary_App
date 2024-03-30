import 'dart:io';
import 'package:favorite_places_app/models/place_location.dart';
import 'package:favorite_places_app/models/places.dart';
import 'package:riverpod/riverpod.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

Future<Database> _getDatabase() async {
  final dbPath = await sql.getDatabasesPath();
  final db = await sql.openDatabase(path.join(dbPath, 'memories.db'),
      onCreate: (db, version) {
    db.execute(
        'CREATE TABLE user_memories(id TEXT PRIMARY KEY, title TEXT,date TEXT, notes TEXT, image TEXT, lat REAL, lng REAL, address TEXT)');
  }, version: 1);
  return db;
}

class UserPlaceNotifier extends StateNotifier<List<Place>> {
  UserPlaceNotifier() : super([]);

  void addPlace(String title, String date, String notes, File image,
      PlaceLocation location) async {
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final fileName = path.basename(image.path);
    final copiedImage = await image.copy('${appDir.path}/$fileName');

    final newPlace = Place(
      title: title,
      date: date,
      notes: notes,
      image: copiedImage,
      location: location,
    );

    final db = await _getDatabase();
    db.insert('user_memories', {
      'id': newPlace.id,
      'title': newPlace.title,
      'notes': newPlace.notes,
      'image': newPlace.image.path,
      'lat': newPlace.location.latitude,
      'lng': newPlace.location.longitude,
      'address': newPlace.location.address,
      'date': newPlace.date,
    });

    state = [newPlace, ...state];
  }

  Future<void> loadData() async {
    final db = await _getDatabase();
    final data = await db.query('user_memories');
    final places = data
        .map(
          (row) => Place(
            id: row['id'] as String,
            title: row['title'] as String,
            date: row['date'] as String,
            notes: row['notes'] as String,
            image: File(row['image'] as String),
            location: PlaceLocation(
              latitude: row['lat'] as double,
              longitude: row['lng'] as double,
              address: row['address'] as String,
            ),
          ),
        )
        .toList();
    state = places;
  }

  void deletePlace(Place place) async {
    final db = await _getDatabase();
    await db.delete('user_memories', where: 'id = ?', whereArgs: [place.id]);

    state = state.where((p) => p.id != place.id).toList();
  }
}

final userPlaceProvider = StateNotifierProvider<UserPlaceNotifier, List<Place>>(
    (ref) => UserPlaceNotifier());

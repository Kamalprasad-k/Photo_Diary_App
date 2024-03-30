import 'package:favorite_places_app/main.dart';
import 'package:favorite_places_app/models/places.dart';
import 'package:favorite_places_app/screens/place_details.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PlacesList extends StatelessWidget {
  const PlacesList({super.key, required this.places});

  final List<Place> places;

  @override
  Widget build(BuildContext context) {
    if (places.isEmpty) {
      return Center(
        child: Text(
          'No memories added yet :)',
          style: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(color: Theme.of(context).colorScheme.onBackground),
        ),
      );
    }
    return ListView.builder(
      itemCount: places.length,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4,horizontal: 8),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(
              14,
            ),
          ),
          child: ListTile(
            leading: CircleAvatar(
              radius: 24,
              backgroundImage: FileImage(
                places[index].image,
              ),
            ),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => PlaceDetailsScreen(
                    place: places[index],
                    parentContext: context,
                  ),
                ),
              );
            },
            title: Text(places[index].title,
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground),maxLines: 1,overflow: TextOverflow.ellipsis,),
            subtitle: Text(
              places[index].notes,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(color: colorScheme.primary),
            ),
            trailing: Text(
              DateFormat('dd/MM/yyyy').format(
                DateTime.parse(places[index].date),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

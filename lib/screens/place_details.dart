import 'package:favorite_places_app/main.dart';
import 'package:favorite_places_app/models/places.dart';
import 'package:favorite_places_app/provider/user_input_provider.dart';
import 'package:favorite_places_app/services/ad_mob_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

class PlaceDetailsScreen extends ConsumerStatefulWidget {
  const PlaceDetailsScreen(
      {super.key, required this.place, required this.parentContext});

  final Place place;
  final BuildContext parentContext;

  String get locationImage {
    final lat = place.location.latitude;
    final lng = place.location.longitude;

    return 'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$lng&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:C%7C$lat,$lng&key=AIzaSyC_949SFPGneIttJyLwNdoXp4vZUtKpHco';
  }

  @override
  ConsumerState<PlaceDetailsScreen> createState() => _PlaceDetailsScreenState();
}

class _PlaceDetailsScreenState extends ConsumerState<PlaceDetailsScreen> {
  InterstitialAd? _interstitialAd;

  @override
  void initState() {
    super.initState();
    _createInterstitialAd();
  }

  void _createInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdMobService.interstitialAdUnitID!,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) => _interstitialAd = ad,
        onAdFailedToLoad: (error) => _interstitialAd = null,
      ),
    );
  }

  void deleteMemory() {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Delete Memory?',
          style: TextStyle(
            color: theme.colorScheme.primary,
          ),
        ),
        content: const Text(
            'Are you sure you want to permanently delete this memory? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () {
              if (_interstitialAd != null) {
                _interstitialAd!.fullScreenContentCallback =
                    FullScreenContentCallback(
                  onAdDismissedFullScreenContent: (ad) {
                    ad.dispose();
                    _createInterstitialAd();
                  },
                  onAdFailedToShowFullScreenContent: (ad, error) {
                    ad.dispose();
                    _createInterstitialAd();
                  },
                );
                _interstitialAd!.show();
                _interstitialAd = null;
              }
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_interstitialAd != null) {
                _interstitialAd!.fullScreenContentCallback =
                    FullScreenContentCallback(
                  onAdDismissedFullScreenContent: (ad) {
                    ad.dispose();
                    _createInterstitialAd();
                  },
                  onAdFailedToShowFullScreenContent: (ad, error) {
                    ad.dispose();
                    _createInterstitialAd();
                  },
                );
                _interstitialAd!.show();
                _interstitialAd = null;
              }
              ref.read(userPlaceProvider.notifier).deletePlace(widget.place);
              Navigator.pop(context);
              Navigator.pop(widget.parentContext);
            },
            child: const Text(
              'Delete',
            ),
          ),
        ],
      ),
    );
  }

  void showInfo() {
    final d = DateTime.parse(widget.place.date);
    final date = DateFormat('dd/MM/yyyy').format(d);
    showModalBottomSheet(
      context: context,
      builder: (context) => ClipRRect(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20),
        ),
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(color: theme.colorScheme.background),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        widget.place.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleSmall!.copyWith(
                          color: theme.colorScheme
                              .primary, // Adjust text color as needed
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(
                        date.toString(),
                        style: theme.textTheme.bodySmall!.copyWith(
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    widget.place.notes,
                    style: theme.textTheme.bodyMedium!.copyWith(
                      color: Colors.black, // Adjust text color as needed
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                    alignment: Alignment.center,
                    height: 120,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        widget.locationImage,
                        fit: BoxFit.cover,
                        height: double.infinity,
                        width: double.infinity,
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(
                            child: Text(
                              '*Check your internet connection to view the map view*',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12,
                                color:
                                    Colors.red, // Adjust text color as needed
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    widget.place.location.address,
                    style: theme.textTheme.bodyMedium!.copyWith(
                      color: theme
                          .colorScheme.secondary, // Adjust text color as needed
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.place.title,
          style: theme.textTheme.titleSmall,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        backgroundColor: theme.colorScheme.background,
      ),
      body: Column(
        children: [
          Expanded(
            child: SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    widget.place.image,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primary.withOpacity(0.8),
                    theme.colorScheme.primary,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.share,
                      color: Colors.white70,
                      size: 20,
                    ),
                    onPressed: () {
                      final String title = widget.place.title;
                      final String notes = widget.place.notes;
                      final String location = widget.place.location.address;
                      final String date = DateFormat('dd/MM/yyyy')
                          .format(
                            DateTime.parse(
                              widget.place.date,
                            ),
                          )
                          .toString();

                      Share.shareXFiles(
                        [
                          XFile(
                            widget.place.image.path,
                          ),
                        ],
                        text: '$title $date\n\n$notes\n\n$location',
                      );
                    },
                  ),
                  IconButton(
                    onPressed: showInfo,
                    icon: const Icon(
                      Icons.book_outlined,
                      color: Colors.white70,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.delete_outline,
                      color: Colors.white70,
                      size: 24,
                    ),
                    onPressed: deleteMemory,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:favorite_places_app/provider/user_input_provider.dart';
import 'package:favorite_places_app/screens/add_place_screen.dart';
import 'package:favorite_places_app/screens/about_screen.dart'; // Import AboutScreen
import 'package:favorite_places_app/services/ad_mob_service.dart';
import 'package:favorite_places_app/widgets/places_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class PlaceScreen extends ConsumerStatefulWidget {
  const PlaceScreen({super.key});

  @override
  ConsumerState<PlaceScreen> createState() => _PlaceScreenState();
}

class _PlaceScreenState extends ConsumerState<PlaceScreen> {
  BannerAd? _banner;
  late Future<void> _placeFuture;

  @override
  void initState() {
    super.initState();
    _createBannerAd();
    _placeFuture = ref.read(userPlaceProvider.notifier).loadData();
  }

  void _createBannerAd() {
    _banner = BannerAd(
      size: AdSize.fullBanner,
      adUnitId: AdMobService.bannerAdUnitID!,
      listener: AdMobService.bannerAdListener,
      request: const AdRequest(),
    )..load();
  }

  @override
  Widget build(BuildContext context) {
    final userPlace = ref.watch(userPlaceProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: Row(
          children: [
            Image.asset(
              'lib/assets/images/mApp.png',
              height: 30,
              width: 30,
            ),
            const SizedBox(width: 4),
            const Text('Memora'),
          ],
        ),
        actions: [
          PopupMenuButton<int>(
            onSelected: (item) => _handleMenuItemSelected(item, context),
            itemBuilder: (context) => [
              const PopupMenuItem<int>(
                value: 1,
                child: Row(
                  // Wrap About text with Icon
                  children: [
                    Icon(Icons.info), // Info icon
                    SizedBox(width: 8),
                    Text('About'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const AddPlaceScreen(),
            ),
          );
        },
        child: Image.asset(
          'lib/assets/images/feather.png',
          height: 30,
          width: 30,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: FutureBuilder(
          future: _placeFuture,
          builder: (context, snapshot) =>
              snapshot.connectionState == ConnectionState.waiting
                  ? const Center(child: CircularProgressIndicator())
                  : PlacesList(places: userPlace),
        ),
      ),
      bottomNavigationBar: _banner == null
          ? Container()
          : Container(
              margin: const EdgeInsets.only(bottom: 1),
              height: 58,
              child: AdWidget(ad: _banner!),
            ),
    );
  }

  void _handleMenuItemSelected(int item, BuildContext context) {
    switch (item) {
      case 1:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) =>
                const AboutScreen(), // Navigate to AboutScreen
          ),
        );
        break;
    }
  }
}

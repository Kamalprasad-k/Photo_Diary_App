import 'dart:io';
import 'package:favorite_places_app/models/place_location.dart';

import 'package:favorite_places_app/provider/user_input_provider.dart';
import 'package:favorite_places_app/services/ad_mob_service.dart';
import 'package:favorite_places_app/widgets/image_input.dart';
import 'package:favorite_places_app/widgets/loaction_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';

class AddPlaceScreen extends ConsumerStatefulWidget {
  const AddPlaceScreen({super.key});

  @override
  ConsumerState<AddPlaceScreen> createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends ConsumerState<AddPlaceScreen> {
  final _titleController = TextEditingController();
  final _notesController = TextEditingController();
  DateTime? _selectedDate;
  File? _selectedImage;
  PlaceLocation? _selectedLocation;
  BannerAd? _banner;
  RewardedAd? _rewardedAd;

  @override
  void initState() {
    super.initState();
    _createBannerAd();
    _createRewardedAd();
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _createBannerAd() {
    _banner = BannerAd(
        size: AdSize.fullBanner,
        adUnitId: AdMobService.bannerAdUnitID!,
        listener: AdMobService.bannerAdListener,
        request: const AdRequest())
      ..load();
  }

  void _createRewardedAd() {
    RewardedAd.load(
      adUnitId: AdMobService.rewardAdUnitID!,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) => setState(() => _rewardedAd = ad),
        onAdFailedToLoad: (error) => setState(
          () => _rewardedAd = null,
        ),
      ),
    );
  }

  void savePlace() {
    // Check for empty/null values first
    if (_titleController.text.isEmpty ||
        _notesController.text.isEmpty ||
        _selectedImage == null ||
        _selectedLocation == null ||
        _selectedDate == null) {
      // Show error message or prevent saving (implementation depends on your app)
      return;
    }

    // If all inputs are valid, proceed with ad and navigation
    if (_rewardedAd != null) {
      _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          _createRewardedAd();
          Navigator.pop(context); // Pop the screen after ad dismissal
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          _createRewardedAd();
          // If ad fails to show, directly save place and pop screen
          ref.read(userPlaceProvider.notifier).addPlace(
                _titleController.text,
                _selectedDate!.toString(),
                _notesController.text,
                _selectedImage!,
                _selectedLocation!,
              );
          Navigator.pop(context); // Pop the screen after saving
        },
      );
      _rewardedAd!.show(
        onUserEarnedReward: (ad, reward) {
          ref.read(userPlaceProvider.notifier).addPlace(
                _titleController.text,
                _selectedDate!.toString(),
                _notesController.text,
                _selectedImage!,
                _selectedLocation!,
              );
        },
      );
      _rewardedAd = null; // Reset the ad after showing
    } else {
      // No ad available, directly save place and pop screen
      ref.read(userPlaceProvider.notifier).addPlace(
            _titleController.text,
            _selectedDate!.toString(),
            _notesController.text,
            _selectedImage!,
            _selectedLocation!,
          );
      Navigator.pop(context); // Pop the screen after saving
    }
  }

  void datePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(
      now.day,
      now.month,
      now.year - 1,
    );
    final pickedDate = await showDatePicker(
        context: context,
        firstDate: firstDate,
        initialDate: now,
        lastDate: now);

    setState(() {
      _selectedDate = pickedDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add your day'),
        backgroundColor: theme.colorScheme.background,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              TextField(
                maxLength: 25,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  labelText: 'Title',
                  labelStyle: TextStyle(color: theme.colorScheme.onBackground),
                ),
                controller: _titleController,
                style: TextStyle(color: theme.colorScheme.onBackground),
              ),
              const SizedBox(
                height: 10,
              ),
              ImageInput(
                savePickedImage: (image) {
                  _selectedImage = image;
                },
              ),
              const SizedBox(
                height: 6,
              ),
              GestureDetector(
                onTap: datePicker,
                child: Container(
                  height: 60,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: theme.colorScheme.primary),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _selectedDate == null
                              ? 'Select date'
                              : DateFormat('dd/MM/yyyy').format(_selectedDate!),
                          style: TextStyle(
                            color: theme.colorScheme.onBackground,
                          ),
                        ),
                        Icon(
                          Icons.calendar_today,
                          color: theme.colorScheme.primary,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              TextField(
                maxLines: 10,
                decoration: const InputDecoration(
                  alignLabelWithHint: true,
                  labelText: 'Write about your day...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                ),
                controller: _notesController,
                style: TextStyle(color: theme.colorScheme.onBackground),
              ),
              const SizedBox(
                height: 16,
              ),
              LoactionInput(
                saveLoaction: (location) {
                  _selectedLocation = location;
                },
              ),
              const SizedBox(
                height: 16,
              ),
              ElevatedButton(
                onPressed: savePlace,
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                  backgroundColor: theme.colorScheme.primary,
                ).copyWith(
                  minimumSize: MaterialStateProperty.all(
                    const Size(double.infinity, 0),
                  ),
                ),
                child: Text(
                  'SAVE',
                  style: TextStyle(color: theme.colorScheme.onPrimary),
                  textAlign: TextAlign.center,
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: _banner == null
          ? Container()
          : Container(
              margin: const EdgeInsets.only(bottom: 1),
              height: 52,
              child: AdWidget(ad: _banner!),
            ),
    );
  }
}

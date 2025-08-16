import 'package:geolocator/geolocator.dart';
import 'package:adhan/adhan.dart';
import 'dart:io' show Platform;

class PrayerTimeService {
  Future<PrayerTimes> getPrayerTimes() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      throw Exception('Adgang til placering er nægtet');
    }

    Position? position;
    position = await Geolocator.getLastKnownPosition();

    if (position == null) {
      final LocationSettings locationSettings = Platform.isAndroid
          ? AndroidSettings(accuracy: LocationAccuracy.medium)
          : AppleSettings(accuracy: LocationAccuracy.medium);

      position = await Geolocator.getCurrentPosition(
        locationSettings: locationSettings,
      );
    }

    final myCoordinates = Coordinates(position.latitude, position.longitude);
    final params = CalculationMethod.muslim_world_league.getParameters();
    params.madhab = Madhab.shafi;
    final prayerTimes = PrayerTimes.today(myCoordinates, params);

    return prayerTimes;
  }
}

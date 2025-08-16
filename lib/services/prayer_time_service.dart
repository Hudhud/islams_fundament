import 'package:geolocator/geolocator.dart';
import 'package:adhan/adhan.dart';

class PrayerTimeService {
  Future<PrayerTimes> getPrayerTimes() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      throw Exception('Adgang til placering er nægtet');
    }

    Position? position;
    position = await Geolocator.getLastKnownPosition();

    position ??= await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.medium,
    );

    final userCoordinates = Coordinates(position.latitude, position.longitude);
    final params = CalculationMethod.muslim_world_league.getParameters();
    params.madhab = Madhab.shafi;
    final prayerTimes = PrayerTimes.today(userCoordinates, params);

    return prayerTimes;
  }
}

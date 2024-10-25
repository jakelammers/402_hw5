import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

/**
 * @author jakelammers & claude 3.5
 * @date 10-24-24
 *
 * location service for hte windowpane app
 */
class LocationService {
  Future<Position> getCurrentPosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<String> getAddressFromCoordinates(Position position) async {
    final placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );
    if (placemarks.isNotEmpty) {
      final place = placemarks.first;
      return '${place.street}, ${place.locality}, ${place.administrativeArea}';
    }
    return 'Unknown location';
  }
}
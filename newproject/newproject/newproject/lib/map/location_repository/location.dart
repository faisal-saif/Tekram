import 'package:location/location.dart';

class LocationRepository {
  // ignore: prefer_final_fields
  Location _location = Location();
  Future<LocationData?> getUserLocation() async {
// ignore: no_leading_underscores_for_local_identifiers
    bool _serviceEnabled;
// ignore: no_leading_underscores_for_local_identifiers
    PermissionStatus _permissionGranted;
// ignore: no_leading_underscores_for_local_identifiers, unused_local_variable
    LocationData _locationData;

    _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
      if (!_serviceEnabled) {
        return null;
      }
    }

    _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }

    _locationData = await _location.getLocation();
    return _locationData;
  }
}

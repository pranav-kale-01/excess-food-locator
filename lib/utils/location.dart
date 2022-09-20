import 'package:geocoder2/geocoder2.dart';
import 'package:location/location.dart';

class GeoLocation {
  // static Future<Map<String, double>> getLocation() async {
  //   Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  //
  //   return {
  //     "lat" : position.latitude,
  //     "lon" : position.longitude,
  //   };;
  // }

  static Location location = Location();

  static Future<LocationData?> getLoc() async{
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return null;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }
    return await location.getLocation();
  }
}
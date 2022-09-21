import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';

class FirebaseOperations {
  static Future<String> uploadingDataUsingCustomId( {
    required String collectionName,
    required String email,
    required String id,
    String? storeName,
    String? idNumber,
    LocationData? location,
    String? contactNumber,
    String? role,
    String? foodQuantity,
    String? typeOfFood,
    String? expectedPickupTime,
    String? itemName,
    String? locationDataString,
    double? lat,
    double? lon,
  }) async {
    try {
      if( collectionName == "users" ) {
        if( role == 'food_provider' ) {
          final ref = await FirebaseFirestore.instance.collection(collectionName).add({
            'store_name': storeName ?? "",
            'id_number': idNumber,
            'location': location == null ? '' : '${location.latitude},${location
                .longitude}',
            'contact_number': contactNumber,
            'email' : email,
            'role' : role,
          });

          return ref.id;
        }
        else {
          final ref = await FirebaseFirestore.instance.collection(collectionName).add({
            'email' : email,
            'role' : role,
          });

          return ref.id;
        }
      }
      else {
        await FirebaseFirestore.instance.collection(collectionName).doc(id).set({
          'food_quantity': foodQuantity,
          'type_of_food': typeOfFood,
          'expected_time': expectedPickupTime,
          'item_name': itemName,
          'geoPoint': GeoPoint(lat!, lon!),
        });

        return id;
      }
    }
    catch( e ) {
      print( e );
      return '';
    }
  }

  static Future<String> uploadingData( {
    required String collectionName,
    required String email,
    String? storeName,
    String? idNumber,
    String? location,
    String? contactNumber,
    String? role,
    String? foodQuantity,
    String? typeOfFood,
    String? expectedPickupTime,
    String? itemName,
  }) async {
    try {
      if( collectionName == "users" ) {
        if( role == 'food_provider' ) {
          final ref = await FirebaseFirestore.instance.collection(collectionName).add({
            'store_name': storeName ?? "",
            'id_number': idNumber,
            'location': location,
            'contact_number': contactNumber,
            'email' : email,
            'role' : role,
          });

          return ref.id;
        }
        else {
          final ref = await FirebaseFirestore.instance.collection(collectionName).add({
            'email' : email,
            'role' : role,
          });

          return ref.id;
        }
      }
      else {
        final ref = await FirebaseFirestore.instance.collection(collectionName).add({
          'store_name': storeName ?? "",
          'id_number': idNumber,
          'location': location,
          'contact_number': contactNumber,
          'email' : email,
          'role' : role,
        });

        return ref.id;
      }
    }
    catch( e ) {
      print( e );
      return '';
    }
  }

  static Future<Map<String, dynamic>?> getProductById( String collection, String id ) async {
    var ref = await FirebaseFirestore.instance
        .collection(collection)
        .doc(id)
        .get();

    return ref.data();
  }

  static Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>?> getMarkersByUserLocation( String collection, double latitude, double longitude ) async {
    double lowerLat = latitude - (0.0144927536231884);
    double lowerLon = longitude - (0.0144927536231884);

    double greaterLat = latitude + (0.0144927536231884);
    double greaterLon = longitude + (0.0144927536231884);

    GeoPoint lesserGeoPoint = GeoPoint(lowerLat, lowerLon);
    GeoPoint greaterGeoPoint = GeoPoint(greaterLat, greaterLon);

    var ref = await FirebaseFirestore.instance
        .collection(collection)
        .where("geoPoint", isGreaterThanOrEqualTo: lesserGeoPoint)
        .where("geoPoint", isLessThanOrEqualTo: greaterGeoPoint)
        .get();

    // var ref = await FirebaseFirestore.instance
    //     .collection(collection)
    //     .get();

    return ref.docs;
  }

  static Future<QueryDocumentSnapshot?> getProduct( String collection, String email ) async {
    var ref = await FirebaseFirestore.instance
        .collection(collection)
        .where(
          'email',
          isEqualTo: email,
        )
        .get();

    if( ref.docs.isNotEmpty ) {
      return ref.docs.first;
    }
    return null;
  }

  static Future<void> editProduct(String collectionName, Map<String, dynamic> details, String id) async {
    try {
      await FirebaseFirestore.instance
          .collection(collectionName)
          .doc(id)
          .update(
            details
          );
    }
    catch( e, s ) {
      print( e );
      print( s );
    }

  }

  static Future<void> deleteProduct(DocumentSnapshot doc) async {
    await FirebaseFirestore.instance
        .collection("products")
        .doc(doc.id)
        .delete();
  }
}
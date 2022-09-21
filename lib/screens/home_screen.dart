import 'dart:ui' as ui;
import 'dart:async';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_app/utils/firebase_operations.dart';
import 'package:food_app/utils/location.dart';
import 'package:food_app/widgets/nav_drawer/home_screen_nav_drawer.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  final User user;
  const HomeScreen({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late GoogleMapController _controller;
  late LocationData? currentLocation;

  String dialogItemName = "";
  String dialogExpectedTime = "";
  String dialogTypeOfFood = "";
  String dialogContactNumber = "";

  bool showInfoDialog = false;

  static const LatLng _center = LatLng(45.521563, -122.677433);

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Set<Marker> markers = <Marker>{};

  void _onMapCreated(GoogleMapController controller) {
    _controller = controller;

    // relocate to user position
    relocateCamera();
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  }

  Future<void> relocateCamera() async {
    // getting user current location
    currentLocation = await GeoLocation.getLoc();

    if( currentLocation != null ) {
      await _controller.animateCamera(
          CameraUpdate.newLatLngZoom(
            LatLng(
              currentLocation!.latitude!,
              currentLocation!.longitude!,
            ),
            14
          )
      ).then((value) async {
        await setMarkers();
      });
    }
  }


  Future<void> setMarkers() async {
    markers.clear();

    try{
      final Uint8List markerIcon = await getBytesFromAsset('assets/current_user_location.png', 50);
      final Marker marker = Marker(
        icon: BitmapDescriptor.fromBytes(markerIcon),
        markerId: const MarkerId("current_user_location"),
        position: LatLng( currentLocation!.latitude!, currentLocation!.longitude! ),
      );

      setState(() {
        markers.add(
          marker
        );
      });
    }
    catch( e,s ) {
      print( e);
      print( s );
    }

    // getting all the location near the users location
    final ref = await FirebaseOperations.getMarkersByUserLocation(
        "food_item",
        currentLocation!.latitude!,
        currentLocation!.longitude!
    );

    if( ref!.isNotEmpty ) {
      for( var i in ref ) {
        final temp = i.data();

        debugPrint( i.id );

        final marker = Marker(
          markerId: MarkerId( i.id ),
          position: LatLng( temp['geoPoint'].latitude, temp['geoPoint'].longitude ),
          icon: BitmapDescriptor.defaultMarkerWithHue( BitmapDescriptor.hueOrange ),

          onTap: () {
            setState(() {
              showInfoDialog = true;
              dialogItemName = temp['item_name'];
              dialogExpectedTime = temp['expected_time'];
              dialogTypeOfFood = temp['type_of_food'];
              if( temp['contact_number'] != null ) {
                dialogContactNumber = temp['contact_number'];
              }
            });
          }
        );

        setState(() {
          markers.add(marker);
        });
      }

      debugPrint( markers.toString() );
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Scaffold(
      key: _scaffoldKey,
      drawer: HomeScreenNavigationDrawer( ),
      body: Stack(
        alignment: AlignmentDirectional.topCenter,
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: const CameraPosition(
              target: _center,
              zoom: 11.0,
            ),
            markers: markers,
            onTap: (_) {
              setState(() {
                showInfoDialog = false;
              });
            },
          ),
          SafeArea(
            child: SizedBox(
              width: mediaQuery.size.width,
              child: Column(
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          _scaffoldKey.currentState!.openDrawer();
                        },
                        child: Container(
                          height: 50,
                          width: 50,
                          margin: const EdgeInsets.all( 8.0, ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0,),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade400,
                                offset: const Offset( 1, 4),
                                blurRadius: 2,
                              )
                            ]
                          ),
                          child: const Icon(
                            Icons.menu,
                          ),
                        ),
                      ),
                      Container(
                        height: 50,
                        width: mediaQuery.size.width - 135 ,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0,),
                          color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade400,
                                offset: const Offset( 1, 4),
                                blurRadius: 2,
                              )
                            ]
                        ),
                        child: Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.0),
                              child: Icon(
                                Icons.search,
                                color: Colors.grey
                              ),
                            ),
                            const Text(
                              "Search by area",
                              style: TextStyle(
                                color: Colors.grey
                              ),
                            ),
                            Expanded(
                              child: Container(
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                child: const Icon(
                                    Icons.filter_list,
                                    color: Colors.grey
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          await setMarkers();
                        },
                        child: Container(
                          height: 50,
                          width: 50,
                          margin: const EdgeInsets.all( 8.0, ),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0,),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.shade400,
                                  offset: const Offset( 1, 4),
                                  blurRadius: 2,
                                )
                              ]
                          ),
                          child: const Icon(
                            Icons.refresh,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if( showInfoDialog )
                    Expanded(
                    child: Container(
                      margin: EdgeInsets.only(bottom: 10, left: 10, right: 10),
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 180,
                        width: mediaQuery.size.width * 0.92,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0,),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade500,
                              offset: const Offset( 1, 4),
                              blurRadius: 2,
                            )
                          ]
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(top: 12.0, left: 12.0, right: 12.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                dialogItemName,
                                style: const TextStyle(
                                  fontSize: 26,
                                   fontWeight: FontWeight.w600
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Expected Pickup Time - $dialogExpectedTime",
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                ),
                              ),

                              const SizedBox(
                                height: 10,
                              ),

                              Row(
                                  children: [
                                    if( dialogTypeOfFood.split("+").contains("veg") )
                                      Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              width: 2.0,
                                              color: Colors.green,
                                            ),
                                            borderRadius: BorderRadius.circular(5.0,)
                                        ),
                                        padding: const EdgeInsets.symmetric( horizontal: 8.0, vertical: 4.0, ),
                                        child: Row(
                                          children: [
                                            const Text(
                                              "Veg",
                                              style: TextStyle(
                                                color: Colors.green,
                                              ),
                                            ),
                                            Container(
                                              padding: const EdgeInsets.only(left: 4.0,),
                                              child: SvgPicture.asset(
                                                'assets/Indian-vegetarian-mark.svg',
                                                color: Colors.green,
                                                width: 25.0,
                                                height: 25.0,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                    if( dialogTypeOfFood.split("+").contains("non-veg") )
                                      Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              width: 2.0,
                                              color: const Color(0xFF9C3b14),
                                            ),
                                            borderRadius: BorderRadius.circular(5.0,)
                                        ),
                                        margin: const EdgeInsets.only( left: 12.0, ),
                                        padding: const EdgeInsets.symmetric( horizontal: 8.0, vertical: 4.0, ),
                                        child: Row(
                                          children: [
                                            const Text(
                                              "Non-Veg",
                                              style: TextStyle(
                                                color: Color(0xFF9C3b14),
                                              ),
                                            ),
                                            Container(
                                              padding: const EdgeInsets.only(left: 4.0, right: 1.0, ),
                                              child: SvgPicture.asset(
                                                'assets/Indian-vegetarian-mark.svg',
                                                color: const Color(0xFF9C3b14),
                                                width: 25.0,
                                                height: 25.0,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                    if( dialogTypeOfFood.split("+").contains("vegan") )
                                      Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              width: 2.0,
                                              color: Colors.green,
                                            ),
                                            borderRadius: BorderRadius.circular(5.0,)
                                        ),
                                        margin: const EdgeInsets.only( left: 12.0, ),
                                        padding: const EdgeInsets.symmetric( horizontal: 8.0, vertical: 4.0, ),
                                        child: Row(
                                          children: [
                                            const Text(
                                              "Vegan",
                                              style: TextStyle(
                                                color: Colors.green,
                                              ),
                                            ),
                                            Container(
                                              padding: const EdgeInsets.only(left: 4.0 ),
                                              child: SvgPicture.asset(
                                                'assets/vegan-icon.svg',
                                                color: Colors.green,
                                                width: 25.0,
                                                height: 25.0,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                  ],
                                ),

                              Container(
                                  width: mediaQuery.size.width * 0.4,
                                  height: 40,
                                  margin: EdgeInsets.only( top: 12.0 ),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                                    decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                            colors: [
                                              Color(0xFFEC9F46),
                                              Color(0xC0DF5216),
                                            ]
                                        ),
                                        borderRadius: BorderRadius.circular(
                                            12.0
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.shade400,
                                            offset: const Offset( 1, 4),
                                            blurRadius: 2,
                                          )
                                        ]
                                    ),
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        final url = "tel:$dialogContactNumber";
                                        if ( await canLaunchUrl(Uri.parse(url) ) )  {
                                        await launchUrl( Uri.parse( url ) );
                                        } else {
                                        throw 'Could not launch $url';
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(primary: Colors.transparent, shadowColor: Colors.transparent),
                                      child: const Text(
                                        'Contact',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600
                                        ),
                                      ),
                                    ),
                                  )
                              ),

                            ],
                          ),
                        )
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),

        ],
      ),
    );
  }
}

// child: ElevatedButton(
//   onPressed: () async {
//     await Authentication.signOut(context: context);
//
//     Navigator.of(context).pushReplacement(
//       MaterialPageRoute(
//         builder: (context) => SignInScreen(),
//       ),
//     );
//   },
//   child: const Text("Sign out"),
// ),
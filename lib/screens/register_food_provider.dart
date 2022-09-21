import 'package:date_format/date_format.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_app/screens/food_status_scrren.dart';
import 'package:food_app/utils/circle_painter.dart';
import 'package:food_app/utils/firebase_operations.dart';
import 'package:food_app/utils/hive_services.dart';
import 'package:food_app/utils/location.dart';
import 'package:food_app/utils/normal_dialog.dart';
import 'package:location/location.dart';

class RegisterFoodProvider extends StatefulWidget {
  final User user;

  const RegisterFoodProvider({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  _RegisterFoodProviderState createState() => _RegisterFoodProviderState();
}

class _RegisterFoodProviderState extends State<RegisterFoodProvider> {
  TextEditingController nameController = TextEditingController();
  TextEditingController idNumberController = TextEditingController();
  TextEditingController contactNumberController = TextEditingController();
  HiveServices hiveService = HiveServices();

  late LocationData? userLocation;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            child: Column(
              children: [
                Transform.translate(
                  offset: Offset( mediaQuery.size.width * 0.32, -mediaQuery.size.height * 0.48),
                  child: Transform.scale(
                    scale: 1.7,
                    child: CustomPaint(
                      size: Size( mediaQuery.size.width, mediaQuery.size.width),
                      painter: const CirclePainter(
                        offset: Offset( 400, 0 ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: SizedBox(
                height: mediaQuery.size.height - 60,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      child: IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(
                          Icons.arrow_back_ios_sharp,
                        ),
                      ),
                    ),

                    // Profile Photo
                    SizedBox(
                      width: mediaQuery.size.width * 0.92,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: mediaQuery.size.width * 0.20,
                        child: Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 10,
                                color: Colors.grey.shade500
                              ),
                            ],
                            borderRadius: BorderRadius.circular(100),
                            color: Colors.white,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Container(
                              color: Colors.white,
                              child: Image.network(
                                "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ42Y1_fnKWKiLCNdi8vu337thvIE4VqCHocQevv6A5jBGt6W3-YMZhz9qcEWEXCofGLNY&usqp=CAU",
                                width: mediaQuery.size.width * 0.4,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // place name
                    Container(
                      width: mediaQuery.size.width * 0.92,
                      margin: const  EdgeInsets.only( top: 20.0 ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        height: 30,
                        child: const Text(
                          "Name (if any)",
                          style: TextStyle(
                            color: Colors.black ,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: mediaQuery.size.width * 0.92,
                      height: mediaQuery.size.height * 0.065,
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade400,
                              blurRadius: 10,
                              offset: const Offset(2, 2),
                            ),
                          ],
                          borderRadius: BorderRadius.circular(10.0)
                      ),
                      child: TextField(
                        controller: nameController,
                        decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.white,
                                    width: 2.0
                                ),
                                borderRadius: BorderRadius.circular(10.0)
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Color(0xFFEC9F46),
                                    width: 2.0
                                ),
                                borderRadius: BorderRadius.circular(10.0)
                            ),
                            hintText: "Enter the name of your place",
                            hintStyle: TextStyle(
                              fontSize: 14.0 * mediaQuery.textScaleFactor,
                              color: Colors.grey,
                            )
                        ),
                      ),
                    ),

                    // id number
                    Container(
                      width: mediaQuery.size.width * 0.92,
                      margin: const  EdgeInsets.only( top: 20.0 ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        height: 30,
                        child: const Text(
                          "Identity Number",
                          style: TextStyle(
                            color: Colors.black ,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: mediaQuery.size.width * 0.92,
                      height: mediaQuery.size.height * 0.065,
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade400,
                              blurRadius: 10,
                              offset: const Offset(2, 2),
                            ),
                          ],
                          borderRadius: BorderRadius.circular(10.0)
                      ),
                      child: TextField(
                        controller: idNumberController,
                        decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.white,
                                    width: 2.0
                                ),
                                borderRadius: BorderRadius.circular(10.0)
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Color(0xFFEC9F46),
                                    width: 2.0
                                ),
                                borderRadius: BorderRadius.circular(10.0)
                            ),
                            hintText: "Aadhar Number / Other UID Number",
                            hintStyle: TextStyle(
                              fontSize: 14.0 * mediaQuery.textScaleFactor,
                              color: Colors.grey,
                            )
                        ),
                      ),
                    ),

                    // choose pickup location
                    Container(
                      width: mediaQuery.size.width * 0.92,
                      margin: const  EdgeInsets.only( top: 20.0 ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        height: 30,
                        child: const Text(
                          "Choose pickup location",
                          style: TextStyle(
                            color: Colors.black ,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: mediaQuery.size.width * 0.92,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(Colors.white),
                                foregroundColor: MaterialStateProperty.all(Colors.black),
                                elevation: MaterialStateProperty.all(4.0),
                              ),
                              onPressed: ( ) async {
                                showDialog(
                                  context: context,
                                  builder: (context) => Container(
                                    color: Colors.black12,
                                    alignment: Alignment.center,
                                    child: const CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.orange,
                                      ),
                                   ),
                                  ),
                                );

                                userLocation = await GeoLocation.getLoc();

                                if( userLocation != null ) {
                                  Navigator.of(context).pop();

                                  showDialog(
                                    context: context,
                                    builder: (context) => const NormalDialog(
                                      height: 150,
                                      header: "Yay!",
                                      message: "Location Set Successfully!",
                                    )
                                  );
                                }
                                else {
                                  Navigator.of(context).pop();
                                }
                              },
                              child: Container(
                                width: mediaQuery.size.width * 0.6,
                                padding: const EdgeInsets.symmetric( vertical: 20.0),
                                alignment: Alignment.center,
                                child: const Text(
                                  "Set current location",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              )
                          ),
                          ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(Colors.white),
                                foregroundColor: MaterialStateProperty.all(Colors.black),
                              ),
                              onPressed: ( ) {

                              },
                              child: Container(
                                width: mediaQuery.size.width * 0.1,
                                padding: const EdgeInsets.symmetric( vertical: 18.0),
                                alignment: Alignment.center,
                                child: const Icon(
                                  Icons.location_pin
                                )
                              )
                          ),
                        ],
                      ),
                    ),

                    // contact no
                    Container(
                      width: mediaQuery.size.width * 0.92,
                      margin: const  EdgeInsets.only( top: 20.0 ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        height: 30,
                        child: const Text(
                          "Contact No.",
                          style: TextStyle(
                            color: Colors.black ,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: mediaQuery.size.width * 0.92,
                      height: mediaQuery.size.height * 0.065,
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade400,
                              blurRadius: 10,
                              offset: const Offset(2, 2),
                            ),
                          ],
                          borderRadius: BorderRadius.circular(10.0)
                      ),
                      child: TextField(
                        controller: contactNumberController,
                        decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.white,
                                    width: 2.0
                                ),
                                borderRadius: BorderRadius.circular(10.0)
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Color(0xFFEC9F46),
                                    width: 2.0
                                ),
                                borderRadius: BorderRadius.circular(10.0)
                            ),
                            hintText: "Enter your contact no.",
                            hintStyle: TextStyle(
                              fontSize: 14.0 * mediaQuery.textScaleFactor,
                              color: Colors.grey,
                            )
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                          alignment: Alignment.bottomCenter,
                          margin: EdgeInsets.symmetric( horizontal: mediaQuery.size.width * 0.05, vertical: 20.0 ),
                          child: Container(
                            width: mediaQuery.size.width * 0.9,
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
                                showDialog(
                                  context: context,
                                  builder: (context) => Container(
                                    color: Colors.black12,
                                    alignment: Alignment.center,
                                    child: const CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.orange,
                                      ),
                                    ),
                                  ),
                                );

                                // saving the data to firebase
                                final result = await FirebaseOperations.uploadingData(
                                    collectionName: "users",
                                    storeName: nameController.text,
                                    idNumber: idNumberController.text,
                                    location: "${userLocation!.latitude!},${userLocation!.longitude!}",
                                    contactNumber: contactNumberController.text,
                                    email: widget.user.email!,
                                    role: "food_provider"
                                );

                                if( result.isNotEmpty ) {
                                  Navigator.of(context).pop();

                                  // storing the user's uid
                                  hiveService.setValue( result , "user_id" );

                                  // redirecting to the food status screen
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (context) => FoodStatusScreen(
                                        userDetails: {
                                          "name" : nameController.text,
                                          "id_number" : idNumberController.text,
                                          "location" : "${userLocation!.latitude!},${userLocation!.longitude!}",
                                          "contact_number" : contactNumberController.text,
                                          "role" : "food_provider"
                                        },
                                        userEmail: widget.user.email!,
                                      ),
                                    )
                                  );
                                }
                                else {
                                  Navigator.of(context).pop();
                                }


                              },
                              style: ElevatedButton.styleFrom(primary: Colors.transparent, shadowColor: Colors.transparent),
                              child: const Text(
                                'Continue',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600
                                ),
                              ),
                            ),
                          )
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

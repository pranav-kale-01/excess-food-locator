import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_app/utils/circle_painter.dart';
import 'package:date_format/date_format.dart';
import 'package:food_app/utils/firebase_operations.dart';
import 'package:food_app/utils/hive_services.dart';
import 'package:food_app/widgets/nav_drawer/home_screen_nav_drawer.dart';
import 'package:location/location.dart';

class FoodStatusScreen extends StatefulWidget {
  final Map<String, dynamic> userDetails;
  final String userEmail;

  const FoodStatusScreen({
    Key? key,
    required this.userDetails,
    required this.userEmail,
  }) : super(key: key);

  @override
  _FoodStatusScreenState createState() => _FoodStatusScreenState();
}

class _FoodStatusScreenState extends State<FoodStatusScreen> {
  late Future<void> foodStatusFetched;
  bool foodStatusSaved = false;
  bool foodItemPersentInFirebase = false;
  String? itemId;

  bool vegSelected = false;
  bool nonVegSelected = false;
  bool veganSelected = false;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // controllers for textfields
  final TextEditingController foodQuantityController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController itemNameController = TextEditingController();

  // for taking time input
  late String _hour, _minute, _time;
  TimeOfDay selectedTime = const TimeOfDay(hour: 22, minute: 00);

  final HiveServices hiveService = HiveServices();

  List<dynamic> foodDetails = [];

  @override
  void initState() {
    super.initState();

    foodStatusFetched = fetchFoodStatus();
  }

  Future<void> fetchFoodStatus() async {
    bool exists = await hiveService.isExists(boxName: "food_details");

    if( exists ) {
      // checking if document if already present
      final result = await FirebaseOperations.getProductById("food_item", widget.userEmail );
      if( result!=null) {
        foodItemPersentInFirebase = true;
      }

      foodDetails = await hiveService.getBoxes("food_details");

      if( foodDetails.first['status'] == 'active' ) {
        foodStatusSaved = true;
      }

      foodQuantityController.text = foodDetails.first['food_quantity'];
      vegSelected = foodDetails.first['type_of_food'].split("+").contains('veg');
      nonVegSelected = foodDetails.first['type_of_food'].split("+").contains('non-veg');
      veganSelected = foodDetails.first['type_of_food'].split("+").contains('vegan');
      _timeController.text = foodDetails.first['expected_time'];
      itemNameController.text = foodDetails.first['item_name'];
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );

    if (picked != null) {
      setState(() {
        selectedTime = picked;
        _hour = selectedTime.hour.toString();
        _minute = selectedTime.minute.toString();
        _time = '$_hour : $_minute';
        _timeController.text = _time;
        _timeController.text =  formatDate(
            DateTime(2019, 08, 1, selectedTime.hour, selectedTime.minute),
            [hh, ':', nn, " ", am]).toString();
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Scaffold(
      key: _scaffoldKey,
      drawer: HomeScreenNavigationDrawer(),
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          SizedBox(
            height: mediaQuery.size.height,
            child: Column(
              children: [
                Transform.translate(
                  offset: Offset( -mediaQuery.size.width * 0.8, mediaQuery.size.height * 0.45),
                  child: Transform.scale(
                    scale: 1.4,
                    child: CustomPaint(
                      size: Size( mediaQuery.size.width, mediaQuery.size.width),
                      painter: const CirclePainter(
                        offset: Offset( 400, 0 ),
                      ),
                    ),
                  ),
                ),
                Transform.translate(
                  offset: Offset( mediaQuery.size.width * 0.4 , -mediaQuery.size.height * 0.45 ),
                  child: Transform.scale(
                    scale: 0.5,
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    _scaffoldKey.currentState!.openDrawer();
                  },
                  child: Container(
                    padding: const EdgeInsets.only( top: 12.0, ),
                    width: mediaQuery.size.width * 0.92,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.menu,
                          size: 30,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 4.0),
                          child: Text(
                            "Menu",
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric( horizontal: mediaQuery.size.width * 0.04 ),
                  // height: mediaQuery.size.height * 0.6,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade600,
                        offset: const Offset( 1, 3),
                        blurRadius: 5,
                      )
                    ],
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: FutureBuilder(
                    future: foodStatusFetched,
                    builder: (context,snapshot) {
                      if( snapshot.connectionState == ConnectionState.done ) {
                        return foodStatusSaved ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.only( left: 16.0, top: 20.0, ),
                              child: const Text(
                                "Food Status",
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),

                            Container(
                              margin: EdgeInsets.only( left: mediaQuery.size.width * 0.04, top: 12, right: mediaQuery.size.width * 0.04, ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // food for
                                  Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          // Food for how many people
                                          Container(
                                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                                            height: 30,
                                            child: const Text(
                                              "Food for",
                                              style: TextStyle(
                                                color: Colors.black ,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: mediaQuery.size.width * 0.17,
                                            height: mediaQuery.size.height * 0.06,
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey.shade500,
                                                    blurRadius: 10,
                                                    offset: const Offset(2, 2),
                                                  ),
                                                ],
                                                borderRadius: BorderRadius.circular(10.0)
                                            ),
                                            alignment: Alignment.center,
                                            child: Text(
                                              foodQuantityController.text,
                                              style: const TextStyle(
                                                  fontSize: 16
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),

                                  // Type of Food
                                  Container(
                                    margin: const EdgeInsets.only(left: 30),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                                          height: 30,
                                          child: const Text(
                                            "Type of Food",
                                            style: TextStyle(
                                              color: Colors.black ,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: mediaQuery.size.width * 0.55,
                                          child: SingleChildScrollView(
                                            physics: const BouncingScrollPhysics(),
                                            scrollDirection: Axis.horizontal,
                                            child: Row(
                                              children: [
                                                // veg
                                                if( vegSelected )
                                                  GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        vegSelected = !vegSelected;
                                                      });
                                                    },
                                                    child: Container(
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
                                                  ),

                                                // non-veg
                                                if( nonVegSelected )
                                                  GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        nonVegSelected = !nonVegSelected;
                                                      });
                                                    },
                                                    child: Container(
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
                                                  ),

                                                // vegan
                                                if( veganSelected  )
                                                  GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        veganSelected = !veganSelected;
                                                      });
                                                    },
                                                    child: Container(
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
                                                  ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),




                            // Expected Pickup time
                            Container(
                              width: mediaQuery.size.width * 0.92,
                              margin: const  EdgeInsets.only( top: 12.0, left: 16.0 ),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 4.0),
                                height: 30,
                                child: const Text(
                                  "Expected Pickup time",
                                  style: TextStyle(
                                    color: Colors.black ,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: mediaQuery.size.width * 0.04 ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: mediaQuery.size.width * 0.63,
                                    height: mediaQuery.size.height * 0.065,
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.shade500,
                                          blurRadius: 10,
                                          offset: const Offset(2, 2),
                                        ),
                                      ],
                                      borderRadius: BorderRadius.circular(10.0),
                                      color: Colors.white,
                                    ),
                                    child: Container(
                                      alignment: Alignment.center,
                                      child: Text(
                                        _timeController.text,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      )
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Item name
                            Container(
                              width: mediaQuery.size.width * 0.92,
                              margin: const  EdgeInsets.only( top: 12.0, left: 16.0 ),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 4.0),
                                height: 30,
                                child: const Text(
                                  "Item Name (if any specific item)",
                                  style: TextStyle(
                                    color: Colors.black ,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: mediaQuery.size.width * 0.82,
                              height: mediaQuery.size.height * 0.065,
                              margin: const EdgeInsets.only(left: 16.0),
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.shade500,
                                    blurRadius: 10,
                                    offset: const Offset(2, 2),
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(10.0),
                                color: Colors.white
                              ),
                              child: Container(
                                  alignment: Alignment.center,
                                  child: Text(
                                    itemNameController.text.isEmpty ? "-" : itemNameController.text,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  )
                              ),
                            ),

                            Container(
                                width: mediaQuery.size.width * 0.9,
                                margin: EdgeInsets.symmetric( horizontal: mediaQuery.size.width * 0.04, vertical: 16.0 ),
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
                                    onPressed: () {

                                      setState(() {
                                        foodStatusSaved = false;
                                      });

                                      // FirebaseOperations.uploadingData(
                                      //     collectionName: "food_item",
                                      //     email: widget.userDetails['email'],
                                      //     foodQuantity:
                                      // );
                                    },
                                    style: ElevatedButton.styleFrom(primary: Colors.transparent, shadowColor: Colors.transparent),
                                    child: const Text(
                                      'Edit',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600
                                      ),
                                    ),
                                  ),
                                )
                            ),
                          ],
                        ) : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.only( left: 16.0, top: 20.0, ),
                              child: const Text(
                                "Add Food Status",
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),

                            // Food for how many people
                            Container(
                              width: mediaQuery.size.width * 0.92,
                              margin: const  EdgeInsets.only( top: 12.0, left: 16.0 ),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 4.0),
                                height: 30,
                                child: const Text(
                                  "Food for how many people",
                                  style: TextStyle(
                                    color: Colors.black ,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: mediaQuery.size.width * 0.82,
                              height: mediaQuery.size.height * 0.065,
                              margin: const EdgeInsets.only(left: 16.0),
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.shade500,
                                      blurRadius: 10,
                                      offset: const Offset(2, 2),
                                    ),
                                  ],
                                  borderRadius: BorderRadius.circular(10.0)
                              ),
                              child: TextField(
                                controller: foodQuantityController,
                                keyboardType: TextInputType.number,
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
                                    hintText: "Food for how many people",
                                    hintStyle: TextStyle(
                                      fontSize: 14.0 * mediaQuery.textScaleFactor,
                                      color: Colors.grey,
                                    )
                                ),
                              ),
                            ),

                            // Type of Food
                            Container(
                              width: mediaQuery.size.width * 0.92,
                              margin: const  EdgeInsets.only( top: 12.0, left: 16.0 ),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 4.0),
                                height: 30,
                                child: const Text(
                                  "Type of Food",
                                  style: TextStyle(
                                    color: Colors.black ,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: mediaQuery.size.width * 0.04 ),
                              child: Row(
                                children: [
                                  // veg
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        vegSelected = !vegSelected;
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          width: 2.0,
                                          color: !vegSelected ? Colors.grey : Colors.green,
                                        ),
                                        borderRadius: BorderRadius.circular(5.0,)
                                      ),
                                      padding: const EdgeInsets.symmetric( horizontal: 8.0, vertical: 4.0, ),
                                      child: Row(
                                        children: [
                                          Text(
                                            "Veg",
                                            style: TextStyle(
                                              color: !vegSelected ? Colors.grey: Colors.green,
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.only(left: 4.0,),
                                            child: SvgPicture.asset(
                                              'assets/Indian-vegetarian-mark.svg',
                                              color: !vegSelected ? Colors.grey : Colors.green,
                                              width: 25.0,
                                              height: 25.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  // non-veg
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        nonVegSelected = !nonVegSelected;
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                            width: 2.0,
                                            color: !nonVegSelected ? Colors.grey : const Color(0xFF9C3b14),
                                          ),
                                          borderRadius: BorderRadius.circular(5.0,)
                                      ),
                                      margin: const EdgeInsets.only( left: 12.0, ),
                                      padding: const EdgeInsets.symmetric( horizontal: 8.0, vertical: 4.0, ),
                                      child: Row(
                                        children: [
                                          Text(
                                            "Non-Veg",
                                            style: TextStyle(
                                              color: !nonVegSelected ? Colors.grey : const Color(0xFF9C3b14),
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.only(left: 4.0, right: 1.0, ),
                                            child: SvgPicture.asset(
                                              'assets/Indian-vegetarian-mark.svg',
                                              color: !nonVegSelected ? Colors.grey : const Color(0xFF9C3b14),
                                              width: 25.0,
                                              height: 25.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  // vegan
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        veganSelected = !veganSelected;
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                            width: 2.0,
                                            color: veganSelected ? Colors.green : Colors.grey,
                                          ),
                                          borderRadius: BorderRadius.circular(5.0,)
                                      ),
                                      margin: const EdgeInsets.only( left: 12.0, ),
                                      padding: const EdgeInsets.symmetric( horizontal: 8.0, vertical: 4.0, ),
                                      child: Row(
                                        children: [
                                          Text(
                                            "Vegan",
                                            style: TextStyle(
                                              color: veganSelected ? Colors.green : Colors.grey,
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.only(left: 4.0 ),
                                            child: SvgPicture.asset(
                                              'assets/vegan-icon.svg',
                                              color: veganSelected ? Colors.green : Colors.grey,
                                              width: 25.0,
                                              height: 25.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Expected Pickup time
                            Container(
                              width: mediaQuery.size.width * 0.92,
                              margin: const  EdgeInsets.only( top: 12.0, left: 16.0 ),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 4.0),
                                height: 30,
                                child: const Text(
                                  "Expected Pickup time",
                                  style: TextStyle(
                                    color: Colors.black ,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: mediaQuery.size.width * 0.04 ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: mediaQuery.size.width * 0.63,
                                    height: mediaQuery.size.height * 0.065,
                                    decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.shade500,
                                            blurRadius: 10,
                                            offset: const Offset(2, 2),
                                          ),
                                        ],
                                        borderRadius: BorderRadius.circular(10.0)
                                    ),
                                    child: TextField(
                                      controller: _timeController,
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
                                          hintText: "Expected Pickup Time",
                                          hintStyle: TextStyle(
                                            fontSize: 14.0 * mediaQuery.textScaleFactor,
                                            color: Colors.grey,
                                          )
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only( right: 8.0, ),
                                    height: mediaQuery.size.height * 0.065,
                                    width: mediaQuery.size.width * 0.15,
                                    child: ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                          foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                                          elevation: MaterialStateProperty.all<double>(6),
                                          shape: MaterialStateProperty.all(
                                              RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(10.0)
                                              )
                                          )
                                        ),
                                        onPressed: () {
                                          _selectTime(context);
                                        },
                                        child: const Icon(
                                          Icons.access_time,
                                        ),
                                    ),
                                  )
                                ],
                              ),
                            ),

                            // Item name
                            Container(
                              width: mediaQuery.size.width * 0.92,
                              margin: const  EdgeInsets.only( top: 12.0, left: 16.0 ),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 4.0),
                                height: 30,
                                child: const Text(
                                  "Item Name (if any specific item)",
                                  style: TextStyle(
                                    color: Colors.black ,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: mediaQuery.size.width * 0.82,
                              height: mediaQuery.size.height * 0.065,
                              margin: const EdgeInsets.only(left: 16.0),
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.shade500,
                                      blurRadius: 10,
                                      offset: const Offset(2, 2),
                                    ),
                                  ],
                                  borderRadius: BorderRadius.circular(10.0)
                              ),
                              child: TextField(
                                controller: itemNameController,
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
                                    hintText: "Item Name",
                                    hintStyle: TextStyle(
                                      fontSize: 14.0 * mediaQuery.textScaleFactor,
                                      color: Colors.grey,
                                    )
                                ),
                              ),
                            ),

                            Container(
                                width: mediaQuery.size.width * 0.9,
                                margin: EdgeInsets.symmetric( horizontal: mediaQuery.size.width * 0.04, vertical: 16.0 ),
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
                                      showDialog(
                                        context: context,
                                        builder: (context) =>  Container(
                                          alignment: Alignment.center,
                                          color: Colors.black12,
                                          child: const CircularProgressIndicator(
                                            valueColor: AlwaysStoppedAnimation<Color>(
                                              Colors.orange,
                                            ),
                                          ),
                                        ),
                                      );

                                      debugPrint( widget.userDetails.toString() );

                                      // saving food status locally
                                      hiveService.setValue( {
                                        "food_quantity" : foodQuantityController.text,
                                        "type_of_food" : "${vegSelected ? "veg" : ""}+${nonVegSelected ? "non-veg" : ""}+${veganSelected ? "vegan" : ""}",
                                        "expected_time" : _timeController.text,
                                        "item_name" : itemNameController.text,
                                        "latitude" : widget.userDetails['location'].split(",").first,
                                        "longitude" : widget.userDetails['location'].split(",").last,
                                        'status' : 'active',
                                      }, "food_details");

                                      if( foodItemPersentInFirebase ) {
                                        // this means that the document is present
                                        // then updating the document
                                        await FirebaseOperations.editProduct(
                                          "food_item",
                                          {
                                            'food_quantity': foodQuantityController.text,
                                            'type_of_food': "${vegSelected ? "veg" : ""}+${nonVegSelected ? "non-veg" : ""}+${veganSelected ? "vegan" : ""}",
                                            'expected_time': _timeController.text,
                                            'item_name': itemNameController.text.isEmpty ? "-" : itemNameController.text,
                                            "latitude" : widget.userDetails['location'].split(",").first,
                                            "longitude" : widget.userDetails['location'].split(",").last,
                                            "contact_number" : widget.userDetails['contact_number'],
                                          },
                                          widget.userEmail,
                                        );
                                      }
                                      else {
                                        // this means that the document is not present
                                        // then adding the document
                                        await FirebaseOperations.uploadingDataUsingCustomId(
                                          id: widget.userEmail,
                                          collectionName: "food_item",
                                          email: widget.userEmail,
                                          foodQuantity: foodQuantityController.text,
                                          typeOfFood: "${vegSelected ? "veg" : ""}+${nonVegSelected ? "non-veg" : ""}+${veganSelected ? "vegan" : ""}",
                                          expectedPickupTime: _timeController.text,
                                          itemName: itemNameController.text.isEmpty ? "-" : itemNameController.text,
                                          lat:  double.parse( widget.userDetails['location'].split(",").first),
                                          lon: double.parse( widget.userDetails['location'].split(",").last),
                                        );

                                        foodItemPersentInFirebase = true;
                                      }

                                      Navigator.of(context).pop();

                                      setState(() {
                                        foodStatusSaved = true;
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(primary: Colors.transparent, shadowColor: Colors.transparent),
                                    child: const Text(
                                      'Save',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600
                                      ),
                                    ),
                                  ),
                                )
                            ),
                          ],
                        );
                      }
                      else if( snapshot.hasError ) {
                        return Container(
                          alignment: Alignment.center,
                          child: Text( snapshot.error.toString() ),
                        );
                      }
                      else {
                        return Container(
                          height: mediaQuery.size.height * 0.7,
                          alignment: Alignment.center,
                          child: const CircularProgressIndicator.adaptive(
                            backgroundColor: Color(0xFFEC9F46),
                          ),
                        );
                      }
                    },
                  ),
                ),
                const SizedBox(
                  height: 30,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}


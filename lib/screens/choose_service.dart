import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_app/screens/home_screen.dart';
import 'package:food_app/screens/register_food_provider.dart';
import 'package:food_app/screens/sign_in_screen.dart';
import 'package:food_app/utils/circle_painter.dart';
import 'package:food_app/utils/firebase_operations.dart';
import 'package:food_app/utils/hive_services.dart';

class ChooseService extends StatefulWidget {
  final User user;

  const ChooseService({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  _ChooseServiceState createState() => _ChooseServiceState();
}

class _ChooseServiceState extends State<ChooseService> {
  final HiveServices hiveService = HiveServices();

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          SizedBox(
            height: mediaQuery.size.height,
            child: Column(
              children: [
                Transform.translate(
                  offset: Offset( - mediaQuery.size.width * 0.9, 250),
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
                  offset: Offset( mediaQuery.size.width * 1.12 , mediaQuery.size.height * 0.15 ),
                  child: Transform.scale(
                    scale: 1.5,
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
          Transform.translate(
            offset: Offset( mediaQuery.size.width * 0.58, mediaQuery.size.height * 0.97 ),
            child: const CustomPaint(
              size: Size( 60, 60),
              painter: CirclePainter(
                offset: Offset( 400, 0 ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.only(top: 20.0, ),
                  height: 100,
                  child: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(
                     Icons.arrow_back_ios_sharp,
                    ),
                  ),
                ),
                Container(
                  height: 200 ,
                  width: mediaQuery.size.width * 0.9,
                  margin: EdgeInsets.symmetric( horizontal: mediaQuery.size.width * 0.05 ),
                  child: Text(
                    "Which service would you like to provide",
                    style: TextStyle(
                        fontSize: mediaQuery.textScaleFactor * 40,
                        fontWeight: FontWeight.w900
                    ),
                  ),
                ),


                Container(
                    width: mediaQuery.size.width * 0.9,
                    margin: EdgeInsets.symmetric( horizontal: mediaQuery.size.width * 0.05, vertical: 12.0 ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      decoration: BoxDecoration(
                          color: Colors.white,
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
                      child: SizedBox(
                        height: 60,
                        child: ElevatedButton(
                          onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => RegisterFoodProvider(
                                user: widget.user,
                              ),
                            ),
                          ),
                          style: ElevatedButton.styleFrom(primary: Colors.transparent, shadowColor: Colors.transparent),
                          child: Container(
                            width: mediaQuery.size.width * 0.5,
                            padding: const EdgeInsets.only( right: 14.0),
                            child: const Text(
                              "I want to help by providing leftover food",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    )
                ),
                Container(
                    width: mediaQuery.size.width * 0.9,
                    margin: EdgeInsets.symmetric( horizontal: mediaQuery.size.width * 0.05, vertical: 12.0 ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      decoration: BoxDecoration(
                          color: Colors.white,
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
                      child: SizedBox(
                        height: 60,
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

                            final result = await FirebaseOperations.uploadingData(
                                collectionName: "users",
                                email: widget.user.email!,
                                role: "food_distributor",
                            );

                            Navigator.of(context).pop();

                            if( result.isNotEmpty ) {
                              // storing the user's uid
                              hiveService.setValue( result , "user_id" );

                              // redirecting to the food status screen
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) => HomeScreen(
                                        user: widget.user,
                                    ),
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(primary: Colors.transparent, shadowColor: Colors.transparent),
                          child: Container(
                            width: mediaQuery.size.width * 0.5,
                            padding: const EdgeInsets.only( right: 14.0),
                            child: const Text(
                              "I want to help by distributing leftover food",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    )
                ),


                Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    width: mediaQuery.size.width * 0.9,
                    margin: EdgeInsets.symmetric( horizontal: mediaQuery.size.width * 0.05 ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Know any other ways to provide help?"),
                        Padding(
                          padding: const EdgeInsets.only(left: 4.0),
                          child: GestureDetector(
                            onTap: () => Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => SignInScreen(),
                                )
                            ),
                            child: const Text(
                              "Contact us",
                              style: TextStyle(
                                  color: Color(0xFFEC9F46),
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

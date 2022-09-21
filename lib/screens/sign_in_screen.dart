import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_app/screens/food_status_scrren.dart';
import 'package:food_app/screens/home_screen.dart';
import 'package:food_app/screens/sign_up_screen.dart';
import 'package:food_app/utils/authentication.dart';
import 'package:food_app/utils/circle_painter.dart';
import 'package:food_app/utils/firebase_operations.dart';
import 'package:food_app/utils/hive_services.dart';
import 'package:food_app/utils/normal_dialog.dart';

class SignInScreen extends StatelessWidget {
  HiveServices hiveService = HiveServices();
  SignInScreen({Key? key}) : super(key: key);


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
                  offset: Offset( -mediaQuery.size.width * 0.3 , -120 ),
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
                  offset: Offset( mediaQuery.size.width * 0.75 , mediaQuery.size.height * 0.48 ),
                  child: Transform.scale(
                    scale: 1.5,
                    child: CustomPaint(
                      size: Size( mediaQuery.size.width, mediaQuery.size.width),
                      painter: const CirclePainter(
                        offset: Offset( 0, 500 ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: mediaQuery.size.width * 0.9,
                margin: EdgeInsets.symmetric( horizontal: mediaQuery.size.width * 0.05 ),
                child: Text(
                  "Sign in",
                  style: TextStyle(
                      fontSize: mediaQuery.textScaleFactor * 40,
                      fontWeight: FontWeight.w900
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                width: mediaQuery.size.width * 0.6,
                margin: EdgeInsets.symmetric( horizontal: mediaQuery.size.width * 0.05 ),
                child: Text(
                  "Already a member? Sign-in to continue this journey!",
                  style: TextStyle(
                    fontSize: mediaQuery.textScaleFactor * 14,

                  ),
                ),
              ),
              Container(
                width: mediaQuery.size.width * 0.9,
                margin: EdgeInsets.only( left: mediaQuery.size.width * 0.05, right: mediaQuery.size.width * 0.05, top: 20.0 ),
                child: TextField(
                  decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      enabledBorder:  OutlineInputBorder(
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
                      hintText: "Enter your Email Address",
                      hintStyle: TextStyle(
                        fontSize: 14.0 * mediaQuery.textScaleFactor,
                        color: Colors.grey,
                      )
                  ),
                ),
              ),
              Container(
                  width: mediaQuery.size.width * 0.9,
                  margin: EdgeInsets.symmetric( horizontal: mediaQuery.size.width * 0.05, vertical: 12.0 ),
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
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(primary: Colors.transparent, shadowColor: Colors.transparent),
                      child: const Text(
                        'Sign In',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600
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
                child: Text(
                  "or",
                  style: TextStyle(
                    fontSize: mediaQuery.textScaleFactor * 14,

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

                          User? user = await Authentication.signInWithGoogle(context: context);

                          debugPrint("user - " + user!.uid );


                          // checking if the current uid is registered on firebase
                          final data = await FirebaseOperations.getProduct(
                            "users",
                            user.email!
                          );

                          final userData = data!.data() as Map<String, dynamic>;

                          // also saving the user to hive services for next load up
                          hiveService.setValue( data.id , "user_id" );

                          if( data != null ) {
                            if( data['role'] == "food_provider" ) {
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) => FoodStatusScreen(
                                      userDetails: userData,
                                      userEmail: user.email!,
                                    ),
                                  )
                              );
                            }
                            else {
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) => HomeScreen(
                                        user: user ,
                                      )
                                  )
                              );
                            }
                          }
                          else {
                            Navigator.of(context).pop();

                            showDialog(
                                context: context,
                                builder: (context) => const NormalDialog(
                                    height: 180,
                                    header: "Oops!",
                                    message: "This user is not registered. Please sign up to use the service"
                                ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(primary: Colors.transparent, shadowColor: Colors.transparent),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only( right: 14.0),
                              child: Text(
                                "Sign in with Google",
                                style: TextStyle(
                                    color: Colors.black
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 30,
                              height: 30,
                              child: Image.network(
                                  "https://assets.stickpng.com/thumbs/5847f9cbcef1014c0b5e48c8.png"
                              ),
                            ),
                          ],
                        )
                    ),
                  )
              ),
              Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  width: mediaQuery.size.width * 0.9,
                  margin: EdgeInsets.symmetric( horizontal: mediaQuery.size.width * 0.05 ),
                  child: Row(
                    children: [
                      const Text("Don't Have an account?"),
                      Padding(
                        padding: const EdgeInsets.only(left: 4.0),
                        child: GestureDetector(
                          onTap: () => Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => const SignUpScreen(),
                              )
                          ),
                          child: const Text(
                            "Sign up",
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
              Container(
                alignment: Alignment.bottomCenter,
                height: 140,
                child: null,
              )
            ],
          ),
        ],
      ),
    );
  }
}

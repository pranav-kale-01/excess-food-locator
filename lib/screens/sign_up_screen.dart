import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_app/screens/choose_service.dart';
import 'package:food_app/screens/sign_in_screen.dart';
import 'package:food_app/utils/authentication.dart';
import 'package:food_app/utils/circle_painter.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
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
                  offset: Offset( mediaQuery.size.width * 0.3 , -120 ),
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
                  offset: Offset( -mediaQuery.size.width * 0.75 , mediaQuery.size.height * 0.48 ),
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
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: mediaQuery.size.width * 0.9,
                margin: EdgeInsets.symmetric( horizontal: mediaQuery.size.width * 0.05 ),
                child: Text(
                  "Sign Up",
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
                  "Sign up and be a part of this amazing contribution",
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
                        'Sign up',
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
              FutureBuilder(
                future: Authentication.initializeFirebase(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Error initializing Firebase');
                  } else if (snapshot.connectionState == ConnectionState.done) {
                    return Container(
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
                              User? user = await Authentication.signInWithGoogle(context: context);

                              if (user != null) {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => ChooseService(
                                      user: user,
                                    )
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
                                "Sign up with Google",
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
                    );
                  }
                  return const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                  Colors.orange,
                  ),
                  );
                },
              ),

              Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  width: mediaQuery.size.width * 0.9,
                  margin: EdgeInsets.symmetric( horizontal: mediaQuery.size.width * 0.05 ),
                  child: Row(
                    children: [
                      const Text("Already have an account?"),
                      Padding(
                        padding: const EdgeInsets.only(left: 4.0),
                        child: GestureDetector(
                          onTap: () => Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => SignInScreen(),
                              )
                          ),
                          child: const Text(
                            "Sign in",
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
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: mediaQuery.size.width * 0.05 ),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                        children: [
                          TextSpan(
                            text: "By providing my phone number, I hereby agree and accept the ",
                            style: TextStyle(
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const TextSpan(
                            text: "Terms of Service",
                            style: TextStyle(
                              color: Color.fromRGBO(233, 145, 144, 1),
                              fontWeight: FontWeight.w800,
                              decoration: TextDecoration.underline,
                              decorationThickness: 2.0,
                            ),
                          ),
                          TextSpan(
                            text: " and ",
                            style: TextStyle(
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const TextSpan(
                            text: "Privacy Policy",
                            style: TextStyle(
                              color: Color.fromRGBO(233, 145, 144, 1),
                              fontWeight: FontWeight.w800,
                              decoration: TextDecoration.underline,
                              decorationThickness: 2.0,
                            ),
                          ),
                          TextSpan(
                            text: " in use of the app.",
                            style: TextStyle(
                                color: Colors.grey.shade600
                            ),
                          )
                        ]
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

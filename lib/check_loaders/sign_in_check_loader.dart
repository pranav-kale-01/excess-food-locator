import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:food_app/screens/food_status_scrren.dart';
import 'package:food_app/screens/home_screen.dart';
import 'package:food_app/screens/sign_in_screen.dart';
import 'package:food_app/screens/sign_up_screen.dart';
import 'package:food_app/utils/firebase_operations.dart';
import 'package:food_app/utils/hive_services.dart';

class SignInCheckLoader extends StatefulWidget {
  const SignInCheckLoader({Key? key}) : super(key: key);

  @override
  _SignInCheckLoaderState createState() => _SignInCheckLoaderState();
}

class _SignInCheckLoaderState extends State<SignInCheckLoader> {
  late Future<void> userCredPresent;
  late List<dynamic> userCredentials;
  late Widget redirectScreen;
  HiveServices hiveService = HiveServices();

  @override
  initState() {
    super.initState();
    userCredPresent = init();
  }

  Future<void> init() async {
    await checkForUserCredentials();
  }

  Future<void> checkForUserCredentials() async {

    try {
      await Firebase.initializeApp();
      final user = FirebaseAuth.instance.currentUser;

      if( user == null ) {
        redirectScreen = SignInScreen();
        return;
      }

      // getting the uid
      await hiveService.init();
      bool data = await hiveService.isExists(boxName: 'user_id');

      if( data ) {
        var box = await hiveService.openHiveBox('user_id');
        String uid = box.values.first;

        debugPrint( "box - " + box.values.toString() );

        // checking if the current uid is registered on firebase
        final data = await FirebaseOperations.getProductById(
          "users",
          uid
        );

        if( data!['role'] == "food_provider" ) {
          redirectScreen = FoodStatusScreen(
            userDetails: data,
            userEmail: user.email!,
          );
        }
        else {
          redirectScreen = HomeScreen(
            user: user,
          );
        }
      }
      else {
        redirectScreen = const SignUpScreen();
      }
    }
    catch( e, s ) {
      debugPrint( e.toString() );
      debugPrint( s.toString() );
      redirectScreen = const SignUpScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: userCredPresent,
      builder: (context, snapshot) {
        if( snapshot.connectionState == ConnectionState.done ) {
          return redirectScreen;
        }
        else if( snapshot.hasError ) {
          return Scaffold(
            body: Container(
              alignment: Alignment.center,
              child: Text( snapshot.error.toString() ),
            ),
          );
        }
        else {
          return Scaffold(
            body: Container(
              alignment: Alignment.center,
              child: const CircularProgressIndicator.adaptive(),
            ),
          );
        }
      },
    );
  }
}
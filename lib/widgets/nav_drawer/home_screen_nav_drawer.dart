import 'package:flutter/material.dart';
import 'package:food_app/screens/sign_in_screen.dart';
import 'package:food_app/utils/authentication.dart';

class HomeScreenNavigationDrawer extends StatelessWidget {
  late MediaQueryData mediaQuery;

  HomeScreenNavigationDrawer({
    Key? key,
  }) : super(key: key);


  Widget buildMenuItems(BuildContext context) => Container(
    padding: const EdgeInsets.only(top: 20.0, bottom: 20.0, left: 20.0),
    height: mediaQuery.size.height - mediaQuery.padding.top,
    child: Column(
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.only(top: 20.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Text(
                      "Yummy Donation",
                      style: TextStyle(
                        fontFamily: "Baumans",
                        fontWeight: FontWeight.w900,
                        color: const Color(0xFFEC9F46),
                        fontSize: 34 * mediaQuery.textScaleFactor,

                      ),
                    ),
                  ),
                ],
              ),
            ),

            // separator
            Container(
              margin: const EdgeInsets.only(top: 20.0, right: 15.0, bottom: 10.0),
              height: 1,
              child: Container(
                color: Colors.grey.shade300,
              ),
            ),

            GestureDetector(
              onTap: () {
                Authentication.signOut(context: context);

                // Navigating to sign in screen
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => SignInScreen(),
                  )
                );
              },
              child: Container(
                  margin: const EdgeInsets.only(top: 4.0),
                  padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
                  color: Colors.transparent,
                  child: Row(
                    children: [
                      Icon(
                        Icons.logout,
                        color: Colors.red,
                        size: 20 * mediaQuery.textScaleFactor,
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 14.0),
                        child: Text(
                          "Logout",
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 14.0 * mediaQuery.textScaleFactor,
                          ),
                        ),
                      ),
                    ],
                  )
              ),
            ),
          ],
        ),


        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric( horizontal: 8.0),
            alignment: Alignment.bottomCenter,
            child: GestureDetector(
              onTap: () {
               debugPrint('test');
              },
              child: Container(
                color: Colors.white,
                height: 65,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 10.0, right: 10.0),
                      height: 1,
                      child: Container(
                        color: Colors.grey.shade300,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ),
        ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    mediaQuery = MediaQuery.of(context);

    return Container(
      color: Colors.white,
      width: mediaQuery.size.width * 0.72,
      child: buildMenuItems(context),
    );
  }
}

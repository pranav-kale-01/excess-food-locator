import 'package:flutter/material.dart';

class NormalDialog extends StatelessWidget {
  final String header;
  final String message;
  final double height;

  const NormalDialog({
    Key? key,
    required this.height,
    required this.header,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Stack(
      children: [
        Center(
          child: Container(
            height: height,
            width: mediaQuery.size.width * 0.92,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10)
            ),
          ),
        ),
        Transform.translate(
          offset: const Offset( -20, 0 ),
          child: Dialog(
              elevation: 0,
              child: Container(
                width: mediaQuery.size.width * 1.2,
                height: height,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Padding(
                  padding: const EdgeInsets.only( top: 16.0, right: 16.0, left: 16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        header,
                        style: TextStyle(
                          fontSize: 28 * mediaQuery.textScaleFactor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Container(
                        width: mediaQuery.size.width * 0.8,
                        padding: const EdgeInsets.only(top: 12.0),
                        child: Text(
                          message,
                          style: TextStyle(
                              fontSize: 16 * mediaQuery.textScaleFactor
                          ),
                        ),
                      ),
                      Transform.translate(
                        offset: const Offset( 40, 0),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<Color>( const Color(0xFFEC9F46), ),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 14.0),
                                  child: Text(
                                    "Ok",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600
                                    ),
                                  ),
                                ),
                              )

                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
          ),
        ),

      ],
    );
  }
}

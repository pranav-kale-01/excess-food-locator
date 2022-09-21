import 'package:flutter/foundation.dart';

import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class HiveServices {
  Future<void> init() async {
    Hive.init( (await getApplicationDocumentsDirectory()).path );
  }

  /// opens a new box if hive box present, else creates a new hive box
  Future<Box> openHiveBox( String boxName ) async {
    if (!kIsWeb) {
      await init();
    }

    return await Hive.openBox(boxName);
  }

  isExists({required String boxName}) async {
    final openBox = await Hive.openBox(boxName);
    int length = openBox.length;
    return length != 0;
  }

  addBoxes<T>(List<T> items, String boxName) async {
    final openBox = await Hive.openBox(boxName);

    for (var item in items) {
      openBox.add(item);
    }
  }

  /// overwrites the old value of the box with the new value
  void setValue( var item, String boxName ) async {
    final openBox = await Hive.openBox(boxName);

    // truncating the box first
    openBox.deleteAll(openBox.keys);

    // now adding the values
    openBox.add( item );
  }

  Future<List<dynamic>> getBoxes<T>(String boxName) async {
    List<T> boxList = <T>[];

    final openBox = await Hive.openBox(boxName);

    int length = openBox.length;

    for (int i = 0; i < length; i++) {
      boxList.add(openBox.getAt(i));
    }

    return boxList;
  }

  Future<bool> deleteBox<T> (String boxName ) async {
    try {
      final openBox = await Hive.openBox(boxName);

      // truncating the box first
      openBox.deleteAll(openBox.keys);

      // closing the opened box
      openBox.close();

      return true;
    }
    catch( e, s ) {
      debugPrint( e.toString() );
      debugPrint( s.toString() );
      return false;
    }
  }
}
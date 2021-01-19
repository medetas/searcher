import 'package:flutter/services.dart' show rootBundle;
import 'dart:async';

class FileReader {
  Future<List> loadAsset() async {
    var response = await rootBundle.loadString('assets/words.txt');
    var list = response.split('\n');
    return list;
  }
}

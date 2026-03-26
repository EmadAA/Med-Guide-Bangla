import 'dart:convert';

import 'package:flutter/services.dart';

class JsonService {
  static Future<List<dynamic>> loadData() async {
    final String response = await rootBundle.loadString(
      'assets/data/medicine.json',
    );

    return json.decode(response);
  }
}

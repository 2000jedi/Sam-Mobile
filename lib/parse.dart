import 'package:flutter/services.dart';

class Parse{
  static String cookie;
}

DateTime parseTime(String date){
  var _date = date.split("-");
  return new DateTime(int.parse(_date[0]), int.parse(_date[1]), int.parse(_date[2]));
}

parseGet(String url) async{
  var httpClient = createHttpClient();
  return await httpClient.read(url, headers: {'User-Agent': 'Dart/1.0', 'Cookie': Parse.cookie});
}

String capitalize(String s) => s[0].toUpperCase() + s.substring(1);
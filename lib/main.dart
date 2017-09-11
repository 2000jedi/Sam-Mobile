import 'package:flutter/material.dart';
import 'package:sam_mobile/dashboard.dart';
import 'package:sam_mobile/login.dart';
import 'package:sam_mobile/parse.dart';
import 'package:shared_preferences/shared_preferences.dart';

getCookie() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String cookie = prefs.getString('cookie') ?? '';
  if (cookie == ''){
    runApp(new Login());
  } else {
    Parse.cookie = cookie;
    runApp(new Dashboard());
  }
}

void main() {
  getCookie();
}

//TODO: Settings Panel

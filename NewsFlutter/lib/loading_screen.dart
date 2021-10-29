import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key key}) : super(key: key);

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {

  @override
  void initState() {
    // TODO: implement initState
    print("LOADING");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    double w_device = MediaQuery.of(context).size.width;
    double h_device = MediaQuery.of(context).size.height;

    return Scaffold(
      body:  Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          width: w_device*0.5,height: w_device*0.5,
            child: Align(
              alignment: Alignment.center,
                child: CircularProgressIndicator())
        ),
      ),

    );

  }
}

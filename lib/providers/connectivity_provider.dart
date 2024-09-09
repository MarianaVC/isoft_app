import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class CheckConnectionPage {

  getConnectivityStatus() async {
  final connectivityResult = await Connectivity().checkConnectivity();
  return (connectivityResult == ConnectivityResult.none);
  }
  
  }
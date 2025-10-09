import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:user_registration/http/http_extensions.dart';
import 'package:user_registration/internet_checker.dart';
import 'package:user_registration/user.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

class ApiHandler {
  final String baseUri = "http://192.168.3.9:7018/api/users";

  Future<List<User>> getUserData({String? filter}) async {
    List<User> data = [];

    Uri uri = Uri.parse(baseUri);

    if (filter != '' && filter != null) {
      uri = uri.replace(queryParameters: {'filter': filter});
    }

    try {
      if (!await InternetChecker.hasConnection()) {
        throw Exception('Check your internet connection!');
      }

      final response = await http.get(uri, headers: <String, String>{
        'Content-type': 'application/json; charset=UTF-8'
      });

      print(response.body);

      if (response.statusCode >= 200 && response.statusCode <= 299) {
        final List<dynamic> jsonData = json.decode(response.body);
        data = jsonData
            .map(
              (json) => User.fromJson(json),
            )
            .toList();
      } else {
        throw "Refresh failed: ${response.statusCode} - ${response.statusMessage}";
      }
    } catch (e) {
      String msg = "$e";
      Fluttertoast.showToast(
          msg: msg,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey[700],
          textColor: Colors.white,
          fontSize: 16.0);
      return data;
    }

    return data;
  }

  Future<http.Response> updateUser(
      {required String id, required User user}) async {
    final uri = Uri.parse("$baseUri/$id");
    late http.Response response;

    try {
      if (!await InternetChecker.hasConnection()) {
        throw Exception('Check your internet connection!');
      }

      response = await http.put(
        uri,
        headers: <String, String>{
          'Content-type': 'application/json; charset=UTF-8'
        },
        body: json.encode(user),
      );

      if (response.statusCode < 200 || response.statusCode > 299) {
        throw "Update failed: ${response.statusCode} - ${response.statusMessage}";
      }
    } catch (e) {
      String msg = "$e";
      Fluttertoast.showToast(
          msg: msg,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey[700],
          textColor: Colors.white,
          fontSize: 16.0);
    }

    return response;
  }

  Future<http.Response> addUser({required User user}) async {
    final uri = Uri.parse(baseUri);
    late http.Response response;

    try {
      if (!await InternetChecker.hasConnection()) {
        throw Exception('Check your internet connection!');
      }

      response = await http.post(
        uri,
        headers: <String, String>{
          'Content-type': 'application/json; charset=UTF-8'
        },
        body: json.encode(user),
      );

      if (response.statusCode < 200 || response.statusCode > 299) {
        throw "Create failed: ${response.statusCode} - ${response.statusMessage}";
      }
    } catch (e) {
      String msg = "$e";
      Fluttertoast.showToast(
          msg: msg,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey[700],
          textColor: Colors.white,
          fontSize: 16.0);
    }

    return response;
  }

  Future<http.Response> deleteUser({required String userId}) async {
    final uri = Uri.parse("$baseUri/$userId");
    late http.Response response;

    try {
      if (!await InternetChecker.hasConnection()) {
        throw Exception('Check your internet connection!');
      }

      response = await http.delete(
        uri,
        headers: <String, String>{
          'Content-type': 'application/json; charset=UTF-8'
        },
      );

      if (response.statusCode < 200 || response.statusCode > 299) {
        throw "Delete failed: ${response.statusCode} - ${response.statusMessage}";
      }
    } catch (e) {
      String msg = "$e";
      Fluttertoast.showToast(
          msg: msg,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey[700],
          textColor: Colors.white,
          fontSize: 16.0);
    }

    return response;
  }

  Future<User> getUserById(String id) async {
    User? user;

    final uri = Uri.parse("$baseUri/$id");

    try {
      if (!await InternetChecker.hasConnection()) {
        throw Exception('Check your internet connection!');
      }

      final response = await http.get(
        uri,
        headers: <String, String>{
          'Content-type': 'application/json; charset=UTF-8'
        },
      );

      print(response.body);

      if (response.statusCode >= 200 && response.statusCode <= 299) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        user = User.fromJson(jsonData);
      } else {
        throw "Search by Id failed: ${response.statusCode} - ${response.statusMessage}";
      }
    } catch (e) {
      String msg = "$e";
      Fluttertoast.showToast(
          msg: msg,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey[700],
          textColor: Colors.white,
          fontSize: 16.0);
      return user!;
    }

    return user!;
  }
}

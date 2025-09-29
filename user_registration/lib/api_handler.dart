import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:user_registration/http/http_extensions.dart';
import 'package:user_registration/user.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

class ApiHandler {
  final String baseUri = "http://192.168.3.9:7018/api/users";

  Future<List<User>> getUserData() async {
    List<User> data = [];

    final uri = Uri.parse(baseUri);

    try {
      final response = await http.get(
        uri,
        headers: <String, String>{
          'Content-type': 'application/json; charset=UTF-8'
        },
      );

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
      print(msg);
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
      response = await http.put(
        uri,
        headers: <String, String>{
          'Content-type': 'application/json; charset=UTF-8'
        },
        body: json.encode(user),
      );
    } catch (e) {
      print('Caiu no catch: ${e}');
    }

    return response;
  }

  Future<http.Response> addUser({required User user}) async {
    final uri = Uri.parse(baseUri);
    late http.Response response;

    try {
      response = await http.post(
        uri,
        headers: <String, String>{
          'Content-type': 'application/json; charset=UTF-8'
        },
        body: json.encode(user),
      );
    } catch (e) {
      print('Caiu no catch: ${e}');
    }

    return response;
  }

  Future<http.Response> deleteUser({required String userId}) async {
    final uri = Uri.parse("$baseUri/$userId");
    late http.Response response;

    try {
      response = await http.delete(
        uri,
        headers: <String, String>{
          'Content-type': 'application/json; charset=UTF-8'
        },
      );
    } catch (e) {
      print('Caiu no catch: ${e}');
    }

    return response;
  }
}

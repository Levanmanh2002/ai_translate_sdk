import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:ai_translate/utils/app_constants.dart';
import 'package:ai_translate/utils/local_storage.dart';
import 'package:ai_translate/utils/shared_key.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class IBaseRepository {
  final int timeoutInSeconds = 30;

  static String noInternetMessage = 'No internet connection. Please check your network settings.';

  void handleError(error) {
    if (error is SocketException && error.osError != null) {
      final osError = error.osError;
      if (osError?.errorCode == 101) {}
    }
  }

  getAuthorizationHeader() {
    final token = LocalStorage.getString(SharedKey.token);

    log('====> API Token: $token');

    return {
      'Content-Type': 'application/json',
      'lang': 'vn',
      'gmt': '1',
      'os-name': '.',
      'os-version': '.',
      'app-version': '.',
      'uuid': '.',
      'X-API-KEY': 'UhuO0gcCmnnYqJDHAQVjJMY2XK8oud2U5BlfeXcRqPTdEtJ0zB3NnRatM1kO',
      'Cookie': 'JSESSIONID=--p3w_9ueOznK6NANWBde1BpA0XcoxzGaj-25UOp.d489dc141a8c',
      'Secret-Key': 'R8VRPGU0RUT3+QJH2ychumFxuYm9n+9fH7wKi/hxiBLohw4eW1/FKJMtkffxVrt6//fBx31Q1GaCMOHVjbuziw==',
      'Authorization': 'Bearer $token',
    };
  }

  Future<http.Response> clientGetData(
    String uri, {
    String? baseUrl,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) async {
    try {
      debugPrint('====> API Call: $uri\nHeader: ${getAuthorizationHeader()}');
      http.Response response = await http
          .get(
            Uri.parse((baseUrl ?? AppConstants.baseUrl) + uri),
            headers: headers ?? getAuthorizationHeader(),
          )
          .timeout(Duration(seconds: timeoutInSeconds));
      return response;
    } catch (e) {
      return http.Response(jsonEncode({'error': noInternetMessage}), 0);
    }
  }

  Future<Response> clientPostData(
    String uri,
    dynamic body, {
    String? baseUrl,
    Map<String, String>? headers,
  }) async {
    try {
      debugPrint('====> API Call: $uri\nHeader: ${getAuthorizationHeader()}');
      debugPrint('====> API Body: $body');
      http.Response response = await http
          .post(
            Uri.parse((baseUrl ?? AppConstants.baseUrl) + uri),
            // body: body,
            body: jsonEncode(body),
            headers: headers ?? getAuthorizationHeader(),
          )
          .timeout(Duration(seconds: timeoutInSeconds));
      return response;
    } catch (e) {
      return http.Response(jsonEncode({'error': noInternetMessage}), 0);
    }
  }

  Future<Response> clientPutData(String uri, dynamic body, {Map<String, String>? headers}) async {
    try {
      debugPrint('====> API Call: $uri\nHeader: ${getAuthorizationHeader()}');
      debugPrint('====> API Body: $body');
      http.Response response = await http
          .put(
            Uri.parse(AppConstants.baseUrl + uri),
            body: jsonEncode(body),
            headers: headers ?? getAuthorizationHeader(),
          )
          .timeout(Duration(seconds: timeoutInSeconds));
      return response;
    } catch (e) {
      return http.Response(jsonEncode({'error': noInternetMessage}), 0);
    }
  }

  Future<Response> clientDeleteData(String uri, {Map<String, String>? headers}) async {
    try {
      debugPrint('====> API Call: $uri\nHeader: ${getAuthorizationHeader()}');
      http.Response response = await http
          .delete(
            Uri.parse(AppConstants.baseUrl + uri),
            headers: headers ?? getAuthorizationHeader(),
          )
          .timeout(Duration(seconds: timeoutInSeconds));
      return response;
    } catch (e) {
      return http.Response(jsonEncode({'error': noInternetMessage}), 0);
    }
  }
}

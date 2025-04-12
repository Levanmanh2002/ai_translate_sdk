import 'dart:convert';
import 'dart:io';

import 'package:ai_translate/models/response/error_response.dart';
import 'package:ai_translate/routes/pages.dart';
import 'package:ai_translate/utils/app_constants.dart';
import 'package:ai_translate/utils/dialog_util.dart';
import 'package:ai_translate/utils/local_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class IBaseRepository {
  final int timeoutInSeconds = 30;

  static String noInternetMessage = 'network_connection'.tr;

  void handleError(error) {
    if (error is SocketException && error.osError != null) {
      final osError = error.osError;
      if (osError?.errorCode == 101) {
        DialogUtils.showInfoErrorDialog(content: error.message);
      }
    }
  }

  getAuthorizationHeader() {
    return {
      // 'Content-Type': 'application/json; charset=UTF-8',
      'lang': 'vn',
      'gmt': '1',
      'os-name': '.',
      'os-version': '.',
      'app-version': '.',
      'uuid': '.',
    };
  }

  Future<Response> clientGetData(String uri, {Map<String, dynamic>? query, Map<String, String>? headers}) async {
    try {
      debugPrint('====> API Call: $uri\nHeader: ${getAuthorizationHeader()}');
      http.Response response = await http
          .get(
            Uri.parse(AppConstants.baseUrl + uri),
            headers: headers ?? getAuthorizationHeader(),
          )
          .timeout(Duration(seconds: timeoutInSeconds));
      return handleResponse(response, uri);
    } catch (e) {
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  Future<Response> clientPostData(String uri, dynamic body, {Map<String, String>? headers}) async {
    try {
      debugPrint('====> API Call: $uri\nHeader: ${getAuthorizationHeader()}');
      debugPrint('====> API Body: $body');
      http.Response response = await http
          .post(
            Uri.parse(AppConstants.baseUrl + uri),
            body: body,
            headers: headers ?? getAuthorizationHeader(),
          )
          .timeout(Duration(seconds: timeoutInSeconds));
      return handleResponse(response, uri);
    } catch (e) {
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  // Future<Response> clientPostMultipartData(
  //   String uri,
  //   Map<String, String> body,
  //   List<MultipartBody> multipartBody, {
  //   Map<String, String>? headers,
  // }) async {
  //   try {
  //     debugPrint('====> API Call: $uri\nHeader: ${getAuthorizationHeader()}');
  //     debugPrint('====> API Body: $body with ${multipartBody.length} files');
  //     http.MultipartRequest request = http.MultipartRequest('POST', Uri.parse(AppConstants.baseUrl + uri));
  //     request.headers.addAll(headers ?? getAuthorizationHeader());

  //     for (MultipartBody multipart in multipartBody) {
  //       if (multipart.file != null) {
  //         File file = File(multipart.file!.path);
  //         request.files.add(http.MultipartFile(
  //           multipart.key,
  //           file.readAsBytes().asStream(),
  //           file.lengthSync(),
  //           filename: file.path.split('/').last,
  //         ));
  //       }
  //     }

  //     request.fields.addAll(body);
  //     http.Response response = await http.Response.fromStream(await request.send());
  //     return handleResponse(response, uri);
  //   } catch (e) {
  //     return Response(statusCode: 1, statusText: noInternetMessage);
  //   }
  // }

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
      return handleResponse(response, uri);
    } catch (e) {
      return Response(statusCode: 1, statusText: noInternetMessage);
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
      return handleResponse(response, uri);
    } catch (e) {
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  Future<Response> handleResponse(http.Response response, String uri) async {
    dynamic body;
    try {
      body = jsonDecode(response.body);
    } catch (_) {}
    Response response0 = Response(
      body: body ?? response.body,
      bodyString: response.body.toString(),
      headers: response.headers,
      statusCode: response.statusCode,
      statusText: response.reasonPhrase,
    );
    if (response0.statusCode != 200 && response0.body != null && response0.body is! String) {
      if (response0.body.toString().startsWith('{errors: [{code:')) {
        ErrorResponse errorResponse = ErrorResponse.fromJson(response0.body);
        response0 = Response(
            statusCode: response0.statusCode, body: response0.body, statusText: errorResponse.errors![0].message);
      } else if (response0.body.toString().startsWith('{message')) {
        response0 =
            Response(statusCode: response0.statusCode, body: response0.body, statusText: response0.body['message']);
      }
    } else if (response0.statusCode != 200 && response0.body == null) {
      response0 = Response(statusCode: 0, statusText: noInternetMessage);
    }

    if (response0.statusCode == 401) {
      await _logout();
    }

    debugPrint('====> API Response: [${response0.statusCode}] $uri');
    print('====> API body: ${response0.body}');

    return response0;
  }

  Future<void> _logout() async {
    await LocalStorage.clearAll();

    Get.offAllNamed(Routes.SPLASH);
  }
}

// class MultipartBody {
//   String key;
//   XFile? file;

//   MultipartBody(this.key, this.file);
// }

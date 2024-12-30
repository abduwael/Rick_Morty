import 'dart:convert';

import 'package:get/get_connect/http/src/response/response.dart';

import 'app_exception.dart';

class NetworkException extends AppException {
  final Response _networkResponse;

  NetworkException(this._networkResponse) : super(_networkResponse.statusText);

  Response get networkResponse => _networkResponse;

  @override
  String toString() {
    final dynamic responseJson;
    try {
      responseJson = jsonDecode(_networkResponse.bodyString!);
    } catch (e) {
      return 'Something went wrong';
    }

    String errorMessage = '';

    if (responseJson is Map<String, dynamic>) {
      if (responseJson.containsKey('error')) {
        if (responseJson['error'] is Map) {
          final Map<String, dynamic> errorsMap = responseJson['error'];
          errorsMap.forEach((key, value) {
            errorMessage += '$value ';
          });
        } else if (responseJson['error'] is String) {
          errorMessage = responseJson['error'];
        }
      } else {
        errorMessage = 'Something went wrong';
      }
    } else {
      errorMessage = 'Something went wrong';
    }

    return errorMessage;
  }
}

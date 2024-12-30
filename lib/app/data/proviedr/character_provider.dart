import 'package:flutter/cupertino.dart';
import 'package:get/get_connect/connect.dart';
import 'package:get/get_connect/http/src/response/response.dart';

import '../exception/network_exception.dart';
import '../models/character_model.dart';

class CharacterProvider extends GetConnect {
  static const int maxRetries = 3;

  Future<CharacterModel?> getCharacters({int page = 1}) async {
    int retryCount = 0;
    Response<dynamic>? result;

    while (retryCount < maxRetries) {
      try {
        result = await get(
          'https://rickandmortyapi.com/api/character',
          query: {'page': '$page'},
        );
        if (!result.isOk) {
          throw NetworkException(
            result,
          );
        }
        if (result.isOk) {
          debugPrint("Character Details: ${result.body}");
          return CharacterModel.fromJson(result.body);
        } else {
          retryCount++;
          debugPrint("Request failed. Retrying... Attempt: $retryCount");
        }
      } catch (e) {
        retryCount++;
        debugPrint("Error occurred: $e. Retrying... Attempt: $retryCount");
      }
    }
  }
}

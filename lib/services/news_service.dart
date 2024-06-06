import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:glide_web/models/newsModels/news_model.dart';
import 'package:glide_web/models/responseModels/failure.dart';
import 'package:glide_web/models/responseModels/response_code.dart';
import 'package:glide_web/models/responseModels/success.dart';
import 'package:glide_web/utils/app_strings.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

class NewsService {
  static Future<Object> fetchNews() async {
    try {
      Response response = await http.get(Uri.parse(AppStrings.newsApiUrl));
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = jsonDecode(response.body);
        return Success(response: NewsModel.fromJson(jsonData));
      } else {
        return Failure(
            response.statusCode,
            ResponseCode.httpStatusMessages[response.statusCode] ??
                AppStrings.unknownErrorText);
      }
    } catch (exception) {
      if (kDebugMode) {
        debugPrint(exception.toString());
      }
    }
    return Failure(600, AppStrings.unknownErrorText);
  }
}

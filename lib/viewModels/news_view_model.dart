import 'package:flutter/foundation.dart';
import 'package:glide_web/models/newsModels/articles.dart';
import 'package:glide_web/models/newsModels/news_model.dart';
import 'package:glide_web/models/responseModels/success.dart';
import 'package:glide_web/services/news_service.dart';

class NewsViewModel extends ChangeNotifier {
  late Object? response;

  List<Articles> articles = [];

  Future<void> getNews() async {
    try {
      response = await NewsService.fetchNews();
      if (response is Success) {
        NewsModel newsModel = (response as Success).response as NewsModel;
        if (newsModel.articles != null) {
          articles = List.from(newsModel.articles as Iterable);
          notifyListeners();
        }
      }
    } catch (exception) {
      if (kDebugMode) {
        debugPrint(exception.toString());
      }
    }
  }
}

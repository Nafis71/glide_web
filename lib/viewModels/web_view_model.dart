import 'package:flutter/foundation.dart';

class WebViewModel extends ChangeNotifier {
  bool _isLoading = false;

  String _url = "";
  double _progress = 0.0;

  double get progress => _progress;

  String get url => _url;

  set setUrl(String url) {
    _url = url;
  }

  bool get isLoading => _isLoading;

  void setIsLoading(bool value, double progress) {
    _isLoading = value;
    _progress = progress;
    notifyListeners();
  }
}

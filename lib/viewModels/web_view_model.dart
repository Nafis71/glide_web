import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:glide_web/utils/app_strings.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class WebViewModel extends ChangeNotifier {
  bool _isLoading = false;

  bool hasFinishedTalking = false;
  String recognizedWords = "";

  String _url = "";
  double _progress = 0.0;
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;

  double get progress => _progress;

  String get url => _url;

  set setUrl(String url) {
    _url = url;
  }

  Future<void> initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    if (_speechEnabled) {
      startListening();
    }
  }

  Future<void> startListening() async {
    await _speechToText.listen(onResult: onSpeechResult);
  }

  void onSpeechResult(SpeechRecognitionResult result) {
    recognizedWords = result.recognizedWords;
    List<String> listOfStrings = recognizedWords.split(RegExp(r"\W+"));
    String joinedStrings = listOfStrings.join("+");
    _url = processUrl(joinedStrings);
  }

  String processUrl(String url){
    if(!url.contains(".")){
      return "${AppStrings.searchUrlPrefix}$url";
    } else if(url.contains("https://")){
      return url;
    }
    else{
      return "https://$url";
    }
  }

  void loadVoiceUrl(){
    hasFinishedTalking = true;
    setIsLoading(true, 0.0);
  }

  bool get isLoading => _isLoading;

  void setIsLoading(bool value, double progress) {
    _isLoading = value;
    _progress = progress;
    notifyListeners();
  }
}

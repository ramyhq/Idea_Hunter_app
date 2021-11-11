import 'package:flutter/material.dart';


class IsRecording extends ChangeNotifier {

  bool _isRecording = false;

  checkIsRecording (){
    _isRecording =! _isRecording;
    notifyListeners();
  }

  bool getIsRecordingState (){
    return _isRecording;
  }
}
import 'dart:async';

import 'package:rxdart/rxdart.dart';

class LearnModeBloc {
  final _learnModeEnableController = BehaviorSubject<bool>();

  StreamSink<bool> get learnModeEnableSink => _learnModeEnableController.sink;

  Stream<bool> get learnModeEnableStream => _learnModeEnableController.stream;

  final _learnModeItemClickedController = BehaviorSubject<int>();

  StreamSink<int> get learnModeItemClickSink =>
      _learnModeItemClickedController.sink;

  Stream<int> get learnModeItemClickStream =>
      _learnModeItemClickedController.stream;

  final _learnModeEnable1 = BehaviorSubject<bool>();
  final _isItemClicked1 = BehaviorSubject<bool>();

// Getter
  Stream<bool> get learnModeEnable1 => _learnModeEnable1.stream;

  Stream<bool> get isItemClicked1 => _isItemClicked1.stream;

//Setter
  Function(bool) get ChangeLearnModeEnable => _learnModeEnable1.sink.add;

  Function(bool) get ChangeLearnModeItemClicked => _isItemClicked1.sink.add;

  void dispose() {
    _learnModeEnable1.close();
    _isItemClicked1.close();
    learnModeEnableSink.close();
    _learnModeItemClickedController.close();
    learnModeItemClickSink.close();
  }
}

class SearchMenuEvent {
  bool? doubleTapEnable,isFilterApply,isOptionOneEnable,isOptionTwoEnable,isOptionThirdEnable,isOptionFourEnable;
  SearchMenuEvent({this.doubleTapEnable,this.isFilterApply,this.isOptionOneEnable,this.isOptionTwoEnable,this.isOptionThirdEnable,this.isOptionFourEnable});
}
class OptionOneChanged extends SearchMenuEvent {
  OptionOneChanged({required this.optionOne});
  final bool optionOne;
}
class OptionTwoChanged extends SearchMenuEvent {
  OptionTwoChanged({required this.optionTwo});
  final bool optionTwo;
}
class OptionThreeChanged extends SearchMenuEvent {
  OptionThreeChanged({required this.optionThree});
  final bool optionThree;
}
class OptionFourChanged extends SearchMenuEvent {
  OptionFourChanged({required this.optionFour});
  final bool optionFour;
}
class DoubleTapOptionChanged extends SearchMenuEvent {
  DoubleTapOptionChanged({required this.doubleTapEnable});
  final bool doubleTapEnable;
}

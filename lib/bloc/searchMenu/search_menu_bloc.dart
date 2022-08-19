import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/preferenecs.dart';
import '../../strings.dart';
import 'search_menu_event.dart';
import 'search_menu_state.dart';

class SearchMenuBloc extends Bloc<SearchMenuEvent, SearchMenuScreenState> {
  SearchMenuBloc() : super(
    SearchMenuScreenState(
        doubleTapEnable: Preferences.getSearchFilter(Strings.enableDoubleTap),
        isFilterApply: false,
        isOptionOneEnable:Preferences.getSearchFilter(Strings.similarOption_1_1),
        isOptionTwoEnable: Preferences.getSearchFilter(Strings.similarOption_2_1),
        isOptionThirdEnable:Preferences.getSearchFilter(Strings.similarOption_3_1),
        isOptionFourEnable: Preferences.getSearchFilter(Strings.similarOption_4_1),
    ),
  ){
    on<OptionOneChanged>(_OnOptionOneChanged);
    on<OptionTwoChanged>(_OnOptionTwoChanged);
    on<OptionThreeChanged>(_OnOptionThreeChanged);
    on<OptionFourChanged>(_OnOptionFourChanged);
    on<DoubleTapOptionChanged>(_OnDoubleTapOptionChanged);
  }

  void _OnOptionOneChanged(OptionOneChanged event, Emitter<SearchMenuScreenState> emit) {
    Preferences.saveSearchFilter(Strings.similarOption_1_1,event.optionOne);
    emit(SearchMenuScreenState(isOptionOneEnable: event.optionOne,
        isOptionTwoEnable:Preferences.getSearchFilter(Strings.similarOption_2_1),
        isOptionThirdEnable: Preferences.getSearchFilter(Strings.similarOption_3_1),
        isOptionFourEnable: Preferences.getSearchFilter(Strings.similarOption_4_1),
        doubleTapEnable: Preferences.getSearchFilter(Strings.enableDoubleTap),
    ));
  }

  void _OnOptionTwoChanged(OptionTwoChanged event, Emitter<SearchMenuScreenState> emit) {
    Preferences.saveSearchFilter(Strings.similarOption_2_1,event.optionTwo);
    emit(SearchMenuScreenState(isOptionTwoEnable: event.optionTwo,
      isOptionOneEnable:Preferences.getSearchFilter(Strings.similarOption_1_1),
      isOptionThirdEnable: Preferences.getSearchFilter(Strings.similarOption_3_1),
      isOptionFourEnable: Preferences.getSearchFilter(Strings.similarOption_4_1),
      doubleTapEnable: Preferences.getSearchFilter(Strings.enableDoubleTap),
    ));
  }

  void _OnOptionThreeChanged(OptionThreeChanged event, Emitter<SearchMenuScreenState> emit) {
    Preferences.saveSearchFilter(Strings.similarOption_3_1,event.optionThree);
    emit(SearchMenuScreenState(isOptionThirdEnable: event.optionThree,
      isOptionTwoEnable:Preferences.getSearchFilter(Strings.similarOption_2_1),
      isOptionOneEnable: Preferences.getSearchFilter(Strings.similarOption_1_1),
      isOptionFourEnable: Preferences.getSearchFilter(Strings.similarOption_4_1),
      doubleTapEnable: Preferences.getSearchFilter(Strings.enableDoubleTap),
    ));
  }

  void _OnOptionFourChanged(OptionFourChanged event, Emitter<SearchMenuScreenState> emit) {
    Preferences.saveSearchFilter(Strings.similarOption_4_1,event.optionFour);
    emit(SearchMenuScreenState(isOptionFourEnable: event.optionFour,
      isOptionTwoEnable:Preferences.getSearchFilter(Strings.similarOption_2_1),
      isOptionThirdEnable: Preferences.getSearchFilter(Strings.similarOption_3_1),
      isOptionOneEnable: Preferences.getSearchFilter(Strings.similarOption_1_1),
      doubleTapEnable: Preferences.getSearchFilter(Strings.enableDoubleTap),
    ));
  }

  void _OnDoubleTapOptionChanged(DoubleTapOptionChanged event, Emitter<SearchMenuScreenState> emit) {
    Preferences.saveSearchFilter(Strings.enableDoubleTap,event.doubleTapEnable);
    emit(SearchMenuScreenState(doubleTapEnable: event.doubleTapEnable,
      isOptionTwoEnable:Preferences.getSearchFilter(Strings.similarOption_2_1),
      isOptionThirdEnable: Preferences.getAppSettings(Strings.similarOption_3_1),
      isOptionFourEnable: Preferences.getAppSettings(Strings.similarOption_4_1),
      isOptionOneEnable: Preferences.getSearchFilter(Strings.similarOption_1_1),
    ));
  }
}



import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learn_shudh_gurbani/bloc/tabView/tab_events.dart';
import 'tab_state.dart';

class TabBloc extends Bloc<TabEvent, TabState> {
  TabBloc() : super(
    TabState(index: 0,),)
  {
    on<TabEvent>((event, emit) => emit(TabState(
        index:event.index)));
  }
  @override
  void onEvent(TabEvent event) {
    super.onEvent(event);
  }

}
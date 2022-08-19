import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learn_shudh_gurbani/strings.dart';


class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  LanguageBloc() : super(
    LanguageState(language: Strings.english,
    ),
  ){
    on<LanguageEvent>((event, emit) => emit(LanguageState(
        language:event.language!)));
  }
}
class LanguageEvent {
  final String? language;
  LanguageEvent({this.language});
}
class LanguageState {
  final String? language ;
  LanguageState({this.language});
}
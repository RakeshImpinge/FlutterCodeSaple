import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learn_shudh_gurbani/app_themes.dart';
import 'package:learn_shudh_gurbani/bloc/theme/theme_events.dart';
import 'package:learn_shudh_gurbani/bloc/theme/theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(
    ThemeState(
      themeData: AppThemes.appThemeData[AppTheme.lightTheme],
    ),
  ){
    on<ThemeEvent>((event, emit) => emit(ThemeState(
        themeData:AppThemes.appThemeData[event.appTheme])));
  }
}
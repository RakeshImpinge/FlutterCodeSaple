import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learn_shudh_gurbani/services/preferenecs.dart';
import 'package:learn_shudh_gurbani/strings.dart';
import 'settings_event.dart';
import 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, AppSettingsState> {
  SettingsBloc() : super(
    AppSettingsState(
      otherAppNotifications: Preferences.getAppSettings(Strings.other_app_notifications),
      dailyNotifications:Preferences.getAppSettings(Strings.daily_notifications),
      offlineMediaEnable: Preferences.getAppSettings(Strings.offline_media),
      homeScreenIntro: Preferences.getAppSettings(Strings.home_screen_introduction),
      autoBackup: Preferences.getAppSettings(Strings.auto_backup)
    ),
  ){
    on<OtherAppNotificationsChanged>(_OnOtherAppNotificationsChanged);
    on<DailyDoseNotificationsChanged>(_OnDailyDoseNotificationsChanged);
    on<OfflineMediaChanged>(_OnOfflineMediaChanged);
    on<HomeScreenIntroChanged>(_OnHomeScreenIntroChanged);
    on<AutoBackUpSettingsChanged>(_OnAutoBackupSettingsChanged);
  }
}

void _OnOtherAppNotificationsChanged(OtherAppNotificationsChanged event, Emitter<AppSettingsState> emit) {
  Preferences.saveAppSettings(Strings.other_app_notifications,event.otherAppNotifications);
   emit(AppSettingsState( otherAppNotifications: event.otherAppNotifications,
       dailyNotifications:Preferences.getAppSettings(Strings.daily_notifications),
       offlineMediaEnable: Preferences.getAppSettings(Strings.offline_media),
       homeScreenIntro: Preferences.getAppSettings(Strings.home_screen_introduction),
       autoBackup: Preferences.getAppSettings(Strings.auto_backup)
  ));
}

void _OnDailyDoseNotificationsChanged(DailyDoseNotificationsChanged event, Emitter<AppSettingsState> emit) {
  Preferences.saveAppSettings(Strings.daily_notifications,event.dailyDoseNotification);
  emit(AppSettingsState(otherAppNotifications: Preferences.getAppSettings(Strings.other_app_notifications),
      dailyNotifications: event.dailyDoseNotification,
      offlineMediaEnable: Preferences.getAppSettings(Strings.offline_media),
      homeScreenIntro: Preferences.getAppSettings(Strings.home_screen_introduction),
      autoBackup: Preferences.getAppSettings(Strings.auto_backup)
  ));
}

void _OnOfflineMediaChanged(OfflineMediaChanged event, Emitter<AppSettingsState> emit) {
  Preferences.saveAppSettings(Strings.offline_media,event.offlineMedia);
  emit(AppSettingsState(otherAppNotifications: Preferences.getAppSettings(Strings.other_app_notifications),
      dailyNotifications: Preferences.getAppSettings(Strings.daily_notifications),
      offlineMediaEnable: event.offlineMedia,
      homeScreenIntro: Preferences.getAppSettings(Strings.home_screen_introduction),
      autoBackup: Preferences.getAppSettings(Strings.auto_backup)
  ));
}

void _OnHomeScreenIntroChanged(HomeScreenIntroChanged event, Emitter<AppSettingsState> emit) {
  Preferences.saveAppSettings(Strings.home_screen_introduction,event.homeScreenIntro);
  emit(AppSettingsState(otherAppNotifications: Preferences.getAppSettings(Strings.other_app_notifications),
      dailyNotifications: Preferences.getAppSettings(Strings.daily_notifications),
      offlineMediaEnable:Preferences.getAppSettings(Strings.offline_media),
      homeScreenIntro: event.homeScreenIntro,
      autoBackup: Preferences.getAppSettings(Strings.auto_backup)
  ));
}

void _OnAutoBackupSettingsChanged(AutoBackUpSettingsChanged event, Emitter<AppSettingsState> emit) {
  Preferences.saveAppSettings(Strings.auto_backup,event.autoBackup);
  emit(AppSettingsState(otherAppNotifications: Preferences.getAppSettings(Strings.other_app_notifications),
      dailyNotifications: Preferences.getAppSettings(Strings.daily_notifications),
      offlineMediaEnable: Preferences.getAppSettings(Strings.offline_media),
      homeScreenIntro: Preferences.getAppSettings(Strings.home_screen_introduction),
      autoBackup: event.autoBackup,
  ));
}



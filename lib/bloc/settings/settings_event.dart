class SettingsEvent {
  final bool? otherAppNotifications,dailyNotifications,offlineMedia,homeScreenIntro,autoBackup;
  SettingsEvent({this.otherAppNotifications,this.dailyNotifications,this.offlineMedia,this.homeScreenIntro,this.autoBackup});
}
class OtherAppNotificationsChanged extends SettingsEvent {
   OtherAppNotificationsChanged({required this.otherAppNotifications});
  final bool otherAppNotifications;
}
class DailyDoseNotificationsChanged extends SettingsEvent {
   DailyDoseNotificationsChanged({required this.dailyDoseNotification});
  final bool dailyDoseNotification;
}
class OfflineMediaChanged extends SettingsEvent {
  OfflineMediaChanged({required this.offlineMedia});
  final bool offlineMedia;
}
class HomeScreenIntroChanged extends SettingsEvent {
  HomeScreenIntroChanged({required this.homeScreenIntro});
  final bool homeScreenIntro;
}
class AutoBackUpSettingsChanged extends SettingsEvent {
  AutoBackUpSettingsChanged({required this.autoBackup});
  final bool autoBackup;
}

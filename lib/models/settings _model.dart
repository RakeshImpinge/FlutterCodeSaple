class SettingsModel {
 final int? otherAppNotifications;
 final int? dailyNotifications;
 final int? offlineMedia;
 final int? homeScreenIntro;
 final int? autoBackup;
  SettingsModel({
    this.otherAppNotifications,
    this.dailyNotifications,
    this.offlineMedia,
    this.homeScreenIntro,
    this.autoBackup,
  });
  Map<String, dynamic> toMap() {
    return {'otherAppNotifications': otherAppNotifications, 'dailyNotifications': dailyNotifications, 'offlineMedia': offlineMedia, 'homeScreenIntro': homeScreenIntro,'autoBackup': autoBackup,};
  }
  @override
  String toString() {
    return 'settings: {otherAppNotifications: ${otherAppNotifications}, dailyNotifications: ${dailyNotifications}, offlineMedia:${offlineMedia},homeScreenIntro: ${homeScreenIntro},autoBackup:${autoBackup}';
  }
}

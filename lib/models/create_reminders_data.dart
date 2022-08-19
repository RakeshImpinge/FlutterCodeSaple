class RemindersData {
  final int? id;
  final String title;
  final String date;
  final String occurance;
  final String repeat;
  final int tracker_id;
  final int ringtone_id;
   int reminderStatus;

   RemindersData({
      this.id, required this.title, required this.date, required this.occurance,required this.repeat,required this.ringtone_id,required this.tracker_id, required this.reminderStatus});

  RemindersData.fromJson(Map<String, dynamic> json)
      :id = json['id'], title = json['title'],
        date = json['date'],
        occurance = json['occurance'],
        repeat = json['repeat'],
        tracker_id = json['tracker_id'],
        ringtone_id = json['ringtone_id'],
        reminderStatus=json['reminderStatus'];

  Map<String, dynamic> toJson() => {
    'id': id,
    'title' : title,
    'occurance' : occurance,
    'repeat': repeat,
    'tracker_id' : tracker_id,
    'ringtone_id': ringtone_id,
    'reminderStatus' : reminderStatus,
    'date':date
  };
}

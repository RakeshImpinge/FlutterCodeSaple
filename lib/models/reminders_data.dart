import 'dart:convert';

class ReminderData {
  final int id;
  final String title;
  final String description;
   bool reminderStatus;

   ReminderData(
      this.id, this.title, this.description, this.reminderStatus);
  ReminderData.fromJson(Map<String, dynamic> json)
      :id = json['id'], title = json['title'],
        description = json['description'],
        reminderStatus=json['reminderStatus'];

  Map<String, dynamic> toJson() => {
    'id': id,
    'title' : title,
    'description' : description,
    'reminderStatus' : reminderStatus,
  };
}

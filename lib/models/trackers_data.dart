import 'dart:convert';

class TrackersData {
  final int? id;
  final String title;
  final String date;
  final String activity_name;
  final String tracker_name;
  final int activity_id;
  final int tracker_id;
  int? completed_daily;
  final int? activity_id2;
  final String? activity_name2;
  final int? overall_counter_goal;
  final int? daily_counter_goal;
  final String? counter_date;
  final String? daily_duration;

  TrackersData({
      this.id, required this.title, required this.date, this.completed_daily,required this.activity_id,required this.tracker_id, required this.activity_name,
      required this.tracker_name,this.activity_id2,this.activity_name2,this.counter_date,this.daily_counter_goal,this.daily_duration,this.overall_counter_goal});
  TrackersData.fromJson(Map<String, dynamic> json)
      :id = json['id'], title = json['title'],
        date = json['date'],
        activity_name = json['activity_name'],
        tracker_id = json['tracker_id'],
        tracker_name = json['tracker_name'],
        activity_id=json['activity_id'],
        completed_daily=json['completed_daily'],
        activity_id2 = json['activity_id2'],
        activity_name2 = json['activity_name2'],
        overall_counter_goal = json['overall_counter_goal'],
        daily_counter_goal=json['daily_counter_goal'],
        counter_date=json['counter_date'],
        daily_duration=json['daily_duration'];



  Map<String, dynamic> toJson() => {
    'id': id,
    'title' : title,
    'activity_name' : activity_name,
    'tracker_id' : tracker_id,
    'tracker_name': tracker_name,
    'activity_id' : activity_id,
    'date' : date,
    'completed_daily' : completed_daily,
    'activity_id2' : activity_id2,
    'activity_name2' : activity_name2,
    'overall_counter_goal' : overall_counter_goal,
    'daily_counter_goal': daily_counter_goal,
    'counter_date' : counter_date,
    'daily_duration' : daily_duration,
  };
}

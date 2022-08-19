class KamaiyiDataItem{
 final String id;
 final String title;
 final String totalGoal;
 final String completed;
 final String deadline;
 final int progress;
 final String progressText;
 final List<KamaiyiDailyStatusData> dailyGoalList;
 KamaiyiDataItem(this.id, this.title,this.totalGoal,this.completed,this.deadline,this.progress,this.progressText,this.dailyGoalList);

 @override
 String toString() {
   return 'KamaiyiData: {id: ${id}, title: ${title}, dailyGoal: ${dailyGoalList},totalGoal: ${totalGoal}, completed: ${completed},deadline: ${deadline},progress: ${progress},progressText: ${progressText} }';
 }
}

class KamaiyiDailyStatusData{
 final String id;
 final String title;
 final String status;
 const KamaiyiDailyStatusData(this.id, this.title, this.status);

 @override
 String toString() {
  return 'KamaiyiDailyStatusData: {id: ${id}, title: ${title}, status: ${status}}';
 }
}
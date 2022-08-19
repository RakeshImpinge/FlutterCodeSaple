class WeekdayData{
 final String id;
 final String day;
  bool status;
  WeekdayData(this.id, this.day, this.status);
 @override
 String toString() {
  return 'WeekdayData: {id: ${id}, day: ${day}, status: ${status}}';
 }
}


class SehajPaathData{
 final String id;
 final String title;
 final List<SehajPaathSubItemData> list;
  SehajPaathData(this.id, this.title,this.list);
 @override
 String toString() {
   return 'SehajPaathData: {id: ${id}, title: ${title}, subList: ${list}}';
 }
}
class SehajPaathSubItemData{
 final String id;
 final String title;
 final int progress;
 const SehajPaathSubItemData(this.id, this.title, this.progress);
 @override
 String toString() {
  return 'SehajPaathDataSubItem: {id: ${id}, title: ${title}, progress: ${progress}}';
 }
}
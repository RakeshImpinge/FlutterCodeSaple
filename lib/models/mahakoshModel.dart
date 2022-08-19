
class MahankoshData{
 final String id;
 final String title;
 final String description;
 final String koshName;
 const MahankoshData(this.id, this.title, this.description,this.koshName);
 @override
 String toString() {
   return 'MahankoshData: {id: ${id}, title: ${title}, description: ${description}, koshName: ${koshName}}';
 }
}

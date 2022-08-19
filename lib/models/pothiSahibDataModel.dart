class PothiSahibData{
 final String id;
 final String title;
 final String description;
 final int progress;
 const PothiSahibData(this.id, this.title,this.description, this.progress);
 @override
 String toString() {
  return 'PothiSahibData: {id: ${id}, title: ${title},description: ${description}, progress: ${progress}}';
 }
}
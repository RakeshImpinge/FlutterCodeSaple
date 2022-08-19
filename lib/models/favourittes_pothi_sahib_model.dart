class FavouritesPothiSahibData{
 final int id;
 final String title;
 final String description;
 bool status;FavouritesPothiSahibData(this.id, this.title,this.description, this.status);

 @override
 String toString() {
  return 'FavouritesPothiSahibData: {id: ${id}, title: ${title},description: ${description}, status: ${status}}';
 }
}
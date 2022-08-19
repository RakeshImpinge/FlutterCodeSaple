class RaagModel {
   int id;
   int source_id;
   String name;
   String name_gurmukhi;
   bool? isSelected=false;

  RaagModel({
    required this.id,
    required this.source_id,
    required this.name, required this.name_gurmukhi,required this.isSelected
  });
   RaagModel.fromJson(Map<String, dynamic> json)
       : id = json['id'],
         source_id = json['source_id'],
         name = json['name'],
         name_gurmukhi = json['name_gurmukhi'];

   Map<String, dynamic> toJson() => {
     'id': id,
     'source_id': source_id,
     'name' : name,
     'name_gurmukhi' : name_gurmukhi
   };
}

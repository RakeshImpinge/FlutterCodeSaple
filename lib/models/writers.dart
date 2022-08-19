class WritersModel {
   int id;
   String name;
   String name_gurmukhi;

  WritersModel({
    required this.id,
    required this.name, required this.name_gurmukhi
  });
   WritersModel.fromJson(Map<String, dynamic> json)
       : id = json['id'],
         name = json['name'],
         name_gurmukhi = json['name_gurmukhi'];

   Map<String, dynamic> toJson() => {
     'id': id,
     'name' : name,
     'name_gurmukhi' : name_gurmukhi
   };

}

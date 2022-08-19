class SourcesModel {
   int id;
   String name;
   String name_short;

  SourcesModel({
    required this.id,
    required this.name, required this.name_short
  });
   SourcesModel.fromJson(Map<String, dynamic> json)
       : id = json['id'],
         name = json['name'],
         name_short = json['name_short'];

   Map<String, dynamic> toJson() => {
     'id': id,
     'name' : name,
     'name_short' : name_short
   };
}

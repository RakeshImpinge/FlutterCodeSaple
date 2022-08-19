class PothiSahibData {
   int id;
   String name;
   String name_unicode;
   String name_english;
   String? audio;

   PothiSahibData({
    required this.id,
    required this.name, required this.name_unicode,required this.name_english, this.audio
  });
   PothiSahibData.fromJson(Map<String, dynamic> json)
       : id = json['id'],
         name = json['name'],
         name_unicode = json['name_unicode'],
         name_english = json['name_english'],
         audio = json['audio'];

   Map<String, dynamic> toJson() => {
     'id': id,
     'name' : name,
     'name_unicode' : name_unicode,
     'name_english' : name_english,
     'audio' : audio,
   };
}

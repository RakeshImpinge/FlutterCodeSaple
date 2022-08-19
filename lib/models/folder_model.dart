class FolderModel {
  final int? id;
  final String name;
  final String date;

  FolderModel({
      this.id,
     required this.name,
    required this.date
  });
  FolderModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        date = json['date'];

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'date': date
  };

}

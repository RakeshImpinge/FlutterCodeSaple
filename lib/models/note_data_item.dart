class NoteDataItem {
  int? id;
  int folderId;
  String pangtiName;
  String note;
  String date;
  String folderName;

  NoteDataItem({
    this.id,
    required this.folderId,
    required this.pangtiName, required this.note,required this.date, required this.folderName
  });
  NoteDataItem.fromJson(Map<String, dynamic> json)
      :folderId = json['folder_id'],
        id = json['id'],
        pangtiName = json['pangti_name'],
        date = json['date'],
        folderName=json['folder_name'],
        note = json['message'];

  Map<String, dynamic> toJson() => {
    'folder_id': folderId,
    'id': id,
    'pangti_name' : pangtiName,
    'message' : note,
    'folder_name': folderName,
    'date':date

  };
}
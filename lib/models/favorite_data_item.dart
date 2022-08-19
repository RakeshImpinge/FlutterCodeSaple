import 'dart:convert';
class FavoriteDataItem {
  final int? id;
  final int? folder_id;
  final int bani_id;
  final String gurmukhi;
  final String gurmukhi_unicode;
  final String folder_name;
  final String date;
  FavoriteDataItem({
     this.id,
    required this.folder_id,
    required this.gurmukhi,
    required this.gurmukhi_unicode,
    required this.folder_name,
    required this.date,
    required this.bani_id
  });

  FavoriteDataItem copyWith({
    int? id,
    int? folder_id,
    int? bani_id,
    String? gurmukhi,
    String? gurmukhi_unicode,
    String? folder_name,
    String? date
  }) {
    return FavoriteDataItem(
      id: id ?? this.id,
        folder_id: folder_id ?? this.folder_id,
        bani_id: bani_id?? this.bani_id,
        gurmukhi: gurmukhi ?? this.gurmukhi,
        gurmukhi_unicode: gurmukhi_unicode ?? this.gurmukhi_unicode,
        folder_name: folder_name ?? this.folder_name,
        date:date??this.date
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'folder_id':folder_id,
      'bani_id':bani_id,
      'gurmukhi': gurmukhi,
      'gurmukhi_unicode': gurmukhi_unicode,
      'folder_name': folder_name,
      'date':date
    };
  }

  factory FavoriteDataItem.fromMap(Map<String, dynamic> map) {
    return FavoriteDataItem(
      id: map['id']?.toInt() ?? 0,
        folder_id: map['folder_id']?.toInt() ?? 0,
        bani_id: map['bani_id']?.toInt()??0,
        gurmukhi: map['gurmukhi'] ?? '',
        gurmukhi_unicode: map['gurmukhi_unicode'] ?? '',
        folder_name: map['folder_name'] ?? '',
        date: map['date']?? ''
    );
  }

  String toJson() => json.encode(toMap());

  factory FavoriteDataItem.fromJson(String source) => FavoriteDataItem.fromMap(json.decode(source));

  @override
  String toString() {
    return 'data(id: $id,folder_id: $folder_id,bani_id: $bani_id, gurmukhi: $gurmukhi, gurmukhi_unicode: $gurmukhi_unicode,folder_name: $folder_name,date:$date)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FavoriteDataItem &&
        other.id == id &&
        other.folder_id==folder_id &&
        other.gurmukhi == gurmukhi &&
        other.gurmukhi_unicode == gurmukhi_unicode &&
        other.date==date&&
        other.folder_name == folder_name;
  }

  @override
  int get hashCode {
    return  id.hashCode ^folder_id.hashCode ^ gurmukhi.hashCode ^ gurmukhi_unicode.hashCode ^ folder_name.hashCode ^date.hashCode;
  }
}

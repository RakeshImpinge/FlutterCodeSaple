import 'dart:convert';
class AppInfoData {
  final int id;
  final int section_id;
  final int subsection_id;
  final String secetion;
  final String subsection;
  final String text_english;
  final String text_gurmukhi;
  AppInfoData({
    required this.id,
    required this.section_id,
    required this.subsection_id,
    required this.secetion,
    required this.subsection,
    required this.text_english,
    required this.text_gurmukhi,
  });

  AppInfoData copyWith({
     int? id,
     int? section_id,
     int? subsection_id,
     String? secetion,
     String? subsection,
     String? text_english,
     String? text_gurmukhi,
  }) {
    return AppInfoData(
      id: id ?? this.id,
      section_id: section_id ?? this.section_id,
      subsection_id: subsection_id ?? this.subsection_id,
      secetion: secetion ?? this.secetion,
      subsection: secetion ?? this.subsection,
      text_english: secetion ?? this.text_english,
      text_gurmukhi: secetion ?? this.text_gurmukhi,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'section_id': section_id,
      'subsection_id': subsection_id,
      'secetion': secetion,
      'subsection': subsection,
      'text_english': text_english,
      'text_gurmukhi': text_gurmukhi,
    };
  }

  factory AppInfoData.fromMap(Map<String, dynamic> map) {
    return AppInfoData(
      id: map['id']?.toInt() ?? 0,
      section_id: map['section_id'] ?? '',
      subsection_id: map['subsection_id'] ?? '',
      secetion: map['secetion'] ?? '',
      subsection: map['subsection'] ?? '',
      text_english: map['text_english'] ?? '',
      text_gurmukhi: map['text_gurmukhi'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory AppInfoData.fromJson(String source) => AppInfoData.fromMap(json.decode(source));

  @override
  String toString() {
    return 'data(id: $id, section_id: $section_id, subsection_id: $subsection_id,secetion: $secetion,subsection: $subsection, text_english: $text_english,text_gurmukhi: $text_gurmukhi)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AppInfoData &&
        other.id == id &&
        other.section_id == section_id &&
        other.subsection_id == subsection_id &&
        other.secetion == secetion &&
        other.subsection == subsection &&
        other.text_english == subsection &&
        other.text_gurmukhi == text_gurmukhi
    ;
  }

  @override
  int get hashCode {
    return id.hashCode ^ section_id.hashCode ^ subsection_id.hashCode ^ secetion.hashCode ^ subsection.hashCode ^ subsection.hashCode ^ text_gurmukhi.hashCode;
  }
}

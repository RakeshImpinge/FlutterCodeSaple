import 'dart:convert';
class GutkasModel {
  final int id;
  final String gurmukhi;
  final String gurmukhi_unicode;
  final String english;
  GutkasModel({
    required this.id,
    required this.gurmukhi,
    required this.gurmukhi_unicode,
    required this.english,
  });

  GutkasModel copyWith({
    int? id,
    String? gurmukhi,
    String? gurmukhi_unicode,
    String? english,
  }) {
    return GutkasModel(
      id: id ?? this.id,
      gurmukhi: gurmukhi ?? this.gurmukhi,
      gurmukhi_unicode: gurmukhi_unicode ?? this.gurmukhi_unicode,
      english: english ?? this.english
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'gurmukhi': gurmukhi,
      'gurmukhi_unicode': gurmukhi_unicode,
      'english': english
    };
  }

  factory GutkasModel.fromMap(Map<String, dynamic> map) {
    return GutkasModel(
      id: map['id']?.toInt() ?? 0,
      gurmukhi: map['gurmukhi'] ?? '',
      gurmukhi_unicode: map['gurmukhi_unicode'] ?? '',
      english: map['english'] ?? ''
    );
  }

  String toJson() => json.encode(toMap());

  factory GutkasModel.fromJson(String source) => GutkasModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'data(id: $id, gurmukhi: $gurmukhi, gurmukhi_unicode: $gurmukhi_unicode,english: $english)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GutkasModel &&
        other.id == id &&
        other.gurmukhi == gurmukhi &&
        other.gurmukhi_unicode == gurmukhi_unicode &&
        other.english == english;
  }

  @override
  int get hashCode {
    return  id.hashCode ^ gurmukhi.hashCode ^ gurmukhi_unicode.hashCode ^ english.hashCode;
  }
}

import 'dart:convert';

class ShabadDataItem {
  final int id;
  final int section_id;
  final int writer_id;
  final int shabad_id;
  final int is_mainline;
  final int line;
  final int ang;
  final int display_group_id;
  final String? arth;
  final String ucharan;
  final String ssk_english;
  final String transliteration;
  final String gurmukhi_devnagri;
  final String gurmukhi_unicode;
  final String gurmukhi;
  final String uid;
  ShabadDataItem({
    required this.id,
    required this.gurmukhi,
    required this.gurmukhi_unicode,
    required this.is_mainline,
    required this.display_group_id,
    required this.ssk_english,
    required this.shabad_id,
    required this.section_id,
    required this.ang,
    required this.arth,
    required this.gurmukhi_devnagri,
    required this.line,
    required this.transliteration,
    required this.ucharan,
    required this.uid,
    required this.writer_id,
  });

  ShabadDataItem copyWith({
     int? id,
     int? section_id,
     int? writer_id,
     int? shabad_id,
     int? is_mainline,
     int? line,
     int? ang,
     int? display_group_id,
     String? arth,
     String? ucharan,
     String? ssk_english,
     String? transliteration,
     String? gurmukhi_devnagri,
     String? gurmukhi_unicode,
     String? gurmukhi,
     String? uid,
  }) {
    return ShabadDataItem(
      id: id ?? this.id,
      gurmukhi: gurmukhi ?? this.gurmukhi,
      gurmukhi_unicode: gurmukhi_unicode ?? this.gurmukhi_unicode,
      section_id: section_id ?? this.section_id,
      writer_id: writer_id ?? this.writer_id,
      shabad_id: shabad_id ?? this.shabad_id,
      is_mainline: is_mainline ?? this.is_mainline,
      line: line ?? this.line,
      ang: ang ?? this.ang,
      display_group_id: display_group_id ?? this.display_group_id,
      arth: arth ?? this.arth,
      ucharan: ucharan ?? this.ucharan,
      ssk_english: ssk_english ?? this.ssk_english,
      transliteration: transliteration ?? this.transliteration,
      gurmukhi_devnagri: gurmukhi_devnagri ?? this.gurmukhi_devnagri,
      uid: uid ?? this.uid,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'gurmukhi': gurmukhi,
      'gurmukhi_unicode': gurmukhi_unicode,
      'section_id': section_id,
      'writer_id': writer_id,
      'shabad_id': shabad_id,
      'is_mainline': is_mainline,
      'line': line,
      'ang': ang,
      'display_group_id': display_group_id,
      'arth': arth,
      'ucharan': ucharan,
      'ssk_english': ssk_english,
      'transliteration': transliteration,
      'gurmukhi_devnagri': gurmukhi_devnagri,
      'uid': uid,
    };
  }

  factory ShabadDataItem.fromMap(Map<String, dynamic> map) {
    return ShabadDataItem(
        id: map['id']?.toInt() ?? 0,
        gurmukhi: map['gurmukhi'] ?? '',
        gurmukhi_unicode: map['gurmukhi_unicode'] ?? '',
        section_id: map['section_id'] ?? 0,
        writer_id: map['writer_id'] ?? 0,
        shabad_id: map['shabad_id'] ?? 0,
        is_mainline: map['is_mainline'] ?? 0,
        line: map['line'] ?? 1,
        ang: map['ang'] ?? 0,
        display_group_id: map['display_group_id'] ?? 0,
        arth: map['arth'] ?? '',
        ucharan: map['ucharan'] ?? '',
        ssk_english: map['ssk_english'] ?? '',
        transliteration: map['transliteration'] ?? '',
        gurmukhi_devnagri: map['gurmukhi_devnagri'] ?? '',
        uid: map['uid'] ?? ''
    );
  }

  String toJson() => json.encode(toMap());

  factory ShabadDataItem.fromJson(String source) => ShabadDataItem.fromMap(json.decode(source));
  @override
  String toString() {
    return 'data(id: $id, gurmukhi: $gurmukhi, gurmukhi_unicode: $gurmukhi_unicode,section_id: $section_id,writer_id: $writer_id,shabad_id: $shabad_id, line: $line, ang: $ang,display_group_id: $display_group_id,arth: $arth,ucharan: $ucharan, ssk_english: $ssk_english,transliteration: $transliteration,gurmukhi_devnagri: $gurmukhi_devnagri,uid: $uid)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ShabadDataItem &&
        other.id == id &&
        other.gurmukhi == gurmukhi &&
        other.gurmukhi_unicode == gurmukhi_unicode &&
        other.section_id == section_id &&
        other.writer_id == writer_id &&
        other.shabad_id == shabad_id &&
        other.is_mainline == is_mainline &&
        other.line == line &&
        other.ang == ang &&
        other.display_group_id == display_group_id &&
        other.arth == arth &&
        other.ucharan == ucharan &&
        other.ssk_english == ssk_english &&
        other.transliteration == transliteration &&
        other.gurmukhi_devnagri == gurmukhi_devnagri &&
        other.uid == uid;
  }

  @override
  int get hashCode {
    return  id.hashCode ^ gurmukhi.hashCode ^ gurmukhi_unicode.hashCode ^ section_id.hashCode ^ writer_id.hashCode ^ is_mainline.hashCode
    ^ line.hashCode^ ang.hashCode^ display_group_id.hashCode^ arth.hashCode^ ucharan.hashCode^ ssk_english.hashCode^ transliteration.hashCode^ gurmukhi_devnagri.hashCode^ uid.hashCode;
  }
}
import 'dart:convert';
class BanisModel {
  final int id;
  final String gurmukhi;
  final String gurmukhi_unicode;
  final String english;
  final String audio;
  final String video;
  final String? video_timestamp;
  BanisModel({
    required this.id,
    required this.gurmukhi,
    required this.gurmukhi_unicode,
    required this.english,
    required this.audio,
    required this.video,
    required this.video_timestamp,
  });

  BanisModel copyWith({
    int? id,
    String? gurmukhi,
    String? gurmukhi_unicode,
    String? english,
    String? audio,
    String? video,
    String? video_timestamp,
  }) {
    return BanisModel(
      id: id ?? this.id,
      gurmukhi: gurmukhi ?? this.gurmukhi,
      gurmukhi_unicode: gurmukhi_unicode ?? this.gurmukhi_unicode,
      english: english ?? this.english,
      audio: audio ?? this.audio,
      video: video ?? this.video,
      video_timestamp: video_timestamp ?? this.video_timestamp,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'gurmukhi': gurmukhi,
      'gurmukhi_unicode': gurmukhi_unicode,
      'english': english,
      'audio': audio,
      'video': video,
      'video_timestamp': video_timestamp,
    };
  }

  factory BanisModel.fromMap(Map<String, dynamic> map) {
    return BanisModel(
      id: map['id']?.toInt() ?? 0,
      gurmukhi: map['gurmukhi'] ?? '',
      gurmukhi_unicode: map['gurmukhi_unicode'] ?? '',
      english: map['english'] ?? '',
      audio: map['audio'] ?? '',
      video: map['video'] ?? '',
      video_timestamp: map['video_timestamp'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory BanisModel.fromJson(String source) => BanisModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'data(id: $id, gurmukhi: $gurmukhi, gurmukhi_unicode: $gurmukhi_unicode,english: $english,audio: $audio,video: $video, video_timestamp: $video_timestamp)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is BanisModel &&
        other.id == id &&
        other.gurmukhi == gurmukhi &&
        other.gurmukhi_unicode == gurmukhi_unicode &&
        other.english == english
        && other.audio == audio &&
        other.video == video &&
        other.video_timestamp == video_timestamp ;
  }

  @override
  int get hashCode {
    return  id.hashCode ^ gurmukhi.hashCode ^ gurmukhi_unicode.hashCode ^ english.hashCode ^ audio.hashCode ^ video.hashCode ^ video_timestamp.hashCode;
  }
}

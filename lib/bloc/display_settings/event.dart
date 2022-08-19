import '../../services/preferenecs.dart';

class DisplaySettingsEvent {
  double? larrivarFontSize;
  double? gurmukhiFontSize;
  double? pronunciationTipFontSize;
  double? transliterationFontSize;
  double? akhriArthFontSize;
  double? detailedArthFontSize;
  double? englishTranslationFontSize ;
  bool? larrivarStyle;
  bool? paragraphStyle;
  bool? bisramStyle;
  bool? transLiteration;
  bool? akhriAarth;
  bool? detailedAarth;
  bool? englishTranslation;
  DisplaySettingsEvent({this.larrivarFontSize,this.englishTranslation,this.transLiteration,this.bisramStyle,this.paragraphStyle,this.larrivarStyle,this.englishTranslationFontSize,this.detailedArthFontSize,this.transliterationFontSize,this.akhriArthFontSize,this.pronunciationTipFontSize,this.gurmukhiFontSize});
}
class FontIncrementPressed extends DisplaySettingsEvent {
  final double? gurmukhiFontSize;
  final double? pronunciationTipFontSize;
  final double? transliterationFontSize;
  final double? akhriArthFontSize;
  final double? detailedArthFontSize;
  final double? englishTranslatiFontSize;
  final double? larrivarFontSize;
  FontIncrementPressed({this.larrivarFontSize,this.englishTranslatiFontSize,this.detailedArthFontSize,this.transliterationFontSize,this.akhriArthFontSize,this.pronunciationTipFontSize,this.gurmukhiFontSize});

}


class FontDecrementPressed extends DisplaySettingsEvent {
  double? gurmukhiFontSize;
  double? pronunciationTipFontSize;
  double? transliterationFontSize;
  double? akhriArthFontSize;
  double? detailedArthFontSize;
  double? englishTranslatiFontSize;
  double? larrivarFontSize;
  FontDecrementPressed({this.larrivarFontSize,this.englishTranslatiFontSize,this.detailedArthFontSize,this.transliterationFontSize,this.akhriArthFontSize,this.pronunciationTipFontSize,this.gurmukhiFontSize});

}
class GurbaniViewStyleChanged extends DisplaySettingsEvent{
  final bool larrivarStyle;
  GurbaniViewStyleChanged({required this.larrivarStyle});

}
class ParagraphStyleChanged extends DisplaySettingsEvent{
  final bool paragraphStyle;
  ParagraphStyleChanged({required this.paragraphStyle});

}
class LarrivarBisramStyleChanged extends DisplaySettingsEvent{
  final bool larriavrBisramStyle;
  LarrivarBisramStyleChanged({required this.larriavrBisramStyle});
}
class BisramStyleChanged extends DisplaySettingsEvent{
  final bool bisramStyle;
  BisramStyleChanged({required this.bisramStyle});
}

class TransLiterationChanged extends DisplaySettingsEvent{
  final bool transLiteration;
  TransLiterationChanged({required this.transLiteration});
}

class AakhriArthChanged extends DisplaySettingsEvent{
  final bool aakhriArth;
  AakhriArthChanged({required this.aakhriArth});
}
class DetailedArthChanged extends DisplaySettingsEvent{
  final bool detailediArth;
  DetailedArthChanged({required this.detailediArth});
}
class EnglishTranslationChanged extends DisplaySettingsEvent{
  final bool englishTranslation;
  EnglishTranslationChanged({required this.englishTranslation});
}
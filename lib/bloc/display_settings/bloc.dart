import 'package:flutter_bloc/flutter_bloc.dart';

import '../../services/preferenecs.dart';
import 'event.dart';
import 'state.dart';

class DisplaySettingsBloc
    extends Bloc<DisplaySettingsEvent, DisplaySettingsState> {
  double maxGurbaniFontSize = 46;
  double minGurbaniFontSize = 16;

  DisplaySettingsBloc()
      : super(
          DisplaySettingsState(
              larrivarFontSize: Preferences.getLarrivarFontSize(),
              gurmukhiFontSize: Preferences.getGurbaniFontSize(),
              transliterationFontSize: Preferences.getTransliterationFontSize(),
              englishTranslationFontSize:
                  Preferences.getEnglishTranslationFontSize(),
              pronunciationTipFontSize:
                  Preferences.getPronunciationTipFontSize(),
              akhriArthFontSize: Preferences.getAkhriArthFontSize(),
              detailedArthFontSize: Preferences.getDetailedArthFontSize(),
              paragraphStyle: Preferences.getParagraphStyle(),
              larrivarStyle: Preferences.getGuraniStyle(),
              larrivarWithBisRamStyle: Preferences.getLarrivarWithBisramStyle(),
              bisramStyle: Preferences.getBisramStyle(),
              englishTranslation: Preferences.getEnglishTranslation(),
              akhriAarth: Preferences.getAakhriArth(),
              detailedAarth: Preferences.getDetailedArth(),
              transLiteration: Preferences.getTransliteration()),
        ) {
    /*
     font size increment
     */
    on<FontIncrementPressed>((event, emit) {
      if (event.gurmukhiFontSize != null &&
          event.gurmukhiFontSize! < maxGurbaniFontSize) {
        Preferences.saveGurmukhiFont(event.gurmukhiFontSize! + 2);
        emit(
          DisplaySettingsState(
              gurmukhiFontSize: event.gurmukhiFontSize! + 2,
              transliterationFontSize: Preferences.getTransliterationFontSize(),
              englishTranslationFontSize:
                  Preferences.getEnglishTranslationFontSize(),
              pronunciationTipFontSize:
                  Preferences.getPronunciationTipFontSize(),
              akhriArthFontSize: Preferences.getAkhriArthFontSize(),
              detailedArthFontSize: Preferences.getDetailedArthFontSize(),
              paragraphStyle: Preferences.getParagraphStyle(),
              larrivarStyle: Preferences.getGuraniStyle(),
              bisramStyle: Preferences.getBisramStyle(),
              englishTranslation: Preferences.getEnglishTranslation(),
              akhriAarth: Preferences.getAakhriArth(),
              detailedAarth: Preferences.getDetailedArth(),
              larrivarWithBisRamStyle: Preferences.getLarrivarWithBisramStyle(),
              larrivarFontSize: Preferences.getLarrivarFontSize(),
              transLiteration: Preferences.getTransliteration()),
        );
      } else if (event.pronunciationTipFontSize != null &&
          event.pronunciationTipFontSize! < (maxGurbaniFontSize - 10)) {
        Preferences.savePronunciationTipFont(
            event.pronunciationTipFontSize! + 2);
        emit(DisplaySettingsState(
            pronunciationTipFontSize: event.pronunciationTipFontSize! + 2,
            gurmukhiFontSize: Preferences.getGurbaniFontSize(),
            transliterationFontSize: Preferences.getTransliterationFontSize(),
            englishTranslationFontSize:
                Preferences.getEnglishTranslationFontSize(),
            akhriArthFontSize: Preferences.getAkhriArthFontSize(),
            detailedArthFontSize: Preferences.getDetailedArthFontSize(),
            paragraphStyle: Preferences.getParagraphStyle(),
            larrivarStyle: Preferences.getGuraniStyle(),
            bisramStyle: Preferences.getBisramStyle(),
            englishTranslation: Preferences.getEnglishTranslation(),
            akhriAarth: Preferences.getAakhriArth(),
            detailedAarth: Preferences.getDetailedArth(),
            larrivarWithBisRamStyle: Preferences.getLarrivarWithBisramStyle(),
            larrivarFontSize: Preferences.getLarrivarFontSize(),
            transLiteration: Preferences.getTransliteration()));
      } else if (event.transliterationFontSize != null &&
          event.transliterationFontSize! < maxGurbaniFontSize - 10) {
        Preferences.saveTransliterationFontSize(
            event.transliterationFontSize! + 2);
        emit(DisplaySettingsState(
            transliterationFontSize: event.transliterationFontSize! + 2,
            gurmukhiFontSize: Preferences.getGurbaniFontSize(),
            englishTranslationFontSize:
                Preferences.getEnglishTranslationFontSize(),
            pronunciationTipFontSize: Preferences.getPronunciationTipFontSize(),
            akhriArthFontSize: Preferences.getAkhriArthFontSize(),
            detailedArthFontSize: Preferences.getDetailedArthFontSize(),
            paragraphStyle: Preferences.getParagraphStyle(),
            larrivarStyle: Preferences.getGuraniStyle(),
            bisramStyle: Preferences.getBisramStyle(),
            englishTranslation: Preferences.getEnglishTranslation(),
            akhriAarth: Preferences.getAakhriArth(),
            larrivarWithBisRamStyle: Preferences.getLarrivarWithBisramStyle(),
            larrivarFontSize: Preferences.getLarrivarFontSize(),
            detailedAarth: Preferences.getDetailedArth(),
            transLiteration: Preferences.getTransliteration()));
      } else if (event.akhriArthFontSize != null &&
          event.akhriArthFontSize! < maxGurbaniFontSize - 10) {
        Preferences.saveAkhriArthFontSize(event.akhriArthFontSize! + 2);
        emit(
          DisplaySettingsState(
              akhriArthFontSize: event.akhriArthFontSize! + 2,
              gurmukhiFontSize: Preferences.getGurbaniFontSize(),
              transliterationFontSize: Preferences.getTransliterationFontSize(),
              englishTranslationFontSize:
                  Preferences.getEnglishTranslationFontSize(),
              pronunciationTipFontSize:
                  Preferences.getPronunciationTipFontSize(),
              detailedArthFontSize: Preferences.getDetailedArthFontSize(),
              paragraphStyle: Preferences.getParagraphStyle(),
              larrivarStyle: Preferences.getGuraniStyle(),
              bisramStyle: Preferences.getBisramStyle(),
              englishTranslation: Preferences.getEnglishTranslation(),
              akhriAarth: Preferences.getAakhriArth(),
              detailedAarth: Preferences.getDetailedArth(),
              larrivarWithBisRamStyle: Preferences.getLarrivarWithBisramStyle(),
              larrivarFontSize: Preferences.getLarrivarFontSize(),
              transLiteration: Preferences.getTransliteration()),
        );
      } else if (event.detailedArthFontSize != null &&
          event.detailedArthFontSize! < maxGurbaniFontSize - 10) {
        Preferences.saveDetailedArthFontSizee(event.detailedArthFontSize! + 2);
        emit(DisplaySettingsState(
            detailedArthFontSize: event.detailedArthFontSize! + 2,
            gurmukhiFontSize: Preferences.getGurbaniFontSize(),
            transliterationFontSize: Preferences.getTransliterationFontSize(),
            englishTranslationFontSize:
                Preferences.getEnglishTranslationFontSize(),
            pronunciationTipFontSize: Preferences.getPronunciationTipFontSize(),
            akhriArthFontSize: Preferences.getAkhriArthFontSize(),
            paragraphStyle: Preferences.getParagraphStyle(),
            larrivarStyle: Preferences.getGuraniStyle(),
            bisramStyle: Preferences.getBisramStyle(),
            englishTranslation: Preferences.getEnglishTranslation(),
            akhriAarth: Preferences.getAakhriArth(),
            larrivarWithBisRamStyle: Preferences.getLarrivarWithBisramStyle(),
            larrivarFontSize: Preferences.getLarrivarFontSize(),
            detailedAarth: Preferences.getDetailedArth(),
            transLiteration: Preferences.getTransliteration()));
      } else if (event.englishTranslatiFontSize != null &&
          event.englishTranslatiFontSize! < maxGurbaniFontSize - 10) {
        Preferences.saveEnglishTranslationFontSize(
            event.englishTranslatiFontSize! + 2);
        emit(DisplaySettingsState(
            englishTranslationFontSize: event.englishTranslatiFontSize! + 2,
            gurmukhiFontSize: Preferences.getGurbaniFontSize(),
            transliterationFontSize: Preferences.getTransliterationFontSize(),
            pronunciationTipFontSize: Preferences.getPronunciationTipFontSize(),
            akhriArthFontSize: Preferences.getAkhriArthFontSize(),
            detailedArthFontSize: Preferences.getDetailedArthFontSize(),
            paragraphStyle: Preferences.getParagraphStyle(),
            larrivarStyle: Preferences.getGuraniStyle(),
            bisramStyle: Preferences.getBisramStyle(),
            englishTranslation: Preferences.getEnglishTranslation(),
            akhriAarth: Preferences.getAakhriArth(),
            detailedAarth: Preferences.getDetailedArth(),
            larrivarWithBisRamStyle: Preferences.getLarrivarWithBisramStyle(),
            larrivarFontSize: Preferences.getLarrivarFontSize(),
            transLiteration: Preferences.getTransliteration()));
      }
      else if (event.larrivarFontSize != null &&
          event.larrivarFontSize! < maxGurbaniFontSize) {
        Preferences.saveLarrivarFont(event.larrivarFontSize! + 2);
        emit(
          DisplaySettingsState(
              gurmukhiFontSize:Preferences.getLarrivarFontSize() ,
              transliterationFontSize: Preferences.getTransliterationFontSize(),
              englishTranslationFontSize:
              Preferences.getEnglishTranslationFontSize(),
              pronunciationTipFontSize:
              Preferences.getPronunciationTipFontSize(),
              akhriArthFontSize: Preferences.getAkhriArthFontSize(),
              detailedArthFontSize: Preferences.getDetailedArthFontSize(),
              paragraphStyle:Preferences.getParagraphStyle(),
              larrivarStyle: Preferences.getGuraniStyle(),
              bisramStyle: Preferences.getBisramStyle(),
              englishTranslation: Preferences.getEnglishTranslation(),
              akhriAarth: Preferences.getAakhriArth(),
              detailedAarth: Preferences.getDetailedArth(),
              larrivarWithBisRamStyle: Preferences.getLarrivarWithBisramStyle(),
              larrivarFontSize:event.larrivarFontSize! + 2,
              transLiteration: Preferences.getTransliteration()));
        }
    });
    /*
     font size decrement
     */
    on<FontDecrementPressed>((event, emit) {
      if (event.gurmukhiFontSize != null &&
          event.gurmukhiFontSize! >= minGurbaniFontSize) {
        Preferences.saveGurmukhiFont(event.gurmukhiFontSize! - 2);
        emit(DisplaySettingsState(
            gurmukhiFontSize: event.gurmukhiFontSize! - 2,
            transliterationFontSize: Preferences.getTransliterationFontSize(),
            englishTranslationFontSize:
                Preferences.getEnglishTranslationFontSize(),
            pronunciationTipFontSize: Preferences.getPronunciationTipFontSize(),
            akhriArthFontSize: Preferences.getAkhriArthFontSize(),
            detailedArthFontSize: Preferences.getDetailedArthFontSize(),
            paragraphStyle: Preferences.getParagraphStyle(),
            larrivarStyle: Preferences.getGuraniStyle(),
            bisramStyle: Preferences.getBisramStyle(),
            englishTranslation: Preferences.getEnglishTranslation(),
            akhriAarth: Preferences.getAakhriArth(),
            larrivarWithBisRamStyle: Preferences.getLarrivarWithBisramStyle(),
            larrivarFontSize: Preferences.getLarrivarFontSize(),
            detailedAarth: Preferences.getDetailedArth(),
            transLiteration: Preferences.getTransliteration()));
      } else if (event.pronunciationTipFontSize != null &&
          event.pronunciationTipFontSize! >= (minGurbaniFontSize - 8)) {
        Preferences.savePronunciationTipFont(
            event.pronunciationTipFontSize! - 2);
        emit(DisplaySettingsState(
            pronunciationTipFontSize: event.pronunciationTipFontSize! - 2,
            gurmukhiFontSize: Preferences.getGurbaniFontSize(),
            transliterationFontSize: Preferences.getTransliterationFontSize(),
            englishTranslationFontSize:
                Preferences.getEnglishTranslationFontSize(),
            akhriArthFontSize: Preferences.getAkhriArthFontSize(),
            detailedArthFontSize: Preferences.getDetailedArthFontSize(),
            paragraphStyle: Preferences.getParagraphStyle(),
            larrivarStyle: Preferences.getGuraniStyle(),
            bisramStyle: Preferences.getBisramStyle(),
            englishTranslation: Preferences.getEnglishTranslation(),
            akhriAarth: Preferences.getAakhriArth(),
            larrivarWithBisRamStyle: Preferences.getLarrivarWithBisramStyle(),
            larrivarFontSize: Preferences.getLarrivarFontSize(),
            detailedAarth: Preferences.getDetailedArth(),
            transLiteration: Preferences.getTransliteration()));
      } else if (event.transliterationFontSize != null &&
          event.transliterationFontSize! >= (minGurbaniFontSize - 8)) {
        Preferences.saveTransliterationFontSize(
            event.transliterationFontSize! - 2);
        emit(DisplaySettingsState(
            transliterationFontSize: event.transliterationFontSize! - 2,
            gurmukhiFontSize: Preferences.getGurbaniFontSize(),
            englishTranslationFontSize: Preferences.getEnglishTranslationFontSize(),
            pronunciationTipFontSize: Preferences.getPronunciationTipFontSize(),
            akhriArthFontSize: Preferences.getAkhriArthFontSize(),
            detailedArthFontSize: Preferences.getDetailedArthFontSize(),
            paragraphStyle: Preferences.getParagraphStyle(),
            larrivarStyle: Preferences.getGuraniStyle(),
            bisramStyle: Preferences.getBisramStyle(),
            englishTranslation: Preferences.getEnglishTranslation(),
            akhriAarth: Preferences.getAakhriArth(),
            larrivarWithBisRamStyle: Preferences.getLarrivarWithBisramStyle(),
            larrivarFontSize: Preferences.getLarrivarFontSize(),
            detailedAarth: Preferences.getDetailedArth(),
            transLiteration: Preferences.getTransliteration()));
      } else if (event.akhriArthFontSize != null &&
          event.akhriArthFontSize! >= (minGurbaniFontSize - 8)) {
        Preferences.saveAkhriArthFontSize(event.akhriArthFontSize! - 2);
        emit(DisplaySettingsState(
            akhriArthFontSize: event.akhriArthFontSize! - 2,
            gurmukhiFontSize: Preferences.getGurbaniFontSize(),
            transliterationFontSize: Preferences.getTransliterationFontSize(),
            englishTranslationFontSize: Preferences.getEnglishTranslationFontSize(),
            pronunciationTipFontSize: Preferences.getPronunciationTipFontSize(),
            detailedArthFontSize: Preferences.getDetailedArthFontSize(),
            paragraphStyle: Preferences.getParagraphStyle(),
            larrivarStyle: Preferences.getGuraniStyle(),
            bisramStyle: Preferences.getBisramStyle(),
            englishTranslation: Preferences.getEnglishTranslation(),
            akhriAarth: Preferences.getAakhriArth(),
            detailedAarth: Preferences.getDetailedArth(),
            larrivarWithBisRamStyle: Preferences.getLarrivarWithBisramStyle(),
            larrivarFontSize: Preferences.getLarrivarFontSize(),
            transLiteration: Preferences.getTransliteration()));
      } else if (event.detailedArthFontSize != null &&
          event.detailedArthFontSize! >= (minGurbaniFontSize - 8)) {
        Preferences.saveDetailedArthFontSizee(event.detailedArthFontSize! - 2);
        emit(DisplaySettingsState(
            detailedArthFontSize: event.detailedArthFontSize! - 2,
            gurmukhiFontSize: Preferences.getGurbaniFontSize(),
            transliterationFontSize: Preferences.getTransliterationFontSize(),
            englishTranslationFontSize: Preferences.getEnglishTranslationFontSize(),
            pronunciationTipFontSize: Preferences.getPronunciationTipFontSize(),
            akhriArthFontSize: Preferences.getAkhriArthFontSize(),
            paragraphStyle:Preferences.getParagraphStyle(),
            larrivarStyle: Preferences.getGuraniStyle(),
            bisramStyle: Preferences.getBisramStyle(),
            englishTranslation: Preferences.getEnglishTranslation(),
            akhriAarth: Preferences.getAakhriArth(),
            detailedAarth: Preferences.getDetailedArth(),
            larrivarWithBisRamStyle: Preferences.getLarrivarWithBisramStyle(),
            larrivarFontSize: Preferences.getLarrivarFontSize(),
            transLiteration: Preferences.getTransliteration()));
      } else if (event.englishTranslatiFontSize != null &&
          event.englishTranslatiFontSize! >= (minGurbaniFontSize - 8)) {
        Preferences.saveEnglishTranslationFontSize(
            event.englishTranslatiFontSize! - 2);
        emit(DisplaySettingsState(
            englishTranslationFontSize: event.englishTranslatiFontSize! - 2,
            gurmukhiFontSize: Preferences.getGurbaniFontSize(),
            transliterationFontSize: Preferences.getTransliterationFontSize(),
            pronunciationTipFontSize: Preferences.getPronunciationTipFontSize(),
            akhriArthFontSize: Preferences.getAkhriArthFontSize(),
            detailedArthFontSize: Preferences.getDetailedArthFontSize(),
            paragraphStyle: Preferences.getParagraphStyle(),
            larrivarStyle: Preferences.getGuraniStyle(),
            bisramStyle: Preferences.getBisramStyle(),
            englishTranslation: Preferences.getEnglishTranslation(),
            akhriAarth: Preferences.getAakhriArth(),
            detailedAarth: Preferences.getDetailedArth(),
            larrivarWithBisRamStyle: Preferences.getLarrivarWithBisramStyle(),
            larrivarFontSize: Preferences.getLarrivarFontSize(),
            transLiteration: Preferences.getTransliteration()));
      }
      else if (event.larrivarFontSize != null &&
          event.larrivarFontSize! >= minGurbaniFontSize) {
        Preferences.saveGurmukhiFont(event.larrivarFontSize! - 2);
        emit(DisplaySettingsState(
            gurmukhiFontSize:Preferences.getLarrivarFontSize(),
            transliterationFontSize: Preferences.getTransliterationFontSize(),
            englishTranslationFontSize: Preferences.getEnglishTranslationFontSize(),
            pronunciationTipFontSize: Preferences.getPronunciationTipFontSize(),
            akhriArthFontSize: Preferences.getAkhriArthFontSize(),
            detailedArthFontSize: Preferences.getDetailedArthFontSize(),
            paragraphStyle:Preferences.getParagraphStyle(),
            larrivarStyle: Preferences.getGuraniStyle(),
            bisramStyle: Preferences.getBisramStyle(),
            englishTranslation: Preferences.getEnglishTranslation(),
            akhriAarth: Preferences.getAakhriArth(),
            larrivarWithBisRamStyle: Preferences.getLarrivarWithBisramStyle(),
            larrivarFontSize: event.larrivarFontSize! - 2,
            detailedAarth: Preferences.getDetailedArth(),
            transLiteration: Preferences.getTransliteration()));
      }
    });
    /* GurbaniView Style Changed
     */
    on<GurbaniViewStyleChanged>((event, emit) {
      Preferences.saveGurbaniStyle(event.larrivarStyle);
      emit(DisplaySettingsState(
          larrivarStyle: event.larrivarStyle,
          paragraphStyle: Preferences.getParagraphStyle(),
          bisramStyle: Preferences.getBisramStyle(),
          gurmukhiFontSize: Preferences.getGurbaniFontSize(),
          transliterationFontSize: Preferences.getTransliterationFontSize(),
          englishTranslationFontSize: Preferences.getEnglishTranslationFontSize(),
          pronunciationTipFontSize: Preferences.getPronunciationTipFontSize(),
          akhriArthFontSize: Preferences.getAkhriArthFontSize(),
          detailedArthFontSize: Preferences.getDetailedArthFontSize(),
          englishTranslation: Preferences.getEnglishTranslation(),
          akhriAarth: Preferences.getAakhriArth(),
          detailedAarth: Preferences.getDetailedArth(),
          larrivarWithBisRamStyle: Preferences.getLarrivarWithBisramStyle(),
          larrivarFontSize: Preferences.getLarrivarFontSize(),
          transLiteration: Preferences.getTransliteration()));
    });
    /* GurbaniView Style Changed
     */
    on<ParagraphStyleChanged>((event, emit) {
      Preferences.saveParagraphStyle(event.paragraphStyle);
      emit(DisplaySettingsState(
          larrivarStyle:  Preferences.getGuraniStyle(),
          paragraphStyle:event.paragraphStyle,
          bisramStyle: Preferences.getBisramStyle(),
          gurmukhiFontSize: Preferences.getGurbaniFontSize(),
          transliterationFontSize: Preferences.getTransliterationFontSize(),
          englishTranslationFontSize: Preferences.getEnglishTranslationFontSize(),
          pronunciationTipFontSize: Preferences.getPronunciationTipFontSize(),
          akhriArthFontSize: Preferences.getAkhriArthFontSize(),
          detailedArthFontSize: Preferences.getDetailedArthFontSize(),
          englishTranslation: Preferences.getEnglishTranslation(),
          akhriAarth: Preferences.getAakhriArth(),
          detailedAarth: Preferences.getDetailedArth(),
          larrivarWithBisRamStyle: Preferences.getLarrivarWithBisramStyle(),
          larrivarFontSize: Preferences.getLarrivarFontSize(),
          transLiteration: Preferences.getTransliteration()));
    });
    /* GurbaniView with bisram Style Changed
     */
    on<BisramStyleChanged>((event, emit) {
      Preferences.saveBisramStyle(event.bisramStyle);
      emit(DisplaySettingsState(
          larrivarStyle: Preferences.getGuraniStyle(),
          paragraphStyle: Preferences.getParagraphStyle(),
          bisramStyle: event.bisramStyle,
          gurmukhiFontSize: Preferences.getGurbaniFontSize(),
          transliterationFontSize: Preferences.getTransliterationFontSize(),
          englishTranslationFontSize: Preferences.getEnglishTranslationFontSize(),
          pronunciationTipFontSize: Preferences.getPronunciationTipFontSize(),
          akhriArthFontSize: Preferences.getAkhriArthFontSize(),
          detailedArthFontSize: Preferences.getDetailedArthFontSize(),
          englishTranslation: Preferences.getEnglishTranslation(),
          akhriAarth: Preferences.getAakhriArth(),
          detailedAarth: Preferences.getDetailedArth(),
          larrivarWithBisRamStyle: Preferences.getLarrivarWithBisramStyle(),
          larrivarFontSize: Preferences.getLarrivarFontSize(),
          transLiteration: Preferences.getTransliteration()));
    });
    /* TransLiteration View Changed
     */
    on<TransLiterationChanged>((event, emit) {
      Preferences.saveTransliteration(event.transLiteration);
      emit(DisplaySettingsState(
        larrivarStyle: Preferences.getGuraniStyle(),
        paragraphStyle: Preferences.getParagraphStyle(),
        bisramStyle: Preferences.getBisramStyle(),
        transLiteration: event.transLiteration,
        gurmukhiFontSize: Preferences.getGurbaniFontSize(),
        transliterationFontSize: Preferences.getTransliterationFontSize(),
        englishTranslationFontSize: Preferences.getEnglishTranslationFontSize(),
        pronunciationTipFontSize: Preferences.getPronunciationTipFontSize(),
        akhriArthFontSize: Preferences.getAkhriArthFontSize(),
        detailedArthFontSize: Preferences.getDetailedArthFontSize(),
        englishTranslation: Preferences.getEnglishTranslation(),
        akhriAarth: Preferences.getAakhriArth(),
        larrivarWithBisRamStyle: Preferences.getLarrivarWithBisramStyle(),
        larrivarFontSize: Preferences.getLarrivarFontSize(),
        detailedAarth: Preferences.getDetailedArth(),
      ));
    });
    /* Aakhri ArthView View Changed
     */
    on<AakhriArthChanged>((event, emit) {
      Preferences.saveAakhriArth(event.aakhriArth);
      emit(DisplaySettingsState(
          larrivarStyle: Preferences.getGuraniStyle(),
          paragraphStyle: Preferences.getParagraphStyle(),
          bisramStyle: Preferences.getBisramStyle(),
          akhriAarth: event.akhriAarth,
          gurmukhiFontSize: Preferences.getGurbaniFontSize(),
          transliterationFontSize: Preferences.getTransliterationFontSize(),
          englishTranslationFontSize: Preferences.getEnglishTranslationFontSize(),
          pronunciationTipFontSize: Preferences.getPronunciationTipFontSize(),
          akhriArthFontSize: Preferences.getAkhriArthFontSize(),
          detailedArthFontSize: Preferences.getDetailedArthFontSize(),
          englishTranslation: Preferences.getEnglishTranslation(),
          detailedAarth: Preferences.getDetailedArth(),
          larrivarWithBisRamStyle: Preferences.getLarrivarWithBisramStyle(),
          larrivarFontSize: Preferences.getLarrivarFontSize(),
          transLiteration: Preferences.getTransliteration()));
    });
    /* Detailed ArthView View Changed
     */
    on<DetailedArthChanged>((event, emit) {
      Preferences.saveDetailedArth(event.detailediArth);
      emit(DisplaySettingsState(
          larrivarStyle: Preferences.getGuraniStyle(),
          paragraphStyle: Preferences.getParagraphStyle(),
          bisramStyle: Preferences.getBisramStyle(),
          detailedAarth: event.detailediArth,
          gurmukhiFontSize: Preferences.getGurbaniFontSize(),
          transliterationFontSize: Preferences.getTransliterationFontSize(),
          englishTranslationFontSize: Preferences.getEnglishTranslationFontSize(),
          pronunciationTipFontSize: Preferences.getPronunciationTipFontSize(),
          akhriArthFontSize: Preferences.getAkhriArthFontSize(),
          detailedArthFontSize: Preferences.getDetailedArthFontSize(),
          englishTranslation: Preferences.getEnglishTranslation(),
          akhriAarth: Preferences.getAakhriArth(),
          larrivarWithBisRamStyle: Preferences.getLarrivarWithBisramStyle(),
          larrivarFontSize: Preferences.getLarrivarFontSize(),
          transLiteration: Preferences.getTransliteration()));
    });
    /* English Translation View Changed
     */
    on<EnglishTranslationChanged>((event, emit) {
      Preferences.saveEnglishTranslation(event.englishTranslation);
      emit(DisplaySettingsState(
          larrivarStyle: Preferences.getGuraniStyle(),
          paragraphStyle:Preferences.getParagraphStyle(),
          bisramStyle: Preferences.getBisramStyle(),
          englishTranslation: event.englishTranslation,
          gurmukhiFontSize: Preferences.getGurbaniFontSize(),
          transliterationFontSize: Preferences.getTransliterationFontSize(),
          englishTranslationFontSize: Preferences.getEnglishTranslationFontSize(),
          pronunciationTipFontSize: Preferences.getPronunciationTipFontSize(),
          akhriArthFontSize: Preferences.getAkhriArthFontSize(),
          detailedArthFontSize: Preferences.getDetailedArthFontSize(),
          akhriAarth: Preferences.getAakhriArth(),
          detailedAarth: Preferences.getDetailedArth(),
          larrivarWithBisRamStyle: Preferences.getLarrivarWithBisramStyle(),
          larrivarFontSize: Preferences.getLarrivarFontSize(),
          transLiteration: Preferences.getTransliteration()));
    });
    /**
     * Larrivar Bisram Style Changed
     */
    on<LarrivarBisramStyleChanged>((event, emit) {
      Preferences.saveLarrivarWithBisramStyle(event.larriavrBisramStyle);
      emit(DisplaySettingsState(
          larrivarStyle: Preferences.getGuraniStyle(),
          paragraphStyle: Preferences.getParagraphStyle(),
          bisramStyle: Preferences.getBisramStyle(),
          englishTranslation: Preferences.getEnglishTranslation(),
          gurmukhiFontSize: Preferences.getGurbaniFontSize(),
          transliterationFontSize: Preferences.getTransliterationFontSize(),
          englishTranslationFontSize:
          Preferences.getEnglishTranslationFontSize(),
          pronunciationTipFontSize: Preferences.getPronunciationTipFontSize(),
          akhriArthFontSize: Preferences.getAkhriArthFontSize(),
          detailedArthFontSize: Preferences.getDetailedArthFontSize(),
          akhriAarth: Preferences.getAakhriArth(),
          detailedAarth: Preferences.getDetailedArth(),
          larrivarWithBisRamStyle: event.larriavrBisramStyle,
          larrivarFontSize: Preferences.getLarrivarFontSize(),
          transLiteration: Preferences.getTransliteration()));
    });

  }
}

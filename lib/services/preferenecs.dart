import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../strings.dart';

class Preferences {
  static late SharedPreferences preferences;
  static const String KEY_SELECTED_THEME = 'key_selected_theme';
  static const String KEY_SELECTED_LANGUAGE = 'key_selected_language';
  static const String KEY_LARRIVAR_FONT_SIZE = 'key_larrivar_font_size';
  static const String KEY_GURBANI_FONT_SIZE = 'key_gurbani_font_size';
  static const String KEY_PRONUNCIATION_TIP_FONT_SIZE = 'pronunciationTipFontSize';
  static const String KEY_TRANSLITERATION_FONT_SIZE = 'transliterationFontSize';
  static const String KEY_ENGLISH_FONT_SIZE = 'englishTranslationFontSize';
  static const String KEY_AKHRI_ARTH_FONT_SIZE = 'akhriArthFontSize';
  static const String KEY_DETAILED_ARTH_FONT_SIZE = 'detailedArthFontSize';
  static const String KEY_LARRIVAAR_STYLE = 'larrivaarStyle';
  static const String KEY_PARAGRAPH_STYLE = 'paragraphStyle';
  static const String KEY_LARRIVAAR_WITH_BISRAM_STYLE = 'larrivaarWithBisramStyle';
  static const String KEY_BISRAMSTYLE = 'bisramStyle';
  static const String KEY_TRANSLITERATION = 'transliteration';
  static const String KEY_AKHRI_ARTH = 'aakhri_arth';
  static const String KEY_DETAILED_ARTH = 'detailed_arth';
  static const String KEY_ENGLISH_TRANSLATION = 'englishTranslation';
  static const String KEY_USER_DETAILS = 'user_details';
  static const String KEY_USER_NAME="user_name";

  static init() async {
    preferences = await SharedPreferences.getInstance();
  }

  // function to save selected theme in shared preference
  static void saveTheme(String selectedTheme) async {
    preferences.setString(KEY_SELECTED_THEME, selectedTheme);
  }

  // Return selected Theme
  static String? getTheme() {
    String? theme = preferences.getString(KEY_SELECTED_THEME);
    if (theme == null || theme.isEmpty) {
      return Strings.appModeDefault;
    }
    return theme;
  }

  // function to save selected language in shared preference
  static void saveLanguage(String selectedLanguage) async {
    preferences.setString(KEY_SELECTED_LANGUAGE, selectedLanguage);
  }

  // Return selected Theme
  static String getLanguage() {
    String? language = preferences.getString(KEY_SELECTED_LANGUAGE);
    if (language == null || language.isEmpty) {
      return Strings.english;
    }
    return language;
  }

  /* save gurbani font size
   */
  static void saveGurmukhiFont(double fontSize) async {
    preferences.setDouble(KEY_GURBANI_FONT_SIZE, fontSize);
  }

  static double getGurbaniFontSize() {
    double? gurbaniFontSize = preferences.getDouble(KEY_GURBANI_FONT_SIZE);
    if (gurbaniFontSize == null || gurbaniFontSize == 0.0) {
      return Strings.gurmukhiFontSize;
    }
    return gurbaniFontSize;
  }
  /* save larrivar font size
   */
  static void saveLarrivarFont(double fontSize) async {
    preferences.setDouble(KEY_LARRIVAR_FONT_SIZE, fontSize);
  }

  static double getLarrivarFontSize() {
    double? larrivarFontSize = preferences.getDouble(KEY_LARRIVAR_FONT_SIZE);
    if (larrivarFontSize == null || larrivarFontSize == 0.0) {
      return Strings.larrivarFontSize;
    }
    return larrivarFontSize;
  }

  /*
  save user details
   */
  static void saveUserDetails(String userId,name) async {
    preferences.setString(KEY_USER_DETAILS, userId);
    preferences.setString(KEY_USER_NAME, name);
  }
  static String? getUserDetails(String key) {
    if(key==KEY_USER_DETAILS){
      return preferences.getString(KEY_USER_DETAILS);
    }else if(key==KEY_USER_NAME) {
      return preferences.getString(KEY_USER_NAME);
    }else{
      return '';
    }
  }

  /*
   * Clear User Details
   */
  static void clearUserDetails(){
    preferences.remove(KEY_USER_DETAILS);
    preferences.remove(KEY_USER_NAME);
  }


  /*
  save Pronunciation font size
   */
  static void savePronunciationTipFont(double fontSize) async {
    preferences.setDouble(KEY_PRONUNCIATION_TIP_FONT_SIZE, fontSize);
  }

  static double getPronunciationTipFontSize() {
    double? fontSize = preferences.getDouble(KEY_PRONUNCIATION_TIP_FONT_SIZE);
    if (fontSize == null || fontSize == 0.0) {
      return Strings.pronunciationTipFontSize;
    }
    return fontSize;
  }

  /*
  save Transliteration font size
  */
  static void saveTransliterationFontSize(double fontSize) async {
    preferences.setDouble(KEY_TRANSLITERATION_FONT_SIZE, fontSize);
  }

  static double getTransliterationFontSize() {
    double? fontSize = preferences.getDouble(KEY_TRANSLITERATION_FONT_SIZE);
    if (fontSize == null || fontSize == 0.0) {
      return Strings.transliterationFontSize;
    }
    return fontSize;
  }

  /*
  save english font size
  */
  static void saveEnglishTranslationFontSize(double fontSize) async {
    preferences.setDouble(KEY_ENGLISH_FONT_SIZE, fontSize);
  }

  static double getEnglishTranslationFontSize() {
    double? fontSize = preferences.getDouble(KEY_ENGLISH_FONT_SIZE);
    if (fontSize == null || fontSize == 0.0) {
      return Strings.englishTranslationSize;
    }
    return fontSize;
  }

  /*
  save Akhri font size
  */
  static void saveAkhriArthFontSize(double fontSize) async {
    preferences.setDouble(KEY_AKHRI_ARTH_FONT_SIZE, fontSize);
  }

  static double getAkhriArthFontSize() {
    double? fontSize = preferences.getDouble(KEY_AKHRI_ARTH_FONT_SIZE);
    if (fontSize == null || fontSize == 0.0) {
      return Strings.akhriArthFontSize;
    }
    return fontSize;
  }

  /*
  save detailed Arth font size
  */
  static void saveDetailedArthFontSizee(double fontSize) async {
    preferences.setDouble(KEY_DETAILED_ARTH_FONT_SIZE, fontSize);
  }

  static double getDetailedArthFontSize() {
    double? fontSize = preferences.getDouble(KEY_DETAILED_ARTH_FONT_SIZE);
    if (fontSize == null || fontSize == 0.0) {
      return Strings.detailedArthFontSize;
    }
    return fontSize;
  }

  /*
  save / get  gurbani style
  */
  static void saveGurbaniStyle(bool style) async {
    preferences.setBool(KEY_LARRIVAAR_STYLE, style);
  }

  static bool getGuraniStyle() {
    bool? style = preferences.getBool(KEY_LARRIVAAR_STYLE);
    if (style == null) {
      return false;
    }
    return style;
  }
  /*
  save / get  gurbani style
  */
  static void saveParagraphStyle(bool style) async {
    preferences.setBool(KEY_PARAGRAPH_STYLE, style);
  }

  static bool getParagraphStyle() {
    bool? style = preferences.getBool(KEY_PARAGRAPH_STYLE);
    if (style == null) {
      return false;
    }
    return style;
  }
  /*
  save / get  gurbani style
  */
  static void saveLarrivarWithBisramStyle(bool style) async {
    preferences.setBool(KEY_LARRIVAAR_WITH_BISRAM_STYLE, style);
  }

  static bool getLarrivarWithBisramStyle() {
    bool? style = preferences.getBool(KEY_LARRIVAAR_WITH_BISRAM_STYLE);
    if (style == null) {
      return false;
    }
    return style;
  }

  /*
  save / get  bisram style
  */
  static void saveBisramStyle(bool style) async {
    preferences.setBool(KEY_BISRAMSTYLE, style);
  }

  static bool getBisramStyle() {
    bool? style = preferences.getBool(KEY_BISRAMSTYLE);
    if (style == null) {
      return false;
    }
    return style;
  }

  /*
  save / get  transliteration
  */
  static void saveTransliteration(bool transliteration) async {
    preferences.setBool(KEY_TRANSLITERATION, transliteration);
  }

  static bool getTransliteration() {
    bool? transliteration = preferences.getBool(KEY_TRANSLITERATION);
    if (transliteration == null) {
      return false;
    }
    return transliteration;
  }

  /*
  save / get  aakhri arth
  */
  static void saveAakhriArth(bool aakhriArth) async {
    preferences.setBool(KEY_AKHRI_ARTH, aakhriArth);
  }

  static bool getAakhriArth() {
    bool? aakhriArth = preferences.getBool(KEY_AKHRI_ARTH);
    if (aakhriArth == null) {
      return true;
    }
    return aakhriArth;
  }

  /*
  save / get  detailed arth
  */
  static void saveDetailedArth(bool detailedArth) async {
    preferences.setBool(KEY_DETAILED_ARTH, detailedArth);
  }

  static bool getDetailedArth() {
    bool? detailedArth = preferences.getBool(KEY_DETAILED_ARTH);
    if (detailedArth == null) {
      return true;
    }
    return detailedArth;
  }

  /*
  save / get  english translation
  */
  static void saveEnglishTranslation(bool englishTranslation) async {
    preferences.setBool(KEY_ENGLISH_TRANSLATION, englishTranslation);
  }
  static bool getEnglishTranslation() {
    bool? englishTranslation = preferences.getBool(KEY_ENGLISH_TRANSLATION);
    if (englishTranslation == null) {
      return true;
    }
    return englishTranslation;
  }
  /*
  save / get App settings details
  */
  static void saveAppSettings(String key,bool value) async {
    preferences.setBool(key, value);
  }

  static bool getAppSettings(String key) {
    bool? value = preferences.getBool(key);
    if (value == null) {
      return true;
     // return key==Strings.home_screen_introduction?false:true;
    }
    return value;
  }
  /*
  save / get search filter
  */
  static void saveSearchFilter(String key,bool value) async {
    preferences.setBool(key, value);
  }
  static bool getSearchFilter(String key) {
    bool? value = preferences.getBool(key);
    if (value == null) {
      return key==Strings.similarOption_1_1||key==Strings.similarOption_2_1?true:false;
    }
    return value;
  }
}

// function to check selected app theme mode
bool isDarkMode(context) {
  String? appTheme = Preferences.getTheme();
  if (appTheme == Strings.app_mode_dark) {
    return true;
  } else if (appTheme == Strings.app_mode_light) {
    return false;
  } else {
    final brightness = MediaQuery.of(context).platformBrightness;
    return brightness == Brightness.dark;
  }
}

import 'package:flutter/material.dart';
import 'package:learn_shudh_gurbani/strings.dart';

class AppThemes {
  static const Color lightBlue = Color(0xFFB4CFFF);
  static const Color greyDivider= Color(0xFFFFFF4D);
  static const Color darkYellowColor=Color(0xFFF5D43B);
  static Color bgColor=Color(0xFFEDEDED);
  static const Color darkBrownColor=Color(0xFF464646);
  static const Color darkYellow=Color(0xFF8E7603);
  static const Color yellowColorCardBg=Color(0xFFF2BF4C);
  static const Color greyColor=Color(0xFFB4B4B4);
  static const Color brownColor=Color(0xFF9F6634);
  static const Color darkBlueColor=Color(0xFF142849);
  static const Color blueColor=Color(0xFF9AB6E6);
  static const Color greyLightColor=Color(0xFFEAEAEA);
  static const Color greyLightColor1=Color(0xFFFFFF29);
  static const Color greyLightColor2=Color(0xFFFFFF0F);
  static const Color greyLightColor3=Color(0xFF0D1C39);
  static const Color greyTextColor=Color(0xFF505050);
  static const Color lightGreyTextColor=Color(0xFFDDDDDD);
  static const Color blueEditTextBgColor=Color(0xFF17428E);
  static const Color floralBgColor= Color(0xFFfcf8ef);
  static const Color yellowBgColor=Color(0xFFF7F8CC);
  static const Color dropShadow=Color(0xFF00000029);
  static const Color deepPinkColor=Color(0xFFC91E86);
  static const Color greyDividerColor=Color(0xFFD1D1D1);

  static final appThemeData = {
    AppTheme.lightTheme: ThemeData(
      scaffoldBackgroundColor: const Color(0xFF2451A0),
      canvasColor: bgColor,
      primaryColor: const Color(0xFF2451A0),
      backgroundColor:const Color(0xFF2451A0),
      indicatorColor: Colors.white,
      fontFamily:Strings.AcuminFont ,
      secondaryHeaderColor: const Color(0xFF2451A0),
      primaryColorLight: const Color(0xFF2451A0),
      primaryColorDark: const Color(0xFF17428E),
      dividerColor: const Color(0xFFF4D43B),
      unselectedWidgetColor: Colors.white,
      dialogBackgroundColor: const Color(0xFF6686bd) ,
      hintColor: Colors.white,
      cursorColor: const Color(0xFFF7F7F7) ,
      focusColor: darkBlueColor,
      hoverColor: const Color(0xFF17428E),
      disabledColor: const Color(0xFF6686bd),
      iconTheme: const IconThemeData(color: Colors.white),
      textTheme: const TextTheme(
        caption:   TextStyle(fontSize: 22),
        subtitle1: TextStyle(color: Colors.white,),
        headline1: TextStyle(fontSize: 26,color: Colors.white),
        headline2: TextStyle(fontSize: 19,color: Colors.white),
        headline3: TextStyle(fontSize: 16,color: Colors.white),
           button: TextStyle(color: Color(0xFFF5D43B)),
        bodyText2: TextStyle(color: Color(0xFFB4CFFF),),
        bodyText1: TextStyle(color: Colors.white,),
      ), colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue).copyWith(secondary: Colors.white).copyWith(secondary: Colors.white), textSelectionTheme: TextSelectionThemeData(cursorColor: Colors.white),
    ),
     AppTheme.darkTheme: ThemeData(
      scaffoldBackgroundColor:  const Color(0xFF182D4E),
       primaryColor: const Color(0xFF182D4E),
       backgroundColor: const Color(0xFF182D4E),
       canvasColor: const Color(0xFF182D4E),
       indicatorColor: const Color(0xFFF7F7F7),
       disabledColor: const Color(0xFF2c3c5a),
       dialogBackgroundColor: const Color(0xFF26334d),
       fontFamily: Strings.AcuminFont,
       secondaryHeaderColor: const Color(0xFF182D4E),
       primaryColorLight: const Color(0xFF182D4E),
       primaryColorDark: const Color(0xFF13254A),
       iconTheme: const IconThemeData(color:Color(0xFFF7F7F7)),
       dividerColor: const Color(0xFFF4D43B),
       unselectedWidgetColor: const Color(0xFFF7F7F7),
       hintColor: const Color(0xFFF7F7F7),
       focusColor: const Color(0xFFF7F7F7),
       hoverColor: const Color(0xFFF4D43B),
       cursorColor: greyLightColor3 ,
        textTheme: const TextTheme(caption: TextStyle(fontSize: 22),
        headline1: TextStyle(fontSize: 26,color: Color(0xFFF7F7F7)),
        headline2: TextStyle(fontSize: 19,color: Color(0xFFF7F7F7)),
        headline3: TextStyle(fontSize: 16,color: Color(0xFFF7F7F7)),
          button: TextStyle(color: Color(0xFFF5D43B)),
        subtitle1: TextStyle(color: Color(0xFFF7F7F7)),
        bodyText1: TextStyle(color: Color(0xFFF7F7F7)),
        bodyText2: TextStyle(color: Color(0xFFB4CFFF),),),
       colorScheme:ColorScheme.fromSwatch(primarySwatch: Colors.blue).copyWith(secondary: const Color(0xFFF7F7F7)).copyWith(secondary: const Color(0xFFF7F7F7)), textSelectionTheme: const TextSelectionThemeData(cursorColor: Color(0xFFF7F7F7)),
    )
  };
}

enum AppTheme {
  lightTheme,
  darkTheme,
}

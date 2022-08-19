import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:learn_shudh_gurbani/app_themes.dart';
import 'package:learn_shudh_gurbani/constants/constants.dart';
import 'package:learn_shudh_gurbani/strings.dart';
import 'package:learn_shudh_gurbani/ui/section_help.dart';
import 'package:learn_shudh_gurbani/widgets/custom_shape_popup.dart';

import '../services/preferenecs.dart';

/*
 *   text widget function
 */
Widget text(
    String text,
    var isCentered,
    var textColor,
    var textSize,
    var letterSpacing,
    var textAllCaps,
    var isLongText,
    BuildContext context,
    double padding,
    FontWeight bold,
    [String? font]) {
  return Padding(
    padding: EdgeInsets.only(top: padding),
    child: Text(
      textAllCaps ? text.toUpperCase() : text,
      textAlign: isCentered ? TextAlign.center : TextAlign.start,
      style: TextStyle(
        fontFamily: font ?? Strings.AcuminFont,
        fontSize: textSize,
        fontWeight: bold,
        color: textColor ?? Theme.of(context).textTheme.bodyText1,
        letterSpacing: letterSpacing>1?letterSpacing:0,
      ),
    ),
  );
}
/*
 *  Text View with ellipse end options for list view
 */
Widget textList(
    String text,
    var isCentered,
    var textColor,
    var textSize,
    var latterSpacing,
    var textAllCaps,
    var maxLines,
    BuildContext context,
    double padding,
    FontWeight bold,
    [String? font]) {
  return Padding(
    padding: EdgeInsets.only(top: padding),
    child: Text(
      textAllCaps ? text.toUpperCase() : text,
      maxLines: maxLines > 0 ? maxLines : null,
      overflow: TextOverflow.ellipsis,
      textAlign: isCentered ? TextAlign.center : TextAlign.start,
      style: TextStyle(
        fontFamily: font ?? Strings.AcuminFont,
        fontSize: textSize,
        fontWeight: bold,
        color: textColor ?? Theme.of(context).textTheme.bodyText1,
        letterSpacing: latterSpacing,
      ),
    ),
  );
}

/*
  Function for italic font style
 */
Widget textItalic(
  String text,
  var isCentered,
  var textColor,
  var textSize,
  var latterSpacing,
  var textAllCaps,
  var isLongText,
  BuildContext context,
  double padding,
  FontWeight bold,
) {
  return Padding(
    padding: EdgeInsets.only(top: padding),
    child: Text(
      textAllCaps ? text.toUpperCase() : text,
      textAlign: isCentered ? TextAlign.center : TextAlign.start,
      style: TextStyle(
        fontSize: textSize,
        fontWeight: bold,
        fontStyle: FontStyle.italic,
        color: textColor ?? Theme.of(context).textTheme.bodyText1,
        letterSpacing: latterSpacing,
      ),
    ),
  );
}

/*
 *  divider function
 */
Widget divider(
    {Color? color,
    double? thickness,
    double? height,
    double? indent,
    double? endIndent,
    required double padding}) {
    return Padding(
      padding: EdgeInsets.only(top: padding),
      child: Divider(
        color: color,
        thickness: thickness,
        height: height,
        indent: indent,
        endIndent: endIndent,
      ));
}

/*
  function to move on next screen screen
  */
navigationPage(BuildContext context, String screenName, Widget screen) {
  Navigator.push(context, SlideRightRoute(page: screen));
}

/*
 *  function to load screen with animation
 */
class SlideRightRoute extends PageRouteBuilder {
  final Widget page;
  SlideRightRoute({required this.page})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) => page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) => SlideTransition(
              position: Tween<Offset>(
              begin: const Offset(-1, 0),
              end: Offset.zero,
            ).animate(animation),
              child: child,
          ),
        );
}

/*
 * text color according to theme
 */
Color textColorTheme(context) {
  return isDarkMode(context)
      ? Theme.of(context).indicatorColor
      : AppThemes.darkBlueColor;
}
/* disabled switch color
 */
Color disableSwitchTheme(context) {
  return isDarkMode(context)
      ? Theme.of(context)
      .indicatorColor.withOpacity(0.4)
      : AppThemes.lightBlue;
}
/*
 *  status customization function
 */
Widget statusBar(BuildContext context) {
  return Container(
    height: MediaQuery.of(context).padding.top,
    width: MediaQuery.of(context).size.width,
    decoration: BoxDecoration(
      color: Theme.of(context).primaryColor,
    ),
  );
}

/*
 * text alignment function
 */
Widget textAlign({
  required String text,
  required double fontSize,
  fontWeight,
  dynamic color,
  align,
}) {
  return Align(
    alignment: align ?? Alignment.topLeft,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Text(text,
        style: TextStyle(
          fontSize: fontSize,
          letterSpacing: 0.8,
          fontWeight: fontWeight,
          color: color,
        ),
      ),
    ),
  );
}
/*
 * function to decorate view background
 */
BoxDecoration boxDecoration(
    {double radius = 10,
    Color color = Colors.amber,
    Color bgColor = Colors.blueAccent,
      Color outerColor= Colors.amber,
    var showShadow = false}) {
  return BoxDecoration(color:bgColor ,
      border: Border.all(color: outerColor),
      borderRadius: BorderRadius.all(Radius.circular(radius)));
}


Widget richText({
  required String name,
  name2,
  required Function onTap,
  required double font,
  required double font2,
}) {
  return RichText(
    text: TextSpan(
      text: name,
      style: TextStyle(
        fontSize: font,
        color: Colors.white,
        letterSpacing: 0.5,
        fontWeight: FontWeight.bold,
      ),
      children: <TextSpan>[
        TextSpan(
          text: name2,
          style: TextStyle(
            fontSize: font2,
            color: ThemeData.light().primaryColor,
            letterSpacing: 0.8,
            fontWeight: FontWeight.bold,
          ),
          recognizer: TapGestureRecognizer()
            ..onTap = onTap as GestureTapCallback?,
        ),
      ],
    ),
  );
}

/*
 * loader function
 */
Widget showLoader() {
  return const Center(
    child: CircularProgressIndicator(
      strokeWidth: 2,
      valueColor: AlwaysStoppedAnimation(Colors.amberAccent),
    ),
  );
}
class ErrorMessageWidget extends StatelessWidget {
  final dynamic exception;
  const ErrorMessageWidget({
    Key? key,
    required this.exception,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline_rounded,
            color: AppThemes.darkYellowColor,
            size: 80,
          ),
          Padding(
            padding: const EdgeInsets.all(25.0),
            child:   Text(
                exception.toString().contains(":")?exception.toString().split(':')[1]:exception.toString(),
              style: const TextStyle(color: AppThemes.darkYellowColor,fontSize: 26),
            ),
          ),
        ],
      ),
    );
  }
}

/*
 *  list title view
 */
Widget listTile(
    {context,
    String? image,
    String? name,
    String? value,
    String? value1,
    String? value2,
    var line}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Container(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Padding(
              padding: const EdgeInsets.only(left: 8, top: 10, bottom: 10),
              child: Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                  image: DecorationImage(image: AssetImage(image!)),
                ),
              )),
          const SizedBox(width: 14),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.70,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      Text(name!,
                        style: const TextStyle(
                          fontSize: 18,
                          letterSpacing: 0.5,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(value!,
                        overflow: TextOverflow.ellipsis,
                        maxLines: line ?? 1,
                        style: const TextStyle(
                          fontSize: 14,
                          letterSpacing: 0.5,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

/*
 * input text field
 */

Widget customTextInputField(
  BuildContext context,
  double padding,
  TextEditingController textEditingController,
  TextInputType textInputType,
  Color cursorColor,
  int maxLine,
  Color fillColor,
  String hint,
  Color borderColor,
  Color outerColor,
  Color textColor,
  double textFontSize,
  TextStyle textStyle,
  TextStyle hintStyle,
) {
  return Padding(
    padding: EdgeInsets.only(top: padding),
    child: TextFormField(
      keyboardType: textInputType,
      cursorColor: cursorColor,
      maxLines: maxLine,
      style: textStyle,
      decoration: InputDecoration(contentPadding: const EdgeInsets.only(left: 30.0, right: 30.0, top: 15.0, bottom: 15.0),
        hintText: hint,
        hintStyle: hintStyle,
        filled: true,
        fillColor: fillColor,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: borderColor, width: 0.5),
          borderRadius: BorderRadius.circular(30.0),
        ),
          border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide(color: outerColor, width: 0.5),
        ),
          enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide(color: fillColor, width: 0.5,
          ),
        ),
      ),
    ),
  );
}

/*
 * input text field with prefix
 */
Widget customTextInputFieldWithPrefix(
  BuildContext context,
  double padding,
  TextInputType textInputType,
  Color cursorColor,
  int maxLine,
  Color fillColor,
  String hint,
  Color borderColor,
  Color outerColor,
  Color textColor,
  double textFontSize,
  TextStyle textStyle,
  TextStyle hintStyle, String? error,
    ValueChanged<String> onChange,
   FocusNode? focusNode,
   TextInputAction? textInputAction,
) {
  return Padding(
    padding: EdgeInsets.only(top: padding),
    child: TextFormField(
      keyboardType: textInputType,
      cursorColor: cursorColor,
      maxLines: maxLine,
      style: textStyle,
      onChanged: onChange,
      focusNode: focusNode,
      textInputAction: textInputAction,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 15.0, bottom: 15.0),
        hintText: hint,
        hintStyle: hintStyle,
        filled: true,
        errorText: error,
        errorStyle: const TextStyle(color: AppThemes.deepPinkColor,fontSize: 16,fontFamily: Strings.AcuminFont),
        fillColor: fillColor,
        prefixIcon: SizedBox(
          width: 110,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                Strings.selected,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Theme.of(context).focusColor,
                    fontSize: 18,
                    fontFamily: Strings.AcuminFont,
                    fontWeight: FontWeight.normal),
              ),
            ),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: borderColor, width: 0.5),
          borderRadius: BorderRadius.circular(30.0),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide(color: outerColor, width: 0.5),
        ),
        errorMaxLines: 2,
        errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30.0),
        borderSide: const BorderSide(color: AppThemes.deepPinkColor, width:2),),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide(
            color: fillColor,
            width: 0.5,
          ),
        ),
      ),
    ),
  );
}

/*
 *  function for list title
 */
Widget listTileSearchItem(
    {context,
    String? image,
    String? name,
    String? value,
    String? value1,
    String? value2,
    var line, String? fontStyle}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 10, left: 25, right: 25),
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(0),
      ),
      child: Row(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.70,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      Text(
                        name!,
                        style: TextStyle(
                          fontSize: Strings.gurmukhiFontSize,
                          letterSpacing: 0.5,
                          color: isDarkMode(context)?Theme.of(context).indicatorColor:Theme.of(context).scaffoldBackgroundColor,
                          fontWeight: FontWeight.w300,
                          fontFamily: fontStyle
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(value!,
                        overflow: TextOverflow.ellipsis,
                        maxLines: line ?? 1,
                        style: TextStyle(
                          fontSize: Strings.transliterationFontSize,
                          letterSpacing: 0.5,
                          color: isDarkMode(context)?AppThemes.greyLightColor:Theme.of(context).scaffoldBackgroundColor,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(value1!,
                        overflow: TextOverflow.ellipsis,
                        maxLines: line ?? 1,
                        style: TextStyle(
                          fontSize: Strings.englishTranslationSize,
                          letterSpacing: 0.5,
                          color: isDarkMode(context)?AppThemes.blueColor:AppThemes.darkBrownColor,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(value2!,
                        overflow: TextOverflow.ellipsis,
                        maxLines: line ?? 1,
                        style: TextStyle(
                          fontSize: Strings.akhriArthFontSize,
                          letterSpacing: 0.5,
                          color:isDarkMode(context)?AppThemes.darkYellowColor:AppThemes.brownColor,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

/*
 *  alert dialog for help dialog
 */
Future<void> helpAlert(BuildContext context, double padding, [String? helpData,String? title]) async {
  return showDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierColor: null,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
                alignment: Alignment.topRight,
                elevation: 0,
                backgroundColor: Colors.transparent,
                insetPadding: EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: AppBar().preferredSize.height - 5),
                contentPadding: EdgeInsets.zero,
                actionsPadding: EdgeInsets.zero,
                buttonPadding: EdgeInsets.zero,
                titlePadding: EdgeInsets.zero,
                content: Wrap(
                  alignment: WrapAlignment.end,
                  direction: Axis.horizontal,
                  children: [
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          helpPopUpTopView(context, padding, AppThemes.darkYellowColor),
                          Container(
                              alignment: Alignment.topRight,
                              color: AppThemes.darkYellowColor,
                              padding: const EdgeInsets.only(
                                  top: 15, bottom: 15, left: 25, right: 25),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pop(true);
                                  navigationPage(
                                      context, sectionHelp, SectionHelp());
                                },
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    text(
                                        title??'Topic Heading',
                                        false,
                                        AppThemes.darkBlueColor,
                                        26.0,
                                        1.0,
                                        false,
                                        true,
                                        context,
                                        1,
                                        FontWeight.bold),
                                    text(helpData??
                                        'This is where the body text can go, in this style. You can also add images, diagrams, animations or whatever else you need to elaborate.',
                                        false,
                                        Theme.of(context).primaryColorDark,
                                        16.0,
                                        1.0,
                                        false,
                                        true,
                                        context,
                                        15,
                                        FontWeight.bold),
                                    // text(
                                    //     'Here is some secondary text style that you may want to use as examples, etc.',
                                    //     false,
                                    //     Theme.of(context).primaryColorDark,
                                    //     16.0,
                                    //     1.0,
                                    //     false,
                                    //     true,
                                    //     context,
                                    //     15,
                                    //     FontWeight.normal),
                                  ],
                                ),
                              )),
                        ]),
                  ],
                ));
          },
        );
      });
}

/*
 * HelpAlert Topview background
 */
Widget helpPopUpTopView(BuildContext context, double padding, Color color) {
  return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 10, left: 25, right: padding),
          child: CustomPaint(painter: CustomShape(color)),
        ),
      ]);
}
/*
 * audio settings background
 */
Widget audioSettingsPopUpTopView(
    BuildContext context, double padding, Color color) {
  return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
            padding: EdgeInsets.only(top: 0, left: 25, right: padding),
            child: CustomPaint(
              size: const Size(20, 20),
              painter: DrawTriangleShape(color),
            )),
      ]);
}
/*
 * Function to detect gesture swipe
 */
Widget backPressGestureDetection(BuildContext context,Widget _child){
 return GestureDetector(
      onVerticalDragUpdate: (details) {
  },
  onHorizontalDragUpdate: (details) {
  if (details.delta.direction <= 0) {
  Navigator.of(context).pop();
  }
  },child: _child);

}
/*
 *  Function to change date format
 */
String convertDate(DateTime dateTime) {
  return DateFormat('MMMM dd, yyy').format(dateTime);
}
 String currentDate(){
  return "${ DateTime.now().millisecondsSinceEpoch}";
}
/*
 *  get Date according to format
 */
String getFormattedDate(String dateTime) {
  DateTime dt = DateTime.parse(dateTime);
  return DateFormat('MMMM dd, yyy').format(dt);
}
/*
 *  compare dates
 */
bool isToday(String date){
  DateTime dt = DateTime.parse(date);
  var date1 =DateFormat('MMMM dd, yyy').format(dt);
  var date2 =DateFormat('MMMM dd, yyy').format(DateTime.now());
  return date1 ==date2?true :false;
}

/*
 *  Method to get data from time stam
 */
String getDateFromTimestamp(String timestamp){
  final DateTime date = DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp));
  print("date>>$date");
  return "${convertDate(date)}";
}
/*
get time format from date and  time
 */
String getTime(String date){
  DateTime dt = DateTime.parse(date);
  var time =DateFormat('hh:mm a').format(dt);
  return "$time";
}

showAlert(BuildContext context, String text) {
    showGeneralDialog(
        transitionBuilder: (context, a1, a2, widget) {
          final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
          return Transform(
            transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
            child: Opacity(
              opacity: a1.value,
              child: AlertDialog(backgroundColor: Theme.of(context).canvasColor,
                shape: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(20.0)),
                title: Text(Strings.alert, style: TextStyle(color: Theme.of(context).hoverColor, fontSize: 20),),
                content: Text(text, style: TextStyle(color: Theme.of(context).hoverColor, fontSize: 18),),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(Strings.okay, style: TextStyle(color: Theme.of(context).hoverColor, fontSize: 18),),
                  ),
                ],
              ),
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 200),
        barrierDismissible: true,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) {
          return const Text(Strings.internetAlertBuilder);
        });
}

/*
 Snackbar to display message
 */
ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackbar(BuildContext context, String message,String? font,[Color? color,Color? textColor]){
  return ScaffoldMessenger.of(context).showSnackBar( SnackBar(
      backgroundColor: color??Theme.of(context).primaryColorDark,
      content: Text(message,
        style: TextStyle(
            fontSize: 16,
            fontFamily: font,
            color: textColor??Theme.of(context).indicatorColor),
      )));
}



String getWriterName( int id){
  switch (id){
    case 0:
      return  Strings.source_1;
      break;
    case 1:
      return Strings.source_2;
      break;
    case 3:
      return Strings.source_3;
      break;
    case 4:
      return Strings.source_4;
      break;
    case 5:
      return Strings.source_5;
      break;
    case 6:
      return Strings.source_6;
      break;
    case 7:
      return Strings.source_7;
      break;
    default:
      return  Strings.source_unknown;
  }
}


// FocusScope.of(context).requestFocus(FocusNode());

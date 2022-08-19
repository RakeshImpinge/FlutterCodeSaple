// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:learn_shudh_gurbani/app_themes.dart';
import 'package:learn_shudh_gurbani/bloc/report_mistake/report_mistake_bloc.dart';
import 'package:learn_shudh_gurbani/bloc/report_mistake/report_mistake_event.dart';
import 'package:learn_shudh_gurbani/strings.dart';
import 'package:learn_shudh_gurbani/widgets/widget.dart';

import '../bloc/report_mistake/report_mistake_state.dart';
import '../services/preferenecs.dart';
import '../widgets/textformfield.dart';

class ReportMistakeForm extends StatefulWidget {
  const ReportMistakeForm({Key? key}) : super(key: key);

  @override
  ReportMistakeState createState() => ReportMistakeState();
}

class ReportMistakeState extends State<ReportMistakeForm> {
  late double _height;
  late double _width;
  late double _pixelRatio;

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    Object? reportMistakeData = ModalRoute.of(context)!.settings.arguments;
    print(reportMistakeData);
    return backPressGestureDetection(
        context,
        Material(
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).primaryColorDark,
              elevation: 0,
              leading: IconButton(
                  iconSize: 30,
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
              centerTitle: false,
              title: const Text(Strings.reportMistake),
              titleTextStyle: const TextStyle(fontSize: 21),
            ),
            body: BlocBuilder<ReportMistakeBloc, ReportMistakeFormState>(
              builder: (context, state) {
                return Container(
                  color: isDarkMode(context)
                      ? Theme.of(context).primaryColorDark
                      : Theme.of(context).canvasColor,
                  child: SafeArea(
                    child: SizedBox(
                      height: _height,
                      width: _width,
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: SingleChildScrollView(
                              padding: const EdgeInsets.only(top: 10, bottom: 25, left: 20, right: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 15),
                                    child: text(
                                        Strings.thuk,
                                        false,
                                        Theme.of(context).hoverColor,
                                        18.0,
                                        1.0,
                                        false,
                                        false,
                                        context,
                                        15,
                                        FontWeight.bold),
                                  ),
                                  BlocBuilder<ReportMistakeBloc,
                                          ReportMistakeFormState>(
                                      buildWhen: (previous, current) =>
                                          previous.selectedGurbani !=
                                          current.selectedGurbani,
                                      builder: (context, state) {
                                        return customTextInputFieldWithPrefix(
                                          context,
                                          5,
                                          TextInputType.text,
                                          Theme.of(context).indicatorColor,
                                          1,
                                          isDarkMode(context)
                                              ? AppThemes.blueEditTextBgColor.withAlpha(80)
                                              : Colors.white,
                                          "gurbwxI jI",
                                          isDarkMode(context)
                                              ? AppThemes.blueEditTextBgColor.withAlpha(80)
                                              : Theme.of(context).cursorColor,
                                          isDarkMode(context)
                                              ? Theme.of(context).indicatorColor
                                              : Theme.of(context).cursorColor,
                                          Theme.of(context).focusColor,
                                          18,
                                          TextStyle(
                                            color: Theme.of(context).focusColor,
                                            fontSize: 18,
                                            fontFamily: Strings.gurmukhiFont,
                                          ),
                                          TextStyle(
                                              color:
                                                  Theme.of(context).focusColor,
                                              fontSize: 18,
                                              fontFamily: Strings.gurmukhiFont),
                                          state.selectedGurbani.invalid
                                              ? Strings.fieldRequired
                                              : null,
                                          (name) => context
                                              .read<ReportMistakeBloc>()
                                              .add(GurbaniTukChanged(
                                                  gurbaniTuk: name)),
                                          null,
                                          TextInputAction.next,
                                        );
                                      }), //<= selected Gurbani tuk
                                  Padding(
                                    padding: const EdgeInsets.only(left: 15),
                                    child: text(
                                        Strings.ang,
                                        false,
                                        Theme.of(context).hoverColor,
                                        18.0,
                                        1.0,
                                        false,
                                        false,
                                        context,
                                        15,
                                        FontWeight.bold),
                                  ),

                                  BlocBuilder<ReportMistakeBloc,
                                      ReportMistakeFormState>(
                                    buildWhen: (previous, current) =>
                                        previous.ang != current.ang,
                                    builder: (context, state) {
                                      return CustomTextField(
                                        padding: 5,
                                        hint: '291',
                                        isRequired: true,
                                        keyboardType: TextInputType.number,
                                        cursorColor: isDarkMode(context)
                                            ? Theme.of(context).primaryColorDark
                                            : Theme.of(context).indicatorColor,
                                        fillColor: isDarkMode(context)
                                            ? AppThemes.blueEditTextBgColor.withAlpha(80)
                                            : Colors.white,
                                        borderColor: isDarkMode(context)
                                            ? AppThemes.blueEditTextBgColor.withAlpha(80)
                                            : Theme.of(context).cursorColor,
                                        outerColor: isDarkMode(context)
                                            ? AppThemes.blueEditTextBgColor.withAlpha(80)
                                            : Theme.of(context).cursorColor,
                                        textStyle: TextStyle(
                                            color: Theme.of(context).focusColor,
                                            fontSize: 18,
                                            fontFamily: Strings.gurmukhiFont),
                                        hintStyle: TextStyle(
                                            color: Theme.of(context).focusColor,
                                            fontSize: 18,
                                            fontFamily: Strings.gurmukhiFont),
                                        errorTextStyle: const TextStyle(
                                            color: AppThemes.deepPinkColor,
                                            fontSize: 16),
                                        errorColor: AppThemes.deepPinkColor,
                                        // focusNode: focusNode,
                                        error: state.ang.invalid
                                            ? Strings.fieldRequired
                                            : null,
                                        onChange: (ang) => {
                                          context
                                              .read<ReportMistakeBloc>()
                                              .add(AngChanged(ang: ang))
                                        },
                                        obscureText: false,
                                        textInputAction: TextInputAction.next,
                                      );
                                    },
                                  ), //<= ang input field
                                  Padding(
                                    padding: const EdgeInsets.only(left: 15),
                                    child: text(
                                        Strings.audioTrackName,
                                        false,
                                        Theme.of(context).hoverColor,
                                        18.0,
                                        1.0,
                                        false,
                                        false,
                                        context,
                                        15,
                                        FontWeight.bold),
                                  ),

                                  BlocBuilder<ReportMistakeBloc,
                                      ReportMistakeFormState>(
                                    buildWhen: (previous, current) =>
                                        previous.trackName != current.trackName,
                                    builder: (context, state) {
                                      return CustomTextField(
                                        padding: 5,
                                        hint: 'Audio Track Name here',
                                        isRequired: true,
                                        keyboardType: TextInputType.text,
                                        cursorColor: isDarkMode(context)
                                            ? Theme.of(context).primaryColorDark
                                            : Theme.of(context).indicatorColor,
                                        fillColor: isDarkMode(context)
                                            ? AppThemes.blueEditTextBgColor.withAlpha(80)
                                            : Colors.white,
                                        borderColor: isDarkMode(context)
                                            ? AppThemes.blueEditTextBgColor.withAlpha(80)
                                            : Theme.of(context).cursorColor,
                                        outerColor: isDarkMode(context)
                                            ? AppThemes.blueEditTextBgColor.withAlpha(80)
                                            : Theme.of(context).cursorColor,
                                        textStyle: TextStyle(
                                            color: Theme.of(context).focusColor,
                                            fontSize: 18,
                                            fontFamily: Strings.AcuminFont,
                                            fontWeight: FontWeight.w300),
                                        hintStyle: TextStyle(
                                            color: Theme.of(context).focusColor,
                                            fontSize: 18,
                                            fontFamily: Strings.AcuminFont,
                                            fontWeight: FontWeight.w300),
                                        errorTextStyle: const TextStyle(
                                            color: AppThemes.deepPinkColor,
                                            fontSize: 16),
                                        errorColor: AppThemes.deepPinkColor,
                                        // focusNode: focusNode,
                                        error: state.trackName.invalid
                                            ? Strings.fieldRequired
                                            : null,
                                        onChange: (trackName) => {
                                          context.read<ReportMistakeBloc>().add(
                                              TrackNameChanged(
                                                  trackName: trackName))
                                        },
                                        obscureText: false,
                                        textInputAction: TextInputAction.next,
                                      );
                                    },
                                  ), //<= trackName input field
                                  Padding(
                                    padding: const EdgeInsets.only(left: 15),
                                    child: text(
                                        Strings.audioTrackTimeStamp,
                                        false,
                                        Theme.of(context).hoverColor,
                                        18.0,
                                        1.0,
                                        false,
                                        false,
                                        context,
                                        15,
                                        FontWeight.bold),
                                  ),

                                  BlocBuilder<ReportMistakeBloc,
                                      ReportMistakeFormState>(
                                    buildWhen: (previous, current) =>
                                        previous.duration != current.duration,
                                    builder: (context, state) {
                                      return CustomTextField(
                                        padding: 5,
                                        hint: '00:00',
                                        isRequired: true,
                                        keyboardType: TextInputType.number,
                                        cursorColor: isDarkMode(context)
                                            ? Theme.of(context).primaryColorDark
                                            : Theme.of(context).indicatorColor,
                                        fillColor: isDarkMode(context)
                                            ? AppThemes.blueEditTextBgColor.withAlpha(80)
                                            : Colors.white,
                                        borderColor: isDarkMode(context)
                                            ? AppThemes.blueEditTextBgColor.withAlpha(80)
                                            : Theme.of(context).cursorColor,
                                        outerColor: isDarkMode(context)
                                            ? AppThemes.blueEditTextBgColor.withAlpha(80)
                                            : Theme.of(context).cursorColor,
                                        textStyle: TextStyle(
                                            color: Theme.of(context).focusColor,
                                            fontSize: 18,
                                            fontFamily: Strings.AcuminFont,
                                            fontWeight: FontWeight.w300),
                                        hintStyle: TextStyle(
                                            color: Theme.of(context).focusColor,
                                            fontSize: 18,
                                            fontFamily: Strings.AcuminFont,
                                            fontWeight: FontWeight.w300),
                                        errorTextStyle: const TextStyle(
                                            color: AppThemes.deepPinkColor,
                                            fontSize: 16),
                                        errorColor: AppThemes.deepPinkColor,
                                        // focusNode: focusNode,
                                        error: state.duration.invalid
                                            ? Strings.fieldRequired
                                            : null,
                                        onChange: (duration) => {
                                          context.read<ReportMistakeBloc>().add(
                                              TrackDurationChanged(
                                                  duration: duration))
                                        },
                                        obscureText: false,
                                        textInputAction: TextInputAction.next,
                                      );
                                    },
                                  ), //<= Audio Track Duration
                                  Padding(
                                    padding: const EdgeInsets.only(left: 15),
                                    child: text(
                                        Strings.screenshotAttached,
                                        false,
                                        Theme.of(context).hoverColor,
                                        18.0,
                                        1.0,
                                        false,
                                        false,
                                        context,
                                        15,
                                        FontWeight.bold),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 0, right: _width / 2, top: 10),
                                    child: Container(
                                      width: _width,
                                      height: 150,
                                      child: Card(
                                        semanticContainer: true,
                                        clipBehavior:
                                            Clip.antiAliasWithSaveLayer,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          child: Image.file(
                                            File(reportMistakeData.toString()),
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                        color: isDarkMode(context)
                                            ? AppThemes.blueEditTextBgColor.withAlpha(80)
                                            : Colors.white,
                                        elevation: 0,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 15),
                                    child: text(
                                        Strings.message,
                                        false,
                                        Theme.of(context).hoverColor,
                                        18.0,
                                        1.0,
                                        false,
                                        false,
                                        context,
                                        15,
                                        FontWeight.bold),
                                  ),
                                  BlocBuilder<ReportMistakeBloc,
                                      ReportMistakeFormState>(
                                    buildWhen: (previous, current) =>
                                        previous.message != current.message,
                                    builder: (context, state) {
                                      return CustomTextField(
                                        padding: 5,
                                        maxLine: 5,
                                        hint: Strings.customMessage,
                                        isRequired: true,
                                        keyboardType: TextInputType.text,
                                        cursorColor: isDarkMode(context)
                                            ? Theme.of(context).primaryColorDark
                                            : Theme.of(context).indicatorColor,
                                        fillColor: isDarkMode(context)
                                            ? AppThemes.blueEditTextBgColor.withAlpha(80)
                                            : Colors.white,
                                        borderColor: isDarkMode(context)
                                            ? AppThemes.blueEditTextBgColor.withAlpha(80)
                                            : Theme.of(context).cursorColor,
                                        outerColor: isDarkMode(context)
                                            ? AppThemes.blueEditTextBgColor.withAlpha(80)
                                            : Theme.of(context).cursorColor,
                                        textStyle: TextStyle(
                                            color: Theme.of(context).focusColor,
                                            fontSize: 18,
                                            fontFamily: Strings.AcuminFont,
                                            fontWeight: FontWeight.w300),
                                        hintStyle: TextStyle(
                                            color: Theme.of(context).focusColor,
                                            fontSize: 18,
                                            fontFamily: Strings.AcuminFont,
                                            fontWeight: FontWeight.w300),
                                        errorTextStyle: const TextStyle(
                                            color: AppThemes.deepPinkColor,
                                            fontSize: 16),
                                        errorColor: AppThemes.deepPinkColor,
                                        // focusNode: focusNode,
                                        error: state.message.invalid|| state.message.toString().isEmpty
                                            ? Strings.fieldRequired
                                            : null,
                                        onChange: (message) => {
                                          context.read<ReportMistakeBloc>().add(
                                              MessageChanged(message: message))
                                        },
                                        obscureText: false,
                                        textInputAction: TextInputAction.done,
                                      );
                                    },
                                  ), //<=message input field
                                  _reportMistakeButton(
                                      context) //<= submit submit
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ));
  }

  /*
  * report mistake Button
   */
  Widget _reportMistakeButton(BuildContext context) {
    return BlocBuilder<ReportMistakeBloc, ReportMistakeFormState>(
        buildWhen: (previous, current) => previous.status != current.status,
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.only(top: 15, bottom: 20),
            child: Wrap(
              alignment: WrapAlignment.center,
              children: [
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      elevation: 2,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 20),
                      backgroundColor: state.status.isValidated
                          ? (isDarkMode(context)
                              ? Theme.of(context).dividerColor
                              : Theme.of(context).primaryColorDark)
                          : isDarkMode(context)
                              ? Theme.of(context).dividerColor.withOpacity(0.8)
                              : Theme.of(context)
                                  .primaryColorDark
                                  .withOpacity(0.8),
                      side: BorderSide(
                          width: 2.0,
                          color: isDarkMode(context)
                              ? Theme.of(context).dividerColor
                              : Theme.of(context).primaryColorDark),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30))),
                  child: text(
                      Strings.reportMistake,
                      false,
                      isDarkMode(context)
                          ? Theme.of(context).primaryColorDark
                          : Theme.of(context).indicatorColor,
                      18.0,
                      1.0,
                      false,
                      false,
                      context,
                      0,
                      FontWeight.w500),
                  onPressed: () {
                    state.status.isValidated ? _showThankYouAlert() : null;
                  },
                ),
              ],
            ),
          );
        });
  }

  /*
   * Thank you popup for rep[ort mistake
   */

  Future<void> _showThankYouAlert() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button
      builder: (
        BuildContext context,
      ) {
        return AlertDialog(
          backgroundColor: isDarkMode(context)?AppThemes.greyLightColor3:Theme.of(context).cursorColor,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          content: Container(
            color: isDarkMode(context)?AppThemes.greyLightColor3:Theme.of(context).cursorColor,
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  text(
                      Strings.thankYouMessageForReportMistake,
                      true,
                      isDarkMode(context)
                          ? Theme.of(context).indicatorColor
                          : Theme.of(context).hoverColor,
                      18.0,
                      1.0,
                      false,
                      false,
                      context,
                      5,
                      FontWeight.w600),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Center(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                            elevation: 2,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 25, vertical: 2),
                            backgroundColor: isDarkMode(context)
                                ? Theme.of(context).dividerColor
                                : Theme.of(context).primaryColorDark,
                            side: BorderSide(
                                width: 2.0,
                                color: isDarkMode(context)
                                    ? Theme.of(context).dividerColor
                                    : Theme.of(context).primaryColorDark),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20))),
                        child: text(
                            Strings.close,
                            false,
                            isDarkMode(context)
                                ? Theme.of(context).primaryColorDark
                                : Theme.of(context).indicatorColor,
                            14.0,
                            1.0,
                            false,
                            false,
                            context,
                            0,
                            FontWeight.w500),
                        onPressed: () {
                          Navigator.of(context)
                            ..pop()
                            ..pop();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

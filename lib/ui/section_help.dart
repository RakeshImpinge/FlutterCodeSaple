import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learn_shudh_gurbani/strings.dart';
import 'package:learn_shudh_gurbani/widgets/widget.dart';

import '../bloc/app_info/app_info_bloc.dart';
import '../bloc/app_info/app_info_event.dart';
import '../bloc/app_info/app_info_state.dart';
import '../services/repository.dart';

class SectionHelp extends StatefulWidget {
  const SectionHelp({Key? key}) : super(key: key);
  @override
  SectionHelpState createState() =>SectionHelpState();
}

class SectionHelpState extends State<SectionHelp> {
  late double _height;
  late double _width;
  late double _pixelRatio;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    return backPressGestureDetection(context,Material(
      child: Scaffold(
        appBar:AppBar(backgroundColor: Theme.of(context).primaryColorDark, elevation:0,leading: IconButton(iconSize:30,
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            }),
          centerTitle: false,
          title: const Text(Strings.help),titleTextStyle: const TextStyle(fontSize: 21),),
         body: Container(color: Theme.of(context).canvasColor,
         child: SafeArea(
          child: SizedBox(
            height: _height,
            width: _width,
            child: BlocProvider(
            create: (_) => AppInfoBloc(Repository(),2,1)..add(AppInfoFetched()),
            child:Stack(
              children: [
                Positioned.fill(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(top:10,bottom: 25,left: 25,right: 25),
                    child:BlocBuilder<AppInfoBloc, AppInfoState>(
                        builder: (context, state) {
                          if (state is AppInfoInitial ||
                              (state is AppInfoFetching && state.isInitial)) {
                            return  Center(child: showLoader());
                          } else if (state is AppInfoFetchSuccess ||
                              (state is AppInfoFetching && !state.isInitial)) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                text('${state.data[0].subsection}',false,Theme.of(context).hoverColor,20.0,1.0, false,false,context,15,FontWeight.bold),
                                text('${state.data[0].text_english}',false,Theme.of(context).focusColor,20.0,1.0, false,false,context,15,FontWeight.normal),
                              ],
                            );
                          } else if (state is AppInfoFetchFailure) {
                            return ErrorMessageWidget(exception: state.exception);
                          } else {
                            return const SizedBox();
                          }
                        })
                  ),
                ),
              ],
            ),
          ),
        ),
       ),
      ),
    )));
  }
}







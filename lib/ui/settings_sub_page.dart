import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learn_shudh_gurbani/widgets/widget.dart';
import '../bloc/app_info/app_info_bloc.dart';
import '../bloc/app_info/app_info_event.dart';
import '../bloc/app_info/app_info_state.dart';
import '../services/repository.dart';

class SettingsSubPage extends StatelessWidget {
    SettingsSubPage({Key? key,  this.index, this.sectionId}) : super(key: key);
    int? index=1;
    int? sectionId=1;

  @override
  Widget build(BuildContext context) {
    final  Object?rcvdData = ModalRoute.of(context)?.settings.arguments;
    return backPressGestureDetection(context,Material(child: rcvdData==null?BlocProvider(
    create: (_) => AppInfoBloc(Repository(),index,sectionId)..add(AppInfoFetched()),
        child:BlocBuilder<AppInfoBloc, AppInfoState>(
            builder: (context, state) {
              if (state is AppInfoInitial ||
                  (state is AppInfoFetching && state.isInitial)) {
                return  Center(child: showLoader());
              } else if (state is AppInfoFetchSuccess ||
                  (state is AppInfoFetching && !state.isInitial)) {
                return Scaffold(
              appBar:AppBar(backgroundColor: Theme.of(context).primaryColorDark, elevation:0,leading: IconButton(iconSize:30,
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
              Navigator.of(context).pop();
              }),
              centerTitle: false,
              title:  Text(rcvdData==null?"${state.data[0].subsection}":"$rcvdData"),titleTextStyle: const TextStyle(fontSize: 21),),
              body: SafeArea(
              child: Stack(
              children: [
              Positioned.fill(
              child: SingleChildScrollView(
              padding: const EdgeInsets.only(top:10,bottom: 30,left: 25,right: 25),
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
               text(rcvdData==null?'${state.data[0].subsection}':"$rcvdData",false,Theme.of(context).dividerColor,20.0,1.0, false,false,context,15,FontWeight.w300),
               text(rcvdData==null?'${state.data[0].text_english.toString().substring(state.data[0].subsection.toString().length+1)}':'Description details are here',false,Theme.of(context).indicatorColor,20.0,1.0, false,false,context,5,FontWeight.w300),

              ],
              ),
              ),
              ),
              ],
              )),
              );
              } else if (state is AppInfoFetchFailure) {
                return ErrorMessageWidget(exception: state.exception);
              } else {
                return const SizedBox();
              }
            }),
    ): Scaffold(
      appBar:AppBar(backgroundColor: Theme.of(context).primaryColorDark, elevation:0,leading: IconButton(iconSize:30,
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          }),
        centerTitle: false,
        title:Text("$rcvdData"),titleTextStyle: const TextStyle(fontSize: 21),),
      body: SafeArea(
          child: Stack(
            children: [
              Positioned.fill(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(top:10,bottom: 30,left: 25,right: 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      text("$rcvdData",false,Theme.of(context).dividerColor,20.0,1.0, false,false,context,15,FontWeight.w300),
                      text('Description details are here',false,Theme.of(context).indicatorColor,20.0,1.0, false,false,context,5,FontWeight.w300),

                    ],
                  ),
                ),
              ),
            ],
          )),
    ),
    ));
  }

}






import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learn_shudh_gurbani/app_themes.dart';
import 'package:learn_shudh_gurbani/models/sehajPaathDataModel.dart';
import 'package:learn_shudh_gurbani/strings.dart';
import 'package:learn_shudh_gurbani/widgets/expandable.dart';
import 'package:learn_shudh_gurbani/widgets/horizontal_progress_bar.dart';
import 'package:learn_shudh_gurbani/widgets/widget.dart';

import '../bloc/sourceList/sources_bloc.dart';
import '../bloc/sourceList/sources_event.dart';
import '../bloc/sourceList/sources_state.dart';
import '../constants/constants.dart';
import '../services/preferenecs.dart';
import 'pothi_sahib_viewer.dart';

class SehajPaathListingScreen extends StatefulWidget {
  const SehajPaathListingScreen({Key? key}) : super(key: key);

  @override
  SehajPaathListingScreenState createState() =>SehajPaathListingScreenState();
}

class SehajPaathListingScreenState extends State<SehajPaathListingScreen> {
  late double _height;
  late double _width;
  late double _pixelRatio;

  List <SehajPaathSubItemData>sehajPaathSubList=[SehajPaathSubItemData('1','Sehaj Paath Name',60),SehajPaathSubItemData('1','Sehaj Paath Name 2',35),SehajPaathSubItemData('1','Sehaj Paath Name 3',90)];

   List <SehajPaathData>sehajPaathList=[];

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    sehajPaathList.clear();
    sehajPaathList.add(SehajPaathData('1','sRI gurU gRMQ swihb jI',sehajPaathSubList));
    sehajPaathList.add(SehajPaathData('1','sRI dsm gurU gRMQ swihb jI',sehajPaathSubList));
    sehajPaathList.add(SehajPaathData('1','vwrW BweI gurdws jI',sehajPaathSubList));
    return backPressGestureDetection(context,Material(
      child: Scaffold(
        appBar:AppBar(backgroundColor: Theme.of(context).primaryColorDark, elevation:0,leading: IconButton(iconSize:30,
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            }),
          centerTitle: false,
          title:  const Text(Strings.paath),titleTextStyle: const TextStyle(fontSize: 21,fontFamily: Strings.AcuminFont),),
       body: Container(
       color: isDarkMode(context)?Theme.of(context).primaryColorDark:Theme.of(context).canvasColor,
        child:SafeArea(
          child: SizedBox(
            height: _height,
            width: _width,
            child: Stack(
              children: [
                Positioned.fill(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(top:20,bottom: 20),
                    child:BlocBuilder<SourcesBloc, SourcesState>(
                    builder: (context, state) {
                    if (state is SourcesInitial) {
                    context.read<SourcesBloc>().add(SourcesFetched());
                    return showLoader();
                    } else if (state is SourcesLoaded) {
                    return ListView.separated(shrinkWrap: true,
                    itemCount: sehajPaathList.length,
                    separatorBuilder: (BuildContext context, int index) =>
                    const Divider(height: 2,color: AppThemes.greyColor),
                    itemBuilder: (context, index) {
                    return _expansionPanel(context,index);
                    },);
                     }
                    else {
                    return showLoader();
                    }
                    },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
       ),
      ),
    ));
  }

  /*
   * Function to display Item in list
   */
  Widget _expansionPanel(BuildContext context, int index) {
    return ExpandableNotifier(initialExpanded: index==0?true:false,
      child: Padding(
        padding: const EdgeInsets.only(left: 25,right: 25),
        child:Column(
          children: <Widget>[
            ScrollOnExpand(
              scrollOnExpand: true,
              scrollOnCollapse: false,
              child: ExpandablePanel(
                theme: const ExpandableThemeData(hasIcon: false,
                  headerAlignment: ExpandablePanelHeaderAlignment.center,
                  tapBodyToCollapse: true,
                ),
                header: Padding(
                  padding: const EdgeInsets.only(
                      top: 10, bottom: 5),
                  child: text(
                      sehajPaathList[index].title,
                      false,
                      Theme.of(context).hoverColor,
                      24.0,
                      1.0,
                      false,
                      false,
                      context,
                      5,
                      FontWeight.w300,Strings.gurmukhiAkkharThickFont),),
                collapsed: const Text(
                  "",
                  softWrap: true,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 1),
                ),
                expanded: _subChildItemView(context,index),
                builder: (_, collapsed, expanded) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 0, right: 0, bottom: 15),
                    child: Expandable(
                      collapsed: collapsed,
                      expanded: expanded,
                      theme: const ExpandableThemeData(crossFadePoint: 0),
                    ),
                  );
                },
              ),
            ),
          ],
        ),),
    );
  }

  /*
   *  Sub child view of list
   */
  Widget _subChildItemView(BuildContext context, int indexChild) {
    return
      ListView.builder(shrinkWrap: true,
        itemCount: sehajPaathList[0].list.length,
        itemBuilder: (context, index) {
          return InkWell(onTap: (){
          navigationPage(context, pothiSahibViewer,
          PothiSahibViewer());
          },child:Container(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                  text(sehajPaathList[indexChild].list[index].title, false,textColorTheme(context), 18.0, 1.0, false, false, context, 15, FontWeight.w600),
                  Padding(padding: const EdgeInsets.only(top: 5),
                    child:ProgressBar(max: 100,current: sehajPaathList[indexChild].list[index].progress,color:  Theme
                        .of(context)
                        .primaryColorDark.withOpacity(0.4),filledColor: isDarkMode(context) ? Theme
                        .of(context)
                        .dividerColor : Theme
                        .of(context)
                        .primaryColorDark,)
                  )

                  ]),
          ));
        },
      );
  }
}







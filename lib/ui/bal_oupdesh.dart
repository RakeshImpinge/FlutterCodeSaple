
import 'package:flutter/material.dart';
import 'package:learn_shudh_gurbani/app_themes.dart';
import 'package:learn_shudh_gurbani/constants/constants.dart';
import 'package:learn_shudh_gurbani/models/pothiSahibDataModel.dart';
import 'package:learn_shudh_gurbani/strings.dart';
import 'package:learn_shudh_gurbani/utils/assets_name.dart';
import 'package:learn_shudh_gurbani/widgets/widget.dart';

import '../services/preferenecs.dart';
import 'bal_oupdesh_learn_mode.dart';

class BalOupdeshScreen extends StatefulWidget {
  const BalOupdeshScreen({Key? key}) : super(key: key);

  @override
  BalOupdeshScreenState createState() =>BalOupdeshScreenState();
}

class BalOupdeshScreenState extends State<BalOupdeshScreen> {
  late double _height;
  late double _width;
  late double _pixelRatio;
  List <PothiSahibData>list=[PothiSahibData('1',"rwg",'Description',60),PothiSahibData('1',"gurU swihbWn",'Description',35),PothiSahibData('1',"Bgq swihbWn",'Description',90),PothiSahibData('1',"5 qKq",'Description',90),PothiSahibData('1',"4 Dwm",'Description',90)];

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
        appBar: AppBar(backgroundColor: Theme
            .of(context)
            .primaryColorDark,
          elevation: 0,
          leading: IconButton(iconSize: 30,
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              }),
          centerTitle: false,
          title: Text(Strings.balUpdesh),titleTextStyle: const TextStyle(fontSize: 21,fontFamily: Strings.AcuminFont),
        ),
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
                    child:
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ReorderableListView(shrinkWrap: true,
                          children: <Widget>[
                            for (int index = 0; index < list.length; index += 1)
                              _ItemView(context,index),
                          ],
                          onReorder: (int oldIndex, int newIndex) {
                            setState(() {
                              if (oldIndex < newIndex) {
                                newIndex -= 1;
                              }
                              final PothiSahibData item = list.removeAt(oldIndex);
                              list.insert(newIndex, item);
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
       ),
      ),
    ) );
  }

  /**
   *   child view of list
   */
  Widget _ItemView(BuildContext context, int index) {
    return Wrap(key: Key('$index'),direction: Axis.horizontal,
        children: [
      Container(padding: EdgeInsets.only(left: 20,right: 15,top: 10,bottom: 0),
    child:InkWell(overlayColor: MaterialStateProperty.resolveWith((states) => Colors.transparent),highlightColor: Colors.transparent,splashColor: Colors.transparent,
    onTap: (){
    navigationPage(context, balOupdeshLearnMode, LearnModeScreen());
    },
      child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 8,
         child:Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            textList(list[index].title, false, Theme.of(context).hoverColor, 24.0, 1.0, false, 1, context, 5,
                FontWeight.w300,Strings.gurmukhiAkkharThickFont),
            textList(list[index].description, false,textColorTheme(context), 16.0, 1.0, false, 2, context, 7, FontWeight.w500, Strings.AcuminFont),
          ]),
         ),
        Expanded(
          flex: 2,
          child:Container(constraints: const BoxConstraints(
              minHeight: 90, maxHeight: double.infinity),
          child:Row(
            crossAxisAlignment: isDarkMode(context)?CrossAxisAlignment.center:CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  constraints: const BoxConstraints(),
                  onPressed: () {
                  },
                  icon:isDarkMode(context)?Icon(Icons.drag_indicator,color:Theme.of(context).indicatorColor,) : Image.asset(AssetsName.ic_hold_drag,width: 20,height:22,fit: BoxFit.fill,),
                ),


              ],),
          ),

            ),

        ]),
    )),
          const Padding(padding: EdgeInsets.only(top: 10),
            child: Divider(height: 2,color: AppThemes.greyColor),),
    ],);


  }
}









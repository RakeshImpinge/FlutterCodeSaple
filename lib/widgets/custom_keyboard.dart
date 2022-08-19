import 'package:flutter/material.dart';
import '../strings.dart';

class CustomKeyboardView extends StatefulWidget {
   CustomKeyboardView({Key? key}) : super(key: key);

  @override
  State<CustomKeyboardView> createState() => CustomKeyboardViewState();
}

class CustomKeyboardViewState extends State<CustomKeyboardView> {

  List<String> itemList = ["w","i","I","","N","a","A","e","s","h","k","K","g","G","|","c","C","j","J","\",","t","T","f","F",
    "x","q","Q","d","D","n","p","P","b","B","m","X","r","l","v","V"];

  @override
  Widget build(BuildContext context) {
    return Container(child:showKeyboard(context));
  }

  /*
   *  bottom sheet for keyboard
   */
  Widget showKeyboard(BuildContext ctx) {
    return Wrap(direction: Axis.horizontal,
        children: <Widget>[
         Column(crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(padding:const EdgeInsets.only(bottom: 20),
              color: Theme.of(context).primaryColorDark,
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(child: GridView.count(padding: const EdgeInsets.only(top: 40, left: 30, right: 30, bottom: 150),
                      shrinkWrap: true,
                      childAspectRatio: 1.9,
                      crossAxisCount: 10,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5,
                      children: List.generate(itemList.length, (index) {
                        return InkWell(splashColor: Colors.transparent,
                            overlayColor: MaterialStateProperty.resolveWith((states) => Colors.transparent),
                            highlightColor: Colors.transparent,
                            onTap: () {

                            },
                            child:Container(color: Colors.transparent,
                                child:Center(child:Text(itemList[index],
                                    style: TextStyle(fontWeight: FontWeight.w700,
                                        fontSize: 20,
                                        fontFamily: Strings.gurmukhiFont,
                                        color: Theme.of(context).indicatorColor)),
                                )));
                      }))),
                ],
              ),
            ),
          ]),
    ]);
  }
}




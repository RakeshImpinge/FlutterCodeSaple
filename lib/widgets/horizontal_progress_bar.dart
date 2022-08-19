import 'package:flutter/material.dart';
import 'package:learn_shudh_gurbani/app_themes.dart';
import 'package:learn_shudh_gurbani/strings.dart';
import 'package:learn_shudh_gurbani/widgets/widget.dart';

import '../services/preferenecs.dart';
import '../utils/assets_name.dart';

class ProgressBar extends StatelessWidget {
  final int max;
  final int current;
  final Color color;
  final Color filledColor;
  final double progressbarHeight;
  final String fontName;
  final String progressText;
  final bool iconsVisibility;
  final bool isPlayModeEnable;

  const ProgressBar(
      {Key? key,
      required this.max,
      required this.current,
      this.color = Colors.white70,
      this.filledColor = Colors.lightBlue,
      this.progressbarHeight = 15,
      this.fontName = Strings.gurmukhiAkkharThickFont,
      this.progressText = "0",
      this.iconsVisibility = false,
      this.isPlayModeEnable = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, boxConstraints) {
        var x = boxConstraints.maxWidth;
        var percent = (current / max) * x;
        return Stack(
          children: [
            Container(
              width: x,
              height: progressbarHeight,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(35),
              ),
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 500),
              width: percent,
              height: progressbarHeight,
              decoration: BoxDecoration(
                color: filledColor,
                borderRadius: BorderRadius.circular(35),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                  left: progressbarHeight > 16 ? percent - 40 : percent - 30),
              height: progressbarHeight - 5,
              child: text(
                  progressbarHeight > 16 ? progressText : current.toString(),
                  true,
                  isDarkMode(context)
                      ? AppThemes.darkBlueColor
                      : Theme.of(context).indicatorColor,
                  progressbarHeight > 16 ? 16.0 : 12.0,
                  1.0,
                  false,
                  false,
                  context,
                  progressbarHeight > 16 ? 2.0 : 0,
                  FontWeight.w600,
                  fontName),
            ),
            Visibility(
                visible: iconsVisibility,
                child: Padding(
                  padding:
                      EdgeInsets.only(left: 10, right: 5, top: 5, bottom: 5),
                  child: InkWell(
                      onTap: () {},
                      child: Image.asset(AssetsName.ic_minus,
                          width: 15,
                          height: 15,
                          fit: BoxFit.scaleDown,
                          color: isDarkMode(context)
                              ? AppThemes.greyLightColor3
                              : (percent > 5
                                  ? Theme.of(context).indicatorColor
                                  : Theme.of(context).primaryColor),
                          alignment: Alignment.centerLeft)),
                )),
            Visibility(
                visible: isPlayModeEnable,
                child: Padding(
                  padding:
                      EdgeInsets.only(left: 10, right: 5, top: 5, bottom: 5),
                  child: InkWell(
                      onTap: () {},
                      child: Icon(
                        Icons.pause,
                        color: isDarkMode(context)
                            ? AppThemes.greyLightColor3
                            : (percent > 5
                                ? Theme.of(context).indicatorColor
                                : Theme.of(context).primaryColor),
                        size: 15,
                      )),
                )),
            Visibility(
              visible: iconsVisibility,
              child: Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding:
                        EdgeInsets.only(left: 5, right: 10, top: 5, bottom: 5),
                    child: InkWell(
                        onTap: () {},
                        child: Image.asset(
                          AssetsName.ic_plus,
                          width: 15,
                          height: 15,
                          fit: BoxFit.scaleDown,
                          color: isDarkMode(context)
                              ? AppThemes.greyLightColor3
                              : (percent < 95
                                  ? Theme.of(context).indicatorColor
                                  : Theme.of(context).primaryColor),
                          alignment: Alignment.centerRight,
                        )),
                  )),
            )
          ],
        );
      },
    );
  }
}

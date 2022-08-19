import 'dart:math';

import 'package:flutter/material.dart';
import 'package:learn_shudh_gurbani/strings.dart';
import 'package:learn_shudh_gurbani/widgets/widget.dart';

class SeekBar extends StatefulWidget {
  final Duration duration;
  final Duration position;
  final Duration bufferedPosition;
  final ValueChanged<Duration>? onChanged;
  final ValueChanged<Duration>? onChangeEnd;
  final bool? isVisible;

  SeekBar({
    required this.duration,
    required this.position,
    required this.bufferedPosition,
    this.onChanged,
    this.onChangeEnd,
    this.isVisible,
  });

  @override
  _SeekBarState createState() => _SeekBarState();
}

class _SeekBarState extends State<SeekBar> {
  double? _dragValue;
  late SliderThemeData _sliderThemeData;

  bool get isVisible => widget.isVisible != null;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _sliderThemeData = SliderTheme.of(context).copyWith(
      trackHeight: isVisible ? 3.0 : 15.0,
      trackShape: RectangularSliderTrackShape(),
      thumbShape: RoundSliderThumbShape(enabledThumbRadius: 0),
      overlayShape: RoundSliderOverlayShape(overlayRadius: 0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          SliderTheme(
            data: _sliderThemeData.copyWith(
              thumbShape: HiddenThumbComponentShape(),
              activeTrackColor: isVisible
                  ? Theme.of(context).indicatorColor
                  : Theme.of(context).dividerColor,
              inactiveTrackColor: isVisible
                  ? Theme.of(context).indicatorColor.withAlpha(70)
                  : Theme.of(context).disabledColor,
            ),
            child: ExcludeSemantics(
              excluding: false,
              child: Slider(
                min: 0.0,
                max: widget.duration.inMilliseconds.toDouble(),
                value: min(widget.bufferedPosition.inMilliseconds.toDouble(),
                    widget.duration.inMilliseconds.toDouble()),
                onChanged: (value) {
                  setState(() {
                    _dragValue = value;
                  });
                  if (widget.onChanged != null) {
                    widget.onChanged!(Duration(milliseconds: value.round()));
                  }
                },
                onChangeEnd: (value) {
                  if (widget.onChangeEnd != null) {
                    widget.onChangeEnd!(Duration(milliseconds: value.round()));
                  }
                  _dragValue = null;
                },
              ),
            ),
          ),
          Visibility(
              visible: !isVisible,
              child: Padding(
                padding:
                    const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 5),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    text(
                        RegExp(r'((^0*[1-9]\d*:)?\d{2}:\d{2})\.\d+$')
                                .firstMatch("$elapsedTime")
                                ?.group(1) ??
                            '$elapsedTime',
                        false,
                        Theme.of(context).dividerColor,
                        14.0,
                        1.0,
                        false,
                        false,
                        context,
                        0,
                        FontWeight.w300),
                    text(
                        RegExp(r'((^0*[1-9]\d*:)?\d{2}:\d{2})\.\d+$')
                                .firstMatch("$remainingTime")
                                ?.group(1) ??
                            '$remainingTime',
                        false,
                        Theme.of(context).dividerColor,
                        14.0,
                        1.0,
                        false,
                        false,
                        context,
                        0,
                        FontWeight.w300),
                  ],
                ),
              ))
        ],
      ),
    );
  }

  Duration get remainingTime => widget.duration - widget.position;

  Duration get elapsedTime => widget.position;
}

class HiddenThumbComponentShape extends SliderComponentShape {
  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) => Size.zero;

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {}
}

class PositionData {
  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;

  PositionData(this.position, this.bufferedPosition, this.duration);
}

Widget showSettings({
  required BuildContext context,
  required int divisions,
  required double min,
  required double max,
  String valueSuffix = '',
  required double value,
  required Stream<double> stream,
  required ValueChanged<double> onChanged,
}) {
  return StreamBuilder<double>(
    stream: stream,
    builder: (context, snapshot) => Container(
      margin: EdgeInsets.only(top: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            flex: 8,
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                thumbColor: Theme.of(context).dividerColor,
                trackHeight: 3,
                thumbShape: SliderThumbImage(
                  thumbRadius: 3.0,
                  sliderValue: value,
                ),
                overlayShape: RoundSliderOverlayShape(overlayRadius: 0),
                trackShape: RectangularSliderTrackShape(),
                activeTrackColor: Theme.of(context).indicatorColor,
                inactiveTrackColor: Theme.of(context).indicatorColor,
              ),
              child: Slider(
                min: min,
                max: max,
                value: snapshot.data ?? value,
                onChanged: onChanged,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text('${snapshot.data?.toStringAsFixed(1)}$valueSuffix',
                textAlign: TextAlign.end,
                style: const TextStyle(
                    fontFamily: Strings.AcuminFont,
                    fontWeight: FontWeight.w500,
                    fontSize: 16.0)),
          ),
        ],
      ),
    ),
  );
}

class SliderThumbImage extends SliderComponentShape {
  final double thumbRadius;
  final double sliderValue;

  const SliderThumbImage({
    required this.thumbRadius,
    required this.sliderValue,
  });

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(thumbRadius);
  }

  @override
  void paint(PaintingContext context, Offset center,
      {required Animation<double> activationAnimation,
      required Animation<double> enableAnimation,
      required bool isDiscrete,
      required TextPainter labelPainter,
      required RenderBox parentBox,
      required SliderThemeData sliderTheme,
      required TextDirection textDirection,
      required double value,
      required double textScaleFactor,
      required Size sizeWithOverflow}) {
    final Path path = Path();
    path.moveTo(center.dx, center.dy);
    path.lineTo(center.dx + 5, center.dy - 10);
    path.lineTo(center.dx + 5, center.dy + 10);
    path.lineTo(center.dx - 5, center.dy + 10);
    path.lineTo(center.dx - 5, center.dy - 10);
    path.lineTo(center.dx + 5, center.dy - 10);

    path.close();
    context.canvas.drawPath(
        path,
        Paint()
          ..color = sliderTheme.thumbColor!
          ..style = PaintingStyle.fill
          ..strokeWidth = 5
          ..strokeCap = StrokeCap.round);
  }
}

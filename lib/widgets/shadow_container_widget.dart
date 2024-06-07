import 'package:flutter/cupertino.dart';
import 'package:monkeybox_viveksorathiya_flutter_dev/utils/color.dart';

class ShadowContainerWidget extends StatelessWidget {
  final Widget widget;
  double? padding;
  double? radius;
  BorderRadiusGeometry? customRadius;
  double? blurRadius;
  Color? shadowColor;
  Color? borderColor;
  Color? color;

  ShadowContainerWidget(
      {Key? key,
      required this.widget,
      this.padding,
      this.radius,
      this.blurRadius,
      this.customRadius,
      this.borderColor,
      this.shadowColor,
      this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(padding ?? 15.0),
        decoration: BoxDecoration(
          color: color ?? primaryWhite,
          boxShadow: [
            BoxShadow(
              blurRadius: blurRadius ?? 10.0,
              color: shadowColor ?? lightGreyColor,
            ),
          ],
          borderRadius: customRadius ?? BorderRadius.circular(radius ?? 15.0),
          border: Border.all(
            color: borderColor ?? lightGreyColor,
          ),
        ),
        child: widget);
  }
}

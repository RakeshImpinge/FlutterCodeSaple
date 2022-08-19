import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String? hint;
  final double? padding;
  final TextEditingController? textEditingController;
  final TextInputType? keyboardType;
  final bool? obscureText;
  final Key? key;
  final bool? isRequired;
  final String? error;
  final String? initialValue;
  final ValueChanged<String> onChange;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final Color? fillColor;
  final Color? errorColor;
  final Color? borderColor;
  final TextStyle? textStyle;
  final TextStyle? errorTextStyle;
  final Color? cursorColor;
  final int? maxLine;
  final Color? outerColor;
  final TextStyle? hintStyle;
    CustomTextField({this.hint,
        this.textEditingController,
        this.keyboardType,
        this.obscureText= false, this.key,
        this.isRequired,
        this.error,
        required this.onChange, this. initialValue,  this.textInputAction,this.focusNode, this.fillColor, this.errorColor, this.borderColor, this.textStyle, this.errorTextStyle, this.cursorColor, this.maxLine, this.outerColor, this.hintStyle, this.padding
      });

  @override
  Widget build(BuildContext context) {
       return Padding(padding: EdgeInsets.only(top: padding??0),
        child: TextFormField(
        key: key,
        focusNode: focusNode,
        keyboardType: keyboardType,
        cursorColor: cursorColor,
        maxLines: maxLine??1,
        initialValue: initialValue,
        onChanged: onChange,
        style: textStyle,
        controller: textEditingController,
        obscureText: obscureText!,
        decoration: InputDecoration(contentPadding: const EdgeInsets.only(left: 30.0,right: 30.0,top:15.0,bottom: 15.0),
          filled: true,
          fillColor: fillColor,
          hintText: hint,
          hintStyle: hintStyle,
          errorText: error,
          errorMaxLines: 3,
          errorStyle: errorTextStyle,
          errorBorder:OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: BorderSide(color: errorColor!,width: 2)),
              border:OutlineInputBorder(borderRadius: BorderRadius.circular(30.0),
              borderSide: BorderSide.none),
        )),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';

class MyTextField extends StatefulWidget {
  final String? hintText;
  final int? maxlen;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final FocusNode? nextFocus;
  final TextInputType inputType;
  final TextInputAction inputAction;
  final int maxLines;
  final bool isPassword;
  final Callback? onTap;
  final Function? onChanged;
  final Callback? onSubmit;
  final bool isEnabled;
  final TextCapitalization capitalization;
  final Color? fillColor;
  final bool validator;
  final IconData? icon;
  final bool? isObscureText;
  final String? errorText;

  const MyTextField(
      {this.hintText = '',
      this.maxlen,
      this.controller,
      this.focusNode,
      this.nextFocus,
      this.isEnabled = true,
      this.inputType = TextInputType.text,
      this.inputAction = TextInputAction.next,
      this.maxLines = 1,
      this.onSubmit,
      this.onChanged,
      this.capitalization = TextCapitalization.none,
      this.onTap,
      this.fillColor,
      this.isPassword = false,
      this.validator = false,
      this.icon,
      this.isObscureText = true,
      this.errorText = ''});

  @override
  _MyTextFieldState createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  bool? obscureText;

  @override
  void initState() {
    super.initState();
    obscureText = widget.isObscureText!;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
            inputFormatters: widget.hintText == 'Phone Number'
                ? <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly]
                : null,
            maxLines: widget.maxLines,
            maxLength: widget.maxlen,
            controller: widget.controller,
            focusNode: widget.focusNode,
            style: const TextStyle(
                fontSize: 16, color: Colors.black, fontWeight: FontWeight.w500),
            textInputAction: widget.inputAction,
            keyboardType: widget.inputType,
            cursorColor: Theme.of(context).primaryColor,
            textCapitalization: widget.capitalization,
            enabled: widget.isEnabled,
            autofocus: false,
            obscureText: widget.isPassword ? obscureText! : false,
            decoration: InputDecoration(
              focusColor: Colors.grey,
              counterText: '',
              prefixIcon: widget.icon != null
                  ? Icon(
                      widget.icon,
                      size: 22,
                      color: Colors.grey[700],
                    )
                  : null,
              errorText: widget.validator ? "This Field Can't be empty" : null,
              hintText: widget.hintText,
              isDense: true,
              filled: true,
              fillColor: widget.fillColor ?? Theme.of(context).cardColor,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none),
              hintStyle: const TextStyle(color: Colors.black, fontSize: 16),
            ),
            onTap: widget.onTap,
            onSubmitted: (text) =>
                FocusScope.of(context).requestFocus(widget.nextFocus)),
        widget.errorText == null
            ? const SizedBox()
            : Text(widget.errorText!,
                style: const TextStyle(color: Colors.red)),
      ],
    );
  }

  void _toggle() {
    setState(() {
      obscureText = !obscureText!;
    });
  }
}

InputDecoration inputDecoration = const InputDecoration(
    fillColor: Colors.white,
    filled: true,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
      borderSide: BorderSide(width: 1.2, color: Colors.white),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(5.0)),
      borderSide: BorderSide(width: 1.2, color: Colors.white),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(5.0)),
      borderSide: BorderSide(width: 1.2, color: Colors.black),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(5.0)),
      borderSide: BorderSide(width: 1.2, color: Colors.yellow),
    ),
    contentPadding: EdgeInsets.all(10.0),
    hintStyle: TextStyle(
      color: Colors.black87,
      fontSize: 18,
      fontWeight: FontWeight.w500,
    ),
    errorStyle: TextStyle(color: Colors.black54),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(5.0)),
      borderSide: BorderSide(color: Colors.yellow, width: 1.2),
    ));

TextStyle inputTextStyle = const TextStyle(
    color: Colors.black,
    fontSize: 18,
    fontWeight: FontWeight.w500,
    height: 1.8);

TextStyle dropTextStyle = const TextStyle(
    color: Colors.black87,
    fontSize: 18,
    fontWeight: FontWeight.w500,
    overflow: TextOverflow.visible);

InputDecoration dropDecoration = inputDecoration.copyWith(
    contentPadding: const EdgeInsets.fromLTRB(10, 15, 10, 15));

InputDecoration settingInputDecoration(context) => InputDecoration(
      enabledBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
        borderSide: BorderSide(color: Colors.grey[400]!, width: 0.8),
      ),
      errorBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        borderSide: BorderSide(color: Colors.red, width: 1.4),
      ),
      focusedErrorBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        borderSide: BorderSide(color: Colors.red, width: 1.4),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
        borderSide: BorderSide(color: Colors.grey[400]!, width: 1.4),
      ),
      isDense: true,
      errorStyle: TextStyle(fontSize: responsiveSize(18, context)),
      contentPadding: EdgeInsets.all(responsiveSize(18, context)),
      hintStyle: TextStyle(
          fontSize: responsiveSize(18, context),
          color: Colors.grey[400],
          fontWeight: FontWeight.w400),
    );

TextStyle settingInputTextStyle(context) => TextStyle(
    fontSize: responsiveSize(18, context),
    color: Colors.black,
    fontWeight: FontWeight.w500);

double responsiveSize(double value, BuildContext context) =>
    ((MediaQuery.of(context).size.width) * value / 4.5) / 100;

customDatePicker(BuildContext context, Widget? child) => Theme(
      data: ThemeData(
        primarySwatch: const MaterialColor(
          0xFF0CCFF0,
          <int, Color>{
            50: Color(0xFF0CCFF0),
            100: Color(0xFF0CCFF0),
            200: Color(0xFF0CCFF0),
            300: Color(0xFF0CCFF0),
            400: Color(0xFF0CCFF0),
            500: Color(0xFF0CCFF0),
            600: Color(0xFF0CCFF0),
            700: Color(0xFF0CCFF0),
            800: Color(0xFF0CCFF0),
            900: Color(0xFF0CCFF0),
          },
        ),
        colorScheme: ColorScheme.light(
          primary: Theme.of(context).primaryColor,
          onPrimary: Colors.white,
          onSurface: Colors.black,
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: InputBorder.none,
        ),
        textTheme: TextTheme(
          caption: TextStyle(fontSize: responsiveSize(12, context)),
        ),
        dialogTheme: const DialogTheme(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(30)))),
      ),
      child: Transform.scale(
          alignment: Alignment.center,
          scale: responsiveSize(1.0, context),
          child: child!),
    );

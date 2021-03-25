import 'package:flutter/material.dart';

// ignore: must_be_immutable
class TextFieldCustom extends StatefulWidget {
  TextFieldCustom({
    @required this.labelText,
    @required this.icon,
    @required this.color,
    @required this.controller,
    @required this.validate,
    this.autoFocus = false,
    this.keybordType = TextInputType.text,
    this.autoCorrect = false,
    this.obscureText = false,
    this.readOnly = false,
    this.onTap,
  });

  final String labelText;
  final IconData icon;
  final Color color;
  final TextEditingController controller;
  bool validate;
  final bool autoFocus;
  final TextInputType keybordType;
  final bool autoCorrect;
  final bool obscureText;
  final Function onTap;
  final bool readOnly;
  @override
  _TextFieldCustomState createState() => _TextFieldCustomState();
}

class _TextFieldCustomState extends State<TextFieldCustom> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      onTap: widget.onTap,
      autofocus: widget.autoFocus,
      readOnly: widget.readOnly,
      keyboardType: widget.keybordType,
      autocorrect: widget.autoCorrect,
      obscureText: widget.obscureText,
      controller: widget.controller,
      
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
          prefixIcon: Icon(widget.icon, color: widget.color),
          labelText: widget.labelText,
          errorText: widget.validate == false ? 'Entrada Inválida' : null,
          focusedBorder:
              OutlineInputBorder(borderSide: BorderSide(color: widget.color)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
          )),
    );
  }
}
